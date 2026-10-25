# Plataforma Inteligente para el Análisis del Mercado Automotor Colombiano
## Documento de contexto para el diseño del Modelo Entidad-Relación

**Reto 8 — Seminario de Ingeniería | Universidad Icesi**

---

## 1. Naturaleza de la plataforma

La solución es una **herramienta interna de empresa (B2B)**, destinada a ser utilizada por personal de una organización que requiere analizar el mercado automotor colombiano. No se trata de una aplicación pública dirigida a compradores o vendedores particulares de vehículos.

Esta precisión es determinante para el modelo de datos: todos los usuarios de la plataforma son internos, acceden mediante credenciales corporativas y se diferencian por el nivel de responsabilidad que tienen sobre el sistema. Los vendedores o publicadores que aparecen en los portales externos no son usuarios de la plataforma; son únicamente un dato más que se extrae de cada anuncio.

---

## 2. Statement del problema

El mercado de compra y venta de vehículos y motocicletas en Colombia se encuentra distribuido entre diferentes portales digitales —Mercado Libre/TuCarro, VendeTuNave, MotoYa, entre otros sitios especializados—. Cada plataforma presenta los anuncios con estructuras, atributos y niveles de detalle distintos. Como consecuencia, comparar vehículos, comprender los precios del mercado e identificar tendencias exige reunir e interpretar información dispersa, que con frecuencia contiene datos faltantes, duplicados o difíciles de contrastar.

Esta situación representa una dificultad concreta para quienes deben tomar decisiones a partir de la información del mercado automotor. El analista debe revisar varias plataformas, comparar manualmente características que no siempre están expresadas de la misma forma y determinar por su cuenta si el precio de un vehículo es razonable. Los anuncios disponibles no ofrecen una visión consolidada del mercado ni permiten comprender con facilidad cómo se relacionan el precio y las características del vehículo.

El problema no consiste únicamente en que los datos estén almacenados en lugares diferentes. Existe además una brecha entre la información publicada y la capacidad de convertirla en conocimiento útil para decidir. Una plataforma que solo consolide datos o muestre resultados de un algoritmo no resolvería completamente esa dificultad si la información continúa siendo confusa, difícil de comparar o poco transparente.

Por tanto, el reto es facilitar que el personal de la organización explore y compare información del mercado automotor colombiano y comprenda estimaciones de precios a partir de datos heterogéneos, sin tener que conocer las particularidades técnicas de cada fuente ni poseer conocimientos especializados en análisis de datos. La solución debe ayudar a interpretar la información y comunicar sus alcances y limitaciones, en lugar de presentar una predicción como una verdad absoluta.

---

## 3. Propuesta de solución

Se propone una plataforma web que integre información de distintos portales de venta de vehículos y motocicletas, la organice bajo una estructura común y la presente mediante una experiencia centrada en las tareas reales del analista. La plataforma combina herramientas de exploración y comparación del mercado con capacidades de análisis y predicción de precios.

### 3.1. Capacidades funcionales

**Integración y normalización.** La plataforma extrae datos de los portales disponibles y transforma sus diferencias de estructura para organizarlos bajo un esquema común. Cada portal registrado conserva su identidad como fuente, de modo que siempre sea posible rastrear de dónde proviene cada anuncio.

**Deduplicación de registros.** El sistema reconoce registros que corresponden al mismo vehículo cuando aparecen publicados en más de un portal, consolidándolos en un registro canónico único. Esto reduce inconsistencias en las comparaciones y evita que un mismo vehículo distorsione los análisis de mercado por aparecer varias veces.

**Exploración y filtrado.** El usuario puede filtrar anuncios por características relevantes —tipo de vehículo, marca, línea, año, ciudad, kilometraje, combustible, transmisión— para delimitar el segmento que desea analizar.

**Comparación consistente.** Los atributos provenientes de distintas fuentes se presentan de forma homogénea. Cuando un atributo no está disponible en el origen, se indica explícitamente en lugar de asumir un valor.

**Seguimiento de precios en el tiempo.** Cada cambio de precio de un anuncio queda registrado, lo que permite observar la evolución de una publicación y alimentar los análisis de tendencia.

**Predicción de precios en dos niveles.** La plataforma ofrece, por un lado, predicciones agregadas de mercado calculadas periódicamente por línea de vehículo y año, consultables en cualquier momento; y por otro, estimaciones puntuales que el usuario solicita ingresando características específicas de un vehículo concreto.

