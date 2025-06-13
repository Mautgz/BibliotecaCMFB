import sys
import json
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity
import unicodedata
import re
import traceback
import codecs
from transformers import GPT2LMHeadModel, GPT2Tokenizer, AutoTokenizer, AutoModelForSeq2SeqLM
import torch
import os

# Configurar la codificación de salida
sys.stdout = codecs.getwriter('utf-8')(sys.stdout.buffer)
sys.stderr = codecs.getwriter('utf-8')(sys.stderr.buffer)

def safe_json_dumps(obj, **kwargs):
    """Asegura que el objeto se pueda serializar a JSON."""
    try:
        return json.dumps(obj, **kwargs)
    except Exception as e:
        return json.dumps({
            "error": f"Error al serializar JSON: {str(e)}",
            "traceback": traceback.format_exc()
        }, ensure_ascii=False)

def output_json(obj):
    """Envía el JSON a stdout y limpia el buffer."""
    json_str = safe_json_dumps(obj, ensure_ascii=False)
    sys.stdout.write(json_str + '\n')
    sys.stdout.flush()

def log_message(message):
    """Envía un mensaje a stderr y limpia el buffer."""
    sys.stderr.write(message + '\n')
    sys.stderr.flush()

def generar_respuesta_gpt2(contexto, pregunta):
    tokenizer_gpt2 = GPT2Tokenizer.from_pretrained("gpt2")
    model_gpt2 = GPT2LMHeadModel.from_pretrained("gpt2")
    prompt = f"{contexto}\nUsuario: {pregunta}\nAsistente:"
    input_ids = tokenizer_gpt2.encode(prompt, return_tensors='pt')
    output = model_gpt2.generate(
        input_ids,
        max_length=input_ids.shape[1] + 60,
        pad_token_id=tokenizer_gpt2.eos_token_id,
        do_sample=True,
        top_p=0.92,
        top_k=50
    )
    respuesta = tokenizer_gpt2.decode(output[0][input_ids.shape[1]:], skip_special_tokens=True)
    return respuesta.strip()

tokenizer_flan = AutoTokenizer.from_pretrained("google/flan-t5-small")
model_flan = AutoModelForSeq2SeqLM.from_pretrained("google/flan-t5-small")

def generar_respuesta_flan_t5(pregunta, contexto=""):
    prompt = f"Responde de forma amable y breve en español. {contexto} Usuario: {pregunta}"
    input_ids = tokenizer_flan(prompt, return_tensors="pt").input_ids
    outputs = model_flan.generate(input_ids, max_length=80)
    respuesta = tokenizer_flan.decode(outputs[0], skip_special_tokens=True)
    return respuesta.strip()

def es_busqueda_libros(texto):
    palabras_clave = [
        "buscar", "libro", "libros", "tienes", "muéstrame", "mostrar", "hay", "encuentra", "recomienda", "sugerir"
    ]
    texto = texto.lower()
    return any(palabra in texto for palabra in palabras_clave)

def cargar_faqs():
    faqs_path = os.path.join(os.path.dirname(__file__), 'faqs.json')
    if not os.path.exists(faqs_path):
        return []
    with open(faqs_path, 'r', encoding='utf-8') as f:
        return json.load(f)

def es_pregunta_servicio(texto):
    faqs = cargar_faqs()
    texto = texto.lower()
    for faq in faqs:
        patron = faq.get('patron_regex') or re.escape(faq['pregunta'].lower())
        if re.search(patron, texto):
            return faq['respuesta']
    return None

def es_busqueda_general(texto):
    texto = texto.lower().strip()
    frases_generales = [
        "libro",
        "libros",
        "buscar libros",
        "buscar un libro",
        "quiero buscar un libro",
        "puedes ayudarme a buscar un libro",
        "me ayudas a buscar libros",
        "puedes buscar un libro",
        "busco un libro"
    ]
    # Solo activa si la consulta es exactamente igual a una frase general
    return texto in frases_generales

def normalize_text(text):
    if not isinstance(text, str):
        return ""
    text = text.lower()
    # Normalizar acentos y caracteres especiales
    text = unicodedata.normalize('NFKD', text).encode('ASCII', 'ignore').decode('ASCII')
    # Remover caracteres especiales pero mantener palabras importantes
    text = re.sub(r'[^a-z0-9\s]', ' ', text)
    # Remover espacios extra
    text = re.sub(r'\s+', ' ', text).strip()
    return text

def prepare_book_text(book):
    # Dar más peso al título y materia
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
    """Detecta si el usuario está pidiendo más detalles sobre un libro específico."""
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

