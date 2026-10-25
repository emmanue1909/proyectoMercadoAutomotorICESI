# Justificaciones de Diseño y Normalización del MER (Versión 2.0) — Plataforma de Mercado Automotor

- **Proyecto:** Reto 8 — Plataforma Inteligente para el Análisis del Mercado Automotor Colombiano.
- **Curso / Programa:** Seminario en Ingeniería — Universidad Icesi.
- **Estándar Visual:** Notación Barker (Oracle SQL Data Modeler).
- **Nivel de Normalización:** Tercera Forma Normal (3FN).
- **Documento de Contexto Fuente:** `docs/contexto/contexto_mer_plataforma_automotor.md`.
- **Diagrama Vectorial Asociado:** `docs/mer/mercadoAutomotorMER-barker-version2.0.svg`.

---

## 1. Contexto del Negocio y Problemática de Modelado

La plataforma es una **solución de inteligencia de negocio interna (B2B)** diseñada para analistas y administradores corporativos que requieren monitorear, auditar y predecir el comportamiento del mercado de vehículos y motocicletas en Colombia. Los datos se extraen e integran de portales digitales heterogéneos (Mercado Libre/TuCarro, VendeTuNave, MotoYa, entre otros).

El modelo de datos responde formalmente a las tres Preguntas de Investigación (RQs) derivadas de la Revisión Sistemática de Literatura (SLR) sobre ~70 artículos académicos:
- **RQ1 (Integración heterogénea y reconciliación):** Ingesta batch ETL, resolución de esquemas mediante reglas globales y deduplicación (reconocimiento del vehículo físico único detrás de anuncios dispersos en distintos portales).
- **RQ2 (Predicción del mercado):** Proyección de rangos de precio agregados periódicos y estimaciones puntuales trazables con algoritmos supervisados de Machine Learning.
- **RQ3 (Almacenamiento y gobierno):** Data Warehouse con esquema relacional en **Tercera Forma Normal (3FN)** estricta, respaldado por la taxonomía de Koukaras, garantizando integridad transaccional, trazabilidad de consumo y auditoría del modelo predictivo.

---

## 2. Cambios Estructurales Clave: MER v1.0 vs. MER v2.0

| Elemento / Dimensión | MER v1.0 (Versión Previa) | MER v2.0 (Versión Actualizada) | Justificación Académica y de Dominio |
|---|---|---|---|
| **Usuarios y Roles** | No modelados (solo capa de datos externa). | Supertipo `USUARIO` con subtipos exclusivos `ADMIN` y `EMPLEADO`. | La plataforma es una herramienta interna B2B con roles operativos diferenciados (consumo y favoritos vs. auditoría y ejecuciones ML). |
| **Publicador / Vendedor** | Entidad independiente `VENDEDOR`. | **Eliminada como entidad**. Atributos integrados en `ANUNCIO` (`tipo_publicador`, `nombre_contacto_publicador`, `telefono_publicador`). | El publicador no es un actor del sistema; es un dato no estructurado ni verificable proveniente del portal de origen, sin identidad canónica entre plataformas. |
| **Auditoría y Búsquedas** | Inexistente. | Entidad `HISTORIAL_BUSQUEDA` y `FAVORITO`. | Permite a los empleados guardar anuncios relevantes y registrar auditoría de consultas, métricas de consumo de tokens y costos por analista. |
| **Gobierno y ML Tracking** | Atributos de algoritmo dispersos en predicción. | Entidad `LOG_EJECUCION_MODELO` vinculada a `ADMIN`. | RQ2 y MLOps: Trazabilidad total de qué administrador disparó el entrenamiento/cálculo, versión del modelo, métricas de efectividad, duración y costos computacionales. |
| **Completitud de Extracción** | Asumía atributos completos. | Campos explícitos `datos_incompletos` y `atributos_faltantes` en `ANUNCIO`. | Transparencia ante datos heterogéneos y faltantes, documentando lagunas de origen para los modelos predictivos. |

---

## 3. Catálogo de Entidades y Justificación de Existencia (3FN)

### 3.1. Bloque de Usuarios y Gobierno Interno (B2B)

#### `USUARIO` *(Supertipo)*
- **Propósito:** Centraliza la identidad, autenticación y credenciales institucionales de los colaboradores internos autorizados.
- **Justificación:** Todos los usuarios comparten atributos esenciales (`correo`, `contrasena_hash`, `nivel_permiso`, `estado_cuenta`). Centralizarlos en un supertipo previene redundancias de autenticación y asegura que el sistema aplique políticas de seguridad homogéneas.