**Transparencia y confiabilidad.** Se registran y exponen la fecha de actualización de cada fuente, su cobertura, los atributos faltantes de cada anuncio y las métricas de confianza del modelo predictivo. Las estimaciones se presentan como referencias basadas en los datos disponibles, nunca como garantías de precio.

**Gobierno del modelo.** Cada ejecución del modelo predictivo queda registrada con sus métricas de desempeño y consumo de recursos, lo que permite auditar la calidad del sistema a lo largo del tiempo.

### 3.2. Principios que orientan la solución

- **Centrada en las necesidades reales.** La interfaz se organiza en torno a las preguntas y tareas de quienes analizan el mercado, no alrededor de la estructura interna de los datos.
- **Clara y fácil de aprender.** Lenguaje cotidiano, jerarquía visual consistente y filtros comprensibles. Las métricas técnicas avanzadas se ubican en vistas de detalle, sin saturar la consulta principal.
- **Transparente.** Se explica qué representa cada resultado, de qué datos depende y cuáles son sus limitaciones. Los valores faltantes no se ocultan.
- **Orientada a la comparación.** Los datos se muestran con unidades, periodos y criterios consistentes para que las comparaciones tengan sentido.
- **Trazable y auditable.** Toda estimación puede vincularse a la ejecución del modelo que la produjo, y toda consulta queda registrada con su consumo asociado.

---

## 4. Roles de usuario y alcance funcional

El sistema contempla dos perfiles de usuario, modelados como **supertipo con subtipos exclusivos** en notación Barker.

### USUARIO (supertipo)

Concentra los atributos comunes de identidad y acceso: credenciales, datos de contacto, nivel de permiso y estado de la cuenta. El nivel de permiso determina qué pantallas y funciones se habilitan tras el inicio de sesión.

### EMPLEADO (subtipo)

Es el usuario operativo de la plataforma. Sus funciones son:

- Explorar, filtrar y comparar anuncios del mercado.
- Consultar las predicciones agregadas de mercado.
- Solicitar estimaciones puntuales de precio ingresando características específicas de un vehículo.
- Guardar anuncios como favoritos para consultarlos posteriormente.
- Acumular un historial de sus búsquedas y consultas, con los resultados obtenidos y el consumo asociado.
- Solicitar la actualización de los datos. **Esta acción dispara el proceso de extracción pero no se registra como entidad en el modelo**: es un disparador operativo, no un dato persistente.

### ADMIN (subtipo)

Es el usuario responsable del gobierno del sistema. Sus funciones son:

- Ejecutar y controlar las actualizaciones del modelo predictivo, quedando registrado como responsable de cada corrida.
- Consultar las métricas de desempeño del modelo: efectividad, consumo de tokens, costos y tiempos de ejecución.
- Auditar la actividad de los empleados: qué consultaron, qué resultados obtuvieron y cuánto consumo generaron.
- Administrar los portales registrados como fuentes de datos.

---

## 5. Modelo de datos

### 5.1. Entidades

> Convención Barker: `#` identificador único (PK) · `*` atributo obligatorio · `o` atributo opcional · `(FK)` llave foránea

#### Bloque de usuarios

**USUARIO** *(supertipo)*
- `# id_usuario`
- `* nombre_usuario`
- `* correo`
- `* contrasena_hash`
- `* nivel_permiso`
- `* fecha_registro`
- `* estado_cuenta`

**ADMIN** *(subtipo de USUARIO)*
- `* fecha_asignacion_rol`
- `o ambito_administracion`

**EMPLEADO** *(subtipo de USUARIO)*
- `o cargo`
- `o area_interna`
- `o limite_consultas`

**FAVORITO**
- `# id_favorito`
- `* id_empleado (FK)`
- `* id_anuncio (FK)`
- `* fecha_guardado`
- `o nota`

**HISTORIAL_BUSQUEDA**
- `# id_busqueda`
- `* id_empleado (FK)`
- `o id_log_ejecucion (FK)`
- `* tipo_busqueda` — exploración/filtro o consulta de estimación
- `* criterios_busqueda`
- `* fecha_busqueda`
- `o precio_estimado_resultado`
- `o tokens_consumidos`
- `o costo_consulta`

#### Bloque de fuentes y anuncios

**PORTAL**
- `# id_portal`
- `* nombre_portal`
- `* url_base`
- `* activo`
- `* fecha_ultima_sincronizacion`
- `o cobertura_datos`

