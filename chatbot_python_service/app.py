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
import numpy as np
from sklearn.preprocessing import normalize
import pickle
from collections import defaultdict

app = Flask(__name__)
app.secret_key = 'supersecretkey'  # Necesario para usar sesiones

# Configuración de la base de datos
db_config = {
    'host': os.getenv('MYSQL_HOST', 'localhost'),
    'user': os.getenv('MYSQL_USER', 'root'),
    'password': os.getenv('MYSQL_PASSWORD', ''),
    'database': os.getenv('MYSQL_DATABASE', 'biblioteca')
}

# Configuración de caché
CACHE_DIR = os.path.join(os.path.dirname(__file__), 'cache')
os.makedirs(CACHE_DIR, exist_ok=True)

def convertir_tiempo_ns_a_segundos(nanosegundos):
    """Convierte nanosegundos a segundos con formato legible"""
    return nanosegundos / 1_000_000_000

def mostrar_logs_tiempo_ollama(response_data):
    """Muestra los logs de tiempo de Ollama en formato legible"""
    if 'total_duration' in response_data:
        total_sec = convertir_tiempo_ns_a_segundos(response_data['total_duration'])
        load_sec = convertir_tiempo_ns_a_segundos(response_data.get('load_duration', 0))
        prompt_eval_sec = convertir_tiempo_ns_a_segundos(response_data.get('prompt_eval_duration', 0))
        eval_sec = convertir_tiempo_ns_a_segundos(response_data.get('eval_duration', 0))
        
        print(f"[DEBUG] Tiempos de Ollama (segundos):")
        print(f"  - Total: {total_sec:.2f}s")
        print(f"  - Carga: {load_sec:.2f}s")
        print(f"  - Evaluación prompt: {prompt_eval_sec:.2f}s")
        print(f"  - Evaluación: {eval_sec:.2f}s")
        print(f"  - Prompts evaluados: {response_data.get('prompt_eval_count', 0)}")
        print(f"  - Evaluaciones: {response_data.get('eval_count', 0)}")

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
        # Limpiar y preparar la consulta
        query = f"{titulo} {autor}"
        query = query.replace(' ', '+')
        
        # Buscar en Google Books API
        url = f"https://www.googleapis.com/books/v1/volumes?q={query}&langRestrict=es"
        print(f"[DEBUG] Buscando en Google Books: {url}")
        
        response = requests.get(url, timeout=10)
        if response.status_code == 200:
            data = response.json()
            if 'items' in data and len(data['items']) > 0:
                # Tomar el primer resultado relevante
                libro = data['items'][0]['volumeInfo']
                descripcion = libro.get('description', '')
                if descripcion:
                    print(f"[DEBUG] Encontrada descripción en Google Books: {descripcion[:100]}...")
                    return descripcion[:1000]  # Limitar a 1000 caracteres
                else:
                    print("[DEBUG] No se encontró descripción en el resultado de Google Books")
            else:
                print("[DEBUG] No se encontraron resultados en Google Books")
        else:
            print(f"[DEBUG] Error en la respuesta de Google Books: {response.status_code}")
        return None
    except Exception as e:
        print(f"[DEBUG] Error al buscar información del libro en Google Books: {str(e)}")
        return None