#### `ADMIN` *(Subtipo Exclusivo de USUARIO)*
- **Propósito:** Modela al personal responsable del gobierno, auditoría y ejecución de los modelos predictivos.
- **Justificación:** Los administradores tienen atributos propios (`fecha_asignacion_rol`, `ambito_administracion`) y una relación de responsabilidad 1:N con `LOG_EJECUCION_MODELO`. Un administrador no realiza consultas operativas ordinarias de cotización, por lo que no hereda tablas de favoritos.

#### `EMPLEADO` *(Subtipo Exclusivo de USUARIO)*
- **Propósito:** Modela al analista operativo que explora el mercado, solicita estimaciones y guarda anuncios.
- **Justificación:** Posee atributos exclusivos (`cargo`, `area_interna`, `limite_consultas`) y relaciones propias con `FAVORITO` e `HISTORIAL_BUSQUEDA`.

#### `FAVORITO`
- **Propósito:** Resuelve la relación N:N entre `EMPLEADO` y `ANUNCIO`.
- **Justificación (3FN / Entidad Asociativa):** Un empleado puede marcar múltiples publicaciones, y un anuncio puede ser marcado por múltiples analistas. Almacena metadatos de la relación como `fecha_guardado` y `nota` cualitativa. Se asocia a `ANUNCIO` (y no a `VEHICULO`) porque el analista requiere revisar la oferta concreta, su precio original y el portal fuente.

#### `HISTORIAL_BUSQUEDA`
- **Propósito:** Bitácora transaccional de búsquedas, filtros y estimaciones puntuales de precio realizadas por los analistas.
- **Justificación:** La estimación puntual en tiempo real no requiere una entidad propia; se persiste como evento en esta bitácora junto con los criterios ingresados, el resultado generado y el consumo de tokens/costo. Su clave foránea `id_log_ejecucion (FK)` es opcional porque aplica únicamente cuando la búsqueda invocó el servicio de predicción puntual.

---

### 3.2. Bloque de Fuentes Externas, Anuncios y Evidencia

#### `PORTAL`
- **Propósito:** Representa cada una de las fuentes externas digitales integradas (Mercado Libre, TuCarro, VendeTuNave, MotoYa, etc.).
- **Justificación:** Normaliza las fuentes fijas. Contiene el estado (`activo`), URL base y la fecha del último lote de extracción batch. Evita duplicar nombres de portales en millones de tuplas.

#### `DEPARTAMENTO` y `CIUDAD`
- **Propósito:** Desacoplamiento de la jerarquía geográfica de los anuncios en Colombia.
- **Justificación (3FN):** La relación funcional $CIUDAD \to DEPARTAMENTO$ exige que `nombre_departamento` no se guarde en `ANUNCIO`. De lo contrario existiría una dependencia transitiva ($ANUNCIO \to CIUDAD \to DEPARTAMENTO$).

#### `ANUNCIO`
- **Propósito:** Instancia observada de una publicación en un portal específico.
- **Justificación:** Modela la realidad heterogénea previa y posterior a la deduplicación. Contiene el precio publicado, la URL original, estado y la indicación transparente de incompletitud de datos (`datos_incompletos`, `atributos_faltantes`).
- **Por qué `id_vehiculo (FK)` es opcional:** Durante el proceso de ingesta en staging, el anuncio recién extraído aún no ha sido reconciliado por el algoritmo deduplicador (HierMatcher); la FK se actualiza al consolidarse la entidad canónica.
- **Por qué no existe `VENDEDOR`:** En portales de clasificados, los publicadores varían desde particulares con seudónimos hasta concesionarios sin identificación tributaria verificable. Crear una entidad `VENDEDOR` induciría entidades huérfanas o deduplicaciones artificiales imposibles de sostener. Sus datos se preservan como atributos opcionales dentro de `ANUNCIO`.

#### `HISTORIAL_PRECIO`
- **Propósito:** Traza la curva de variación de precios de un anuncio en el tiempo.
- **Justificación (1FN y Series Temporales):** Un mismo anuncio cambia de precio durante su vigencia. Guardar listas o arrays de precios dentro de `ANUNCIO` violaría 1FN (atributos multivaluados); sobreescribir el campo destruiría la serie temporal necesaria para análisis econométricos y predicción de tendencias.

