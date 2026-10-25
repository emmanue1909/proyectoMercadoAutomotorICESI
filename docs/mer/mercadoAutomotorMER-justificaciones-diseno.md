# Justificaciones de Diseño y Normalización del MER — Plataforma de Mercado Automotor

- **Proyecto:** Reto 8 — Plataforma de análisis del mercado automotor colombiano (Seminario en Ingeniería, Universidad Icesi).
- **Estándar visual:** Notación Barker (Oracle SQL Data Modeler).
- **Nivel de normalización:** Tercera Forma Normal (3FN).
- **Diagrama asociado:** `docs/mercadoAutomotorMER-barker.svg`.

---

## 1. Contexto del Negocio y Problemática de Modelado

La plataforma consolida y procesa datos heterogéneos provenientes de **cinco portales fijos** del mercado automotor colombiano:
1. OLX
2. Mercado Libre (TuCarro)
3. VendeTuNave
4. MotoYa
5. Sergio Sierra Motos

A partir de los tres objetivos de investigación (RQs) definidos en la Revisión Sistemática de Literatura (SLR):
- **RQ1 (Integración y Deduplicación):** Se extraen anuncios por lotes y se aplica deduplicación (HierMatcher). Un mismo vehículo físico puede publicarse simultáneamente en múltiples portales con pequeñas discrepancias léxicas o de precio.
- **RQ2 (Predicción):** Se generan pronósticos de precios y tendencias de mercado por segmento y período a partir de los datos históricos consolidados.
- **RQ3 (Almacenamiento):** Por requerimiento estricto del curso y basado en la taxonomía de Koukaras, los datos se consolidan en un **Data Warehouse relacional en Tercera Forma Normal (3FN)**.

---

## 2. Catálogo de Entidades y Justificación de Existencia

### 2.1. `PORTAL`
- **Propósito:** Representa cada una de las fuentes externas fijas de datos.
- **Justificación:** Al ser fuentes fijas con características de extracción específicas (frecuencia, URL base, métodos de scraping/API), centralizar el portal evita repetir cadenas de texto como `'MercadoLibre'` o `'OLX'` en millones de anuncios, garantizando integridad referencial y permitiendo activar/desactivar fuentes en el pipeline ETL.

### 2.2. `DEPARTAMENTO` y `CIUDAD`
- **Propósito:** Normalización jerárquica de la localización geográfica de anuncios y vendedores en Colombia.
- **Justificación (3FN):** En un anuncio o vendedor, la ciudad determina de forma unívoca el departamento ($CIUDAD \to DEPARTAMENTO$). Si guardáramos `nombre_departamento` directamente en `ANUNCIO`, existiría una dependencia transitiva ($ANUNCIO \to CIUDAD \to DEPARTAMENTO$), violando la 3FN y generando anomalías de actualización. Se desacopla en dos entidades.

### 2.3. `TIPO_VEHICULO`
- **Propósito:** Clasifica la naturaleza del vehículo (ej. *Carro*, *Camioneta*, *Motocicleta*).
- **Justificación:** Permite unificar en un solo esquema el procesamiento de carros y motos (requisito explícito del Reto 8, que incluye portales especializados como MotoYa y Sergio Sierra Motos), facilitando filtros analíticos transversales.

### 2.4. `MARCA` y `LINEA_VEHICULO`
- **Propósito:** Estructurar el catálogo vehicular estandarizado.
- **Justificación (3FN):** Cada línea (ej. *Duster*, *Spark GT*, *Pulsar NS200*, *FZ25*) pertenece a una única marca fabricante ($LINEA \to MARCA$). Guardar la marca directamente en cada vehículo generaría una dependencia transitiva ($VEHICULO \to LINEA \to MARCA$), multiplicando redundancias léxicas entre portales.

### 2.5. `VENDEDOR`
- **Propósito:** Identifica al anunciante que oferta el bien (persona natural o concesionario).
- **Justificación:** Desacoplar al vendedor del anuncio permite modelar que un mismo concesionario o particular publique múltiples vehículos a lo largo del tiempo, facilitando análisis de reputación, volumen de inventario y concentración del mercado.