def generar_resumen_libro(titulo, autor, info_web):
    prompt = f"""Genera una sinopsis breve (2-3 oraciones) y clara del siguiente libro, usando la información proporcionada. Sé directo y conciso.

Título: {titulo}
Autor: {autor}

Información encontrada:
{info_web}

Instrucciones:
1. Si no hay suficiente información, indica que no se puede generar un resumen detallado.
2. No inventes información que no esté en los datos proporcionados.
3. Mantén el resumen objetivo y basado en hechos.
4. Si el libro es filosófico o teórico, enfócate en sus principales conceptos.
5. Si el libro es histórico o social, destaca su contexto y relevancia.
"""
    try:
        print("[DEBUG] Enviando prompt a Mistral/Ollama:", prompt[:300])
        response = requests.post('http://localhost:11434/api/generate', 
                               json={
                                   "model": "mistral",
                                   "prompt": prompt,
                                   "stream": False,
                                   "max_tokens": 150,
                                   "temperature": 0.3
                               })
        print("[DEBUG] Status code de Ollama:", response.status_code)
        if response.status_code == 200:
            response_data = response.json()
            
            # Mostrar logs de tiempo en formato legible
            mostrar_logs_tiempo_ollama(response_data)
            
            return response_data.get('response', '')
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
                    return faq['respuesta']
            except Exception as e:
                print(f"Error en regex pattern: {e}")
                continue
        elif faq.get('pregunta', '').strip().lower() == query:
            return faq['respuesta']
    
    # If no exact match, try semantic matching
    for faq in faqs:
        pregunta = faq.get('pregunta', '').lower()
        # Check if the query contains key location-related words
        location_words = ['donde', 'dónde', 'ubicación', 'ubicacion', 'lugar', 'zona', 'sección', 'seccion']
        if any(word in query for word in location_words) and any(word in pregunta for word in location_words):
            return faq['respuesta']
        
        # Check for similar words using difflib
        similarity = difflib.SequenceMatcher(None, query, pregunta).ratio()
        if similarity > 0.6:  # Adjust threshold as needed
            return faq['respuesta']
    
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
        # Preparar el prompt con información de libros si está disponible
        if libros_encontrados:
            libros_info = []
            for libro in libros_encontrados:
                # Verificar si el libro existe en la base de datos
                if libro.get('id') is not None:
                    estado = 'Disponible' if int(libro.get('cantidad', 0)) > 0 else 'No disponible'
                    ubicacion = libro.get('ubicacion')
                    if not ubicacion or not isinstance(ubicacion, str) or ubicacion.strip() == '':
                        ubicacion = 'No especificada'
                    libros_info.append(
                        f"- {libro['titulo']} de {libro.get('autor_personal', 'Autor desconocido')} "
                        f"(Ubicación: {ubicacion}, "
                        f"Estado: {estado})"
                    )
                else:
                    libros_info.append(
                        f"- {libro['titulo']} de {libro.get('autor_personal', 'Autor desconocido')} "
                        f"(Este libro no está disponible en nuestra biblioteca)"
                    )
            
            libros_texto = "\n".join(libros_info)
            
            # Prompt más restrictivo para evitar que el modelo invente información
            prompt_restrictivo = f"""
{prompt}

IMPORTANTE: Solo puedes mencionar y recomendar los siguientes libros que están disponibles en nuestra biblioteca. NO inventes ni menciones otros libros que no estén en esta lista:

{libros_texto}

Instrucciones:
1. Solo menciona los libros de la lista anterior
2. NO inventes títulos, autores, ubicaciones o información que no esté en la lista
3. Si no hay libros relevantes en la lista, di que no tienes libros sobre ese tema
4. Usa exactamente la información proporcionada (título, autor, ubicación, estado)
5. No agregues información adicional que no esté en los datos proporcionados
"""
        else:
            # Si no hay libros encontrados, ser muy claro sobre esto
            prompt_restrictivo = f"""
{prompt}

IMPORTANTE: No tengo libros en mi base de datos que coincidan con tu consulta. 
No puedo recomendarte libros que no están disponibles en nuestra biblioteca.
Por favor, intenta con otros términos de búsqueda o consulta nuestro catálogo completo.
"""
        
        # Llamar a la API de Ollama
        response = requests.post(
            'http://localhost:11434/api/generate',
            json={
                'model': model,
                'prompt': prompt_restrictivo,
                'max_tokens': 500,
                'temperature': 0.3,  # Reducir temperatura para respuestas más consistentes
                'stream': False
            }
        )
        
        if response.status_code == 200:
            response_data = response.json()
            
            # Mostrar logs de tiempo en formato legible
            mostrar_logs_tiempo_ollama(response_data)
            
            return response_data['response']
        else:
            return "Lo siento, no pude procesar tu solicitud en este momento."
            
    except Exception as e:
        print(f"Error en generar_respuesta_ollama: {str(e)}")
        return "Lo siento, hubo un error al procesar tu solicitud."

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