#### `IMAGEN_ANUNCIO`
- **Propósito:** Almacena los enlaces a las fotografías que respaldan la publicación.
- **Justificación (1FN):** Un anuncio contiene de 1 a N imágenes. Se separa en una entidad 1:N que registra la URL, el orden visual y la bandera `es_principal`.

---

### 3.3. Bloque Vehicular Canónico y Catálogos

#### `VEHICULO` *(Registro Canónico Post-Deduplicación)*
- **Propósito:** Entidad canónica unificada que representa el vehículo físico en el Data Warehouse.
- **Justificación Arquitectónica (RQ1):** Soluciona la distorsión del mercado automotor provocada por la publicación simultánea del mismo automóvil en múltiples plataformas. Mantiene atributos consolidados (`anio_modelo`, `kilometraje_estimado`, `tipo_combustible`, `tipo_transmision`, `cilindraje_cc`, `color`).

#### `LINEA_VEHICULO`, `MARCA` y `TIPO_VEHICULO`
- **Propósito:** Catálogo jerárquico y taxonómico automotor normalizado.
- **Justificación (3FN):**
  - Cada línea (ej. *Sandero*, *Duster*, *Pulsar NS 200*) pertenece a una sola marca ($LINEA \to MARCA$).
  - Cada línea se clasifica en un tipo de vehículo ($LINEA \to TIPO\_VEHICULO$: carro, camioneta, moto).
  - Colocar marca o tipo directamente en `VEHICULO` crearía dependencias transitivas ($VEHICULO \to LINEA \to MARCA$).

---

### 3.4. Bloque de Analítica Predictiva y MLOps (RQ2)

#### `LOG_EJECUCION_MODELO`
- **Propósito:** Registro de gobierno, ejecución y trazabilidad de los modelos predictivos supervisados.
- **Justificación:** Cumple con las directrices de reproducibilidad y auditoría. Registra la versión del modelo, método/algoritmo (ej. XGBoost, Random Forest), métricas de efectividad ($R^2$, RMSE, MAPE), tokens consumidos y costos operacionales. Cada corrida es atribuida a un `ADMIN` responsable.

#### `PREDICCION_MERCADO`
- **Propósito:** Almacena las predicciones periódicas agregadas por línea de vehículo, año modelo y período temporal.
- **Justificación:** Materializa las bandas de referencia del mercado (`precio_estimado_mercado`, `rango_min_estimado`, `rango_max_estimado`), incorporando métricas explícitas de `nivel_confianza` y `completitud_datos` para no presentar las predicciones como verdades absolutas. Vinculada directamente al log de ejecución que la generó.

---

## 4. Demostración Formal de Normalización hasta 3FN

| Forma Normal | Regla Teórica | Verificación en el MER v2.0 |
|---|---|---|
| **Primera Forma Normal (1FN)** | Cada tupla tiene clave primaria; todos los campos contienen valores atómicos; no hay grupos repetitivos ni arrays multivaluados. | - Múltiples precios de un anuncio $\to$ `HISTORIAL_PRECIO`.<br>- Múltiples imágenes de un anuncio $\to$ `IMAGEN_ANUNCIO`.<br>- Favoritos de un usuario $\to$ `FAVORITO`.<br>- Todos los identificadores primarios son escalares simples (`id_*`). |
| **Segunda Forma Normal (2FN)** | Cumple 1FN y ningún atributo no clave depende parcialmente de una clave primaria compuesta. | - Todas las entidades emplean surrogate keys simples enteras como identificador primario (`# id_*`). Por definición, no pueden existir dependencias funcionales parciales. |
| **Tercera Forma Normal (3FN)** | Cumple 2FN y no existen dependencias funcionales transitivas entre atributos no clave ($X \to Y$ donde ninguno es superclave). | - **Geografía:** $ANUNCIO \to CIUDAD$, y $CIUDAD \to DEPARTAMENTO$. `DEPARTAMENTO` no se duplica en `ANUNCIO`.<br>- **Taxonomía Vehicular:** $VEHICULO \to LINEA\_VEHICULO \to MARCA$. Ni marca ni tipo se almacenan en `VEHICULO`.<br>- **Usuarios y Métricas:** Costos agregados y ejecuciones de modelo se separan de la entidad de usuario. No hay campos derivados o redundantes almacenados en tuplas transaccionales. |

---

## 5. Matriz de Relaciones y Cardinalidades Barker

