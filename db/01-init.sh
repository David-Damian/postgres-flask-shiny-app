#!/bin/bash
set -e
export PGPASSWORD=$POSTGRES_PASSWORD;
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  CREATE USER $APP_DB_USER WITH PASSWORD '$APP_DB_PASS';
  GRANT ALL ON schema public TO $APP_DB_USER;
  CREATE DATABASE $APP_DB_NAME;
  GRANT ALL ON DATABASE $APP_DB_NAME TO $APP_DB_USER;
  \connect $APP_DB_NAME $APP_DB_USER
  BEGIN;
    CREATE SCHEMA wine;
    DROP TABLE IF EXISTS wine.wine_quality;
    CREATE TABLE wine.wine_quality(
        id_wine 				SERIAL NOT NULL PRIMARY KEY,
        fixed_acidity 			DECIMAL(10,6)	NOT NULL,
        volatile_acidity		DECIMAL(10,6)	NOT NULL,
        citric_acid				DECIMAL(10,6)	NOT NULL,
        residual_sugar			DECIMAL(10,6)	NOT NULL,
        chlorides				DECIMAL(10,6)	NOT NULL,
        free_sulfur_dioxide		DECIMAL(10,6)	NOT NULL,
        total_sulfur_dioxide	DECIMAL(10,6)	NOT NULL,
        density					DECIMAL(10,6)	NOT NULL,
        pH						DECIMAL(10,6)	NOT NULL,
        sulphates				DECIMAL(10,6)	NOT NULL,
        alcohol					DECIMAL(10,6)	NOT NULL,
        quality					INT  			NOT NULL
    );
  COMMIT;
EOSQL