---
id: F-05
titulo: Ver la ficha de un anuncio
version: 0.1.1
fecha: 2026-11-06
estado: borrador
autores: [Equipo del proyecto]
requisitos: [RF-07, RF-08, RF-09, RF-10, RF-11]
depende_de: [F-04]
---

# F-05 · Ver la ficha de un anuncio

## Objetivo

El empleado consulta toda la información disponible de un vehículo, con su precio publicado y los datos de quien lo publica, sin salir de la plataforma.

## Flujo principal

1. El empleado elige un anuncio de la lista.
2. El sistema muestra la ficha con los atributos disponibles del vehículo y el precio publicado.
3. El sistema muestra los datos del publicador que estén disponibles.
4. El empleado vuelve a la lista con sus filtros intactos.

## Flujos alternos

- **A1 · Atributo ausente:** el atributo se muestra «No disponible».
- **A2 · Anuncio original:** el empleado pulsa «Ver anuncio original» y se abre el anuncio en el portal de origen.
- **A3 · Anuncio ya no disponible:** el sistema avisa y ofrece volver a la lista.

## Reglas

- Todas las fichas tienen los mismos campos, en el mismo orden.
- El precio se rotula «Precio publicado» y se muestra en COP; el kilometraje, en km.
- Un atributo ausente nunca se muestra como 0 ni como un valor supuesto.
- Los datos del publicador son solo los que el portal entrega y se pueden guardar.
- Deseable: la ficha se muestra en menos de 2 segundos con una conexión de 10 Mbps.

## Estados

- **Cargando:** indicador de carga en la ficha.
- **Vacío:** no aplica; si el anuncio no existe, se usa A3.
- **Error:** «No se pudo cargar el anuncio» con un botón para reintentar.

## Datos

- Ficha: tipo de vehículo, marca, modelo, año, kilometraje (km), ciudad, precio publicado (COP), datos del publicador, portal de origen, enlace al anuncio original.

## Criterios de aceptación

- **CA-1** Dado un anuncio en la lista, cuando el empleado lo elige, entonces ve su ficha con marca, modelo, año, kilometraje, ciudad y precio publicado.
- **CA-2** Dado un anuncio con precio, cuando abre la ficha, entonces ve «Precio publicado» seguido de la cifra en COP.
- **CA-3** Dado un anuncio con nombre de publicador, cuando abre la ficha, entonces ve el nombre del publicador.
- **CA-4** Dado un anuncio sin kilometraje, cuando abre la ficha, entonces ve «Kilometraje: No disponible» y no ve 0 km.
- **CA-5** Dado un anuncio sin datos del publicador, cuando abre la ficha, entonces ve «Publicador: No disponible».
- **CA-6** Dado una ficha abierta, cuando el empleado pulsa «Ver anuncio original», entonces se abre el anuncio en su portal de origen.
- **CA-7** Dado una ficha abierta desde una lista filtrada, cuando vuelve a la lista, entonces los filtros siguen activos.
- **CA-8** Dado un anuncio que ya no está disponible, cuando el empleado intenta abrirlo, entonces ve «Este anuncio ya no está disponible» y un botón para volver a la lista.
- **CA-9** Dado que falla la carga, cuando el empleado elige un anuncio, entonces ve «No se pudo cargar el anuncio» y un botón para reintentar.

## Fuera de alcance

- Contactar al publicador desde la plataforma.
- Guardar anuncios como favoritos.
- Mostrar fotos del anuncio.

## Preguntas abiertas

- ¿Qué datos del publicador se pueden mostrar?
- ¿La ficha debe incluir fotos del vehículo?
- ¿Cómo se sabe que un anuncio ya fue retirado del portal?

## Historial

- 0.1.1 · 2026-11-06 · El tiempo de respuesta queda como deseable, igual que su requisito.
- 0.1.0 · 2026-11-06 · Primera versión.
