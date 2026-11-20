---
id: F-03
titulo: Obtener y organizar los anuncios del portal
version: 0.2.0
fecha: 2026-11-06
estado: borrador
autores: [Equipo del proyecto]
requisitos: [RF-15, RF-17, RF-26]
depende_de: []
---

# F-03 · Obtener y organizar los anuncios del portal

## Objetivo

Que la plataforma tenga siempre anuncios del portal externo elegido, obtenidos sin que ninguna persona los cargue, y organizados con la misma estructura para que el empleado los consulte.

## Flujo principal

1. El sistema consulta automáticamente el portal externo y obtiene sus anuncios de vehículos.
2. El sistema organiza cada anuncio en una ficha con el mismo conjunto de atributos, sin importar cómo lo presente el portal.
3. Si un atributo no viene en el anuncio, el sistema lo deja como ausente.
4. Si el anuncio ya había sido obtenido antes, el sistema actualiza sus datos en lugar de agregarlo otra vez.
5. Los anuncios organizados quedan disponibles para que los empleados los busquen (ver F-04).
6. El sistema repite el proceso al menos una vez cada 24 horas.

## Flujos alternos

- **A1 · El portal no responde:** el sistema conserva los anuncios ya obtenidos, reintenta en la siguiente ejecución y no muestra anuncios incompletos.
- **A2 · Anuncio con atributos ausentes:** el anuncio se organiza igual y los atributos sin valor quedan como ausentes.
- **A3 · Anuncio ya obtenido:** el anuncio no se repite; su precio y sus demás datos se actualizan con los más recientes.

## Reglas

- La obtención no la inicia ni la detiene ningún usuario; ni el administrador ni el empleado la ejecutan a mano.
- Todos los anuncios tienen los mismos atributos de ficha: tipo de vehículo, marca, modelo, año, kilometraje (km), ciudad, precio publicado (COP) y datos del publicador.
- Un atributo sin valor queda ausente; nunca se reemplaza por 0 ni por un valor supuesto.
- Del publicador solo se guardan los datos que se muestran en la ficha.
- Cada anuncio conserva su portal de origen, su identificador en ese portal y la fecha en que se obtuvo.
- Un anuncio que ya fue obtenido se muestra una sola vez; al volver a obtenerlo se actualizan sus datos.
- Deseable: la plataforma tiene al menos 1.000 anuncios disponibles del portal.

## Estados

- **Cargando:** no aplica al usuario; la obtención ocurre sin que nadie la vea.
- **Vacío:** si aún no se ha obtenido ningún anuncio, el empleado ve «Aún no hay anuncios disponibles».
- **Error:** si la obtención falla, el empleado sigue viendo los anuncios anteriores.

## Datos

- Anuncio: tipo de vehículo, marca, modelo, año, kilometraje (km), ciudad, precio publicado (COP), datos del publicador, portal de origen, identificador en el portal, fecha de obtención.

## Criterios de aceptación

- **CA-1** Dado que el portal publicó un anuncio nuevo, cuando pasan 24 horas, entonces el empleado lo encuentra buscando su marca y modelo.
- **CA-2** Dado un anuncio del portal con marca, modelo y año, cuando el sistema lo organiza, entonces su ficha muestra esos tres atributos con las mismas etiquetas que cualquier otra ficha.
- **CA-3** Dado un anuncio del portal sin kilometraje, cuando el sistema lo organiza, entonces su kilometraje queda ausente y no vale 0.
- **CA-4** Dado que el portal no responde, cuando el sistema intenta obtener anuncios, entonces los empleados siguen viendo los anuncios anteriores.
- **CA-5** (Deseable) Dado que se obtuvieron los anuncios, cuando el empleado abre la búsqueda sin filtros, entonces el total de resultados es de al menos 1.000.
- **CA-6** Dado que aún no se obtuvo ningún anuncio, cuando un empleado abre la búsqueda, entonces ve «Aún no hay anuncios disponibles».
- **CA-7** Dado que el portal entrega un dato del publicador que la ficha no incluye, cuando el empleado abre la ficha, entonces ese dato no aparece.
- **CA-8** Dado un anuncio ya obtenido cuyo precio cambió en el portal, cuando el sistema lo obtiene de nuevo, entonces la lista muestra un solo anuncio, con el precio publicado nuevo.

## Fuera de alcance

- Obtener anuncios de más de un portal.
- Que el administrador ejecute o configure la obtención.
- Guardar el historial de cambios de precio.

## Preguntas abiertas

- ¿Qué portal se usa? Lo confirma la prueba técnica del PRD.
- ¿Qué atributos entrega realmente el portal y cuáles datos del publicador se pueden guardar?
- ¿Qué pasa con los anuncios que el portal retira?

## Historial

- 0.2.0 · 2026-11-06 · Se agrega que un anuncio ya obtenido no se repite (RF-26), con el identificador del portal, y se pasa a visibles los criterios CA-1, CA-5 y CA-7; el mínimo de 1.000 anuncios queda como deseable.
- 0.1.0 · 2026-11-06 · Primera versión.
