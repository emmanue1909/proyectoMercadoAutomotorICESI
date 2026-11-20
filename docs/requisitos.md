---
documento: requisitos
proyecto: Plataforma inteligente para el análisis del mercado automotor colombiano
version: 0.2.0
fecha: 2026-11-06
estado: borrador
basado_en: prd 0.1.0
---

# Requisitos · Plataforma inteligente para el análisis del mercado automotor colombiano

Cada requisito cita el objetivo del PRD que atiende. Las prioridades y los valores numéricos de los RNF son una propuesta para que el equipo los confirme (ver *Preguntas abiertas*).

## Funcionales

### O-01 · El empleado busca anuncios con facilidad

- **RF-01** El sistema debe permitir que el empleado busque anuncios escribiendo texto, por ejemplo una marca o un modelo. (O-01) *Debe*
- **RF-02** El sistema debe permitir que el empleado filtre los anuncios por marca, modelo y año. (O-01) *Debe*
- **RF-03** El sistema debe permitir que el empleado filtre los anuncios por un rango de precio publicado, en COP, y por un rango de kilometraje, en km. (O-01) *Debe*
- **RF-04** El sistema debe permitir que el empleado filtre los anuncios por ciudad. (O-01) *Debería*
- **RF-05** El sistema debe permitir que el empleado vea la lista de anuncios que cumplen la búsqueda y los filtros, con el total de resultados. (O-01) *Debe*
- **RF-06** El sistema debe permitir que el empleado quite un filtro o todos los filtros activos. (O-01) *Debería*

### O-02 · El empleado consulta la información de un vehículo sin salir de la plataforma

- **RF-07** El sistema debe permitir que el empleado abra la ficha de un anuncio desde la lista de resultados. (O-02) *Debe*
- **RF-08** El sistema debe mostrar en la ficha los atributos disponibles del vehículo y su precio publicado. (O-02) *Debe*
- **RF-09** El sistema debe mostrar en la ficha los datos del publicador que estén disponibles. (O-02) *Debe*
- **RF-10** El sistema debe mostrar «No disponible» cuando un atributo del anuncio no tiene valor, sin reemplazarlo por un valor supuesto. (O-02) *Debe*
- **RF-11** El sistema debe permitir que el empleado abra el anuncio original en su portal de origen desde la ficha. (O-02) *Podría*

### O-03 · El empleado compara anuncios

- **RF-12** El sistema debe permitir que el empleado seleccione entre 2 y 4 anuncios para compararlos. (O-03) *Debe*
- **RF-13** El sistema debe mostrar los anuncios seleccionados lado a lado en una misma vista comparativa, con los mismos atributos para todos. (O-03) *Debe*
- **RF-14** El sistema debe permitir que el empleado quite un anuncio de la comparación. (O-03) *Debería*

### O-04 · La consulta del mercado queda centralizada

- **RF-15** El sistema debe obtener anuncios del portal externo elegido de forma automática, sin intervención de ningún usuario. (O-04) *Debe*
- **RF-16** El sistema debe mostrar al empleado, dentro de la plataforma, los anuncios obtenidos del portal. (O-04) *Debe*
- **RF-26** El sistema debe mostrar una sola vez cada anuncio del portal, aunque se obtenga más de una vez, y actualizar sus datos en lugar de repetirlo. (O-04) *Debe*

### O-05 · La información de los anuncios está organizada

- **RF-17** El sistema debe organizar cada anuncio obtenido en una ficha con el mismo conjunto de atributos, sin importar cómo lo presente el portal. (O-05) *Debe*
- **RF-18** El sistema debe mostrar los precios en COP y los kilometrajes en km, con la unidad visible, en todos los anuncios. (O-05) *Debe*

### O-06 · El administrador gestiona los empleados

