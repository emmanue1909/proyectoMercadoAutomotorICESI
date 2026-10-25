# Contexto del proyecto — Reto 8 (Icesi): Plataforma de análisis del mercado automotor colombiano

## Qué es el proyecto
Proyecto grupal de Ingeniería de Sistemas (Seminario en Ingeniería, Icesi). Siguiendo el Engineering Design Process de Dieter & Schmidt (7 fases), el equipo diseña una **plataforma que consolida y analiza datos del mercado automotor colombiano** (vehículos y motos en venta), con el fin de generar predicciones sobre el comportamiento del mercado.

El paper del grupo está respaldado por una Revisión Sistemática de Literatura (SLR) de ~70 papers (20 por integrante), organizada en 3 preguntas de investigación (RQ). Emmanuel es responsable de las secciones de Resultados y Discusión.

## Fuentes de datos (capa de integración)
La plataforma consolida datos de **cinco portales fijos y conocidos**:
1. OLX
2. Mercado Libre (TuCarro)
3. VendeTuNave
4. MotoYa
5. Sergio Sierra Motos

Al ser fuentes fijas (no un escenario schema-agnostic genérico), se optó por integración liviana en vez de frameworks de integración completos.

## Decisiones arquitectónicas (una por cada RQ)

| RQ | Capa | Decisión | Justificación |
|---|---|---|---|
| RQ1 | Integración de datos heterogéneos | ETL por extracción batch + mapeo de esquema basado en reglas (inspirado en NextiaDI) + deduplicación simplificada basada en HierMatcher | 5 fuentes fijas y conocidas → complejidad media es suficiente, no se necesita integración schema-agnostic completa |
| RQ2 | Predicción del comportamiento del mercado | Análisis comparativo de métodos de predicción de mercado automotor | — |
| RQ3 | Almacenamiento de datos heterogéneos | Data Warehouse como arquitectura principal | Restringido por el entregable obligatorio del curso: modelo relacional en **Tercera Forma Normal (3FN)**. Justificado teóricamente con la taxonomía de almacenamiento de Koukaras |

**Restricción clave para el MER**: el modelo de datos del Data Warehouse debe entregarse en 3FN — esto es un requisito obligatorio del curso, no solo buena práctica, así que la skill de MER aplica directo aquí.

## Lo que ya sabemos que necesita vivir en el modelo de datos
A partir del pipeline (ETL → deduplicación → Data Warehouse → predicción), el dominio probablemente incluye:
- **Anuncios/listados** publicados en cada portal (vehículo o moto en venta, precio, fecha de publicación, ubicación, etc.)
- **Fuente/portal** de origen de cada anuncio
- **Vehículo/moto** como entidad "canónica" después de la deduplicación (un mismo vehículo puede aparecer en varios portales)
- Atributos propios de vehículos/motos: marca, modelo, año, kilometraje, tipo (carro/moto), precio, estado, ciudad, etc.
- Posiblemente **vendedor/anunciante**
- Algo relacionado con **predicciones de mercado** generadas (por segmento, por marca/modelo, por periodo)

## ⚠️ Lo que falta confirmar antes de modelar (pendiente de responder)
Para que la skill no tenga que inventar reglas de negocio (paso 1 del flujo), falta precisar:

1. **Atributos exactos de un vehículo/moto**: ¿qué campos captura cada anuncio? (marca, modelo, año, kilometraje, transmisión, combustible, color, precio, ¿algo más específico de motos vs. carros?)
2. **Deduplicación**: cuando el mismo vehículo aparece en 2+ portales, ¿se modela como un vehículo único con varios anuncios asociados, o cada portal genera un registro independiente?
3. **Vendedor/anunciante**: ¿se captura esa información (particular vs. concesionario, nombre, contacto) o los portales no la exponen de forma confiable?
4. **Predicciones**: ¿qué granularidad tienen? (¿por marca+modelo? ¿por ciudad? ¿por periodo de tiempo?) ¿Se guardan como histórico o solo la más reciente?
5. **Historial de precios**: ¿interesa rastrear cambios de precio de un mismo anuncio en el tiempo, o solo el precio actual?
6. **Alcance del MER de prueba**: ¿modelamos todo el dominio completo, o arrancamos con un subconjunto (p. ej. solo "anuncio + vehículo + fuente") para probar la skill rápido y luego escalamos?
