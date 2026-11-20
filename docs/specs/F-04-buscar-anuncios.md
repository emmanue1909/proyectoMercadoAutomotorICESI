---
id: F-04
titulo: Buscar y filtrar anuncios
version: 0.1.1
fecha: 2026-11-06
estado: borrador
autores: [Equipo del proyecto]
requisitos: [RF-01, RF-02, RF-03, RF-04, RF-05, RF-06, RF-16, RF-18]
depende_de: [F-01, F-03]
---

# F-04 · Buscar y filtrar anuncios

## Objetivo

El empleado encuentra en la plataforma los anuncios que cumplen sus criterios, en máximo 3 minutos, sin visitar el portal.

## Flujo principal

1. El empleado inicia sesión y ve la lista de anuncios con el total.
2. Escribe un texto en el buscador, por ejemplo una marca o un modelo.
3. Elige filtros: marca, modelo, año, rango de precio publicado (COP), rango de kilometraje (km) y ciudad.
4. El sistema actualiza la lista y el total, y muestra los filtros activos.
5. El empleado elige un anuncio de la lista para ver su ficha (ver F-05) o lo marca para compararlo (ver F-06).

## Flujos alternos

- **A1 · Sin resultados:** ningún anuncio cumple la búsqueda; el sistema lo dice y ofrece quitar los filtros.
- **A2 · Quitar filtros:** el empleado quita un filtro o todos y la lista vuelve a ampliarse.
- **A3 · Rango inválido:** el valor inicial del rango es mayor que el final; el sistema avisa y no aplica el rango.

## Reglas

- Búsqueda y filtros se combinan: un anuncio aparece solo si cumple todos los activos.
- Los modelos que se ofrecen son solo los de la marca elegida.
- Los precios se muestran en COP y los kilometrajes en km, con la unidad visible.
- Un anuncio sin valor en el atributo filtrado no aparece en ese filtro.
- En la lista, el atributo sin valor se muestra «No disponible».
- Los filtros activos están siempre visibles.
- Deseable: la lista se actualiza en menos de 3 segundos con una conexión de 10 Mbps.
- Los filtros disponibles dependen de los atributos que entregue el portal.

## Estados

- **Cargando:** la lista muestra un indicador de carga.
- **Vacío:** «No hay anuncios con estos filtros» y la opción de quitarlos; si aún no hay anuncios, «Aún no hay anuncios disponibles».
- **Error:** «No se pudieron cargar los anuncios» con un botón para reintentar; búsqueda y filtros se conservan.

## Datos

- Anuncio en la lista: marca, modelo, año, kilometraje (km), ciudad, precio publicado (COP).

## Criterios de aceptación

- **CA-1** Dado un empleado con sesión iniciada, cuando abre la búsqueda, entonces ve la lista de anuncios y el total de resultados.
- **CA-2** Dado que escribe «Mazda», cuando termina de escribir, entonces cada anuncio listado es de esa marca y el total refleja ese número.
- **CA-3** Dado que elige la marca «Renault», cuando abre el filtro de modelo, entonces ve solo modelos de Renault.
- **CA-4** Dado que fija años de 2018 a 2022 y ciudad «Cali», cuando se actualiza la lista, entonces cada anuncio es de Cali y de un año entre 2018 y 2022.
- **CA-5** Dado que fija un precio de 30.000.000 a 50.000.000 COP, cuando se actualiza la lista, entonces cada precio publicado está en ese rango y se lee con «COP».
- **CA-6** Dado que fija kilometraje de 0 a 50.000 km, cuando se actualiza la lista, entonces ningún anuncio supera 50.000 km y el kilometraje se lee con «km».
- **CA-7** Dado un anuncio sin año, cuando aparece en la lista sin filtro de año, entonces su año dice «No disponible».
- **CA-8** Dado un anuncio sin año, cuando el empleado filtra por 2018 a 2022, entonces ese anuncio no aparece.
- **CA-9** Dado que ningún anuncio cumple los filtros, cuando se actualiza la lista, entonces ve «No hay anuncios con estos filtros» y la opción de quitarlos.
- **CA-10** Dado dos filtros activos, cuando quita uno, entonces la lista se amplía y el otro filtro sigue visible.
- **CA-11** Dado un año inicial de 2022 y uno final de 2018, cuando intenta aplicar el rango, entonces ve «El rango no es válido» y la lista no cambia.
- **CA-12** Dado que falla la carga, cuando cambia un filtro, entonces ve «No se pudieron cargar los anuncios», un botón para reintentar y sus filtros intactos.

## Fuera de alcance

- Ordenar los resultados.
- Guardar búsquedas.
- Búsqueda por atributos que el portal no entregue.

## Preguntas abiertas

- ¿Se puede elegir más de una marca o ciudad a la vez?
- ¿Cuántos anuncios se muestran por página?
- ¿Los filtros de ciudad y kilometraje existen en el portal elegido?
- ¿Se incluyen motocicletas en el MVP?

## Historial

- 0.1.1 · 2026-11-06 · El tiempo de respuesta queda como deseable, igual que su requisito.
- 0.1.0 · 2026-11-06 · Primera versión.
