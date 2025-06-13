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

if __name__ == "__main__":
    verificar_prestamos()