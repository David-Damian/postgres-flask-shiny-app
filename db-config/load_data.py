import psycopg2

#Conexión a base de datos
conn = psycopg2.connect(
    database='vinos',
    user='root',
    password='root',
    host='0.0.0.0'
)

#Cursor para operaciones en base de datos
cursor = conn.cursor()

#Consultas
cur.execute("SELECT * FROM wine_quality")
rows = cur.fetchall()

if not len(rows):
    print("EMPTY")
else:
    for row in rows:
        print(row)

#Terminar comunicación.
cur.close()
conn.close()