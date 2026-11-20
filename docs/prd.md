---
documento: prd
proyecto: Plataforma inteligente para el análisis del mercado automotor colombiano
version: 0.1.0
fecha: 2026-11-06
estado: borrador
autores: [Equipo del proyecto (5 integrantes)]
---

# PRD · Plataforma inteligente para el análisis del mercado automotor colombiano

## Problema

Quien necesita consultar el mercado automotor colombiano tiene la información de vehículos y motocicletas dispersa en varios portales de compraventa. Cada portal presenta los anuncios con estructuras, atributos y niveles de detalle distintos, y hay anuncios con datos faltantes o duplicados que impiden comparaciones precisas.

Hoy, la persona visita cada portal, busca vehículos con características similares y contrasta a mano marca, modelo, año, kilometraje y ubicación. Tener acceso a muchos anuncios no equivale a tener información útil para decidir: la plataforma busca reunirlos y presentarlos de forma consolidada y comparable.

## Usuarios

- **Empleado** (usuario principal del MVP): persona de una empresa cuyo trabajo es consultar el mercado. Quiere buscar vehículos, ver su ficha y comparar anuncios. Uso recurrente; prioridad en celular, con el computador como segundo dispositivo.
- **Administrador**: quiere crear y gestionar las cuentas de los empleados. No gestiona portales, extracciones ni modelos.

Perfiles previstos para versiones futuras (no son parte del MVP): comprador particular, vendedor particular, comerciante de vehículos y analista del mercado automotor.

## Objetivos

- **O-01** El empleado busca anuncios con facilidad. *Se cumple si* el empleado encuentra un anuncio que cumple sus criterios de búsqueda en máximo 3 minutos.
- **O-02** El empleado consulta la información de un vehículo sin salir de la plataforma. *Se cumple si* el empleado puede abrir la ficha de un anuncio dentro de la plataforma.
- **O-03** El empleado compara anuncios. *Se cumple si* el empleado puede seleccionar entre 2 y 4 anuncios y consultarlos en una misma vista comparativa.
- **O-04** La consulta del mercado queda centralizada. *Se cumple si* la plataforma obtiene y muestra anuncios de 1 portal externo, de forma automática.
- **O-05** La información de los anuncios está organizada. *Se cumple si* el 100 % de los anuncios mostrados tiene una ficha estructurada con los atributos disponibles del vehículo y la información del publicador.
- **O-06** El administrador gestiona los empleados. *Se cumple si* el administrador puede crear una cuenta de empleado y comprobar que esa persona inicia sesión con ella.

## Alcance

### Incluye

- Obtención automática de anuncios desde un único portal externo.
- Visualización de los anuncios dentro de la plataforma.
- Búsqueda y filtrado de vehículos según los atributos disponibles.
- Ficha estructurada con la información del vehículo, el precio publicado y los datos del publicador.
- Comparación de varios anuncios en una misma vista.
- Inicio de sesión para empleados.
- Módulo exclusivo del administrador para crear y gestionar cuentas de empleados.

### No incluye

- Modelos predictivos de precios (por ejemplo, random forest o regresión lineal).
- Estimación automática del precio de los vehículos.
- Cálculo de precios de referencia, análisis de tendencias o comportamiento histórico del mercado.
- Seguimiento histórico de los cambios de precio de los anuncios.
- Integración simultánea con más de un portal externo.
- Administración manual de portales o de la obtención de anuncios desde el módulo del administrador.

Se dejan fuera para mantener un alcance viable según el tiempo disponible y las recomendaciones del profesor. Podrían considerarse en versiones posteriores.

## Restricciones

- Fecha de entrega: 30 de noviembre de 2026.
- Equipo: 5 integrantes.
- Una sola fuente externa de datos.
- Se guarda únicamente la información necesaria para el funcionamiento, respetando las condiciones de uso de la fuente y las disposiciones de protección de datos personales.
- No hay pruebas con usuarios: los perfiles y las funciones son una propuesta inicial.

## Preguntas abiertas

- Portal para el MVP: se propone Mercado Libre Colombia por contar con documentación oficial de acceso. La decisión depende de una prueba técnica que confirme el acceso a anuncios de vehículos, los campos disponibles y las condiciones de uso y almacenamiento.
- ¿Qué atributos concretos ofrece el portal elegido para filtrar? Lo determina la prueba técnica.
- ¿Qué datos del publicador se pueden mostrar y guardar según las condiciones de uso y la protección de datos personales?
- ¿Cada cuánto se obtienen los anuncios nuevos?
- ¿Se mantiene la vista comparativa? Una nota del equipo la condiciona a que siga en el alcance.
- ¿Cuáles son los nombres de los integrantes del equipo?
- ¿Se incluyen motocicletas además de vehículos en el MVP, o solo los tipos que ofrezca el portal elegido?

## Historial

- 0.1.0 · 2026-11-06 · Primera versión, escrita desde cero a partir de la entrevista al equipo.