**ANUNCIO**
- `# id_anuncio`
- `* id_portal (FK)`
- `o id_vehiculo (FK)` — opcional: se asigna al consolidar el registro canónico
- `* id_ciudad (FK)`
- `* codigo_anuncio_portal`
- `* titulo_anuncio`
- `* precio_publicado`
- `* fecha_publicacion`
- `o fecha_baja`
- `* url_publicacion`
- `* estado_anuncio`
- `o tipo_publicador` — particular o concesionario, según lo reporte el portal
- `o nombre_contacto_publicador`
- `o telefono_publicador`
- `* datos_incompletos` — indicador de que faltan atributos en el origen
- `o atributos_faltantes` — detalle de qué atributos no estaban disponibles

**IMAGEN_ANUNCIO**
- `# id_imagen`
- `* id_anuncio (FK)`
- `* url_imagen`
- `* orden`
- `* es_principal`

**HISTORIAL_PRECIO**
- `# id_historial_precio`
- `* id_anuncio (FK)`
- `* precio_registrado`
- `* fecha_cambio`

#### Bloque de vehículos y catálogos

**VEHICULO** *(registro canónico tras deduplicación)*
- `# id_vehiculo`
- `* id_linea (FK)`
- `* anio_modelo`
- `* kilometraje_estimado`
- `* tipo_combustible`
- `* tipo_transmision`
- `o cilindraje_cc`
- `o color`
- `* fecha_registro_canonico`

**LINEA_VEHICULO**
- `# id_linea`
- `* id_marca (FK)`
- `* id_tipo_vehiculo (FK)`
- `* nombre_linea`

**MARCA**
- `# id_marca`
- `* nombre_marca`

**TIPO_VEHICULO**
- `# id_tipo_vehiculo`
- `* descripcion`

**DEPARTAMENTO**
- `# id_departamento`
- `* nombre_departamento`

**CIUDAD**
- `# id_ciudad`
- `* id_departamento (FK)`
- `* nombre_ciudad`

#### Bloque de predicción

**LOG_EJECUCION_MODELO**
- `# id_log_ejecucion`
- `* id_admin (FK)`
- `* fecha_ejecucion`
- `* version_modelo`
- `* metodo_algoritmo`
- `* tokens_consumidos`
- `* costo_ejecucion`
- `* metrica_efectividad`
- `o duracion_ejecucion`
- `o observaciones`

**PREDICCION_MERCADO**
- `# id_prediccion`
- `* id_linea (FK)`
- `* id_log_ejecucion (FK)`
- `* anio_modelo`
- `* periodo_prediccion`
- `* precio_estimado_mercado`
- `* rango_min_estimado`
- `* rango_max_estimado`
- `* fecha_calculo`
- `* nivel_confianza`
- `* completitud_datos`

### 5.2. Relaciones y cardinalidades

| Relación | Entidad origen | Cardinalidad | Entidad destino |
|---|---|---|---|
| contiene | DEPARTAMENTO | 1 : N | CIUDAD |
| ubica | CIUDAD | 1 : N | ANUNCIO |
| publica | PORTAL | 1 : N | ANUNCIO |
| unifica *(deduplicación)* | VEHICULO | 1 : N | ANUNCIO |
| registra cambios | ANUNCIO | 1 : N | HISTORIAL_PRECIO |
| ilustra | ANUNCIO | 1 : N | IMAGEN_ANUNCIO |
| es marcado en | ANUNCIO | 1 : N | FAVORITO |
| especifica | LINEA_VEHICULO | 1 : N | VEHICULO |
| fabrica | MARCA | 1 : N | LINEA_VEHICULO |
| clasifica | TIPO_VEHICULO | 1 : N | LINEA_VEHICULO |
| proyecta | LINEA_VEHICULO | 1 : N | PREDICCION_MERCADO |
| genera | LOG_EJECUCION_MODELO | 1 : N | PREDICCION_MERCADO |
| sustenta | LOG_EJECUCION_MODELO | 1 : N | HISTORIAL_BUSQUEDA |
| ejecuta | ADMIN | 1 : N | LOG_EJECUCION_MODELO |
| guarda | EMPLEADO | 1 : N | FAVORITO |
| realiza | EMPLEADO | 1 : N | HISTORIAL_BUSQUEDA |
| es un | USUARIO | supertipo | ADMIN / EMPLEADO |