def obtener_detalles_libro(libro):
    """Genera una respuesta detallada sobre un libro específico."""
    detalles = []
    
    # Información básica
    detalles.append(f"El libro '{libro['titulo']}'")
    if libro.get('autor_personal'):
        detalles.append(f"fue escrito por {libro['autor_personal']}")
    if libro.get('editorial'):
        detalles.append(f"y publicado por {libro['editorial']}")
    
    # Información de ubicación y disponibilidad
    detalles.append(f"\nPuedes encontrarlo en la ubicación: {libro.get('ubicacion', 'No especificada')}")
    detalles.append(f"con el código: {libro.get('codigo_libro', 'No especificado')}")
    detalles.append(f"Actualmente está {libro.get('estado_disponibilidad', 'Desconocido').lower()}")
    
    # Información de préstamo
    if libro.get('estado_disponibilidad') == 'Disponible':
        detalles.append("\nPuedes solicitarlo en el mostrador de préstamos presentando tu carnet.")
        detalles.append("El préstamo tiene una duración de 15 días, con posibilidad de renovación.")
    
    return " ".join(detalles)

def main():
    try:
        if len(sys.argv) != 3:
            print(json.dumps({
                "error": "Se requieren dos argumentos: consulta y archivo JSON"
            }, ensure_ascii=False))
            sys.exit(1)

        query = sys.argv[1]
        json_file = sys.argv[2]

        print("Cargando modelo de embeddings...", file=sys.stderr)
        sentence_model = SentenceTransformer('all-MiniLM-L6-v2')
        print("Modelo de embeddings cargado", file=sys.stderr)
        print(f"Leyendo archivo: {json_file}", file=sys.stderr)
        with open(json_file, 'r', encoding='utf-8') as f:
            books = json.load(f)
        print(f"Libros cargados: {len(books)}", file=sys.stderr)
        print("Procesando libros...", file=sys.stderr)

        # Verificar si es una consulta de detalles
        if es_consulta_detalles_libro(query):
            # Buscar el libro más relevante en la consulta
            query_norm = normalize_text(query)
            book_texts = []
            for book in books:
                text = prepare_book_text(book)
                book_texts.append(text)
            
            query_embedding = sentence_model.encode([query_norm])[0]
            book_embeddings = sentence_model.encode(book_texts)
            similarities = cosine_similarity([query_embedding], book_embeddings)[0]
            
            # Obtener el libro más relevante
            idx = similarities.argmax()
            if similarities[idx] > 0.3:
                book = books[idx].copy()
                detalles = obtener_detalles_libro(book)
                print(json.dumps({
                    "respuesta": detalles,
                    "libros": [book]
                }, ensure_ascii=False))
                return

        # Si no es una consulta de detalles o no se encontró el libro, continuar con la búsqueda normal
        query_norm = normalize_text(query)
        print(f"Consulta normalizada: {query_norm}", file=sys.stderr)

        # Preparar textos de libros
        book_texts = []
        for book in books:
            text = prepare_book_text(book)
            book_texts.append(text)

        # Calcular similitud
        query_embedding = sentence_model.encode([query_norm])[0]
        book_embeddings = sentence_model.encode(book_texts)
        similarities = cosine_similarity([query_embedding], book_embeddings)[0]

        # Obtener los libros más relevantes
        similar_indices = similarities.argsort()[-5:][::-1]  # Top 5 libros
        relevant_books = []
        
        for idx in similar_indices:
            similarity = similarities[idx]
            if similarity > 0.3:  # Umbral más bajo para capturar más resultados relevantes
                book = books[idx].copy()
                book['similarity'] = float(similarity)
                
                # Agregar código de libro y ubicación
                book['codigo_libro'] = book.get('codigo_libro', 'No especificado')
                book['ubicacion'] = book.get('ubicacion', 'No especificada')
                
                # Agregar estado de disponibilidad
                cantidad = book.get('cantidad', 0)
                try:
                    cantidad = int(cantidad)
                except Exception:
                    cantidad = 0
                book['estado_disponibilidad'] = 'Disponible' if cantidad > 0 else 'Prestado'
                relevant_books.append(book)

        # Ordenar por similitud
        relevant_books.sort(key=lambda x: x['similarity'], reverse=True)

        if not relevant_books:
            print(json.dumps({
                "respuesta": "No encontré libros que coincidan con tu búsqueda. ¿Podrías ser más específico o intentar con otros términos?",
                "libros": []
            }, ensure_ascii=False))
            return

        # Generar respuesta contextual
        if len(relevant_books) == 1:
            respuesta = f"He encontrado un libro que coincide con tu búsqueda: {relevant_books[0]['titulo']}"
        else:
            respuesta = f"He encontrado {len(relevant_books)} libros que podrían interesarte. ¿Te gustaría saber más detalles sobre alguno en particular? Puedes preguntarme por más información sobre cualquiera de estos libros."

        print(json.dumps({
            "respuesta": respuesta,
            "libros": relevant_books
        }, ensure_ascii=False))
        return

    except Exception as e:
        print(json.dumps({
            "error": f"Error en el procesamiento: {str(e)}"
        }, ensure_ascii=False))
        sys.exit(1)

if __name__ == "__main__":
    main() 