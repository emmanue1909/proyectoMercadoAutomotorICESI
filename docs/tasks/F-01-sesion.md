---
documento: tareas
id: F-01
titulo: Autenticación y control de sesión
proyecto: Plataforma inteligente para el análisis del mercado automotor colombiano
version: 0.1.0
fecha: 2026-11-26
estado: borrador
autores: [Juan Diego Dominguez (P2)]
basado_en: [plan F-01 0.1.0, requisitos 0.2.0, F-01 0.1.1, F-02 0.1.0, reparto-trabajo]
---

# Tareas · F-01 · Autenticación y control de sesión

Plan: [`docs/plans/F-01-sesion.md`](../plans/F-01-sesion.md). Allí están los criterios CP y las decisiones D-1 a D-12.

## Cómo leer las tareas

- **Responsable de todas: P2.** Cuando otra persona interviene, mi parte y la integración están en tareas separadas.
- **Prioridad oficial:** la de `requisitos.md` (Debe, Debería, Podría). «Sin prioridad oficial» significa que no hay requisito.
- **En la entrega:** Obligatoria u Opcional, según el reparto. Una tarea bloqueada sigue siendo obligatoria.
- **Estados:** pendiente, en curso, hecha.
- Las rutas de código son relativas a `Prototipo_Vehiculos_V2/automarket_v2/`.
- **Rama:** todo se trabaja en `feature/p2-auth`. Nunca se modifica ni se hace commit directamente en `main`.
- **Commits.** C1 a C4 parten de los sugeridos por el reparto. Como el reparto fija un mínimo y no un máximo, lo que depende de otros va en commits propios para no frenar ni mezclar C2 y C3. C2 no dice «login real» porque se puede hacer antes de que exista Supabase: el login real llega con CS.

| Commit | Responsabilidad | Archivos | Tareas |
| --- | --- | --- | --- |
| C1 `docs: plan/tasks de sesión (F-01)` | Este plan y estas tareas | `docs/plans/`, `docs/tasks/` | — |
| C2 `feat: AuthService, login y cierre de sesión` | **Autenticarse y cerrar sesión:** operaciones del servicio y formulario | `auth_service.dart` (`AuthService`, `AuthBackend`, errores, validación de la fila, `cerrarSesion`), `login_page.dart`, `login_screen.dart`, falso y pruebas de ambos | 02, 03, 05 (parte del servicio) |
| C3 `feat: control de sesión y de rol` | **Qué se muestra según la sesión y el rol**, incluida la recuperación al arrancar | `app_gate.dart` (`AppGate`, `GuardiaRol`, reacción al cierre), lógica de recuperación en `auth_service.dart`, sus pruebas | 04, 05 (parte de `AppGate`), 06 |
| CM `feat: AppGate como pantalla inicial` | Conectar la app | `main.dart`, prueba 1 de `widget_test.dart` y lo que defina D-12 | 09 |
| CS `feat: backend de Supabase Auth` | Autenticación real, cuando P1 entregue | `auth_service.dart` | 08; correcciones de 10 en un commit `fix:` aparte |
| CL `feat: cierre de sesión en las screens` | Solo con la opción b de D-10 | `admin_screen.dart`, `employee_screen.dart` | 11 |
| C4 `docs: README y actualización de CLAUDE.md` | Al final, fuera de estas tareas | `README.md`, `CLAUDE.md` | — |

  - C2 no toca `app_gate.dart` ni `main.dart`. C3 no cambia el formulario de login ni `cerrarSesion`.
  - Las pruebas van en el mismo commit que el código que prueban.
  - C2, C3 y CM llegan juntos a `main`. En los commits intermedios de la rama, el login todavía no lleva a otra pantalla y la prueba 1 falla.

## Resumen

