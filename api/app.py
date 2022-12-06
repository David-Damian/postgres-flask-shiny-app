import os
import json
import numpy as np
import psycopg2
import psycopg2.extras
from flask import Flask
from utils import predict_quality

#Get enviroment variables
USER = os.getenv('POSTGRES_USER')
PASSWORD = os.environ.get('POSTGRES_PASSWORD')
ADDRESS = os.environ.get('POSTGRES_ADDR')
DB = os.environ.get('POSTGRES_DB')
database_uri = f'postgresql://{USER}:{PASSWORD}@{ADDRESS}:5432/{DB}'

#Conexión a base de datos
schema, table = 'public', 'wine_quality'
conn = psycopg2.connect(database_uri)

app = Flask(__name__)

@app.route('/')
@app.route("/inicio", methods=['GET', 'POST'])
def inicio():
    cur = conn.cursor(cursor_factory=psycopg2.extras.NamedTupleCursor)
    cur.execute(f"SELECT * FROM {schema}.{table}")
    results = cur.fetchall()
    cur.close()
    return json.dumps([x._asdict() for x in results], default=str)

@app.route("/predict", methods=['GET', 'POST'])
def predict():
    X_play = np.array([[6.0000e+00, 2.1000e-01, 3.8000e-01, 8.0000e-01, 2.0000e-02,
        2.2000e+01, 9.8000e+01, 9.8941e-01, 3.2600e+00, 3.2000e-01,
        1.1800e+01]])
    cur = conn.cursor(cursor_factory=psycopg2.extras.NamedTupleCursor)
    cur.execute(f"""SELECT
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
    FROM {schema}.{table}""")
    rows = np.array(cur.fetchall())
    results = predict_quality(rows, X_play)
    cur.close()
    return str(results)


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=4999, debug=True)