### 2.6. `VEHICULO` (Entidad Canónica Post-Deduplicación)
- **Propósito:** Representa la entidad vehicular física unificada en el Data Warehouse.
- **Justificación Arquitectónica (RQ1):** Resuelve el problema central de deduplicación. Si un mismo Mazda 3 modelo 2021 con 45,000 km se publica en OLX y TuCarro, el algoritmo HierMatcher vincula ambos anuncios a un único registro canónico en `VEHICULO`.
- **Atributos:**
  - `# id_vehiculo` (PK)
  - `* id_linea` (FK)
  - `* anio_modelo`
  - `* kilometraje_estimado`
  - `* tipo_combustible`
  - `* tipo_transmision`
  - `o cilindraje_cc` (Relevante especialmente para motos)
  - `o color`
  - `* fecha_registro_canonico`

### 2.7. `ANUNCIO` (Instancia en Portal)
- **Propósito:** Registra la publicación puntual observada en un portal específico.
- **Justificación:** Modela la realidad heterogénea previa y posterior a la deduplicación. Almacena el precio específico ofertado, la URL original, la fecha de publicación y el identificador que el portal le dio a la publicación.
- **Atributos:**
  - `# id_anuncio` (PK)
  - `* id_portal` (FK)
  - `o id_vehiculo` (FK - Opcional al cargar en staging; se completa tras el proceso de match de HierMatcher)
  - `* id_vendedor` (FK)
  - `* id_ciudad` (FK)
  - `* codigo_anuncio_portal`
  - `* titulo_anuncio`
  - `* precio_publicado`
  - `* fecha_publicacion`
  - `o fecha_baja`
  - `* url_publicacion`
  - `* estado_anuncio`

### 2.8. `HISTORIAL_PRECIO`
- **Propósito:** Registra las variaciones de precio que experimenta un anuncio a lo largo de su ciclo de vida.
- **Justificación (1FN y Análisis Temporal):** Un vendedor suele rebajar el precio si el vehículo no se vende en semanas. Modelar múltiples precios en el registro del anuncio violaría 1FN (grupo repetitivo) o perdería la dimensión temporal si solo se sobrescribe. Esta entidad 1:M permite calcular el tiempo de venta y la elasticidad del precio.

### 2.9. `PREDICCION_MERCADO`
- **Propósito:** Almacena las proyecciones y estimaciones de precio de mercado producidas por los modelos analíticos (RQ2).
- **Justificación:** Conecta la capa de Data Warehouse con la capa de analítica predictiva. Se asocia a la `LINEA_VEHICULO` y año modelo en un período dado, registrando los intervalos de confianza (mínimo, estimado, máximo) y el algoritmo utilizado (ej. XGBoost, Random Forest).

---

## 3. Demostración de Normalización hasta 3FN

| Forma Normal | Regla Aplicada | Verificación en el Esquema Diseñado |
|---|---|---|
| **Primera Forma Normal (1FN)** | Todos los atributos son atómicos; no hay listas, vectores ni grupos repetitivos. | - Los múltiples precios de un anuncio se extrajeron a `HISTORIAL_PRECIO`.<br>- Los nombres y ubicaciones son valores escalares simples.<br>- Cada tupla tiene una clave primaria identificadora simple (`id_*`). |
| **Segunda Forma Normal (2FN)** | Cumple 1FN y no existen dependencias funcionales parciales respecto a la clave primaria. | - Todas las entidades principales utilizan claves primarias simples (surrogate keys enteras `id_*`), por lo que cualquier atributo no clave depende funcionalmente de la totalidad de la PK. |
| **Tercera Forma Normal (3FN)** | Cumple 2FN y no existen dependencias transitivas entre atributos no clave ($X \to Y$ donde ninguno es superclave). | - **Ubicación:** $ANUNCIO \to CIUDAD$, pero no $ANUNCIO \to DEPARTAMENTO$. `DEPARTAMENTO` depende exclusivamente de `CIUDAD`.<br>- **Clasificación Automotor:** $VEHICULO \to LINEA\_VEHICULO$, y a su vez $LINEA\_VEHICULO \to MARCA$. `MARCA` no se duplica en `VEHICULO`.<br>- **Precios y Métricas:** No se guardan atributos derivados calculables (como promedios o variaciones porcentuales) en la tabla del vehículo o anuncio. |