| ID | Tarea | Grupo | Depende de | Prioridad oficial | Estado |
| --- | --- | --- | --- | --- | --- |
| T-F01-01 | Preparación y acuerdos | A | — | Sin prioridad oficial | pendiente |
| T-F01-02 | `AuthService` y backend falso | A | 01 | Debe | pendiente |
| T-F01-03 | Pantalla de login | A | 02 | Debe | pendiente |
| T-F01-04 | Control de sesión y de rol | A | 02, 03 | Debe | pendiente |
| T-F01-05 | Cierre de sesión: parte de P2 | A | 04 | Debería | pendiente |
| T-F01-06 | Persistencia: parte de P2 | A | 04 | Sin prioridad oficial | pendiente |
| T-F01-07 | Pruebas con backend falso | A | 03, 04, 05, 06 | Debe | pendiente |
| T-F01-08 | Backend de Supabase Auth | B | 02, P1, D-1 | Debe | pendiente |
| T-F01-09 | `AppGate` en `main.dart` y prueba 1 | B | 04, 07, D-10, D-12 | Debe | pendiente |
| T-F01-10 | Persistencia real | B | 06, 08, 09, P1 | Sin prioridad oficial | pendiente |
| T-F01-11 | Cierre de sesión integrado | B | 05, 08, 09, P3, P4 | Debería | pendiente |
| T-F01-12 | Verificación final | B | 10, 11, P3 | Debe | pendiente |
| T-F01-13 | Cierre por inactividad | C | 12, D-9 | Podría | pendiente |

Orden: 01 → 02 → 03 → 04 → 05 y 06 → 07 → 08 → 09 → 10 y 11 → 12. La 13 solo si el equipo la aprueba. Si P1 se retrasa, 09 se adelanta a 08 (no depende de P1), pero no se integra a `main` sin 08, porque nadie podría entrar. La parte del servicio de 05 (C2) se puede hacer después de 02, sin esperar a 04.

## Cómo avanzar con el backend falso, antes de P1

`AppGate` se implementa, se integra con `AuthService` y el login, y se prueba sin Supabase, sin P1 y **sin tocar `main.dart`**:

1. La prueba crea el servicio con el constructor `@visibleForTesting` y un backend falso de `test/auth/`.
2. Monta `MaterialApp(home: AppGate(...))` y le entrega ese servicio por constructor. `AppGate` se lo pasa a `LoginScreen`, para que ambos usen la misma instancia.
3. El falso controla cada escenario: sin sesión, empleado, administrador, cuenta desactivada, sin fila, sin conexión, sesión recuperable y respuesta demorada (para ver la carga).
4. Las pantallas de empleado y administrador se sustituyen por constructor con pantallas de prueba.
5. Así se recorren juntos: login → pantalla según rol → cierre con `cerrarSesion()` llamado desde la prueba → login, y también la recuperación al arrancar.

Para verlo a mano se puede usar, opcionalmente, un punto de entrada en `test/auth/main_falso.dart` que haga el mismo montaje, con `flutter run -d chrome -t test/auth/main_falso.dart`. **No se ha probado** que ese comando funcione en este proyecto; si no funciona, bastan las pruebas de widget. El falso nunca se copia a `lib/` ni se usa por defecto.

Con esto se pueden terminar 02 a 07. No demuestra el login real, la persistencia real ni el cierre desde las screens de P3 y P4: eso es 08, 10 y 11.

---

## A. Obligatorias que no necesitan código de otros

### T-F01-01 · Preparación y acuerdos

- **Descripción:** confirmar la rama de trabajo y plantear al grupo lo que afecta a otros. Esperar las respuestas no frena T-F01-02 a 06.
- **Archivos:** ninguno de código.
- **Dependencias:** ninguna.
- **Prioridad oficial:** sin prioridad oficial. **En la entrega:** obligatoria. **Commit:** ninguno. **Estado:** pendiente.
- **Criterios de aceptación:**
  - [ ] La rama activa es `feature/p2-auth` antes de cualquier commit.
  - [ ] C1 está en la rama antes del primer commit de código.
  - [ ] El grupo recibió las firmas propuestas de `AuthService`, incluida la adición `cambiosSesion`.
  - [ ] Se planteó la representación de roles (D-1) y las decisiones D-2 y D-3.
  - [ ] P3 y P4 conocen el riesgo de quedar atascado al cerrar sesión y las opciones a y b (D-10).
  - [ ] Se preguntó quién actualiza `widget_test.dart` (D-10).
  - [ ] Se planteó cómo hacer visible `AppGate` en `main.dart` (D-12).
  - [ ] P1 recibió la lista de dependencias, incluida la cuenta de prueba desactivada.
  - [ ] Se preguntó la fecha de la entrega (D-11).

### T-F01-02 · `AuthService` y backend falso

