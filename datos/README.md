# Información del conjunto de datos:
El conjunto de datos está relacionado con las variantes rojas y blancas del vino portugués "Vinho Verde". Para más detalles, consulte: Cortez et al., 2009. Debido a cuestiones de privacidad y logística, solo están disponibles las variables fisicoquímicas (entradas) y sensoriales (salida) (por ejemplo, no hay datos sobre tipos de uva, marca de vino, precio de venta del vino, etc.).

Estos conjuntos de datos se pueden ver como tareas de clasificación o regresión. Las clases están ordenadas y no equilibradas (por ejemplo, hay muchos más vinos normales que excelentes o malos). Los algoritmos de detección de valores atípicos podrían usarse para detectar los pocos vinos excelentes o malos. Además, no estamos seguros de si todas las variables de entrada son relevantes. Por lo que podría ser interesante probar métodos de selección de características.

# Información de atributos:

## Variables de entrada (basadas en pruebas fisicoquímicas):
* acidez fija
* acidez volátil
* ácido cítrico
* azúcar residual
* cloruros
* dióxido de azufre libre
* dióxido de azufre total
* densidad
* pH
* sulfatos
* alcohol

## Variable de salida (basada en datos sensoriales):
* calidad (entre 0 y 10)

### Missing Attribute Values: Ninguno
