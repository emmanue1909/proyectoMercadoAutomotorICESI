---
id: F-06
titulo: Comparar anuncios
version: 0.1.1
fecha: 2026-11-06
estado: borrador
autores: [Equipo del proyecto]
requisitos: [RF-12, RF-13, RF-14]
depende_de: [F-04, F-05]
---

# F-06 · Comparar anuncios

## Objetivo

El empleado pone lado a lado entre 2 y 4 anuncios y contrasta sus atributos y precios en una misma vista.

## Flujo principal

1. El empleado marca anuncios en la lista para compararlos.
2. Pulsa «Comparar».
3. El sistema muestra una vista con una columna por anuncio y una fila por atributo.
4. Cada atributo sin valor se muestra «No disponible».
5. El empleado vuelve a la lista con sus filtros intactos.

## Flujos alternos

- **A1 · Un solo anuncio marcado:** «Comparar» no se activa y el sistema indica que se necesitan al menos 2.
- **A2 · Quinto anuncio:** el sistema avisa que el máximo es 4 y no lo agrega.
- **A3 · Quitar un anuncio:** el empleado quita una columna; si quedan menos de 2 anuncios, vuelve a la lista.

## Reglas

- Se comparan mínimo 2 y máximo 4 anuncios.
- Todos los anuncios muestran las mismas filas: tipo de vehículo, marca, modelo, año, kilometraje (km), ciudad, precio publicado (COP) y datos del publicador.
- El precio se rotula «Precio publicado».
- Un atributo ausente se muestra «No disponible», nunca 0 ni un valor supuesto.
- Deseable: la vista de 4 anuncios se muestra en menos de 3 segundos con una conexión de 10 Mbps.

## Estados

- **Cargando:** indicador de carga en la vista.
- **Vacío:** si no hay anuncios marcados, «Marca al menos 2 anuncios para compararlos».
- **Error:** «No se pudo armar la comparación» con un botón para reintentar; los anuncios marcados se conservan.

## Datos

- Los atributos de ficha listados en las reglas.

## Criterios de aceptación

- **CA-1** Dado un solo anuncio marcado, cuando el empleado mira «Comparar», entonces está desactivado y ve «Marca al menos 2 anuncios».
- **CA-2** Dado dos anuncios marcados, cuando pulsa «Comparar», entonces ve una vista de dos columnas con las mismas filas.
- **CA-3** Dado cuatro anuncios marcados, cuando pulsa «Comparar», entonces ve cuatro columnas con las mismas filas.
- **CA-4** Dado cuatro anuncios marcados, cuando intenta marcar un quinto, entonces ve «Puedes comparar hasta 4 anuncios» y el quinto no se agrega.
- **CA-5** Dado dos anuncios con precios publicados distintos, cuando los compara, entonces cada precio aparece en COP bajo «Precio publicado».
- **CA-6** Dado un anuncio sin año, cuando se compara, entonces su celda de año dice «No disponible».
- **CA-7** Dado una comparación de tres anuncios, cuando quita uno, entonces la vista queda con dos columnas.
- **CA-8** Dado una comparación de dos anuncios, cuando quita uno, entonces vuelve a la lista con el otro aún marcado.
- **CA-9** Dado que falla la comparación, cuando pulsa «Comparar», entonces ve «No se pudo armar la comparación», un botón para reintentar y sus anuncios aún marcados.

## Fuera de alcance

- Guardar o compartir una comparación.
- Resaltar cuál anuncio es mejor.
- Comparar más de 4 anuncios.

## Preguntas abiertas

- ¿Se mantiene la vista comparativa en el alcance? Una nota del equipo la condiciona.
- ¿Se pueden comparar vehículos de tipos distintos en la misma vista?

## Historial

- 0.1.1 · 2026-11-06 · El tiempo de respuesta queda como deseable, igual que su requisito.
- 0.1.0 · 2026-11-06 · Primera versión.
