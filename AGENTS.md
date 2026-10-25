# Instrucciones y Contexto Permanente del Proyecto — AGENTS.md

> **ATENCIÓN PARA EL AGENTE:** Lee este documento detenidamente antes de procesar cualquier solicitud o prompt en este repositorio. Define las reglas de negocio, directrices metodológicas y estándares técnicos del proyecto.

---

## 1. Identidad y Contexto del Proyecto

- **Curso / Programa:** Seminario en Ingeniería — Universidad Icesi.
- **Reto asignado:** **Reto 8 — Plataforma de análisis del mercado automotor colombiano**.
- **Objetivo del sistema:** Consolidar, limpiar, deduplicar y analizar datos de vehículos y motocicletas en venta en Colombia a partir de 5 fuentes predefinidas, para generar predicciones sobre el comportamiento del mercado automotor.
- **Metodología de diseño:** *Engineering Design Process* de Dieter & Schmidt (7 fases).
- **Sustento académico:** Revisión Sistemática de Literatura (SLR) sobre ~70 papers organizada en 3 preguntas de investigación (RQs).

---

## 2. Decisiones Arquitectónicas Clave (RQs)

| RQ | Capa / Problema | Decisión Técnica | Justificación Metodológica |
|---|---|---|---|
| **RQ1** | Integración de datos heterogéneos | Extracción ETL batch + mapeo de esquema por reglas (NextiaDI) + deduplicación (HierMatcher). | Se analizan 5 portales fijos y conocidos (OLX, TuCarro/MercadoLibre, VendeTuNave, MotoYa, Sergio Sierra Motos). |
| **RQ2** | Predicción del mercado | Análisis comparativo de algoritmos supervisados de predicción de precios y comportamiento automotor. | Estimación de rangos y tendencias por línea/modelo y período temporal. |
| **RQ3** | Almacenamiento de datos | Data Warehouse con **modelo relacional en Tercera Forma Normal (3FN)**. | Restricción obligatoria del entregable académico del curso; justificado teóricamente con la taxonomía de almacenamiento de Koukaras. |

---

## 3. Directrices Operativas Obligatorias para el Asistente

En **cada interacción y prompt**, el agente debe cumplir estrictamente con los siguientes principios:

### A. Consulta Previa de Contexto y Skills
1. Revisar siempre `docs/contexto-reto8-mer.md` y `docs/mercadoAutomotorMER-justificaciones-diseno.md` antes de proponer cambios estructurales o consultas SQL.
2. Seguir las especificaciones de modelado descritas en `.agents/skills/mer-svg/skill-MER-barker.md`.

### B. Estándares para el Modelo de Datos (MER)
1. **Notación Barker Obligatoria:** Estilo Oracle SQL Data Modeler.
   - Símbolo `#` para identificadores primarios (PK).
   - Símbolo `*` para atributos obligatorios no clave.
   - Símbolo `o` para atributos opcionales.
   - Sufijo `(FK)` para claves foráneas.
   - Cardinalidad en el extremo opuesto: pata de gallo (muchos), trazo perpendicular (uno), círculo (opcional).
2. **Cumplimiento Estricto de 3FN:**
   - **1FN:** Atomicidad total, sin campos multivaluados o concatenados.
   - **2FN:** Dependencia funcional completa de la PK (sin dependencias parciales en PKs compuestas).
   - **3FN:** Eliminación de dependencias transitivas (ej. marcas separadas de líneas; departamentos separados de ciudades).
3. **Nombres en Singular y Mayúsculas:** Entidades como `VEHICULO`, `ANUNCIO`, `PORTAL`, `VENDEDOR`.
4. **Trazabilidad Dual (Artefacto Gráfico + Justificación):** Nunca modificar el MER sin actualizar en sincronía:
   - El archivo vectorial SVG: `docs/mercadoAutomotorMER-barker.svg`.
   - El documento de defensa académica: `docs/mercadoAutomotorMER-justificaciones-diseno.md`.

### C. Enfoque de Sustentación Académica
- Todo atributo, entidad y relación debe tener una justificación formal ("¿por qué está modelado así?"), para defender las decisiones ante los docentes y evaluadores de la Universidad Icesi.
- Se debe mantener coherencia con la sección de Resultados y Discusión del paper.