- **Descripción:** crear el servicio con el patrón singleton con `factory` del proyecto, la interfaz `AuthBackend`, los estados de sesión, los errores tipados, la validación de la fila de `usuarios` y el falso para pruebas. Sin importar Supabase.
- **Archivos:** `lib/services/auth_service.dart` (nuevo), `test/auth/` (falso y pruebas del servicio). Usa `lib/models/usuario.dart` sin modificarlo.
- **Dependencias:** T-F01-01.
- **Requisitos:** RF-22, RF-23, RF-24, RF-25; F-01 CA-1 a CA-4 y CA-8.
- **Prioridad oficial:** Debe. **En la entrega:** obligatoria. **Commit:** C2. **Estado:** pendiente.
- **Criterios de aceptación:**
  - [ ] Expone `iniciarSesion`, `cerrarSesion`, `usuarioActual` y `rolActual`.
  - [ ] `AuthService()` devuelve siempre la misma instancia; no hay variable global asignable.
  - [ ] Un `AuthBackend` falso se inyecta con un constructor `@visibleForTesting`; no se agregan paquetes.
  - [ ] El backend por defecto informa «sin sesión» y su inicio de sesión falla.
  - [ ] Distingue credenciales incorrectas, cuenta desactivada y falla de conexión.
  - [ ] Sin fila, con `activo` ausente o falso, o con rol no reconocido, no hay usuario actual ni estado «autenticado».
  - [ ] «Autenticado» se publica solo después de validar la fila.
  - [ ] Si la cuenta está desactivada, se cierra la sesión abierta en Auth.
  - [ ] La conversión del texto del rol está en un solo punto.
  - [ ] Hay una prueba para cada caso anterior de acceso concedido o negado.

### T-F01-03 · Pantalla de login

- **Descripción:** reemplazar los botones por rol con un formulario de correo y contraseña. `LoginScreen` maneja carga y errores, y deja de navegar.
- **Archivos:** `lib/pages/login_page.dart`, `lib/screens/login_screen.dart`, `test/auth/`. Reutiliza `AppTextField`, `AppButton` y `AppCard` sin modificarlos.
- **Dependencias:** T-F01-02.
- **Requisitos:** RF-22; F-01 CA-1, CA-3, CA-4, CA-8; RNF-01, RNF-02.
- **Prioridad oficial:** Debe. **En la entrega:** obligatoria. **Commit:** C2. **Estado:** pendiente.
- **Criterios de aceptación:**
  - [ ] Hay campo de correo, campo de contraseña y botón «Iniciar sesión».
  - [ ] La contraseña no se ve mientras se escribe.
  - [ ] No existen los botones por rol, ni enlaces de registro o de recuperar contraseña.
  - [ ] Durante el envío el botón muestra «Ingresando…» y un segundo toque no hace otra llamada.
  - [ ] Con datos incorrectos se ve «Correo o contraseña incorrectos», sigue en el login y se puede reintentar.
  - [ ] Con cuenta desactivada se ve «Tu cuenta está desactivada».
  - [ ] Sin conexión se ve «No se pudo iniciar sesión. Revisa tu conexión e inténtalo de nuevo» y el correo sigue escrito.
  - [ ] No se valida la longitud de la contraseña ni se muestran errores técnicos.
  - [ ] No hay desbordamientos a 360 px de ancho.
  - [ ] `LoginScreen` no navega ni importa las screens de empleado o administrador.
  - [ ] El comportamiento ante casos de D-6 y D-7 sigue lo que acuerde el equipo; si no hay acuerdo, queda anotado como pendiente.

### T-F01-04 · Control de sesión y de rol

- **Descripción:** crear `AppGate`, que cambia su hijo según el estado de sesión, y `GuardiaRol` para el módulo de gestión. El control es de interfaz y no protege el backend.
- **Archivos:** `lib/screens/app_gate.dart` (nuevo), `test/auth/`.
- **Dependencias:** T-F01-02, T-F01-03. No depende de P1, D-12 ni `main.dart`: se verifica con el montaje descrito en «Cómo avanzar con el backend falso».
- **Requisitos:** RF-24, RF-25; F-01 CA-1, CA-2, CA-5; F-02 CA-7.
- **Prioridad oficial:** Debe. **En la entrega:** obligatoria. **Commit:** C3. **Estado:** pendiente.
- **Criterios de aceptación:**
  - [ ] Acepta un `AuthService?` opcional por constructor, usa `AuthService()` si no llega y pasa la misma instancia a `LoginScreen`.
  - [ ] Una prueba de widget recorre login → pantalla según rol con `AuthService`, `LoginScreen` y `AppGate` reales y solo el backend falso.
  - [ ] Sin sesión se ve el login y no se construye ninguna pantalla de anuncios.
  - [ ] Un empleado ve la búsqueda de anuncios y un administrador el módulo de gestión.
  - [ ] Una cuenta sin fila, inactiva o con rol no reconocido no ve ninguna de las dos.
  - [ ] Con rol de empleado, `GuardiaRol` muestra «No tienes permiso para ver esta sección» y no construye el módulo ni carga cuentas.
  - [ ] Cambia de contenido sin `push`, rutas con nombre ni paquetes nuevos.
  - [ ] Las pantallas destino se pueden sustituir por constructor en las pruebas.
  - [ ] `LoginScreen` sigue montada mientras se envía el formulario.
  - [ ] La documentación y los comentarios no presentan este control como seguridad del backend.

