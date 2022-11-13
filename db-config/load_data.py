import csv
import numpy as np
import psycopg2


#Conexión a base de datos
conn = psycopg2.connect(
    database='vinos',
    user='root',
    password='root',
    host='0.0.0.0'
)

#Cursor para operaciones en base de datos
cur = conn.cursor()

#Lectura de datos en bruto
with open('../datos/winequality-red-raw.csv', mode='r') as file:
    csvFile = csv.reader(file)
    for line in csvFile:
        try:
            #Se truncan valores a 6 decimales max
            row = np.array(line).astype(float) * 1e6
            row = np.trunc(row) / 1e6
            
            #Query de inserción
            insert_query = f"""
            INSERT INTO wine_quality(
                fixed_acidity,
                volatile_acidity,
                citric_acid,
                residual_sugar,
                chlorides,
                free_sulfur_dioxide,
                total_sulfur_dioxide,
                density,
                pH,
                sulphates,
                alcohol,
                quality)
            VALUES ({row[0]},{row[1]},{row[2]},{row[3]},{row[4]},{row[5]},{row[6]},{row[7]},{row[8]},{row[9]},{row[10]},{row[11]});"""

            #Escritura en base de datos
            cur.execute(insert_query)
        
        except ValueError:
            pass
file.close()

#Consulta de inserción en base de datos
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