def es_busqueda_por_tema(query):
    temas = [
        "alma", "filosofía", "filosofia", "psicología", "psicologia", "historia",
        "literatura", "ciencia", "arte", "matemáticas", "matematicas", "física",
        "fisica", "química", "quimica", "biología", "biologia", "medicina",
        "derecho", "economía", "economia", "política", "politica", "sociología",
        "sociologia", "antropología", "antropologia", "religión", "religion"
    ]
    texto = query.lower()
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

def es_pregunta_general(query):
    preguntas = [
        "como te llamas", "quien eres", "que eres", "que puedes hacer", "ayuda", "quien te creo", "que sabes hacer", "eres un bot", "eres humano", "cual es tu nombre"
    ]
    texto = query.lower()
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
    
    # Extraer palabras clave importantes del título (palabras de más de 4 caracteres)
    palabras_clave_titulo = [palabra for palabra in titulo_actual.split() if len(palabra) > 4]
    
    similares = []
    for libro in books:
        # Skip the same book
        if libro.get('titulo', '').lower() == titulo_actual:
            continue
            
        # Verificar que el libro exista en la base de datos
        if libro.get('id') is None:
            continue
            
        # Verificar que el libro esté disponible
        cantidad = libro.get('cantidad', 0)
        try:
            cantidad = int(cantidad)
        except Exception:
            cantidad = 0
            
        if cantidad <= 0:
            continue
            
        # Calcular puntuación de similitud
        puntuacion = 0
        titulo_libro = libro.get('titulo', '').lower()
        materia_libro = libro.get('materia', '').lower()
        autor_libro = libro.get('autor_personal', '').lower()
        
        # Misma materia (+5 puntos)
        if materia_libro == materia_actual and materia_actual:
            puntuacion += 5
            
        # Mismo autor (+3 puntos)
        if autor_libro == autor_actual and autor_actual:
            puntuacion += 3
            
        # Palabras clave del título en el título del libro (+2 puntos por palabra)
        for palabra_clave in palabras_clave_titulo:
            if palabra_clave in titulo_libro:
                puntuacion += 2
            
        # Palabras clave del título en la materia del libro (+1 punto por palabra)
        for palabra_clave in palabras_clave_titulo:
            if palabra_clave in materia_libro:
                puntuacion += 1
                
        # Palabras clave del título en la descripción del libro (+1 punto por palabra)
        descripcion_libro = libro.get('descripcion', '').lower()
        for palabra_clave in palabras_clave_titulo:
            if palabra_clave in descripcion_libro:
                puntuacion += 1
        
        # Coincidencias de palabras comunes en el título (+1 punto por palabra)
        palabras_titulo_actual = set(titulo_actual.split())
        palabras_titulo_libro = set(titulo_libro.split())
        palabras_comunes = palabras_titulo_actual.intersection(palabras_titulo_libro)
        puntuacion += len(palabras_comunes)
        
        # Si hay alguna puntuación, agregar el libro
        if puntuacion > 0:
            similares.append((libro, puntuacion))
    
    # Ordenar por puntuación y tomar los 5 más similares
    similares.sort(key=lambda x: x[1], reverse=True)
    return [libro for libro, _ in similares[:5]]

def es_consulta_sugerencias(texto):
    sugerencias_keywords = [
        "similar", "parecido", "recomienda", "sugiere", "como este",
        "otros como", "más como", "algo como", "algo parecido",
        "recomendación", "sugerencia", "similar a", "parecido a",
        "libros similares", "libros parecidos", "recomiéndame",
        "sugiéreme", "me recomiendas", "me sugieres"
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
        r"quiero saber de qu[ée] trata",
        r"contenido",
        r"temas",
        r"argumento",
        r"trama"
    ]
    texto = texto.lower().strip()
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

