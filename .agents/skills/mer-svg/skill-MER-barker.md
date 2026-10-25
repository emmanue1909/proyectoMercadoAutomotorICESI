---
name: diagrama-mer
description: Genera diagramas Modelo Entidad-Relación (MER) en notación Barker (estilo Oracle Data Modeler), normalizados hasta Tercera Forma Normal (3FN), como imagen SVG con justificación académica de las decisiones de modelado. Úsala cada vez que el usuario pida crear, dibujar, diseñar o revisar un MER, un modelo entidad-relación, un diagrama de base de datos, o cuando describa entidades y relaciones de un dominio y espere un diagrama como resultado — incluso si no menciona "MER" explícitamente (p. ej. "necesito modelar la base de datos de un sistema de pedidos", "ayúdame con las entidades de mi proyecto"). También aplica cuando el usuario pida revisar o corregir un MER existente, verificar que esté en 3FN, o traducir un MER a notación Barker.
---

# Diagrama MER (notación Barker, hasta 3FN)

Esta skill construye diagramas Entidad-Relación pensados para un contexto académico: no solo deben verse bien, deben poder **defenderse** — cada entidad, atributo y relación debe tener una razón de ser que el usuario pueda explicar si un profesor o un revisor pregunta "¿por qué modelaste esto así?". Estas razones o desiciones de diseño deben ser generadas en un .dm aparte y el nombre del documento .md debe ser llamado de la forma nombreProyectoMER-justificaciones-diseño, este documento .md lo vas a ubicar en la documentacion del proyecto, en la raiz de esa carpeta, de la forma ~/doc/aqui lo ubicas, el nombre doc, puede ser escrito de diversas formas, lo importante es que sea generado en una carpeta con nombre relacionado a la documentacion, si no la hay, pregunta en que apartado del proyecto guardar el MER y la justificacion.

El resultado final es una imagen SVG en notación Barker (la misma lógica visual que usa Oracle SQL Data Modeler) más un breve documento de justificación. Nunca entregues solo el dibujo: el razonamiento detrás de las entidades y la normalización es tan parte del entregable como el gráfico.

## Flujo de trabajo

Sigue estos pasos en orden. No saltes a dibujar antes de tener claro el modelo lógico — un MER bonito pero mal normalizado es peor que uno feo pero correcto.

### 1. Entender el dominio

Antes de modelar, identifica:
- **El proceso de negocio o fenómeno que se quiere representar** (p. ej. "mercado automotor colombiano", "sistema de pedidos de una tienda").
- **Las reglas de negocio explícitas** que el usuario haya dado (un cliente puede tener varios pedidos, un pedido pertenece a un solo cliente, etc.).

Si el usuario solo da una descripción vaga del dominio sin reglas de negocio claras, pregunta por las reglas mínimas necesarias (cardinalidad y obligatoriedad de las relaciones clave) antes de modelar — inventar reglas de negocio es la forma más común de que un MER quede mal, y es difícil de corregir después sin rehacer el diagrama.

### 2. Definir entidades y atributos

Para cada entidad:
- Nombre en **singular** (ENTIDAD, no ENTIDADES) — es la convención estándar en Barker y la que espera un revisor académico.
- Lista de atributos, distinguiendo:
  - **Identificador primario (PK)**: uno o más atributos que identifican de forma única cada instancia.
  - **Atributos obligatorios**: siempre tienen valor.
  - **Atributos opcionales**: pueden quedar vacíos.
- No incluyas atributos derivados (calculables a partir de otros) salvo que el usuario los pida explícitamente — es una fuente común de violaciones de 3FN y de preguntas incómodas en una sustentación.

### 3. Normalizar hasta 3FN

Antes de dibujar, revisa mentalmente cada entidad contra las tres formas normales, y si encuentras una violación, corrígela separando la entidad en lugar de dejarla y solo anotarla:

- **1FN**: cada atributo es atómico (sin listas ni grupos repetidos dentro de un mismo campo) y no hay atributos multivaluados.
- **2FN**: si la PK es compuesta, todo atributo no clave depende de la **PK completa**, no de una parte de ella. Una dependencia parcial normalmente señala que falta una entidad intermedia.
- **3FN**: ningún atributo no clave depende de otro atributo no clave (dependencia transitiva). Si un atributo describe a otro atributo y no directamente a la PK, probablemente pertenece a una entidad propia.

