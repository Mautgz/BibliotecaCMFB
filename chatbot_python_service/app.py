# Este archivo contiene un servicio Flask básico para generar texto con un LLM ligero.
from flask import Flask, request, jsonify, session
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity
import unicodedata
import re
import json
import os
import difflib
import requests
from bs4 import BeautifulSoup
import time
import mysql.connector
from datetime import datetime

app = Flask(__name__)
app.secret_key = 'supersecretkey'  # Necesario para usar sesiones

# Configuración de la base de datos
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': '',
    'database': 'biblio'
}

def registrar_log(query, respuesta, tiempo_respuesta):
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()
        
        sql = """INSERT INTO chatbot_logs 
                (mensaje, respuesta, tiempo_respuesta, fecha_hora) 
                VALUES (%s, %s, %s, %s)"""
        
        cursor.execute(sql, (query, respuesta, tiempo_respuesta, datetime.now()))
        conn.commit()
        
    except Exception as e:
        print(f"Error al registrar log: {str(e)}")
    finally:
        if 'conn' in locals():
            conn.close()

# Cargar modelo y libros UNA SOLA VEZ
print("Cargando modelo de embeddings...")
sentence_model = SentenceTransformer('all-MiniLM-L6-v2')
print("Modelo cargado.")

# Cargar FAQs desde JSON
FAQS_PATH = os.path.join(os.path.dirname(__file__), '../scripts/faqs.json')
faqs = []
if os.path.exists(FAQS_PATH):
    with open(FAQS_PATH, encoding='utf-8') as f:
        faqs = json.load(f)

def normalize_text(text):
    if not isinstance(text, str):
        return ""
    text = text.lower()
    text = unicodedata.normalize('NFKD', text).encode('ASCII', 'ignore').decode('ASCII')
    text = re.sub(r'[^a-z0-9\\s]', ' ', text)
    text = re.sub(r'\\s+', ' ', text).strip()
    return text

def prepare_book_text(book):
    title = book.get('titulo', '') * 3
    materia = book.get('materia', '') * 2
    fields = [
        title,
        materia,
        book.get('autor_personal', ''),
        book.get('autor_corporativo', ''),
        book.get('editorial', ''),
        book.get('descripcion', '')
    ]
    text = ' '.join(filter(None, fields))
    return normalize_text(text)

def es_consulta_detalles_libro(texto):
    patrones = [
        r"m[áa]s detalles sobre",
        r"m[áa]s informaci[oó]n sobre",
        r"detalles del libro",
        r"informaci[oó]n del libro",
        r"cu[áa]nto cuesta",
        r"d[óo]nde est[áa]",
        r"d[óo]nde puedo encontrar",
        r"c[óo]mo lo encuentro",
        r"me interesa",
        r"quiero saber m[áa]s sobre",
        r"hablame de",
        r"cu[áa]nto tiempo",
        r"por cu[áa]nto tiempo",
        r"cu[áa]nto dura el pr[ée]stamo"
    ]
    texto = texto.lower()
    return any(re.search(patron, texto) for patron in patrones)

def buscar_info_libro_web(titulo, autor):
    try:
        # Buscar en Google Books API
        query = f"{titulo} {autor}"
        url = f"https://www.googleapis.com/books/v1/volumes?q={requests.utils.quote(query)}"
        response = requests.get(url)
        if response.status_code == 200:
            data = response.json()
            if 'items' in data and len(data['items']) > 0:
                # Tomar el primer resultado relevante
                libro = data['items'][0]['volumeInfo']
                descripcion = libro.get('description', '')
                if descripcion:
                    return descripcion[:1000]  # Limitar a 1000 caracteres
        return None
    except Exception as e:
        print(f"Error al buscar información del libro en Google Books: {str(e)}")
        return None

def generar_resumen_libro(titulo, autor, info_web):
    prompt = f"""Genera una sinopsis breve (2-3 oraciones) y clara del siguiente libro, usando la información proporcionada. Sé directo y conciso.

Título: {titulo}
Autor: {autor}

Información encontrada:
{info_web}
"""
    try:
        print("[DEBUG] Enviando prompt a Mistral/Ollama:", prompt[:300])
        response = requests.post('http://localhost:11434/api/generate', 
                               json={
                                   "model": "mistral",
                                   "prompt": prompt,
                                   "stream": False,
                                   "max_tokens": 80
                               })
        print("[DEBUG] Status code de Ollama:", response.status_code)
        if response.status_code == 200:
            print("[DEBUG] Respuesta de Ollama:", response.json())
            return response.json().get('response', '')
        print("[DEBUG] Ollama no devolvió 200:", response.text)
        return None
    except Exception as e:
        print(f"Error al generar resumen con Ollama: {str(e)}")
        return None

def obtener_detalles_libro(book):
    # Crear una copia para no modificar el original
    libro = dict(book)
    
    # Determinar el estado del libro
    estado = 'Disponible'
    if 'estado' in libro:
        try:
            estado = 'Disponible' if int(libro['estado']) == 1 else 'Prestado'
        except (ValueError, TypeError):
            if libro['estado'].lower() in ['disponible', 'prestado']:
                estado = libro['estado']
    elif 'cantidad' in libro:
        try:
            cantidad = int(libro['cantidad'])
            estado = 'Disponible' if cantidad > 0 else 'Prestado'
        except (ValueError, TypeError):
            pass
    elif 'estado' in libro:
        estado = libro['estado']

    # Actualizar el estado en el objeto libro
    libro['estado'] = estado
    return libro