# Función para cargar o generar embeddings en caché
def get_cached_embeddings(books, force_reload=False):
    cache_file = os.path.join(CACHE_DIR, 'book_embeddings.pkl')
    
    if not force_reload and os.path.exists(cache_file):
        try:
            with open(cache_file, 'rb') as f:
                return pickle.load(f)
        except Exception as e:
            print(f"Error al cargar caché: {str(e)}")
    
    print("Generando embeddings para libros...")
    book_texts = [prepare_book_text(book) for book in books]
    embeddings = sentence_model.encode(book_texts, show_progress_bar=True)
    embeddings = normalize(embeddings)
    
    try:
        with open(cache_file, 'wb') as f:
            pickle.dump(embeddings, f)
    except Exception as e:
        print(f"Error al guardar caché: {str(e)}")
    
    return embeddings

# Función para búsqueda eficiente
def search_books_efficient(query, books, embeddings, top_k=5):
    query_norm = normalize_text(query)
    query_embedding = sentence_model.encode([query_norm])[0]
    query_embedding = normalize(query_embedding.reshape(1, -1))
    
    similarities = np.dot(embeddings, query_embedding.T).flatten()
    top_indices = np.argpartition(similarities, -top_k)[-top_k:]
    top_indices = top_indices[np.argsort(-similarities[top_indices])]
    
    results = []
    for idx in top_indices:
        if similarities[idx] > 0.3:
            book = books[idx].copy()
            book['similarity'] = float(similarities[idx])
            results.append(book)
    
    return results

# Función para búsqueda por palabras clave optimizada
def search_by_keywords_efficient(query, books):
    keyword_index = defaultdict(list)
    for i, book in enumerate(books):
        text = prepare_book_text(book).lower()
        words = set(text.split())
        for word in words:
            if len(word) > 3:
                keyword_index[word].append(i)
    
    query_words = set(normalize_text(query).split())
    matching_indices = set()
    
    for word in query_words:
        if len(word) > 3 and word in keyword_index:
            matching_indices.update(keyword_index[word])
    
    results = []
    for idx in matching_indices:
        book = books[idx].copy()
        book_text = prepare_book_text(book).lower()
        score = sum(1 for word in query_words if word in book_text)
        if score > 0:
            book['score'] = score
            results.append(book)
    
    results.sort(key=lambda x: x['score'], reverse=True)
    return results[:5]

@app.route('/')
def home():
    return "Servidor Flask funcionando 🎉"

@app.route('/buscar_libros', methods=['POST'])
def buscar_libros():
    try:
        data = request.get_json()
        query = data.get('query', '').strip()
        books = data.get('books', [])
        
        # Primero verificar si es una pregunta frecuente
        faq_response = buscar_faq_por_regex(query)
        if faq_response:
            return jsonify({
                'respuesta': faq_response,
                'libros': []
            })
        
        # Si no es una FAQ, continuar con la búsqueda normal de libros
        if not query:
            return jsonify({
                'respuesta': 'Por favor, ingresa una consulta válida.',
                'libros': []
            })
        
        # Verificar si es una pregunta sobre el resumen de un libro
        if es_pregunta_resumen(query):
            return procesar_pregunta_resumen(query, books)
        
        # Verificar si es una consulta sobre libros similares
        if es_consulta_sugerencias(query):
            return procesar_consulta_similares(query, books)
        
        # Verificar si es una pregunta sobre la ubicación
        if es_pregunta_ubicacion(query):
            return procesar_pregunta_ubicacion(query, books)
        
        # Verificar si es una pregunta sobre disponibilidad
        if es_pregunta_disponibilidad(query):
            return procesar_pregunta_disponibilidad(query, books)
        
        # Verificar si es una pregunta sobre el autor
        if es_pregunta_autor(query):
            return procesar_pregunta_autor(query, books)
        
        # Verificar si es una pregunta sobre el tema
        if es_busqueda_por_tema(query):
            return procesar_busqueda_por_tema(query, books)
        
        # Verificar si es una pregunta general
        if es_pregunta_general(query):
            return procesar_pregunta_general(query)
        
        # Si no es ninguna de las anteriores, hacer búsqueda general
        return procesar_busqueda_general(query, books)
        
    except Exception as e:
        print(f"Error en buscar_libros: {str(e)}")
        return jsonify({
            'error': 'Error al procesar la consulta',
            'detalles': str(e)
        }), 500

