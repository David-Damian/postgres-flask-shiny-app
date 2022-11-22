# Base de Datos.

## Prerrequisitos:
* Docker
* Python:
    * **psycopg2**: `pip install psycopg2`

## Pasos de inicialización:
**Paso 1**: Archivo de configuración.
<br>Desde una terminal de bash ejecutar `cd db-config/ | docker-compose up -d`. Esto va a crear dos contenedores de Docker:
* Uno con la imagen de Docker para PostgreSQL que se comunica en 5432:5432
* Uno con la imagen de Docker para pgAdmin4 que se comunica en 80:80

**Paso 2**: Acceso a pgAdmin4.
<br>Desde un navegador, ir a la dirección `localhost:80`. Esto va a redirigir a una pestaña con la página de inicio de
pgAdmin4 en donde se deben introducir las credenciales de acceso:
* user: admin@admin.com
* pass: admin

**Paso 3**: Habilitar el servidor.
1. Dar click derecho en `Servers` $\rightarrow$ `Resigter` $\rightarrow$ `Server`.
2.  En la pestaña **General**:
    * `Name`: Proporcionar el nombre del servidor (Puede ser cualquier nombre).
3.  En la pestaña **Connection**:
    * `Host name`: postgres
    * `Username`: root
    * `Password`: root

Lo anterior va a habilitar un servidor `Name` con 2 bases de datos:
 * Base de datos de mantenimiento: `postgres`
 * Base de datos de trabajo: `vinos`
 
 **Paso 4**: Iniciar tabla en BD de `vinos`.
 1. Navegar a `vinos` $\rightarrow$ `Schemas` $\rightarrow$ `Tables`. No debería haber ninguna tabla creada.
 2. En un archivo _Query_ (`alt`+`shift`+`Q`) copiar el contenido del script `db-config/table_config.txt` y ejecutarlo (`F5`).
 3. Verificar que la tabla se creó correctamente _refrescando_ `Tables`. Ahora debería existir la tabla `wine_quality`.