def es_saludo(texto):
    saludos = [
        "hola", "buenos dias", "buen dia", "buenas tardes", "buenas noches", 
        "saludos", "que tal", "como estas", "buen día", "buenas días"
    ]
    texto = texto.lower().strip()
    palabras = texto.split()
    return len(palabras) <= 2 and any(saludo in texto for saludo in saludos)

def obtener_respuesta_saludo():
    return {
        "respuesta": "¡Hola! Soy tu asistente virtual de la biblioteca. Estoy aquí para ayudarte a encontrar los libros que necesitas, informarte sobre nuestros servicios y resolver cualquier duda que tengas. ¿En qué puedo ayudarte hoy?",
        "libros": []
    }

def buscar_por_titulo(query, books):
    query_norm = normalize_text(query)
    for book in books:
        titulo_norm = normalize_text(book.get('titulo', ''))
        if titulo_norm in query_norm or query_norm in titulo_norm:
            return book
        if difflib.SequenceMatcher(None, titulo_norm, query_norm).ratio() > 0.85:
            return book
    return None

def buscar_faq_por_regex(query):
    query = query.lower().strip()
    
    # First try exact pattern match
    for faq in faqs:
        patron = faq.get('patron_regex')
        if patron:
            try:
                if re.search(patron, query, re.IGNORECASE):
                    return faq
            except Exception:
                continue
        elif faq.get('pregunta', '').strip().lower() == query:
            return faq
    
    # If no exact match, try semantic matching
    for faq in faqs:
        pregunta = faq.get('pregunta', '').lower()
        # Check if the query contains key location-related words
        location_words = ['donde', 'dónde', 'ubicación', 'ubicacion', 'lugar', 'zona', 'sección', 'seccion']
        if any(word in query for word in location_words) and any(word in pregunta for word in location_words):
            return faq
        
        # Check for similar words using difflib
        similarity = difflib.SequenceMatcher(None, query, pregunta).ratio()
        if similarity > 0.6:  # Adjust threshold as needed
            return faq
    
    return None

def buscar_por_palabras_clave(query, books):
    # Lista de palabras a ignorar
    stopwords = {"sobre", "tenian", "libro", "aqui", "era", "de", "y", "un", "una", "el", "la", "los", "las", "en", "por", "con", "del", "al", "que"}
    palabras = [w.strip() for w in normalize_text(query).split() if len(w) > 3 and w not in stopwords]
    resultados = []
    for book in books:
        titulo = normalize_text(book.get('titulo', ''))
        if all(palabra in titulo for palabra in palabras):
            resultados.append(book)
    return resultados[:2]  # Limitar a 2 resultados

def buscar_por_palabra_principal(query, books):
    palabras = [w.strip() for w in normalize_text(query).split() if len(w) > 3]
    resultados = []
    for book in books:
        titulo = normalize_text(book.get('titulo', ''))
        materia = normalize_text(book.get('materia', ''))
        autor = normalize_text(book.get('autor', ''))
        
        # Contar cuántas palabras clave coinciden
        coincidencias = 0
        for palabra in palabras:
            if palabra in titulo or palabra in materia or palabra in autor:
                coincidencias += 1
        
        # Si hay al menos una coincidencia, agregar el libro con su puntuación
        if coincidencias > 0:
            book['coincidencias'] = coincidencias
            resultados.append(book)
    
    # Ordenar por número de coincidencias (más coincidencias primero)
    resultados.sort(key=lambda x: x['coincidencias'], reverse=True)
    return resultados[:2]  # Limitar a 2 resultados

def generar_respuesta_ollama(prompt, model='mistral', libros_encontrados=None):
    try:
        url = 'http://localhost:11434/api/generate'
        system_prompt = """Eres un asistente virtual de biblioteca amable y servicial. 
Responde de manera concisa y directa. Limita tus respuestas a 2-3 oraciones.
Si encuentras libros, menciona solo los más relevantes (máximo 2)."""
        
        # Si hay libros encontrados, agregar su información al prompt
        if libros_encontrados:
            libros_info = "\nLibros encontrados:\n"
            for libro in libros_encontrados[:2]:  # Limitar a 2 libros
                libros_info += f"""
Título: {libro.get('titulo', '')}
Autor: {libro.get('autor_personal', '')}
Ubicación: {libro.get('ubicacion', '')}
Estado: {libro.get('estado', 'Desconocido')}
"""
            full_prompt = f"{system_prompt}\n\n{libros_info}\n\nUsuario: {prompt}\n\nAsistente:"
        else:
            full_prompt = f"{system_prompt}\n\nUsuario: {prompt}\n\nAsistente:"
        
        data = {
            "model": model,
            "prompt": full_prompt,
            "stream": False,
            "temperature": 0.3,
            "max_tokens": 100,
            "top_p": 0.9,
            "top_k": 40,
            "timeout": 300
        }
        
        response = requests.post(url, json=data, timeout=300)
        
        if response.status_code == 200:
            return response.json()['response'].strip()
        else:
            print(f"Error en respuesta de Ollama: {response.status_code}")
            return None
    except requests.exceptions.Timeout:
        print("Timeout al conectar con Ollama")
        return None
    except requests.exceptions.ConnectionError:
        print("Error de conexión con Ollama")
        return None
    except Exception as e:
        print(f"Error al llamar a Ollama: {str(e)}")
        return None

def es_consulta_general_busqueda(texto):
    patrones = [
        r"ayud(a|ame|arme) a buscar( un)? libro",
        r"quiero buscar( un)? libro",
        r"busco( un)? libro",
        r"me ayudas a buscar( un)? libro",
        r"quiero encontrar( un)? libro",
        r"puedes buscar( un)? libro"
    ]
    texto = texto.lower()
    return any(re.search(patron, texto) for patron in patrones)

