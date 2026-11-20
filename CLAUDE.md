# CLAUDE.md

Guía para Claude Code en este repositorio. Fuente: el documento `Statement_y_solucion_enfoque_usuario_experiencia (1).docx` (problema y propuesta) y los documentos de `docs/`. El alcance del MVP lo fija `docs/prd.md`; si este archivo y los documentos difieren, prevalecen los documentos y se avisa al usuario.

## Qué es la app

**Plataforma inteligente para el análisis del mercado automotor colombiano** (proyecto de seminario).

Plataforma web que integra anuncios de vehículos y motocicletas de portales colombianos de compraventa (Mercado Libre, TuCarro, VendeTuNave, MotoYa y otros), los unifica bajo una estructura común y facilita su consulta. El problema: la información está dispersa en varios portales, con estructuras distintas y datos faltantes o duplicados, y tener muchos anuncios no equivale a tener información útil para decidir.

**MVP (primera versión, entrega el 30 de noviembre de 2026, equipo de 5):**

- Dos perfiles: **empleado** (usuario principal: busca, filtra, ve fichas y compara anuncios; prioridad en celular) y **administrador** (crea y gestiona cuentas de empleados; no gestiona portales, extracciones ni modelos).
- Obtención automática de anuncios de **un solo portal externo** (propuesto: Mercado Libre Colombia, sujeto a una prueba técnica de acceso, campos y condiciones de uso).
- Búsqueda y filtros, ficha del anuncio (con precio publicado y datos del publicador), comparación de 2 a 4 anuncios, inicio de sesión.
- **Fuera del MVP:** modelos de machine learning, estimación de precios, precios de referencia y tendencias, histórico de precios, varios portales a la vez.
- Perfiles futuros (no del MVP): comprador, vendedor, comerciante y analista.

## Estado actual del repositorio

- Contiene el docx, `docs/` y `.agents/skills/`. Todavía no hay código, dependencias, scripts ni tests. No hay repositorio git.
- No existen comandos de build, test ni lint.
- El stack propuesto (Flutter + `supabase_flutter`; Supabase con Auth, Postgres/PostgREST y Storage) está en `docs/architectural_spine.md`. Es el del curso y sigue pendiente de confirmar: no agregues paquetes ni servicios sin preguntar.
- Actualiza este archivo cuando se tomen decisiones técnicas o se agregue código (comandos, estructura de carpetas, convenciones reales).

## Estructura actual de `lib/`

`lib/` **todavía no existe**: el repositorio aún no tiene código. Cuando se cree, documentar aquí su estructura real (carpetas y responsabilidad de cada una), sin adelantarla.

## Documentos

`docs/` contiene el PRD, los requisitos, la spine y las specs:

- `docs/prd.md`: PRD (problema, usuarios, objetivos O-01…O-06, alcance).
- `docs/requisitos.md`: requisitos funcionales (RF) y no funcionales (RNF), cada uno ligado a un objetivo, con prioridad.
- `docs/architectural_spine.md`: spine de arquitectura (invariantes AD-01…AD-09).
- `docs/specs/`: specs funcionales (F-01…F-06), con su `README.md` de índice y el `reporte.md` de la crítica.

Todos están en estado `borrador`. Se generan y actualizan con las skills de `.agents/skills/` (`sdd-prd`, `sdd-requisitos`, `sdd-arquitectura`, `sdd-specs`, `sdd-critica`), en ese orden. Reglas: los ids no se renumeran ni se reusan; al cambiar un documento se sube su versión y se anota en *Historial*; requisitos y specs no nombran tecnología; lo que no se sepa va en *Preguntas abiertas*.

## Convenciones

- Interfaz y textos en **español (Colombia)**; precios en **COP** y kilometraje en **km**, con la unidad visible.
- Un atributo sin valor se muestra «No disponible», nunca 0 ni un valor supuesto.
- Hay que distinguir siempre el **precio publicado** del anuncio (no hay estimaciones en el MVP).
- No hay registro libre: las cuentas las crea el administrador.
- Cada anuncio conserva su portal de origen, su identificador en el portal y la fecha de obtención; un anuncio obtenido de nuevo se actualiza, no se repite.
- Mantén separadas las capas (obtención de anuncios, datos, servicios de la app, pantallas) y probables por separado.

## Advertencias

- Los perfiles y funciones son una propuesta; no hay pruebas con usuarios. No los presentes como hallazgos.
- Antes de implementar la obtención de anuncios, confirma el portal, el método de acceso y sus términos de uso, y qué datos del publicador se pueden mostrar y guardar (protección de datos personales).
- Quedan abiertas, entre otras: cómo crea el administrador las cuentas sin exponer la secret key, la seguridad por filas (no se usa en el curso), si hay fotos de perfil y si el MVP incluye motos. Pregúntalas, no las inventes.
- Los datos bibliográficos del docx (Putrama y Martinek 2024, Sun y Shen 2022, Fayyaz et al. 2025, Cui et al. 2022, Domínguez et al. 2024) deben verificarse en las fuentes originales antes de una entrega académica; no completes DOI, revista ni páginas.
