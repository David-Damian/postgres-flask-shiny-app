import psycopg2

conn = psycopg2.connect(
    database='wine',
    user='docker',
    password='docker',
    host='0.0.0.0'
)

cur = conn.cursor()

#Consulta de inserción en base de datos
cur.execute(f"SELECT * FROM wine.wine_quality")
rows = cur.fetchall()

if not len(rows):
    print("EMPTY")
else:
    print(f"Registros en wine_quality: {len(rows):,}")

#Terminar comunicación.
cur.close()
conn.close()