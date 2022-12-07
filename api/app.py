import os
import json
import numpy as np
import psycopg2
import psycopg2.extras
from flask import Flask, request
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
@app.route("/inicio", methods=['GET'])
def inicio():
    cur = conn.cursor(cursor_factory=psycopg2.extras.NamedTupleCursor)
    cur.execute(f"SELECT * FROM {schema}.{table}")
    results = cur.fetchall()
    cur.close()
    return json.dumps([x._asdict() for x in results], default=str)

@app.route("/predict", methods=['GET', 'POST'])
def predict():
    if request.method == 'POST':
        x_input = json.loads(request.data)
        x_input = np.array([list(x_input[0].values())])

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
        results = predict_quality(rows, x_input)
        cur.close()

        #Model results file
        res_file = open("results.txt", "w")
        res_file.write(str(results[0]))
        res_file.close()

        #Log file
        log = open("log.txt", "w")
        log.write(f"Input: {x_input}\n")
        log.write(f"Scaled: {results[1]}\n")
        log.write(f"Pred: {results[0]}\n")
        log.write(f"Coefs: {results[2]}\n")
        log.close()

        return str(results)
    
    if request.method == 'GET':
        file = open("results.txt", "r")
        results = file.read()
        file.close()

        return str(results)


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=4999, debug=True)