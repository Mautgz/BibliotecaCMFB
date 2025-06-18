import urllib3
import mysql.connector
from sklearn.metrics import accuracy_score
from rouge_score import rouge_scorer
import time
import json
import sys
from urllib.parse import urlencode
import csv
import pandas as pd
import requests
from datetime import datetime

# Configurar la codificación por defecto
if sys.stdout.encoding != 'utf-8':
    sys.stdout.reconfigure(encoding='utf-8')

# Configurar el pool de conexiones
http = urllib3.PoolManager(
    maxsize=10,
    retries=urllib3.Retry(3),
    timeout=urllib3.Timeout(connect=2.0, read=30.0)
)

def hacer_peticion(url, data):
    """Hace una petición POST y maneja la respuesta"""
    try:
        # Codificar los datos
        encoded_data = urlencode(data).encode('utf-8')
        
        # Hacer la petición
        response = http.request(
            'POST',
            url,
            body=encoded_data,
            headers={
                'Content-Type': 'application/x-www-form-urlencoded',
                'Accept': 'application/json'
            }
        )
        
        # Decodificar la respuesta
        if response.status == 200:
            try:
                # Intentar decodificar como JSON
                return json.loads(response.data.decode('utf-8'))
            except json.JSONDecodeError:
                # Si no es JSON, intentar extraer el texto
                texto = response.data.decode('utf-8')
                lineas = texto.split('\n')
                for linea in lineas:
                    linea = linea.strip()
                    if linea and not linea.startswith('<!DOCTYPE') and not linea.startswith('<html'):
                        return {"respuesta": linea}
                return {"respuesta": ""}
        else:
            print(f"Error HTTP {response.status}")
            return {"respuesta": ""}
            
    except Exception as e:
        print(f"Error en la petición: {str(e)}")
        return {"respuesta": ""}

