## Integrantes
- David Damian Arbeu
- Miguel Ángel Castañeda Martínez
- José Eduardo Gutiérrez Navarrete

## Explicación del problema de negocio
El principal objetivo de la aplicación presentada es que a partir de ciertas caracteristicas quimicas de un vino sea capaz de predecir la calidad del mismo. Adicionalmente, ésta presenta al usuario una tabla con información de alrededor de 6,500 vinos diferentes, con la cual es posible explorar gráficamente las relaciones entre características.

Para conseguir los objetivos planteados, se necesitó de entrenar un modelo de *Machine Learning* en `Python`a partir de un [conjunto de datos de vinos](https://www.kaggle.com/code/vishalyo990/prediction-of-quality-of-wine/data) que alojamos en una base de datos en `Postgres`.

La aplicación se aloja en un `ShinyDashboard` y es requerido que la comunicación entre la base de datos, el modelo y la interfaz sea a través de la implementación de una [API](https://github.com/Skalas/EC2022/blob/main/notas/API/Intro.org).

La aplicación también permite que el usuario actualice, borre, y añada registros de nuevos vinos a los ya existentes.

## Herramientas utilizadas
 - Docker
   - docker compose 
 - R
   - Shiny
   - ShinyDashboard
   - dplyr
   - ggplot
   - httr
 - Python
   - Flask
   - Numpy
   - Scikit-learn
   - Psycopg2 
 - SQL
   - Postgres

## Requisitos
Tener instalado:
   - Docker desktop
   - Git
## Instrucciones.
 - Clonar este repositorio en la dirección local deseada.
 - Dentro de la carpeta ejecutar en linea de comandos:  
   - Linux/iOS: `docker compose up` 
   - Windows: `docker-compose up`
 
 El tiempo de carga es aproximadamente 5 minutos.