def es_pregunta_ubicacion(query):
    """Verifica si la consulta es sobre la ubicación de un libro"""
    palabras_clave = ['donde', 'dónde', 'ubicación', 'ubicacion', 'lugar', 'zona', 'sección', 'seccion', 'estante']
    return any(palabra in query.lower() for palabra in palabras_clave)

def es_pregunta_disponibilidad(query):
    """Verifica si la consulta es sobre la disponibilidad de un libro"""
    palabras_clave = ['disponible', 'prestado', 'prestar', 'tener', 'hay', 'existe', 'encontrar']
    return any(palabra in query.lower() for palabra in palabras_clave)

def es_pregunta_autor(query):
    """Verifica si la consulta es sobre el autor de un libro"""
    palabras_clave = ['autor', 'escrito', 'escribió', 'escribio', 'quien', 'quién']
    return any(palabra in query.lower() for palabra in palabras_clave)

def es_busqueda_por_tema(query):
    """Verifica si la consulta es una búsqueda por tema"""
    palabras_clave = ['libros de', 'sobre', 'tema', 'materia', 'categoría', 'categoria']
    return any(palabra in query.lower() for palabra in palabras_clave)

def es_pregunta_general(query):
    """Verifica si la consulta es una pregunta general"""
    palabras_clave = ['que', 'qué', 'como', 'cómo', 'cual', 'cuál', 'cuando', 'cuándo']
    return any(palabra in query.lower() for palabra in palabras_clave)

def procesar_pregunta_ubicacion(query, books):
    """Procesa una pregunta sobre la ubicación de un libro"""
    # Primero intentar encontrar el libro específico
    libro_encontrado = buscar_libro_por_titulo_parcial(query, books)
    if libro_encontrado:
        ubicacion = libro_encontrado.get('ubicacion', '')
        if not ubicacion or not isinstance(ubicacion, str) or ubicacion.strip() == '':
            ubicacion = 'No especificada'
        
        return jsonify({
            'respuesta': f"El libro '{libro_encontrado.get('titulo', '')}' se encuentra en: {ubicacion}.",
            'libros': [libro_encontrado]
        })
    
    # Si no se encuentra un libro específico, buscar por tema
    tema = extraer_tema_ubicacion(query)
    if tema:
        libros_tema = [libro for libro in books if tema.lower() in libro.get('materia', '').lower()]
        if libros_tema:
            # Obtener ubicaciones únicas de los libros del tema
            ubicaciones = []
            for libro in libros_tema:
                ubicacion = libro.get('ubicacion', '')
                if ubicacion and isinstance(ubicacion, str) and ubicacion.strip() != '':
                    ubicaciones.append(ubicacion)
            
            if ubicaciones:
                ubicaciones_unicas = list(set(ubicaciones))
            return jsonify({
                    'respuesta': f"Los libros sobre {tema} se encuentran en: {', '.join(ubicaciones_unicas)}.",
                    'libros': libros_tema
                })
        else:
            return jsonify({
                    'respuesta': f"He encontrado libros sobre {tema}, pero no tengo información específica sobre su ubicación.",
                'libros': libros_tema
            })
    
    return jsonify({
        'respuesta': "Lo siento, no pude encontrar información sobre la ubicación que buscas. ¿Podrías ser más específico?",
        'libros': []
    })

def procesar_pregunta_disponibilidad(query, books):
    """Procesa una pregunta sobre la disponibilidad de un libro"""
    libro_encontrado = buscar_libro_por_titulo_parcial(query, books)
    if libro_encontrado:
        return jsonify({
            'respuesta': f"El libro '{libro_encontrado.get('titulo', '')}' está {'disponible' if libro_encontrado.get('disponible', True) else 'prestado'}.",
            'libros': [libro_encontrado]
        })
    
    return jsonify({
        'respuesta': "Lo siento, no pude encontrar el libro que mencionas. ¿Podrías verificar el título?",
        'libros': []
    })

