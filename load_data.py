import db
import psycopg2
from flask import Flask

# Get environment variables
USER = db.USER
PASSWORD = db.PASSWORD
ADDRESS = db.ADDRESS
DB = db.DB
print(f"USER: {USER}, PASS: {PASSWORD}, ADDRESS: {ADDRESS}, DB: {DB}\n")

#Conexión a base de datos
conn = psycopg2.connect(
    database=DB,
    user=USER,
    password=PASSWORD,
    host=ADDRESS)
cur = conn.cursor()

#Lectura e inserción de datos en bruto
schema, table = 'wine', 'wine_quality'
data_file = 'datos/winequality-red-raw.csv'
query_template = 'db/insert_data.txt'

#Condición para no sobre escribir en la BD.
cur.execute(f"SELECT * FROM {schema}.{table}")
rows = cur.fetchall()
if not len(rows):
    print(f"Insertando datos en {table}...")
    db.initial_load(cursor=cur, schema=schema, table=table, data=data_file, template=query_template)
    print("Datos insertados.")
else:
    pass

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