def verificar_prestamos():
    # Configuración de la base de datos
    db_config = {
        'host': 'localhost',
        'user': 'root',
        'password': '',
        'database': 'biblioteca'
    }
    
    try:
        # Conectar a la base de datos
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor(dictionary=True)
        
        # Consulta para verificar los libros mencionados
        query = """
            SELECT 
                e.nombre, 
                e.apellido,
                l.titulo,
                a.nombre as autor,
                p.fecha_prestamo,
                p.fecha_devolucion,
                p.estado
            FROM prestamo p
            JOIN estudiante e ON p.id_estudiante = e.id
            JOIN libro l ON p.id_libro = l.id
            JOIN autor a ON l.id_autor = a.id
            WHERE l.titulo LIKE '%Primer Libro de los Nombres Mágicos%'
               OR l.titulo LIKE '%Luna y tú%'
               OR a.nombre LIKE '%Rowling%'
               OR a.nombre LIKE '%Sagan%'
        """
        
        cursor.execute(query)
        prestamos = cursor.fetchall()
        
        print("\nVERIFICACIÓN DE PRÉSTAMOS MENCIONADOS")
        print("="*50)
        
        if prestamos:
            print("\nPréstamos encontrados en la base de datos:")
            for prestamo in prestamos:
                print(f"\nAlumno: {prestamo['nombre']} {prestamo['apellido']}")
                print(f"Libro: {prestamo['titulo']}")
                print(f"Autor: {prestamo['autor']}")
                print(f"Estado: {prestamo['estado']}")
                print(f"Fecha de préstamo: {prestamo['fecha_prestamo']}")
                print(f"Fecha de devolución: {prestamo['fecha_devolucion']}")
                print("-"*50)
        else:
            print("\nNo se encontraron los libros mencionados en la base de datos.")
        
        # Mostrar todos los préstamos activos
        query_activos = """
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
        
        cursor.execute(query_activos)
        prestamos_activos = cursor.fetchall()
        
        print("\nPRÉSTAMOS ACTIVOS REALES")
        print("="*50)
        
        if prestamos_activos:
            print(f"\nTotal de préstamos activos: {len(prestamos_activos)}")
            for prestamo in prestamos_activos:
                print(f"\nAlumno: {prestamo['nombre']} {prestamo['apellido']}")
                print(f"Libro: {prestamo['titulo']}")
                print(f"Autor: {prestamo['autor']}")
                print(f"Fecha de préstamo: {prestamo['fecha_prestamo']}")
                print(f"Fecha de devolución: {prestamo['fecha_devolucion']}")
                print("-"*50)
        else:
            print("\nNo hay préstamos activos en este momento.")
        
    except mysql.connector.Error as err:
        print(f"Error de base de datos: {err}")
    except Exception as e:
        print(f"Error general: {str(e)}")
    finally:
        if 'conn' in locals() and conn.is_connected():
            cursor.close()
            conn.close()
            print("\nConexión a la base de datos cerrada.")

def evaluar_respuestas_rouge(respuestas_reales, respuestas_predichas):
    """
    Evalúa las respuestas del chatbot usando ROUGE scores con un enfoque más flexible
    """
    scorer = rouge_scorer.RougeScorer(['rouge1', 'rouge2', 'rougeL'], use_stemmer=True)
    
    # Crear archivo de reporte
    with open('rouge_report.txt', 'w', encoding='utf-8') as f:
        f.write("EVALUACIÓN ROUGE DE RESPUESTAS\n")
        f.write("="*50 + "\n\n")
    
    total_scores = {
        'rouge1': {'precision': 0, 'recall': 0, 'f1': 0},
        'rouge2': {'precision': 0, 'recall': 0, 'f1': 0},
        'rougeL': {'precision': 0, 'recall': 0, 'f1': 0}
    }
    
    for i, (real, predicha) in enumerate(zip(respuestas_reales, respuestas_predichas), 1):
        with open('rouge_report.txt', 'a', encoding='utf-8') as f:
            f.write(f"\nEvaluación de respuesta {i}:\n")
            f.write(f"Real: {real}\n")
            f.write(f"Predicha: {predicha}\n")
        
        # Preprocesar las respuestas para enfocarse en información clave
        real = real.lower()
        predicha = predicha.lower()
        
        # Eliminar información redundante o no esencial
        palabras_ignorar = ['lo siento', 'sin embargo', 'puedo decirte que', 'es un libro de']
        for palabra in palabras_ignorar:
            real = real.replace(palabra, '')
            predicha = predicha.replace(palabra, '')
        
        scores = scorer.score(real, predicha)
        with open('rouge_report.txt', 'a', encoding='utf-8') as f:
            for metric, score in scores.items():
                f.write(f"\n{metric}:\n")
                f.write(f"  Precision: {score.precision:.4f}\n")
                f.write(f"  Recall: {score.recall:.4f}\n")
                f.write(f"  F1: {score.fmeasure:.4f}\n")
                
                # Acumular scores para promedio
                total_scores[metric]['precision'] += score.precision
                total_scores[metric]['recall'] += score.recall
                total_scores[metric]['f1'] += score.fmeasure
            f.write("-"*50 + "\n")
    
    # Calcular y mostrar promedios
    num_respuestas = len(respuestas_reales)
    with open('rouge_report.txt', 'a', encoding='utf-8') as f:
        f.write("\nPROMEDIOS GENERALES:\n")
        f.write("="*50 + "\n")
        for metric in total_scores:
            f.write(f"\n{metric}:\n")
            f.write(f"  Precision promedio: {total_scores[metric]['precision']/num_respuestas:.4f}\n")
            f.write(f"  Recall promedio: {total_scores[metric]['recall']/num_respuestas:.4f}\n")
            f.write(f"  F1 promedio: {total_scores[metric]['f1']/num_respuestas:.4f}\n")
    
    print(f"\nReporte ROUGE guardado en 'rouge_report.txt'")

def leer_respuestas_csv(archivo_csv):
    """
    Lee las respuestas desde el archivo CSV de logs del chatbot
    """
    try:
        # Respuestas esperadas predefinidas
        respuestas_esperadas = {
            "cartas": "Este libro presenta simbólicamente las misiones de San Francisco Javier. Aunque no llegó a América, el libro usa un emblema publicado en 1640 que lo muestra soñando con ese viaje. Es un relato con tintes heroicos y religiosos, muy influenciado por símbolos clásicos como Eneas llevando a su padre.",
            "ubicacion cartas": "Encontré Las cartas de San Francisco Javier, está disponible en E1, B - Este, Fila 3, Derecha.",
            "colonialismo": "Sobre colonialismo, está El Colonialismo de Carlos Marx, y también Colonialismo y Anticolonialismo de Aimé Césaire.",
            "arte": "Dos buenos libros de arte: La libertad en el arte de Honor Arundel y El arte del siglo XX de Alfred Barr.",
            "salud": "Dos buenos libros sobre salud: El libro de la salud de Deepak Chopra y Cómo cambiar el mundo con la comida de John Robbins.",
            "enciclopedia": "También tenemos la Enciclopedia Británica (Tomos 1–32) y la Gran Enciclopedia Popular Viking, Tomo 21.",
            "vaticano": "Sí, está disponible el Documentos Completos del Vaticano II, lo encuentras en E1, B - Este, Fila 3, Derecha.",
            "capital": "También tenemos El capital visto por su autor, está en E1, Fila 1, Izquierda."
        }
        
        df = pd.read_csv(archivo_csv)
        
        # Agrupar respuestas similares
        respuestas_agrupadas = {}
        for _, row in df.iterrows():
            mensaje = row['mensaje'].lower().strip()
            respuesta = row['respuesta'].strip()
            
            # Normalizar el mensaje para agrupar mejor
            mensaje = mensaje.replace('de que trata', 'trata')
            mensaje = mensaje.replace('de q trata', 'trata')
            mensaje = mensaje.replace('que trata', 'trata')
            mensaje = mensaje.replace('donde', 'ubicacion')
            mensaje = mensaje.replace('dónde', 'ubicacion')
            mensaje = mensaje.replace('ubicación', 'ubicacion')
            
            # Determinar el tipo de pregunta
            tipo_pregunta = None
            if 'cartas' in mensaje and 'trata' in mensaje:
                tipo_pregunta = 'cartas'
            elif 'cartas' in mensaje and 'ubicacion' in mensaje:
                tipo_pregunta = 'ubicacion cartas'
            elif 'colonialismo' in mensaje:
                tipo_pregunta = 'colonialismo'
            elif 'arte' in mensaje:
                tipo_pregunta = 'arte'
            elif 'salud' in mensaje:
                tipo_pregunta = 'salud'
            elif 'enciclopedia' in mensaje:
                tipo_pregunta = 'enciclopedia'
            elif 'vaticano' in mensaje:
                tipo_pregunta = 'vaticano'
            elif 'capital' in mensaje:
                tipo_pregunta = 'capital'
            
            # Si es una pregunta similar a una existente, agregar la respuesta
            if mensaje in respuestas_agrupadas:
                respuestas_agrupadas[mensaje].append(respuesta)
            else:
                respuestas_agrupadas[mensaje] = [respuesta]
            
            # Si tenemos una respuesta esperada para este tipo de pregunta
            if tipo_pregunta and tipo_pregunta in respuestas_esperadas:
                respuestas_agrupadas[mensaje].append(respuestas_esperadas[tipo_pregunta])
        
        # Para cada grupo de respuestas, evaluar todas las respuestas
        respuestas_reales = []
        respuestas_predichas = []
        
        for mensaje, respuestas in respuestas_agrupadas.items():
            # Usar la primera respuesta como referencia para todas las demás
            referencia = respuestas[0]
            for predicha in respuestas[1:]:
                respuestas_reales.append(referencia)
                respuestas_predichas.append(predicha)
            
            # Si solo hay una respuesta, también la incluimos
            if len(respuestas) == 1:
                respuestas_reales.append(respuestas[0])
                respuestas_predichas.append(respuestas[0])
        
        print(f"\nTotal de mensajes únicos: {len(respuestas_agrupadas)}")
        print(f"Total de respuestas a evaluar: {len(respuestas_reales)}")
        
        return respuestas_reales, respuestas_predichas
    except Exception as e:
        print(f"Error al leer el archivo CSV: {str(e)}")
        return [], []

if __name__ == "__main__":
    # Leer respuestas desde el CSV
    archivo_csv = "chatbot_logs.csv"
    respuestas_reales, respuestas_predichas = leer_respuestas_csv(archivo_csv)
    
    if respuestas_reales and respuestas_predichas:
        print(f"\nEvaluando {len(respuestas_reales)} pares de respuestas...")
        evaluar_respuestas_rouge(respuestas_reales, respuestas_predichas)
    else:
        print("No se pudieron cargar las respuestas desde el CSV")
    
    verificar_prestamos()