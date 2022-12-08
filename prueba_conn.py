from api.utils import predict_quality
import numpy as np
import psycopg2

conn = psycopg2.connect(
    database='root',
    user='root',
    password='password',
    host='0.0.0.0'
)

cur = conn.cursor()

#Consulta de inserción en base de datos
cur.execute("""INSERT INTO wine_quality(
        type,
        fixed_acidity,
        volatile_acidity,
        citric_acid,
        residual_sugar,
        chlorides,
        free_sulfur_dioxide,
        total_sulfur_dioxide,
        density,
        ph,
        sulphates,
        alcohol,
        quality)
    VALUES (
        'red',
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12)""")
cur.execute("select * from wine_quality order by id desc limit 1")
rows = np.array(cur.fetchall())

X_play = np.array([[7.3,0.65,0,1.2,0.065,15,21,0.9946,3.39,0.47,10]])

if not len(rows):
    print("EMPTY")
else:
    print(rows)

#Terminar comunicación.
cur.close()
conn.close()