### T-F01-05 · Cierre de sesión: parte de P2

- **Descripción:** lógica de `cerrarSesion` y reacción de `AppGate`. El botón de las screens de P3 y P4 se integra en T-F01-11.
- **Archivos:** `lib/services/auth_service.dart`, `lib/screens/app_gate.dart`, `test/auth/`.
- **Dependencias:** T-F01-04.
- **Requisitos:** RF-23; F-01 CA-6; CP-2.
- **Prioridad oficial:** Debería. **En la entrega:** obligatoria, no es opcional. **Commit:** C2 (servicio) y C3 (`AppGate`), según la etiqueta de cada criterio. **Estado:** pendiente hasta cumplir ambas partes.
- **Criterios de aceptación:**
  - [ ] **[C2]** `cerrarSesion` deja `usuarioActual` y `rolActual` nulos y publica «sin sesión».
  - [ ] **[C2]** Si el cierre falla, el servicio no publica «sin sesión» sin comprobar el estado real; el comportamiento sin conexión se confirma en T-F01-11 (D-4).
  - [ ] **[C3]** `AppGate` muestra el login sin que la pantalla que cerró la sesión tenga que navegar.
  - [ ] **[C3]** Con un diálogo abierto, el cierre lo quita y limpia los SnackBars.
  - [ ] **[C3]** Volver atrás después del cierre no muestra anuncios (prueba con backend falso).

### T-F01-06 · Persistencia: parte de P2

- **Descripción:** lógica de arranque: comprobar si hay sesión recuperable, validar de nuevo la cuenta y resolver los estados. Con backend falso.
- **Archivos:** `lib/services/auth_service.dart`, `lib/screens/app_gate.dart`, `test/auth/`.
- **Dependencias:** T-F01-04.
- **Requisitos:** reparto P2; RF-24; CP-1 a CP-5.
- **Prioridad oficial:** sin prioridad oficial. **En la entrega:** obligatoria. **Commit:** C3. **Estado:** pendiente.
- **Criterios de aceptación:**
  - [ ] Mientras comprueba, solo hay un indicador de carga (CP-3).
  - [ ] Sesión recuperable y cuenta activa: pantalla del rol sin pedir credenciales (CP-1).
  - [ ] Sin sesión o sesión inválida: login. También después de un cierre de sesión (CP-2).
  - [ ] Cuenta desactivada: se cierra la sesión y se ve el login (CP-4).
  - [ ] Sin conexión: error con reintento y ningún anuncio; al reintentar con conexión se entra (CP-5). El texto depende de D-6.

### T-F01-07 · Pruebas con backend falso

- **Descripción:** completar y revisar la batería de pruebas de T-F01-02 a 06. Las pruebas se escriben junto a cada tarea; aquí se cierra la cobertura.
- **Archivos:** `test/auth/`.
- **Dependencias:** T-F01-03 a 06.
- **Requisitos:** F-01 CA-1 a CA-6 y CA-8; F-02 CA-7; CP-1 a CP-5.
- **Prioridad oficial:** Debe. **En la entrega:** obligatoria. **Commit:** sin commit propio; cada prueba va en C2 o C3, con su código. **Estado:** pendiente.
- **Criterios de aceptación:**
  - [ ] Cada criterio obligatorio y cada CP tiene al menos una prueba que lo nombra.
  - [ ] Las pruebas no necesitan red, Supabase ni paquetes nuevos.
  - [ ] Pasan todas las pruebas de `test/auth/` y las pruebas 0, 2, 3 y 4 de `widget_test.dart`. La prueba 1 puede fallar hasta T-F01-09 y se deja anotado.
  - [ ] `flutter analyze --no-pub` no muestra errores ni advertencias nuevas; los avisos `info` por `material.dart` obsoleto ya existían (24 el 2026-11-26).