- **RF-19** El sistema debe permitir que el administrador cree una cuenta de empleado. (O-06) *Debe*
- **RF-20** El sistema debe permitir que el administrador vea la lista de las cuentas de empleados. (O-06) *Debería*
- **RF-21** El sistema debe permitir que el administrador edite los datos de una cuenta de empleado y la desactive. (O-06) *Debería*
- **RF-22** El sistema debe permitir que el empleado inicie sesión con la cuenta que le creó el administrador. (O-06) *Debe*
- **RF-23** El sistema debe permitir que el empleado cierre su sesión. (O-06) *Debería*
- **RF-24** El sistema debe permitir consultar los anuncios solo a quien haya iniciado sesión. (O-06) *Debe*
- **RF-25** El sistema debe impedir que un empleado acceda al módulo del administrador. (O-06) *Debe*

## No funcionales

- **RNF-01** El 100 % de los textos de la interfaz está en español (Colombia). (O-01, O-02, O-03, O-06) *Debe*
- **RNF-02** La plataforma se usa en celular y en computador, con prioridad en celular: funciona desde 360 px de ancho de pantalla y en las dos últimas versiones de Chrome, Safari, Firefox y Edge. (O-01, O-02, O-03, O-06) *Debe*
- **RNF-03** Tras buscar o cambiar un filtro, la lista se actualiza en menos de 3 segundos con una conexión de 10 Mbps. (O-01) *Debería*
- **RNF-04** La ficha de un anuncio se muestra en menos de 2 segundos con una conexión de 10 Mbps. (O-02) *Debería*
- **RNF-05** La vista comparativa de 4 anuncios se muestra en menos de 3 segundos con una conexión de 10 Mbps. (O-03) *Debería*
- **RNF-06** La primera pantalla que ve el empleado pesa menos de 2 MB al cargarse. (O-01) *Debería*
- **RNF-07** Los anuncios del portal se actualizan al menos una vez cada 24 horas. (O-04) *Debe*
- **RNF-08** La plataforma tiene disponibles al menos 1.000 anuncios del portal. (O-04) *Debería*
- **RNF-09** Un empleado encuentra un anuncio que cumple sus criterios en máximo 3 minutos, medido con al menos 5 personas en una prueba de uso. (O-01) *Debe*
- **RNF-10** El inicio de sesión toma menos de 3 segundos con una conexión de 10 Mbps. (O-06) *Debería*
- **RNF-11** Las contraseñas tienen mínimo 8 caracteres. (O-06) *Debe*
- **RNF-12** La sesión se cierra tras 30 minutos sin actividad. (O-06) *Podría*
- **RNF-13** Solo se guardan los datos del publicador que se muestran en la ficha del anuncio. (O-02, O-05) *Debe*

## Preguntas abiertas

- ¿Se confirman las prioridades propuestas? En particular, que la ciudad (RF-04), quitar filtros (RF-06) y la gestión avanzada de cuentas (RF-20, RF-21) sean *Debería*, y que el enlace al anuncio original (RF-11) y la expiración de sesión (RNF-12) sean *Podría*.
- ¿Se confirman los números propuestos? 2 a 4 anuncios por comparación viene del PRD; los demás los propuse yo: 3, 2 y 3 segundos, 10 Mbps, 2 MB, 24 horas, 1.000 anuncios, 8 caracteres, 30 minutos, 360 px y 5 personas de prueba.
- ¿Qué atributos reales entrega el portal elegido? De eso depende si se pueden filtrar año, kilometraje, ciudad y datos del publicador (RF-02 a RF-04, RF-09). Lo confirma la prueba técnica del PRD.
- ¿Cómo inicia sesión el empleado (correo y contraseña u otro medio) y quién define su contraseña inicial?
- ¿Debe existir más de un administrador, o uno solo?
- ¿Qué pasa con los anuncios que el portal retira? Los repetidos ya están cubiertos por RF-26; los retirados no tienen requisito.
- ¿Debe mostrarse la fecha de la última actualización de los anuncios? Tampoco está en el PRD; no agregué requisito.
- ¿Los vehículos incluyen motocicletas en el MVP? Depende del portal.

## Historial

- 0.2.0 · 2026-11-06 · Se agrega RF-26 (no repetir anuncios al volver a obtenerlos).
- 0.1.0 · 2026-11-06 · Primera versión, basada en el PRD 0.1.0.