Cuando una violación te lleve a crear una entidad nueva, documenta por qué (esto alimenta el paso 5).

### 4. Definir las relaciones en notación Barker

Para cada relación entre dos entidades, define en ambos sentidos:
- **Cardinalidad**: uno (uno y solo uno) o muchos (uno o más).
- **Opcionalidad**: obligatoria (debe existir) u opcional (puede no existir).
- **Verbo o frase** que describe la relación en cada sentido (p. ej. "un CLIENTE realiza uno o más PEDIDOS" / "un PEDIDO pertenece a uno y solo un CLIENTE").

La notación Barker se lee en el extremo **opuesto** a la entidad desde la que empiezas: el símbolo junto a la entidad B describe cuántas B se relacionan con una A.

Símbolos a usar en el SVG:

| Símbolo visual | Significado |
|---|---|
| Línea que termina en "pata de gallo" (tres ramales) | Muchos |
| Línea que termina en un solo trazo perpendicular | Uno (y solo uno) |
| Círculo sobre la línea, antes del símbolo de cardinalidad | Opcional |
| Trazo perpendicular sobre la línea, sin círculo | Obligatorio |

Para relaciones muchos-a-muchos, resuélvelas en una entidad asociativa (intersección) con los atributos propios de la relación, salvo que el usuario pida explícitamente dejarla sin resolver.

### 5. Dibujar el SVG

Carga la guía de diseño de artifacts/diagramas disponible en la sesión antes de escribir el SVG, y luego usa el tool de artifacts para publicarlo. Reglas visuales, inspiradas en el estilo de Oracle SQL Data Modeler:

- **Entidad**: rectángulo de esquinas suavemente redondeadas.
  - Encabezado: nombre de la entidad en mayúsculas, centrado, fondo ligeramente más oscuro que el cuerpo, separado del resto por una línea horizontal.
  - Cuerpo: lista de atributos, uno por fila.
    - Atributos que forman parte de la PK van **arriba**, separados del resto por una línea horizontal, con `#` antes del nombre.
    - Atributos obligatorios (no PK): marcados con `*`.
    - Atributos opcionales: marcados con `o`.
    - Claves foráneas (FK) se marcan con `(FK)` después del nombre, incluso si también son parte de la PK de esa entidad.
- **Relación**: línea recta o en ángulo recto entre los rectángulos (evita que las líneas crucen entidades), con los símbolos de cardinalidad/opcionalidad del paso 4 en cada extremo. Si el verbo de la relación no es obvio por el nombre de las entidades, inclúyelo como etiqueta pequeña sobre la línea.
- **Paleta**: colores neutros (grises/azules suaves) — el objetivo es que se vea como una herramienta de modelado profesional, no un diagrama decorativo. Evita colores saturados o decorativos que distraigan de la estructura.
- **Legibilidad primero**: si el modelo tiene muchas entidades, prioriza que no se superpongan sobre que quede compacto; un MER que no se puede leer no sirve aunque esté bien modelado.

### 6. Entregar la justificación

Junto con el SVG, entrega un resumen breve (no un ensayo) que cubra:
- Por qué cada entidad existe (qué representa en el dominio).
- Cualquier decisión de normalización que no sea obvia a simple vista (p. ej. "se separó DIRECCIÓN de CLIENTE porque un cliente puede tener varias direcciones, lo que violaría 1FN si quedara como atributo multivaluado").
- Supuestos de negocio que asumiste si el usuario no los dio explícitamente, para que los pueda confirmar o corregir.

Este resumen es lo que le permite al usuario sustentar el diagrama sin tener que reconstruir el razonamiento desde cero.

## Errores comunes a evitar

- Dibujar la cardinalidad "al revés" (el símbolo junto a B describe a B, no a A) — es el error más frecuente al usar Barker por primera vez.
- Dejar una relación muchos-a-muchos sin resolver en una entidad asociativa sin que el usuario lo haya pedido así.
- Agregar atributos derivados o redundantes "por si acaso" — cada atributo debe justificarse.
- Entregar el diagrama sin la justificación de las decisiones de modelado.