---

## B. Obligatorias con bloqueo externo

Siguen siendo responsabilidad de P2. El bloqueo cambia cuándo se pueden terminar, no si hay que hacerlas.

### T-F01-08 · Backend de Supabase Auth

- **Descripción:** implementar `AuthBackend` con Supabase Auth y la lectura de la fila propia de `usuarios`, y usarlo por defecto.
- **Archivos:** `lib/services/auth_service.dart`. La configuración y el cliente de `lib/core/` son de P1; se usan sin modificarlos.
- **Dependencias:** T-F01-02; **bloqueada por P1** (dependencia, cliente, esquema, `rol`, `activo`, permiso de lectura) y por el acuerdo D-1.
- **Requisitos:** RF-22, RF-23, RF-24, RF-25; F-01 CA-1 a CA-4 y CA-8; AD-02, AD-03, AD-09.
- **Prioridad oficial:** Debe. **En la entrega:** obligatoria. **Commit:** CS. **Estado:** pendiente.
- **Criterios de aceptación:**
  - [ ] `flutter test` sigue sin necesitar red ni un proyecto de Supabase; si usar este backend por defecto afecta la prueba 1, se ajusta dentro de lo acordado en D-10.
  - [ ] Con las cuentas de prueba, el empleado y el administrador inician sesión y quedan con su rol.
  - [ ] El usuario se identifica por el `uuid` de Auth.
  - [ ] Credenciales incorrectas, cuenta desactivada y falta de conexión producen los tres errores tipados.
  - [ ] Ningún otro archivo de mi alcance importa el SDK de Supabase.
  - [ ] No hay URL, claves ni contraseñas escritas en el código; la secret key no aparece en ninguna parte.
  - [ ] No hay ninguna llamada de registro de cuentas.
  - [ ] No se modifica `pubspec.yaml`.

### T-F01-09 · `AppGate` en `main.dart` y prueba 1

- **Descripción:** usar `AppGate` como pantalla inicial y actualizar la prueba que depende del login antiguo.
- **Archivos:** `lib/main.dart` (**únicamente la línea `home:`**, como dice el reparto), `test/widget_test.dart` (prueba 1 y lo que necesite para arrancar sin Supabase).
- **Dependencias:** T-F01-04, T-F01-07; **bloqueada por D-10** (cierres de sesión y dueño de la prueba) **y D-12**: cambiar solo `home:` a `const AppGate()` no compila mientras `AppGate` no esté visible en `main.dart`, que hoy solo importa `login_screen.dart`. Ningún cambio fuera de `home:` está autorizado. Para entrar con datos reales también necesita T-F01-08 y la inicialización de P1. Se integra a `main` junto con T-F01-03 y 04.
- **Requisitos:** RF-24; F-01 CA-5.
- **Prioridad oficial:** Debe. **En la entrega:** obligatoria. **Commit:** CM. **Estado:** pendiente.
- **Criterios de aceptación:**
  - [ ] D-12 está resuelta antes de editar `main.dart`.
  - [ ] En `main.dart`, mi único cambio es la línea `home:`. Cualquier otro solo si D-12 lo autoriza expresamente, y queda anotado aquí.
  - [ ] Al abrir la app sin sesión se ve el login.
  - [ ] La prueba 1 comprueba el formulario nuevo y que no hay anuncios.
  - [ ] `flutter test` pasa completo.
  - [ ] No se cambian las pruebas 0, 2, 3 y 4.

### T-F01-10 · Persistencia real

- **Descripción:** comprobar con Supabase que la sesión se conserva al cerrar y reabrir la app, y ajustar el backend si hace falta.
- **Archivos:** `lib/services/auth_service.dart`.
- **Dependencias:** T-F01-06, 08, 09; **bloqueada por P1** (incluida una cuenta que se pueda desactivar).
- **Requisitos:** reparto P2; CP-1 a CP-5.
- **Prioridad oficial:** sin prioridad oficial. **En la entrega:** obligatoria. **Commit:** un `fix:` aparte, solo si hay correcciones. **Estado:** pendiente.
- **Criterios de aceptación:**
  - [ ] CP-1 a CP-5 comprobados en web, cerrando y reabriendo de verdad, no solo recargando en caliente.
  - [ ] Se anota la versión de `supabase_flutter` y lo observado sobre cómo recupera la sesión (D-4).
  - [ ] Se anota en qué plataformas se probó; Android no se puede probar mientras no exista `android/`.

