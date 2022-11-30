import os
import json
import psycopg2
import psycopg2.extras
from flask import Flask

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

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)