def es_frase_no_entendida(texto):
    frases = [
        "no te entendi", "no entiendo", "no sé", "no se", "ayuda", "no comprendo", "no supe"
    ]
    texto = texto.lower()
    return any(frase in texto for frase in frases)

def es_busqueda_por_autor(texto):
    palabras_clave = ["autor", "escrito por", "de", "del autor"]
    texto = texto.lower()
    return any(palabra in texto for palabra in palabras_clave)

def es_busqueda_por_titulo(texto):
    palabras_clave = ["titulo", "libro", "llamado", "que se llama"]
    texto = texto.lower()
    return any(palabra in texto for palabra in palabras_clave)

def es_busqueda_por_materia(texto):
    palabras_clave = ["materia", "tema", "sobre", "de la materia"]
    texto = texto.lower()
    return any(palabra in texto for palabra in palabras_clave)

def extraer_palabra_clave(texto, tipo):
    palabras = texto.lower().split()
    if tipo == "autor":
        for palabra in palabras:
            if palabra in ["autor", "escrito", "por", "de", "del"]:
                idx = palabras.index(palabra)
                if idx + 1 < len(palabras):
                    return palabras[idx + 1]
    elif tipo == "titulo":
        for palabra in palabras:
            if palabra in ["titulo", "libro", "llamado", "que"]:
                idx = palabras.index(palabra)
                if idx + 1 < len(palabras):
                    return palabras[idx + 1]
    elif tipo == "materia":
        for palabra in palabras:
            if palabra in ["materia", "tema", "sobre", "de"]:
                idx = palabras.index(palabra)
                if idx + 1 < len(palabras):
                    return palabras[idx + 1]
    return None

def es_busqueda_por_palabra_clave(texto):
    palabras_clave = [
        "libro", "buscar", "encontrar", "tenian", "tenían", "habia", "había", 
        "recuerdo", "me acuerdo", "trata", "habla", "sobre", "tema", "temas",
        "busco", "quiero", "necesito", "me interesa", "me gustaría"
    ]
    texto = texto.lower()
    return any(palabra in texto for palabra in palabras_clave)

def es_busqueda_por_tema(texto):
    temas = [
        "alma", "filosofía", "filosofia", "psicología", "psicologia", "historia",
        "literatura", "ciencia", "arte", "matemáticas", "matematicas", "física",
        "fisica", "química", "quimica", "biología", "biologia", "medicina",
        "derecho", "economía", "economia", "política", "politica", "sociología",
        "sociologia", "antropología", "antropologia", "religión", "religion"
    ]
    texto = texto.lower()
    return any(tema in texto for tema in temas)

def es_consulta_detalles_especificos(texto):
    # Primero, normalizar el texto
    texto = texto.lower().strip()
    
    # Si el texto es solo un título de libro, también lo consideramos una consulta de detalles
    if len(texto.split()) <= 5:  # Si son 5 palabras o menos, probablemente es un título
        return texto
    
    # Patrones para detectar consultas de detalles
    patrones = [
        r"quiero saber más de (.*)",
        r"más información de (.*)",
        r"detalles de (.*)",
        r"hablame de (.*)",
        r"cuéntame de (.*)",
        r"más sobre (.*)",
        r"información sobre (.*)",
        r"quiero saber más sobre (.*)",
        r"dime más de (.*)",
        r"dime más sobre (.*)",
        r"me puedes contar más sobre (.*)",
        r"me puedes contar más de (.*)"
    ]
    
    for patron in patrones:
        match = re.search(patron, texto)
        if match:
            return match.group(1).strip()
    
    return None

def normalizar_texto_busqueda(texto):
    texto = texto.lower().strip()
    texto = ''.join(c for c in unicodedata.normalize('NFD', texto) if unicodedata.category(c) != 'Mn')
    texto = texto.replace('á', 'a').replace('é', 'e').replace('í', 'i').replace('ó', 'o').replace('ú', 'u')
    texto = texto.replace('ü', 'u').replace('ñ', 'n')
    return texto

def buscar_libro_por_titulo_parcial(titulo_buscar, books):
    titulo_buscar_norm = normalizar_texto_busqueda(titulo_buscar)
    mejor_libro = None
    mejor_score = 0.0
    for book in books:
        titulo = book.get('titulo', '')
        titulo_norm = normalizar_texto_busqueda(titulo)
        # Usar difflib para coincidencia flexible
        score = difflib.SequenceMatcher(None, titulo_buscar_norm, titulo_norm).ratio()
        if score > mejor_score:
            mejor_score = score
            mejor_libro = book
    # Considerar coincidencia si el score es razonable (>0.5)
    if mejor_score > 0.5:
        print(f"[DEBUG] Mejor coincidencia: '{mejor_libro.get('titulo','')}' con score {mejor_score}")
        return mejor_libro
    print(f"[DEBUG] No se encontró coincidencia razonable para: '{titulo_buscar}' (mejor score: {mejor_score})")
    return None

def es_pregunta_general(texto):
    preguntas = [
        "como te llamas", "quien eres", "que eres", "que puedes hacer", "ayuda", "quien te creo", "que sabes hacer", "eres un bot", "eres humano", "cual es tu nombre"
    ]
    texto = texto.lower()
    return any(p in texto for p in preguntas)

