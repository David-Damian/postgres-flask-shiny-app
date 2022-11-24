import os
import csv
import numpy as np

#Get enviroment variables
USER = os.getenv('POSTGRES_USER')
PASSWORD = os.environ.get('POSTGRES_PASSWORD')
ADDRESS = os.environ.get('POSTGRES_ADDR')
DB = os.environ.get('POSTGRES_DB')


def create_query(query_file):
    """"
    Esta función recibe un archivo .txt con un query
    de SQL para transformarlo en un str de python.
    
    Parámetros:
    query_file: Archivo .txt con query de SQL.
    """
    #Se abre el archivo
    with open(query_file, mode='r') as file:
        query = """"""
        for row in file:
            query += (row)      
    file.close()
    return query


def initial_load(cursor, schema, table, data, template):
    with open(data, mode='r') as file:
        csvFile = csv.reader(file)
        
        for line in csvFile:
            try:
                #Se truncan valores a 6 decimales max
                row = np.array(line).astype(float) * 1e6
                row = np.trunc(row) / 1e6
                
                #Query de inserción
                insert_query = create_query(template)
                insert_query = insert_query.replace("<schema>", f"{schema}").replace("<table>", f"{table}")
                for i in range(len(row)):
                    insert_query = insert_query.replace(f"x_{i}", f"{row[i]}")
                
                #Escritura en base de datos
                cursor.execute(insert_query)
                
            except ValueError:
                pass
    file.close()