def procesar_pregunta_autor(query, books):
    """Procesa una pregunta sobre el autor de un libro"""
    libro_encontrado = buscar_libro_por_titulo_parcial(query, books)
    if libro_encontrado:
        return jsonify({
            'respuesta': f"El libro '{libro_encontrado.get('titulo', '')}' fue escrito por {libro_encontrado.get('autor_personal', '')}.",
            'libros': [libro_encontrado]
        })
    
    return jsonify({
        'respuesta': "Lo siento, no pude encontrar el libro que mencionas. ¿Podrías verificar el título?",
        'libros': []
    })

def procesar_busqueda_por_tema(query, books):
    """Procesa una búsqueda por tema"""
    tema = extraer_tema(query)
    if tema:
        # Buscar coincidencias exactas en materia
        libros_tema = [libro for libro in books if tema.lower() in libro.get('materia', '').lower()]
        
        # Si no hay coincidencias exactas, buscar en título y descripción
        if not libros_tema:
            libros_tema = [
                libro for libro in books 
                if tema.lower() in libro.get('titulo', '').lower() or 
                   tema.lower() in libro.get('descripcion', '').lower()
            ]
        
        if libros_tema:
            # Ordenar por relevancia (primero coincidencias en título, luego en materia)
            libros_tema.sort(key=lambda x: (
                tema.lower() in x.get('titulo', '').lower(),
                tema.lower() in x.get('materia', '').lower()
            ), reverse=True)
            
            return jsonify({
                'respuesta': f"He encontrado {len(libros_tema)} libros sobre {tema}. Aquí están los resultados:",
                'libros': libros_tema
            })
    
    # Si no se encuentra el tema, intentar búsqueda general
    return procesar_busqueda_general(query, books)

def extraer_tema_ubicacion(query):
    """Extrae el tema de una consulta sobre ubicación"""
    palabras = query.lower().split()
    for i, palabra in enumerate(palabras):
        if palabra in ['donde', 'dónde', 'ubicación', 'ubicacion', 'lugar', 'zona', 'sección', 'seccion', 'estante']:
            if i + 1 < len(palabras):
                return ' '.join(palabras[i+1:])
    return None

def extraer_tema(query):
    """Extrae el tema de una consulta"""
    palabras = query.lower().split()
    
    # Patrones comunes para búsqueda de temas
    patrones = [
        'libros de',
        'sobre',
        'tema',
        'materia',
        'categoría',
        'categoria',
        'tienes',
        'hay',
        'existe',
        'busco',
        'quiero'
    ]
    
    for i, palabra in enumerate(palabras):
        if palabra in patrones:
            if i + 1 < len(palabras):
                tema = ' '.join(palabras[i+1:])
                # Limpiar el tema de palabras comunes
                tema = tema.replace('libros', '').replace('libro', '').strip()
                return tema
    
    # Si no se encuentra un patrón, usar toda la consulta como tema
    return query.strip()

def procesar_pregunta_general(query):
    """Procesa una pregunta general"""
    return jsonify({
        'respuesta': "Lo siento, no entiendo tu pregunta. ¿Podrías reformularla?",
        'libros': []
    })

def procesar_busqueda_general(query, books):
    """Procesa una búsqueda general"""
    # Cargar embeddings desde caché
    embeddings = get_cached_embeddings(books)
    
    # Realizar búsqueda semántica
    semantic_results = search_books_efficient(query, books, embeddings, top_k=1)
    
    if semantic_results:
        libro_actualizado = obtener_detalles_libro(semantic_results[0])
        respuesta_llm = generar_respuesta_ollama(query, libros_encontrados=[libro_actualizado])
        
        return jsonify({
            "respuesta": respuesta_llm if respuesta_llm else f"He encontrado este libro que podría interesarte: {libro_actualizado['titulo']}",
            "libros": [libro_actualizado]
        })
    
    # Si no hay resultados semánticos, intentar búsqueda por palabras clave
    keyword_results = search_by_keywords_efficient(query, books)
    
    if keyword_results:
        libro_actualizado = obtener_detalles_libro(keyword_results[0])
        respuesta_llm = generar_respuesta_ollama(query, libros_encontrados=[libro_actualizado])
        
        return jsonify({
            "respuesta": respuesta_llm if respuesta_llm else f"He encontrado este libro que podría interesarte: {libro_actualizado['titulo']}",
            "libros": [libro_actualizado]
        })
    
    return jsonify({
        "respuesta": "No encontré libros que coincidan con tu búsqueda. ¿Podrías ser más específico?",
        "libros": []
    })