def es_consulta_servicios(texto):
    servicios_keywords = [
        "servicios", "que hay", "que ofrece", "que puedo hacer", "que puedo encontrar",
        "horario", "horarios", "abierto", "cerrado", "prestamo", "préstamo",
        "internet", "wifi", "computadoras", "estudio", "sala", "salas"
    ]
    texto = texto.lower()
    return any(keyword in texto for keyword in servicios_keywords)

def obtener_info_servicios():
    return {
        "respuesta": """En nuestra biblioteca ofrecemos los siguientes servicios:

1. Préstamo de libros
2. Sala de lectura
3. Acceso a internet
4. Área de estudio
5. Consulta de material bibliográfico
6. Servicio de fotocopias
7. Asesoría en búsqueda de información

¿Te gustaría saber más detalles sobre alguno de estos servicios?""",
        "libros": []
    }

def es_consulta_horarios(texto):
    horarios_keywords = [
        "horario", "hora", "abre", "cierra", "días", "dias", "lunes", "martes", 
        "miércoles", "miercoles", "jueves", "viernes", "sábado", "sabado", "domingo",
        "mañana", "manana", "tarde", "noche"
    ]
    texto = texto.lower()
    return any(keyword in texto for keyword in horarios_keywords)

def obtener_info_horarios():
    return {
        "respuesta": "La biblioteca abre de lunes a viernes de 9:00 a 18:30 y sábados de 9:00 a 14:00.",
        "libros": []
    }

def es_pregunta_personal(texto):
    preguntas_personales = [
        "cual es tu nombre", "como te llamas", "quien eres", "que eres",
        "cual es tu funcion", "que haces", "para que sirves", "que puedes hacer",
        "como te llamas", "cual es tu rol", "que tipo de asistente eres"
    ]
    texto = texto.lower().strip()
    return any(pregunta in texto for pregunta in preguntas_personales)

def obtener_respuesta_personal():
    return {
        "respuesta": "Mi nombre es LibroFinder, soy el asistente virtual de la biblioteca. Estoy aquí para ayudarte a encontrar libros, informarte sobre nuestros servicios y horarios, y responder cualquier pregunta que tengas sobre la biblioteca. ¿En qué puedo ayudarte hoy?",
        "libros": []
    }

def buscar_libros_similares(libro_actual, books):
    if not libro_actual or not books:
        return []
    
    # Obtener materia y autor del libro actual
    materia_actual = libro_actual.get('materia', '').lower()
    autor_actual = libro_actual.get('autor_personal', '').lower()
    titulo_actual = libro_actual.get('titulo', '').lower()
    
    similares = []
    for libro in books:
        # Skip the same book
        if libro.get('titulo', '').lower() == titulo_actual:
            continue
            
        # Calcular puntuación de similitud
        puntuacion = 0
        
        # Misma materia (+3 puntos)
        if libro.get('materia', '').lower() == materia_actual:
            puntuacion += 3
            
        # Mismo autor (+2 puntos)
        if libro.get('autor_personal', '').lower() == autor_actual:
            puntuacion += 2
            
        # Palabras clave similares en el título (+1 punto por palabra)
        palabras_titulo_actual = set(titulo_actual.split())
        palabras_titulo_libro = set(libro.get('titulo', '').lower().split())
        palabras_comunes = palabras_titulo_actual.intersection(palabras_titulo_libro)
        puntuacion += len(palabras_comunes)
        
        if puntuacion > 0:
            similares.append((libro, puntuacion))
    
    # Ordenar por puntuación y tomar los 3 más similares
    similares.sort(key=lambda x: x[1], reverse=True)
    return [libro for libro, _ in similares[:3]]

def es_consulta_sugerencias(texto):
    sugerencias_keywords = [
        "similar", "parecido", "recomienda", "sugiere", "como este",
        "otros como", "más como", "algo como", "algo parecido",
        "recomendación", "sugerencia"
    ]
    texto = texto.lower()
    return any(keyword in texto for keyword in sugerencias_keywords)

def es_pregunta_resumen(texto):
    patrones = [
        r"de qu[ée] trata",
        r"de que trata",
        r"resumen",
        r"sinopsis",
        r"qu[ée] es",
        r"que es",
        r"habla sobre",
        r"trata sobre",
        r"cu[eé]ntame sobre",
        r"explicame",
        r"informaci[oó]n sobre",
        r"expl[ií]came",
        r"d[ií]me qu[ée] es",
        r"d[ií]me de qu[ée] trata",
        r"d[ií]me sobre",
        r"quiero saber sobre",
        r"quiero saber de",
        r"quiero saber qu[ée] es",
        r"quiero saber de qu[ée] trata"
    ]
    texto = texto.lower()
    resultado = any(re.search(patron, texto) for patron in patrones)
    print(f"[DEBUG] es_pregunta_resumen('{texto}') = {resultado}")
    return resultado

def es_consulta_libros_nuevos(texto):
    patrones = [
        r"libros nuevos",
        r"nuevos libros",
        r"novedades",
        r"que hay nuevo",
        r"que hay de nuevo",
        r"ultimos libros",
        r"últimos libros",
        r"recientes",
        r"recien llegados",
        r"recién llegados"
    ]
    texto = texto.lower()
    return any(re.search(patron, texto) for patron in patrones)