La relación N:N entre empleados y anuncios se resuelve mediante **FAVORITO** como entidad asociativa, conforme a la tercera forma normal.

---

## 6. Decisiones de diseño y supuestos

**El publicador no es una entidad.** En una versión anterior del modelo existía una entidad VENDEDOR. Se elimina porque el publicador del anuncio no es un actor del sistema: es un dato extraído del portal de origen, frecuentemente incompleto y sin identidad verificable entre fuentes. Se conserva como atributos opcionales dentro de ANUNCIO.

**Los favoritos se guardan sobre ANUNCIO, no sobre VEHICULO.** El empleado marca publicaciones concretas, con su precio publicado, su fuente y su enlace original, que es lo que necesita para volver a revisarlas.

**La estimación puntual no es una entidad propia.** Es una consulta que el empleado realiza en tiempo real. Lo que sí se persiste es su registro en HISTORIAL_BUSQUEDA, junto con los criterios ingresados, el precio estimado devuelto y el consumo generado. Esto permite la auditoría por parte del administrador sin duplicar la lógica de predicción.

**Trazabilidad del modelo.** Tanto las predicciones agregadas como las estimaciones puntuales se vinculan a la ejecución del modelo que las produjo, mediante la llave foránea hacia LOG_EJECUCION_MODELO. Así es posible saber con qué versión del modelo se calculó cada resultado.

**La solicitud de actualización no se modela.** El empleado puede disparar el proceso de extracción, pero esa acción no deja registro persistente. Se trata de un evento operativo, no de un dato de negocio.

**Implicación de los subtipos exclusivos.** Al modelar ADMIN y EMPLEADO como subtipos exclusivos, las relaciones de favoritos e historial de búsqueda cuelgan de EMPLEADO, mientras que la ejecución del modelo cuelga de ADMIN. Esto implica que, en el modelo, **un administrador no posee favoritos ni historial de búsqueda propios**: su rol es de gobierno y auditoría sobre la actividad de los empleados, no de consulta operativa personal. Esta separación es deliberada y mantiene cada subtipo con atributos y relaciones distintivas, que es la condición que justifica el uso de subtipos en notación Barker.

**Deduplicación opcional en el tiempo.** La llave foránea `id_vehiculo` en ANUNCIO es opcional porque un anuncio recién extraído puede no haber sido consolidado aún con su registro canónico. Se asigna cuando el proceso de reconciliación lo resuelve.

---

## 7. Sustento en la revisión de literatura

La revisión sistemática del proyecto seleccionó 16 estudios a partir de 2.546 registros iniciales y analizó tres ejes: integración de datos heterogéneos, almacenamiento y predicción de precios del mercado automotor. Sus hallazgos respaldan las decisiones técnicas adoptadas:

- **Integración:** se identifica ETL como alternativa adecuada para extraer, transformar y cargar datos provenientes de fuentes dispares, y se propone el uso de un esquema global con reglas de mapeo para armonizarlas.
- **Reconciliación:** se destaca la importancia de reconocer registros que refieren a la misma entidad real antes de cualquier análisis, lo que sustenta la separación entre ANUNCIO y VEHICULO.
- **Almacenamiento:** se señala que una base relacional puede servir como repositorio principal, con componentes NoSQL como complemento eventual para atributos variables.
- **Predicción:** se subraya la necesidad de preparar los datos y tratar los valores faltantes antes de entrenar modelos predictivos, lo que sustenta los atributos de completitud y confiabilidad del modelo.

Referencias consultadas: Putrama y Martinek (2024); Sun y Shen (2022); Fayyaz et al. (2025); Cui et al. (2022); Domínguez et al. (2024). Los datos bibliográficos completos deben verificarse en las fuentes originales antes de la entrega académica.

---

## 8. Resultado esperado

Se espera que la plataforma reduzca el esfuerzo necesario para consultar múltiples portales, comparar vehículos y comprender referencias de precios. Su aporte no será únicamente reunir datos ni producir una predicción, sino ofrecer una experiencia que permita explorar la información, entender los resultados y valorar sus limitaciones con mayor facilidad.

Los perfiles de usuario, las funciones de interfaz y los principios de experiencia aquí descritos constituyen una propuesta derivada del problema y de la solución técnica planteada. La usabilidad y la utilidad real de la experiencia deberán validarse posteriormente mediante pruebas con usuarios, evaluando la precisión del modelo y la facilidad de uso como aspectos distintos.
