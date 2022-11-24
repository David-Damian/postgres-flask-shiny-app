import os
import csv
import numpy as np
import psycopg2
from flask import Flask


def create_query(query_file):
    """"
    Esta función recibe un archivo .txt con un query
    de SQL para transformarlo en un str de python.
    
    Parámetros:
    query_file: Archivo .txt con query de SQL.
    """
    #Se abre el archivo
    with open(query_file, mode='r') as file:
        query = """"""
        for row in file:
            query += (row)      
    file.close()
    return query

# Get environment variables
USER = os.getenv('POSTGRES_USER')
PASSWORD = os.environ.get('POSTGRES_PASSWORD')
ADDRESS = os.environ.get('POSTGRES_ADDR')
DB = os.environ.get('POSTGRES_DB')
print(f"USER: {USER}, PASS: {PASSWORD}, ADDRESS: {ADDRESS}, DB: {DB}")

#Conexión a base de datos
conn = psycopg2.connect(
    database=DB,
    user=USER,
    password=PASSWORD,
    host=ADDRESS
)

#Cursor para operaciones en base de datos
cur = conn.cursor()

#Crear tabla en base de datos
# file = 'db-queries/table_wineQuality.txt'
# print(f"Creando tabla de archivo {file}...")
# query = create_query(query_file=file)
# cur.execute(query)
# print("Tabla creada.\n")

#Lectura e inserción de datos en bruto
schema, table = 'wine', 'wine_quality'
print(f"Insertando datos en {table}...")
with open('datos/winequality-red-raw.csv', mode='r') as file:
    csvFile = csv.reader(file)
    
    for line in csvFile:
        try:
            #Se truncan valores a 6 decimales max
            row = np.array(line).astype(float) * 1e6
            row = np.trunc(row) / 1e6
            
            #Query de inserción
            insert_query = create_query("db/insert_data.txt")
            insert_query = insert_query.replace("<table>", f"{table}")
            for i in range(len(row)):
                insert_query = insert_query.replace(f"x_{i}", f"{row[i]}")
            
            #Escritura en base de datos
            cur.execute(insert_query)
            
        except ValueError:
            pass
file.close()
print("Datos insertados.")

#Consulta de inserción en base de datos
cur.execute(f"SELECT * FROM {schema}.{table}")
rows = cur.fetchall()

if not len(rows):
    print("EMPTY")
else:
    print(f"Registros en {table}: {len(rows):,}")

#Terminar comunicación.
conn.commit()
cur.close()
conn.close()