### T-F01-11 · Cierre de sesión integrado

- **Descripción:** lograr que «Cerrar Sesión» de las dos screens use `AuthService().cerrarSesion()` sin navegar, y verificarlo.
- **Archivos:** `lib/screens/admin_screen.dart` (P3) y `lib/screens/employee_screen.dart` (P4). **No son míos:** los cambia su dueño (opción a) o yo con su autorización (opción b).
- **Dependencias:** T-F01-05, 08, 09; **bloqueada por P3 y P4**.
- **Requisitos:** RF-23, RF-24; F-01 CA-6; CP-2.
- **Prioridad oficial:** Debería. **En la entrega:** obligatoria. **Commit:** CL si es la opción b; si es la a, va en los commits de P3 y P4. **Estado:** pendiente.
- **Criterios de aceptación:**
  - [ ] En las dos screens, el cierre llama a `AuthService().cerrarSesion()`, sin `pushReplacement` ni `import` de `login_screen`.
  - [ ] Como empleado y como administrador: cerrar sesión lleva al login y volver atrás no muestra anuncios ni cuentas.
  - [ ] Después de cerrar se puede iniciar sesión otra vez, incluso con otro rol, sin quedar atascado.
  - [ ] Reabrir la app después de cerrar muestra el login.
  - [ ] Se comprobó el cierre sin conexión y se anotó el resultado (D-4).
  - [ ] Cerrar con un diálogo o una operación en curso no produce errores.

### T-F01-12 · Verificación final

- **Descripción:** recorrer todos los criterios con Supabase y las ramas integradas, en especial los roles reales, y dejar evidencia.
- **Archivos:** `docs/tasks/F-01-sesion.md` (estados y evidencia). Las correcciones van en mis archivos.
- **Dependencias:** T-F01-10, 11; **P3** para F-02 CA-2 y CA-6.
- **Requisitos:** RF-22 a RF-25; F-01 CA-1 a CA-6 y CA-8; F-02 CA-2, CA-6, CA-7; RNF-01, RNF-02, RNF-10.
- **Prioridad oficial:** Debe. **En la entrega:** obligatoria. **Commit:** el que corresponda a cada corrección; la evidencia puede ir en C4. **Estado:** pendiente.
- **Criterios de aceptación:**
  - [ ] Cada criterio tiene resultado (cumple, no cumple o no verificable), fecha y forma de comprobarlo.
  - [ ] Los roles se probaron con cuentas reales de empleado y administrador.
  - [ ] F-02 CA-2 y CA-6 se probaron con cuentas creadas y desactivadas desde el módulo de P3, o quedan como no verificables con su motivo.
  - [ ] F-02 CA-7 se verificó, indicando si fue en la app o solo con pruebas de widget (la interfaz no ofrece al empleado un camino al módulo).
  - [ ] Textos en español y login sin desbordamientos a 360 px; se anotan los navegadores probados.
  - [ ] Se registra el tiempo de inicio de sesión y la red usada (RNF-10, Debería: si no cumple, se reporta y no bloquea).
  - [ ] El informe no presenta el control de rol de la app como seguridad del backend, y lista D-2 y D-3 si siguen abiertas.

---

## C. Opcional, fuera del alcance inicial

### T-F01-13 · Cierre tras 30 minutos de inactividad

- **Descripción:** cerrar la sesión tras 30 minutos sin actividad. Solo si el equipo lo aprueba.
- **Archivos:** `lib/services/auth_service.dart`, `lib/screens/app_gate.dart`, `test/auth/`.
- **Dependencias:** T-F01-12 y la decisión D-9.
- **Requisitos:** RNF-12; F-01 A4 y CA-7.
- **Prioridad oficial:** Podría. **En la entrega:** opcional. **Commit:** uno aparte. **Estado:** pendiente.
- **Criterios de aceptación:**
  - [ ] Tras 30 minutos sin actividad se cierra la sesión y se ve «Tu sesión se cerró por inactividad».
  - [ ] La actividad reinicia el conteo.
  - [ ] Se puede probar sin esperar 30 minutos reales.
  - [ ] El comportamiento con la app cerrada sigue lo acordado en D-9.

---

## Preguntas abiertas

Las decisiones D-1 a D-12 del plan.

## Historial

- 0.1.0 · 2026-11-26 · Primera versión: 13 tareas, todas pendientes.