def consultar_prestamos_activos():
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor(dictionary=True)
        
        query = """
            SELECT 
                e.nombre, 
                e.apellido,
                l.titulo,
                a.nombre as autor,
                p.fecha_prestamo,
                p.fecha_devolucion
            FROM prestamo p
            JOIN estudiante e ON p.id_estudiante = e.id
            JOIN libro l ON p.id_libro = l.id
            JOIN autor a ON l.id_autor = a.id
            WHERE p.estado = 'prestado'
            ORDER BY p.fecha_prestamo DESC
        """
        
        cursor.execute(query)
        prestamos = cursor.fetchall()
        return prestamos
    except Exception as e:
        print(f"Error al consultar préstamos: {str(e)}")
        return []
    finally:
        if 'conn' in locals():
            conn.close()

def es_consulta_prestamos(texto):
    patrones = [
        r"que alumno tiene prestamos",
        r"quien tiene prestamos",
        r"quienes tienen prestamos",
        r"prestamos activos",
        r"libros prestados",
        r"quien tiene libros prestados",
        r"quienes tienen libros prestados"
    ]
    texto = texto.lower()
    return any(re.search(patron, texto) for patron in patrones)

def generar_respuesta_prestamos():
    prestamos = consultar_prestamos_activos()
    
    if not prestamos:
        return {
            "respuesta": "Actualmente no hay libros prestados en la biblioteca.",
            "libros": []
        }
    
    # Agrupar préstamos por estudiante
    prestamos_por_estudiante = {}
    for prestamo in prestamos:
        key = f"{prestamo['nombre']} {prestamo['apellido']}"
        if key not in prestamos_por_estudiante:
            prestamos_por_estudiante[key] = []
        prestamos_por_estudiante[key].append(prestamo)
    
    # Construir respuesta
    respuesta = "Aquí están los préstamos activos:\n\n"
    for estudiante, libros in prestamos_por_estudiante.items():
        respuesta += f"El estudiante {estudiante} tiene los siguientes libros prestados:\n"
        for libro in libros:
            respuesta += f"- {libro['titulo']} ({libro['autor']})\n"
        respuesta += "\n"
    
    return {
        "respuesta": respuesta,
        "libros": []
    }

@app.route('/')
def home():
    return "Servidor Flask funcionando 🎉"

