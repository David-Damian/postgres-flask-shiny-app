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
cur.execute("""SELECT
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
    quality
FROM public.wine_quality""")
rows = np.array(cur.fetchall())

X_play = np.array([[7.3,0.65,0,1.2,0.065,15,21,0.9946,3.39,0.47,10]])

if not len(rows):
    print("EMPTY")
else:
    print(predict_quality(rows, X_play))

#Terminar comunicación.
cur.close()
conn.close()