---

## 4. Definición de Relaciones en Notación Barker

En notación Barker, la relación se lee y evalúa en el **extremo opuesto**:

1. **`PORTAL` — `ANUNCIO`**:
   - Un `PORTAL` puede publicar **uno o muchos (1:M obligatorio)** `ANUNCIO`s.
   - Un `ANUNCIO` debe pertenecer a **uno y solo un (1:1 obligatorio)** `PORTAL`.

2. **`VEHICULO` — `ANUNCIO`**:
   - Un `VEHICULO` canónico puede originar **uno o muchos (1:M)** `ANUNCIO`s (evidencia de duplicación cross-portal).
   - Un `ANUNCIO` puede asociarse a **cero o un (0:1 opcional)** `VEHICULO` (opcional durante la ingesta en bruto, obligatorio tras ejecutar HierMatcher).

3. **`MARCA` — `LINEA_VEHICULO`**:
   - Una `MARCA` agrupa **una o muchas (1:M obligatorio)** `LINEA_VEHICULO`s.
   - Una `LINEA_VEHICULO` pertenece a **una y solo una (1:1 obligatorio)** `MARCA`.

4. **`TIPO_VEHICULO` — `LINEA_VEHICULO`**:
   - Un `TIPO_VEHICULO` clasifica **una o muchas (1:M)** `LINEA_VEHICULO`s.
   - Una `LINEA_VEHICULO` corresponde a **un y solo un (1:1 obligatorio)** `TIPO_VEHICULO`.

5. **`LINEA_VEHICULO` — `VEHICULO`**:
   - Una `LINEA_VEHICULO` define la referencia técnica de **cero, uno o muchos (0:M)** `VEHICULO`s físicos.
   - Un `VEHICULO` físico debe ser de **una y solo una (1:1 obligatorio)** `LINEA_VEHICULO`.

6. **`DEPARTAMENTO` — `CIUDAD`**:
   - Un `DEPARTAMENTO` contiene **una o muchas (1:M)** `CIUDAD`es.
   - Una `CIUDAD` pertenece a **un y solo un (1:1 obligatorio)** `DEPARTAMENTO`.

7. **`CIUDAD` — `ANUNCIO`**:
   - Una `CIUDAD` es sede de publicación de **cero, uno o muchos (0:M)** `ANUNCIO`s.
   - Un `ANUNCIO` se ubica en **una y solo una (1:1 obligatorio)** `CIUDAD`.

8. **`VENDEDOR` — `ANUNCIO`**:
   - Un `VENDEDOR` publica **uno o muchos (1:M)** `ANUNCIO`s.
   - Un `ANUNCIO` es publicado por **un y solo un (1:1 obligatorio)** `VENDEDOR`.

9. **`ANUNCIO` — `HISTORIAL_PRECIO`**:
   - Un `ANUNCIO` registra **cero, uno o muchos (0:M)** cambios en `HISTORIAL_PRECIO`.
   - Un `HISTORIAL_PRECIO` pertenece a **un y solo un (1:1 obligatorio)** `ANUNCIO`.

10. **`LINEA_VEHICULO` — `PREDICCION_MERCADO`**:
    - Una `LINEA_VEHICULO` es objeto de **cero, una o muchas (0:M)** `PREDICCION_MERCADO`s.
    - Una `PREDICCION_MERCADO` se calcula para **una y solo una (1:1 obligatorio)** `LINEA_VEHICULO`.