@app.route('/buscar_libros', methods=['POST'])
def buscar_libros():
    tiempo_inicio = time.time()
    try:
        data = request.get_json()
        query = data.get('query', '').strip().lower()
        books = data.get('books', [])
        print(f"[DEBUG] Recibido query: {query}")
        print(f"[DEBUG] Recibidos {len(books)} libros")

        # 1. FAQ - Check this BEFORE any other processing
        faq = buscar_faq_por_regex(query)
        if faq:
            print(f"[DEBUG] FAQ encontrada: {faq['pregunta']}")
            respuesta = faq['respuesta']
            tiempo_respuesta = time.time() - tiempo_inicio
            registrar_log(query, respuesta, tiempo_respuesta)
            return jsonify({
                "respuesta": respuesta,
                "libros": []
            })

        # 2. Si es una consulta de préstamos
        if es_consulta_prestamos(query):
            respuesta = generar_respuesta_prestamos()
            tiempo_respuesta = time.time() - tiempo_inicio
            registrar_log(query, respuesta["respuesta"], tiempo_respuesta)
            return jsonify(respuesta)

        # 2. Si es una consulta de sugerencias
        if es_consulta_sugerencias(query):
            # Buscar el último libro mencionado
            libro_actual = None
            for book in books:
                if book.get('titulo', '').lower() in query.lower():
                    libro_actual = book
                    break
            
            if libro_actual:
                similares = buscar_libros_similares(libro_actual, books)
                if similares:
                    respuesta = f"Basado en '{libro_actual.get('titulo', '')}', te sugiero estos libros similares:\n\n"
                    for libro in similares:
                        respuesta += f"- {libro.get('titulo', '')} por {libro.get('autor_personal', '')}\n"
                        respuesta += f"  Materia: {libro.get('materia', '')}\n"
                        respuesta += f"  Ubicación: {libro.get('ubicacion', '')}\n\n"
                    tiempo_respuesta = time.time() - tiempo_inicio
                    registrar_log(query, respuesta, tiempo_respuesta)
                    return jsonify({
                        "respuesta": respuesta,
                        "libros": similares
                    })
                else:
                    tiempo_respuesta = time.time() - tiempo_inicio
                    registrar_log(query, f"Lo siento, no encontré libros similares a '{libro_actual.get('titulo', '')}'. ¿Te gustaría buscar por otro criterio?", tiempo_respuesta)
                    return jsonify({
                        "respuesta": f"Lo siento, no encontré libros similares a '{libro_actual.get('titulo', '')}'. ¿Te gustaría buscar por otro criterio?",
                        "libros": []
                    })
            else:
                tiempo_respuesta = time.time() - tiempo_inicio
                registrar_log(query, "¿Podrías mencionar el título del libro para el que quieres sugerencias similares?", tiempo_respuesta)
                return jsonify({
                    "respuesta": "¿Podrías mencionar el título del libro para el que quieres sugerencias similares?",
                    "libros": []
                })

        # Si es una pregunta sobre el resumen de un libro
        if es_pregunta_resumen(query):
            libro_encontrado = buscar_libro_por_titulo_parcial(query, books)
            
            if libro_encontrado:
                # Normalizar el estado del libro
                libro_encontrado = obtener_detalles_libro(libro_encontrado)
                descripcion = libro_encontrado.get('descripcion', '').strip()
                if descripcion:
                    resumen = generar_resumen_libro(libro_encontrado.get('titulo', ''), libro_encontrado.get('autor_personal', ''), descripcion)
                    if resumen:
                        tiempo_respuesta = time.time() - tiempo_inicio
                        registrar_log(query, resumen, tiempo_respuesta)
                        return jsonify({
                            'respuesta': f"{resumen}",
                            'libros': [libro_encontrado]
                        })
                    else:
                        tiempo_respuesta = time.time() - tiempo_inicio
                        registrar_log(query, f"El libro '{libro_encontrado['titulo']}' trata sobre: {descripcion}", tiempo_respuesta)
                        return jsonify({
                            'respuesta': f"El libro '{libro_encontrado['titulo']}' trata sobre: {descripcion}",
                            'libros': [libro_encontrado]
                        })
                info_web = buscar_info_libro_web(
                    libro_encontrado.get('titulo', ''),
                    libro_encontrado.get('autor_personal', '')
                )
                if info_web:
                    resumen = generar_resumen_libro(libro_encontrado.get('titulo', ''), libro_encontrado.get('autor_personal', ''), info_web)
                    if resumen:
                        tiempo_respuesta = time.time() - tiempo_inicio
                        registrar_log(query, resumen, tiempo_respuesta)
                        return jsonify({
                            'respuesta': f"{resumen}",
                            'libros': [libro_encontrado]
                        })
                    else:
                        tiempo_respuesta = time.time() - tiempo_inicio
                        registrar_log(query, f"El libro '{libro_encontrado['titulo']}' trata sobre: {info_web}", tiempo_respuesta)
                        return jsonify({
                            'respuesta': f"El libro '{libro_encontrado['titulo']}' trata sobre: {info_web}",
                            'libros': [libro_encontrado]
                        })
                datos = f"Título: {libro_encontrado.get('titulo', 'Desconocido')}\n"
                datos += f"Autor: {libro_encontrado.get('autor_personal', 'No especificado')}\n"
                datos += f"Editorial: {libro_encontrado.get('editorial', 'No especificada')}\n"
                datos += f"Materia: {libro_encontrado.get('materia', 'No especificada')}\n"
                datos += f"Código: {libro_encontrado.get('codigo_libro', 'No especificado')}\n"
                datos += f"Ubicación: {libro_encontrado.get('ubicacion', 'No especificada')}\n"
                datos += f"Estado: {libro_encontrado.get('estado', 'No especificado')}"
                tiempo_respuesta = time.time() - tiempo_inicio
                registrar_log(query, f"No tengo un resumen disponible para este libro, pero aquí tienes sus datos principales:\n{datos}", tiempo_respuesta)
                return jsonify({
                    'respuesta': f"No tengo un resumen disponible para este libro, pero aquí tienes sus datos principales:\n{datos}",
                    'libros': [libro_encontrado]
                })
            else:
                tiempo_respuesta = time.time() - tiempo_inicio
                registrar_log(query, "No encontré el libro mencionado en tu consulta.", tiempo_respuesta)
                return jsonify({
                    'respuesta': "No encontré el libro mencionado en tu consulta.",
                    'libros': []
                })

        # Verificar si Ollama está disponible
        try:
            requests.get('http://localhost:11434/api/generate', timeout=60)
        except:
            print("Ollama no está disponible, usando respuestas predefinidas")
            # Si Ollama no está disponible, usar respuestas predefinidas
            if es_busqueda_por_tema(query):
                libros_clave = buscar_por_palabras_clave(query, books)
                if libros_clave:
                    libros_actualizados = [obtener_detalles_libro(libro) for libro in libros_clave]
                    tiempo_respuesta = time.time() - tiempo_inicio
                    registrar_log(query, f"He encontrado estos libros que podrían interesarte: {', '.join([libro['titulo'] for libro in libros_actualizados])}", tiempo_respuesta)
                    return jsonify({
                        "respuesta": f"He encontrado estos libros que podrían interesarte: {', '.join([libro['titulo'] for libro in libros_actualizados])}",
                        "libros": libros_actualizados
                    })
            tiempo_respuesta = time.time() - tiempo_inicio
            registrar_log(query, "Lo siento, no encontré libros que coincidan con tu búsqueda. ¿Podrías ser más específico?", tiempo_respuesta)
            return jsonify({
                "respuesta": "Lo siento, no encontré libros que coincidan con tu búsqueda. ¿Podrías ser más específico?",
                "libros": []
            })

        # 1. Si es una consulta sobre horarios
        if es_consulta_horarios(query):
            tiempo_respuesta = time.time() - tiempo_inicio
            registrar_log(query, "Consulta sobre horarios", tiempo_respuesta)
            respuesta = obtener_info_horarios()
            tiempo_respuesta = time.time() - tiempo_inicio
            registrar_log(query, respuesta["respuesta"], tiempo_respuesta)
            return jsonify(respuesta)

        # 2. Si es una pregunta personal
        if es_pregunta_personal(query):
            tiempo_respuesta = time.time() - tiempo_inicio
            registrar_log(query, "Pregunta personal", tiempo_respuesta)
            respuesta = obtener_respuesta_personal()
            tiempo_respuesta = time.time() - tiempo_inicio
            registrar_log(query, respuesta["respuesta"], tiempo_respuesta)
            return jsonify(respuesta)

        # 3. Si es una consulta sobre servicios
        if es_consulta_servicios(query):
            tiempo_respuesta = time.time() - tiempo_inicio
            registrar_log(query, "Consulta sobre servicios", tiempo_respuesta)
            prompt = f"""Usuario: {query}

Asistente: ¡Con gusto te informo sobre los servicios que ofrecemos en nuestra biblioteca! Tenemos:

- Préstamo de libros para llevar a casa
- Sala de lectura con ambiente tranquilo
- Acceso a internet para investigación
- Área de estudio individual y grupal
- Consulta de material bibliográfico
- Servicio de fotocopias
- Asesoría personalizada en búsqueda de información

¿Te gustaría que te explique más detalles sobre alguno de estos servicios? Estoy aquí para ayudarte a aprovechar al máximo todos nuestros recursos."""
            
            respuesta_llm = generar_respuesta_ollama(prompt)
            if respuesta_llm:
                tiempo_respuesta = time.time() - tiempo_inicio
                registrar_log(query, respuesta_llm, tiempo_respuesta)
                return jsonify({
                    "respuesta": respuesta_llm,
                    "libros": []
                })
            else:
                tiempo_respuesta = time.time() - tiempo_inicio
                registrar_log(query, "¡Con gusto te informo sobre los servicios que ofrecemos en nuestra biblioteca! Tenemos préstamo de libros, sala de lectura, acceso a internet, área de estudio, consulta de material bibliográfico, servicio de fotocopias y asesoría en búsqueda de información. ¿Te gustaría que te explique más detalles sobre alguno de estos servicios?", tiempo_respuesta)
                return jsonify({
                    "respuesta": "¡Con gusto te informo sobre los servicios que ofrecemos en nuestra biblioteca! Tenemos préstamo de libros, sala de lectura, acceso a internet, área de estudio, consulta de material bibliográfico, servicio de fotocopias y asesoría en búsqueda de información. ¿Te gustaría que te explique más detalles sobre alguno de estos servicios?",
                    "libros": []
                })

        # 5. Si es una búsqueda por tema
        if es_busqueda_por_tema(query):
            # Primero intentar búsqueda semántica
            tiempo_inicio_busqueda = time.time()
            query_norm = normalize_text(query)
            book_texts = [prepare_book_text(book) for book in books]
            query_embedding = sentence_model.encode([query_norm])[0]
            book_embeddings = sentence_model.encode(book_texts)
            similarities = cosine_similarity([query_embedding], book_embeddings)[0]
            similar_indices = similarities.argsort()[-5:][::-1]
            relevant_books = []
            for idx in similar_indices:
                similarity = similarities[idx]
                if similarity > 0.3:
                    book = books[idx].copy()
                    libro_actualizado = obtener_detalles_libro(book)
                    libro_actualizado['similarity'] = float(similarity)
                    libro_actualizado['codigo_libro'] = libro_actualizado.get('codigo_libro', 'No especificado')
                    libro_actualizado['ubicacion'] = libro_actualizado.get('ubicacion', 'No especificada')
                    relevant_books.append(libro_actualizado)
            
            if relevant_books:
                tiempo_respuesta = time.time() - tiempo_inicio_busqueda
                registrar_log(query, f"He encontrado estos libros que podrían interesarte: {', '.join([libro['titulo'] for libro in relevant_books])}", tiempo_respuesta)
                respuesta_llm = generar_respuesta_ollama(query, libros_encontrados=relevant_books)
                tiempo_respuesta = time.time() - tiempo_inicio
                registrar_log(query, respuesta_llm, tiempo_respuesta)
                return jsonify({
                    "respuesta": respuesta_llm if respuesta_llm else f"He encontrado estos libros que podrían interesarte: {', '.join([libro['titulo'] for libro in relevant_books])}",
                    "libros": relevant_books
                })
            else:
                # Si no hay resultados semánticos, intentar búsqueda por palabras clave
                tiempo_inicio_clave = time.time()
                libros_clave = buscar_por_palabras_clave(query, books)
                if libros_clave:
                    libros_actualizados = [obtener_detalles_libro(libro) for libro in libros_clave]
                    tiempo_respuesta = time.time() - tiempo_inicio_clave
                    registrar_log(query, f"He encontrado estos libros que podrían interesarte: {', '.join([libro['titulo'] for libro in libros_actualizados])}", tiempo_respuesta)
                    respuesta_llm = generar_respuesta_ollama(query, libros_encontrados=libros_actualizados)
                    tiempo_respuesta = time.time() - tiempo_inicio
                    registrar_log(query, respuesta_llm, tiempo_respuesta)
                    return jsonify({
                        "respuesta": respuesta_llm if respuesta_llm else f"He encontrado estos libros que podrían interesarte: {', '.join([libro['titulo'] for libro in libros_actualizados])}",
                        "libros": libros_actualizados
                    })

        # 6. Si es una búsqueda por palabra clave
        if es_busqueda_por_palabra_clave(query):
            tiempo_inicio_clave = time.time()
            libros_clave = buscar_por_palabras_clave(query, books)
            if libros_clave:
                libros_actualizados = [obtener_detalles_libro(libro) for libro in libros_clave]
                tiempo_respuesta = time.time() - tiempo_inicio_clave
                registrar_log(query, f"He encontrado estos libros que podrían interesarte: {', '.join([libro['titulo'] for libro in libros_actualizados])}", tiempo_respuesta)
                respuesta_llm = generar_respuesta_ollama(query, libros_encontrados=libros_actualizados)
                tiempo_respuesta = time.time() - tiempo_inicio
                registrar_log(query, respuesta_llm, tiempo_respuesta)
                return jsonify({
                    "respuesta": respuesta_llm if respuesta_llm else f"He encontrado estos libros que podrían interesarte: {', '.join([libro['titulo'] for libro in libros_actualizados])}",
                    "libros": libros_actualizados
                })

        # 7. Si coincide con un patrón regex de FAQ
        faq = buscar_faq_por_regex(query)
        if faq:
            tiempo_inicio_faq = time.time()
            prompt = f"""Usuario: {query}

Asistente: {faq['respuesta']}

¿Hay algo más en lo que pueda ayudarte? Estoy aquí para resolver cualquier otra duda que tengas sobre nuestra biblioteca."""
            
            respuesta_llm = generar_respuesta_ollama(prompt)
            tiempo_respuesta = time.time() - tiempo_inicio_faq
            registrar_log(query, respuesta_llm, tiempo_respuesta)
            return jsonify({"respuesta": respuesta_llm if respuesta_llm else faq['respuesta'], "libros": []})

        # 8. Si es una consulta general de búsqueda, pide más detalles
        if es_consulta_general_busqueda(query):
            tiempo_inicio_general = time.time()
            prompt = f"""Usuario: {query}

Asistente: ¡Claro! Estoy aquí para ayudarte a encontrar el libro que necesitas. ¿Podrías decirme si buscas un libro por título, autor o tema en particular? Esto me ayudará a darte una mejor recomendación."""
            
            respuesta_llm = generar_respuesta_ollama(prompt)
            tiempo_respuesta = time.time() - tiempo_inicio_general
            registrar_log(query, respuesta_llm, tiempo_respuesta)
            return jsonify({
                "respuesta": respuesta_llm if respuesta_llm else "¡Claro! ¿Sobre qué tema, autor o título te gustaría buscar un libro?",
                "libros": []
            })

        # 9. Si coincide con un libro exacto
        libro_encontrado = buscar_por_titulo(query, books)
        if libro_encontrado:
            libro_actualizado = obtener_detalles_libro(libro_encontrado)
            tiempo_respuesta = time.time() - tiempo_inicio
            registrar_log(query, f"He encontrado este libro que podría interesarte: {libro_actualizado.get('titulo', '')}", tiempo_respuesta)
            respuesta_llm = generar_respuesta_ollama(query, libros_encontrados=[libro_actualizado])
            tiempo_respuesta = time.time() - tiempo_inicio
            registrar_log(query, respuesta_llm, tiempo_respuesta)
            return jsonify({
                "respuesta": respuesta_llm if respuesta_llm else f"He encontrado este libro que podría interesarte: {libro_actualizado.get('titulo', '')}",
                "libros": [libro_actualizado]
            })

        # 10. Si no se encontró nada, intentar búsqueda semántica
        tiempo_inicio_semantico = time.time()
        query_norm = normalize_text(query)
        book_texts = [prepare_book_text(book) for book in books]
        query_embedding = sentence_model.encode([query_norm])[0]
        book_embeddings = sentence_model.encode(book_texts)
        similarities = cosine_similarity([query_embedding], book_embeddings)[0]
        similar_indices = similarities.argsort()[-5:][::-1]
        relevant_books = []
        for idx in similar_indices:
            similarity = similarities[idx]
            if similarity > 0.3:
                book = books[idx].copy()
                libro_actualizado = obtener_detalles_libro(book)
                libro_actualizado['similarity'] = float(similarity)
                libro_actualizado['codigo_libro'] = libro_actualizado.get('codigo_libro', 'No especificado')
                libro_actualizado['ubicacion'] = libro_actualizado.get('ubicacion', 'No especificada')
                relevant_books.append(libro_actualizado)
        
        if relevant_books:
            tiempo_respuesta = time.time() - tiempo_inicio_semantico
            registrar_log(query, f"He encontrado estos libros que podrían interesarte: {', '.join([libro['titulo'] for libro in relevant_books])}", tiempo_respuesta)
            respuesta_llm = generar_respuesta_ollama(query, libros_encontrados=relevant_books)
            tiempo_respuesta = time.time() - tiempo_inicio
            registrar_log(query, respuesta_llm, tiempo_respuesta)
            return jsonify({
                "respuesta": respuesta_llm if respuesta_llm else f"He encontrado estos libros que podrían interesarte: {', '.join([libro['titulo'] for libro in relevant_books])}",
                "libros": relevant_books
            })
        else:
            tiempo_inicio_semantico = time.time()
            prompt = f"""Usuario: {query}

Asistente: Lo siento, no encontré libros que coincidan exactamente con tu búsqueda. ¿Podrías ser más específico sobre el tema, autor o título que estás buscando? También puedo ayudarte a explorar otras opciones o sugerir temas relacionados."""
            
            respuesta_llm = generar_respuesta_ollama(prompt)
            tiempo_respuesta = time.time() - tiempo_inicio_semantico
            registrar_log(query, respuesta_llm, tiempo_respuesta)
            return jsonify({
                "respuesta": respuesta_llm if respuesta_llm else "No se encontraron libros relevantes para tu búsqueda. ¿Podrías ser más específico?",
                "libros": []
            })
    except Exception as e:
        tiempo_respuesta = time.time() - tiempo_inicio
        error_msg = f"Error: {str(e)}"
        registrar_log(query, error_msg, tiempo_respuesta)
        return jsonify({
            "respuesta": "Lo siento, ha ocurrido un error. Por favor, intenta de nuevo.",
            "libros": []
        })

if __name__ == '__main__':
    print("Iniciando servidor Flask...")
    try:
        app.run(host='localhost', port=8080, debug=True, threaded=True)
        print("Servidor Flask iniciado en http://localhost:8080")
    except Exception as e:
        print(f"Error al iniciar el servidor: {str(e)}")
# Nota: Usando 'flask run' es suficiente para desarrollo.
# Para producción se recomienda un servidor WSGI como Gunicorn o uWSGI. 