def procesar_pregunta_resumen(query, books):
    """Procesa una pregunta sobre el resumen de un libro"""
    libro_encontrado = buscar_libro_por_titulo_parcial(query, books)
    if libro_encontrado:
        libro_encontrado = obtener_detalles_libro(libro_encontrado)
        
        # Primero intentar obtener información de Google Books
        info_web = buscar_info_libro_web(
            libro_encontrado.get('titulo', ''),
            libro_encontrado.get('autor_personal', '')
        )
        
        if info_web:
            print("[DEBUG] Usando información de Google Books para generar resumen")
            resumen = generar_resumen_libro(
                libro_encontrado.get('titulo', ''),
                libro_encontrado.get('autor_personal', ''),
                info_web
            )
            if resumen:
                return jsonify({
                    'respuesta': resumen,
                    'libros': [libro_encontrado]
                })
        
        # Si no hay información web, intentar con la descripción local
        descripcion = libro_encontrado.get('descripcion', '').strip()
        if descripcion:
            print("[DEBUG] Usando descripción local para generar resumen")
            resumen = generar_resumen_libro(
                libro_encontrado.get('titulo', ''),
                libro_encontrado.get('autor_personal', ''),
                descripcion
            )
            if resumen:
                return jsonify({
                    'respuesta': resumen,
                    'libros': [libro_encontrado]
                })
        
        # Si no hay resumen, devolver información básica
        return jsonify({
            'respuesta': f"Lo siento, no puedo generar un resumen detallado para '{libro_encontrado.get('titulo', '')}'. Sin embargo, puedo decirte que es un libro de {libro_encontrado.get('materia', '')} escrito por {libro_encontrado.get('autor_personal', '')}.",
            'libros': [libro_encontrado]
        })
    
    # Si no se encuentra el libro, intentar búsqueda general
    return procesar_busqueda_general(query, books)

def procesar_consulta_similares(query, books):
    """Procesa una consulta sobre libros similares"""
    # Primero intentar encontrar el libro de referencia
    libro_referencia = buscar_libro_por_titulo_parcial(query, books)
    
    if not libro_referencia:
        return jsonify({
            'respuesta': "No encontré el libro de referencia en nuestra biblioteca. ¿Podrías verificar el título o intentar con otro libro?",
            'libros': []
        })
    
    # Buscar libros similares
    libros_similares = buscar_libros_similares(libro_referencia, books)
    
    if not libros_similares:
        return jsonify({
            'respuesta': f"No encontré libros similares a '{libro_referencia.get('titulo', '')}' en nuestra biblioteca. Te sugiero consultar nuestro catálogo completo para encontrar otros libros sobre el mismo tema.",
            'libros': [libro_referencia]
        })
    
    # Generar respuesta con los libros similares encontrados
    respuesta = f"Basándome en '{libro_referencia.get('titulo', '')}', te recomiendo estos libros similares que están disponibles en nuestra biblioteca:\n\n"
    
    for i, libro in enumerate(libros_similares, 1):
        ubicacion = libro.get('ubicacion', '')
        if not ubicacion or not isinstance(ubicacion, str) or ubicacion.strip() == '':
            ubicacion = 'No especificada'
        
        estado = 'Disponible' if int(libro.get('cantidad', 0)) > 0 else 'No disponible'
        
        respuesta += f"{i}. {libro.get('titulo', '')}\n"
        respuesta += f"   Autor: {libro.get('autor_personal', 'Autor desconocido')}\n"
        respuesta += f"   Ubicación: {ubicacion}\n"
        respuesta += f"   Estado: {estado}\n"
        if libro.get('materia'):
            respuesta += f"   Materia: {libro.get('materia')}\n"
        respuesta += "\n"
    
    # Incluir el libro de referencia también en la respuesta
    todos_libros = [libro_referencia] + libros_similares
    
    return jsonify({
        'respuesta': respuesta,
        'libros': todos_libros
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