A continuación se detalla la semántica en ambos extremos conforme a las reglas visuales de Barker:
- *Extremo opuesto a Entidad A indica la cardinalidad y opcionalidad de B respecto a A.*

| Entidad Origen | Cardinalidad / Opcionalidad | Verbo en Relación | Entidad Destino | Justificación de Negocio |
|---|---|---|---|---|
| `USUARIO` | Supertipo (1 : 1 exclusivo) | es un | `ADMIN` / `EMPLEADO` | Especialización disjunta de roles internos. |
| `EMPLEADO` | 1 obligatorio : M opcional | guarda | `FAVORITO` | Un empleado puede no tener favoritos o tener muchos; cada favorito pertenece a un empleado. |
| `ANUNCIO` | 1 obligatorio : M opcional | es marcado en | `FAVORITO` | Un anuncio puede ser favorito de 0, 1 o muchos empleados. |
| `EMPLEADO` | 1 obligatorio : M opcional | realiza | `HISTORIAL_BUSQUEDA` | Bitácora de consultas y consumo generada por analistas. |
| `LOG_EJECUCION_MODELO` | 1 obligatorio : M opcional | sustenta | `HISTORIAL_BUSQUEDA` | Opcional en destino: solo consultas de cotización puntual invocan un modelo ML. |
| `ADMIN` | 1 obligatorio : M opcional | ejecuta | `LOG_EJECUCION_MODELO` | Cada corrida ML es gobernada por un administrador responsable. |
| `PORTAL` | 1 obligatorio : M opcional | publica | `ANUNCIO` | Un portal registrado publica múltiples anuncios. |
| `DEPARTAMENTO` | 1 obligatorio : M obligatorio | contiene | `CIUDAD` | Todo departamento contiene al menos una ciudad registrada. |
| `CIUDAD` | 1 obligatorio : M opcional | ubica | `ANUNCIO` | Un anuncio debe localizarse obligatoriamente en una ciudad colombiana. |
| `VEHICULO` | 1 obligatorio : M opcional | unifica | `ANUNCIO` | La deduplicación consolida varios anuncios; opcional en el anuncio antes de reconciliar. |
| `ANUNCIO` | 1 obligatorio : M opcional | registra cambios | `HISTORIAL_PRECIO` | Traza de precios históricos del anuncio. |
| `ANUNCIO` | 1 obligatorio : M opcional | ilustra | `IMAGEN_ANUNCIO` | Galería fotográfica de la publicación. |
| `MARCA` | 1 obligatorio : M obligatorio | fabrica | `LINEA_VEHICULO` | Una marca manufactura una o más líneas automotrices. |
| `TIPO_VEHICULO` | 1 obligatorio : M obligatorio | clasifica | `LINEA_VEHICULO` | Clasificación taxonómica (carro, moto, etc.). |
| `LINEA_VEHICULO` | 1 obligatorio : M opcional | especifica | `VEHICULO` | Un vehículo físico canónico corresponde a una línea exacta. |
| `LINEA_VEHICULO` | 1 obligatorio : M opcional | proyecta | `PREDICCION_MERCADO` | Estimación periódica de precios calculada por línea y año. |
| `LOG_EJECUCION_MODELO` | 1 obligatorio : M opcional | genera | `PREDICCION_MERCADO` | Trazabilidad del algoritmo y métricas que produjeron las bandas de mercado. |

---

## 6. Supuestos de Modelado y Reglas de Negocio Explícitas

1. **Usuarios estrictamente internos:** Los publicadores externos no interactúan con la plataforma; el acceso está restringido a personal corporativo autenticado.
2. **Supranacionalidad vehicular vs. territorialidad del anuncio:** La entidad canónica `VEHICULO` no depende de la ciudad; la localización geográfica radica en el `ANUNCIO` puntual. Si un vehículo cambia de dueño o ciudad en una nueva publicación, la identidad física del carro permanece mientras que el anuncio capta el nuevo punto geográfico.
3. **Disparadores operativos sin persistencia:** La solicitud manual de sincronización o re-extracción de datos disparada por un empleado es un evento efímero del middleware ETL; no se modela como entidad de base de datos.
4. **Estimaciones puntuales efímeras vs. agregadas periódicas:** Las estimaciones en tiempo real solicitadas por un analista se guardan como transacciones en `HISTORIAL_BUSQUEDA` para auditoría y facturación de consumo, mientras que las proyecciones estadísticas agregadas se consolidan en `PREDICCION_MERCADO`.
