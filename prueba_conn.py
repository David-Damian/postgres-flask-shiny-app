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

X_play = np.array([[6.0000e+00, 2.1000e-01, 3.8000e-01, 8.0000e-01, 2.0000e-02,
        2.2000e+01, 9.8000e+01, 9.8941e-01, 3.2600e+00, 3.2000e-01,
        1.1800e+01]])

if not len(rows):
    print("EMPTY")
else:
    print(predict_quality(rows, X_play))

#Terminar comunicación.
cur.close()
conn.close()