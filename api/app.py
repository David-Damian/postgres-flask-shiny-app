import os
import json
import numpy as np
import psycopg2
import psycopg2.extras
from flask import Flask, request
from utils import train_model
from sklearn.preprocessing import StandardScaler

#Get enviroment variables
USER = os.getenv('POSTGRES_USER')
PASSWORD = os.environ.get('POSTGRES_PASSWORD')
ADDRESS = os.environ.get('POSTGRES_ADDR')
DB = os.environ.get('POSTGRES_DB')
database_uri = f'postgresql://{USER}:{PASSWORD}@{ADDRESS}:5432/{DB}'

#Conexión a base de datos
schema, table = 'public', 'wine_quality'
conn = psycopg2.connect(database_uri)

#Modelo de predicción
cur = conn.cursor(cursor_factory=psycopg2.extras.NamedTupleCursor)
cur.execute(f"""SELECT
    volatile_acidity,
    density,
    alcohol,
    quality
FROM {schema}.{table}""")
rows = np.array(cur.fetchall())
cur.close()
model = train_model(rows)


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

        #Formatear x_input a parámetors del modelo
        cur = conn.cursor(cursor_factory=psycopg2.extras.NamedTupleCursor)
        cur.execute(f"""SELECT
            volatile_acidity,
            density,
            alcohol
        FROM {schema}.{table}""")
        rows = np.array(cur.fetchall())
        rows = np.append(rows, x_input, axis=0)
        #Columnas de interacciones
        x1_x2 = rows[:,0] * rows[:,1]
        x2_x3 = rows[:,1] * rows[:,2]
        x3_x1 = rows[:,2] * rows[:,0]
        interactions = np.stack((x1_x2, x2_x3, x3_x1), axis=1)
        rows = np.append(rows, interactions, axis=1)

        #Escalador
        scaler = StandardScaler()
        rows = scaler.fit_transform(rows)
        x_input = np.array([rows[-1,:]])

        #Predicción
        results = model.predict(x_input)

        #Model results file
        res_file = open("results.txt", "w")
        res_file.write(str(results[0]))
        res_file.close()

        #Log file
        log = open("log.txt", "a")
        log.write(f"Input: {x_input}\n")
        log.write(f"Pred: {results}\n")
        log.close()

        return str(results)
    
    if request.method == 'GET':
        file = open("results.txt", "r")
        results = file.read()
        file.close()

        return str(results)


@app.route("/delete", methods=['POST'])
def delete():
    id = json.loads(request.data)
    id = list(id[0].values())[0]

    cur = conn.cursor(cursor_factory=psycopg2.extras.NamedTupleCursor)
    cur.execute(f"""DELETE FROM {schema}.{table} WHERE id={id}""")
    conn.commit()
    cur.close()

    #Log file
    log = open("log.txt", "a")
    log.write(f"Deleted id: {id}\n")
    log.close()

    return f"Deleted id: {id}"


@app.route("/submit", methods=['POST'])
def submit():
    #Log file
    log = open("log.txt", "a")
    
    record = json.loads(request.data)
    log.write(f'json: {record}\n\n')

    record = record[0]
    log.write(f'pos 0: {record}\n\n')

    record = record.values()
    log.write(f'values: {record}\n\n')
    
    record = list(record)
    log.write(f'list: {record}\n\n')

    cur = conn.cursor(cursor_factory=psycopg2.extras.NamedTupleCursor)
    query = f"""INSERT INTO {schema}.{table}(
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
        '{record[0]}',
        {record[1]},
        {record[2]},
        {record[3]},
        {record[4]},
        {record[5]},
        {record[6]},
        {record[7]},
        {record[8]},
        {record[9]},
        {record[10]},
        {record[11]},
        {record[12]}
        );"""

    log.write(f'len: {len(record)}\n\n')
    log.write(query)
    log.close()
    
    cur.execute(query)
    conn.commit()
    cur.close()

    return "New record added to DB"


@app.route("/update", methods=['POST'])
def update():
    row = json.loads(request.data)
    row = list(row[0].values())

    query = f"""
    UPDATE {schema}.{table}
    SET type = '{row[1]}',
        fixed_acidity = {row[2]},
        volatile_acidity = {row[3]},
        citric_acid = {row[4]},
        residual_sugar = {row[5]},
        chlorides = {row[6]},
        free_sulfur_dioxide = {row[7]},
        total_sulfur_dioxide = {row[8]},
        density = {row[9]},
        ph = {row[10]},
        sulphates = {row[11]},
        alcohol = {row[12]},
        quality = {row[13]}
    WHERE id = {row[0]};
    """

    #Log file
    log = open("log.txt", "a")
    log.write(f"row: {row}\n")
    log.write(f"query: {query}\n")
    log.close()

    cur = conn.cursor(cursor_factory=psycopg2.extras.NamedTupleCursor)
    cur.execute(query)
    conn.commit()
    cur.close()

    return f"Update id: {row[0]}"


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=4999, debug=True)
