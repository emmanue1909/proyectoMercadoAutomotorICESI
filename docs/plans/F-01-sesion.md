---
documento: plan
id: F-01
titulo: Autenticación y control de sesión
proyecto: Plataforma inteligente para el análisis del mercado automotor colombiano
version: 0.1.0
fecha: 2026-11-26
estado: borrador
autores: [Juan Diego Dominguez (P2)]
basado_en: [prd 0.1.0, requisitos 0.2.0, architectural_spine 0.1.1, F-01 0.1.1, F-02 0.1.0, reparto-trabajo]
---

# Plan · F-01 · Autenticación y control de sesión

Tareas: [`docs/tasks/F-01-sesion.md`](../tasks/F-01-sesion.md). Spec: [F-01](../specs/F-01-sesion.md); de [F-02](../specs/F-02-gestion-empleados.md) solo se toma lo relativo a RF-25 y a la integración.

## 1. Contexto y objetivo

El prototipo `Prototipo_Vehiculos_V2/automarket_v2/` no tiene autenticación: el login son dos botones que navegan según el botón pulsado, no hay sesión, y «Cerrar Sesión» solo vuelve a `LoginScreen`. `supabase_flutter` no está en el proyecto y no hay esquema de base de datos.

Objetivo: que empleado y administrador entren con correo y contraseña usando Supabase Auth, que sin sesión no se vea ningún anuncio, que cada rol vea solo lo que le corresponde, que puedan cerrar sesión y que la sesión se conserve al cerrar y reabrir la aplicación.

Responsable: **Juan Diego Dominguez, P2** (`docs/reparto-trabajo.pdf`, secciones 2 y 4). Archivos propios según el reparto: `auth_service`, `login_screen`, `login_page`, `app_gate`, `README.md` y `CLAUDE.md`. En `main.dart`, solo la línea `home:`.

### Regla de rama

- Todo el trabajo de P2 se hace en `feature/p2-auth`.
- **Nunca se modifica ni se hace commit directamente en `main`.** Los cambios llegan por PR, con rebase sobre `main` antes de abrirlo.
- No se suben claves ni archivos `.env`. La secret key nunca va en la app ni en el repositorio (AD-09).
- Este plan y sus tareas se suben antes que el código (evidencia SDD).

## 2. Alcance de P2

La **prioridad oficial** es la de `docs/requisitos.md`. El **carácter en mi entrega** es lo que me asigna el reparto. No siempre coinciden.

| Elemento | Prioridad oficial | En mi entrega |
| --- | --- | --- |
| RF-22, inicio de sesión | Debe | Obligatorio |
| RF-23, cierre de sesión | **Debería** | **Obligatorio**: el reparto lo asigna a P2; no es opcional |
| RF-24, acceso solo con sesión | Debe | Obligatorio |
| RF-25, acceso según rol | Debe | Obligatorio |
| Persistencia de la sesión | Sin RF ni criterio en las specs | Obligatoria por el reparto |
| Correo y contraseña, carga y error, sin registro libre, Supabase Auth | RF-22, F-01, reparto, spine | Obligatorio |
| RNF-01, español (Colombia) | Debe | Obligatorio en lo que yo construya |
| RNF-02, desde 360 px y navegadores indicados | Debe | Obligatorio en lo que yo construya |
| RNF-10, inicio de sesión en menos de 3 s con 10 Mbps | Debería | No bloquea la entrega; se mide en la verificación final |
| RNF-12, cierre tras 30 min sin actividad (F-01 CA-7) | Podría | Opcional, fuera del alcance inicial |

Logout, persistencia y control de rol son **responsabilidad de P2**, aunque parte de su integración dependa de otras personas.

**Fuera de alcance:** registro libre, recuperar contraseña, cambiar contraseña (F-01); crear, editar o desactivar cuentas (P3); esquema, políticas, seed y cliente de Supabase (P1). RNF-11 (contraseña de mínimo 8 caracteres) aplica al crear cuentas (F-02, P3): el login no valida la longitud.

## 3. Requisitos y criterios involucrados

| Id | Criterio | Tipo en mi entrega | Tareas |
| --- | --- | --- | --- |
| F-01 CA-1 | Empleado activo con datos correctos ve la búsqueda de anuncios | Obligatorio | 02, 03, 04, 08, 12 |
| F-01 CA-2 | Administrador activo ve el módulo de gestión de empleados | Obligatorio | 02, 04, 08, 12 |
| F-01 CA-3 | Contraseña incorrecta: «Correo o contraseña incorrectos» y sigue en el login | Obligatorio | 02, 03, 08, 12 |
| F-01 CA-4 | Cuenta desactivada: «Tu cuenta está desactivada» y no entra | Obligatorio | 02, 03, 08, 12 |
| F-01 CA-5 | Sin sesión, al intentar abrir los anuncios ve el login y ningún anuncio | Obligatorio | 04, 09, 12 |
| F-01 CA-6 | Tras «Cerrar sesión» ve el login y al volver atrás no ve anuncios | Obligatorio | 05, 11, 12 |
| F-01 CA-7 | Cierre por inactividad con «Tu sesión se cerró por inactividad» | Opcional | 13 |
| F-01 CA-8 | Sin conexión: «No se pudo iniciar sesión. Revisa tu conexión e inténtalo de nuevo» y el correo se conserva | Obligatorio | 02, 03, 08, 12 |
| F-02 CA-7 | Un empleado que intenta abrir el módulo ve «No tienes permiso para ver esta sección» y ninguna cuenta (flujo A5) | Obligatorio | 04, 12 |
| F-02 CA-2 | Un empleado recién creado inicia sesión y entra a la búsqueda | Integración con P3 | 12 |
| F-02 CA-6 | Un empleado desactivado ve «Tu cuenta está desactivada» | Integración con P3 | 12 |

### Persistencia: criterios derivados

La persistencia viene solo del reparto («Persistencia de la sesión al cerrar y volver a abrir la app»). **Los criterios CP no están en ninguna spec**: son una propuesta para poder verificarla.

| Id | Criterio derivado | Tareas |
| --- | --- | --- |
| CP-1 | Con sesión válida y cuenta activa, al cerrar y reabrir la app se ve la pantalla del rol sin pedir credenciales | 06, 10 |
| CP-2 | Después de cerrar sesión, al reabrir la app se ve el login | 05, 06, 10, 11 |
| CP-3 | Mientras se comprueba la sesión no se muestra ningún anuncio ni el módulo de empleados | 06, 10 |
| CP-4 | Si al recuperar la sesión la cuenta está desactivada, no se entra y se cierra la sesión | 06, 10 |
| CP-5 | Si al recuperar la sesión no se puede verificar la cuenta por falta de conexión, se muestra un error con opción de reintentar y ningún anuncio | 06, 10 |

## 4. Arquitectura propuesta

Se respetan AD-01 (sin backend propio), AD-02 (solo los servicios llaman a Supabase), AD-03 (el usuario es el de Auth y la fila guarda `uuid` y rol), AD-04 (acceso por sesión y rol, sin registro libre) y AD-09 (llaves fuera del código).

Rutas relativas a `Prototipo_Vehiculos_V2/automarket_v2/lib/`:

```
main.dart                  home: AppGate (solo esa línea)
screens/app_gate.dart      nuevo: decide qué se muestra; incluye GuardiaRol
screens/login_screen.dart  estado del formulario y llamada a AuthService
pages/login_page.dart      formulario (solo presentación)
services/auth_service.dart AuthService, AuthBackend y estados de sesión
```

El reparto no fija la carpeta de `app_gate`; `screens/` es la propuesta, porque ahí están los contenedores con estado.

### Patrón actual del proyecto

- `VehiculosService` y `TrabajadoresService` son singletons con constructor `factory` (`static final _instance; factory X() => _instance; X._internal();`) y cada screen los crea como campo.
- Las pages reciben datos y callbacks por constructor, y así se prueban en `test/widget_test.dart`.
- No hay paquete de inyección de dependencias, `InheritedWidget` ni gestor de estado.

No se agrega ningún framework ni paquete para inyección o pruebas.

## 5. Componentes

### 5.1 `AuthService`

- Sigue el patrón del proyecto: `AuthService()` devuelve la instancia compartida. No hay una variable global asignable. P3 y P4 lo usan como `AuthService().cerrarSesion()`.
- `LoginScreen` y `AppGate` aceptan un `AuthService?` opcional por constructor; si no llega, usan `AuthService()`.
- El acceso externo queda detrás de una interfaz pequeña, `AuthBackend`, en el mismo archivo. Se inyecta con un constructor marcado `@visibleForTesting`. Así las pruebas ejercitan la lógica real (fila inválida, cuenta desactivada) con un backend falso que vive en `test/`.
- Solo el backend de Supabase importa el SDK (AD-02).
- Hasta que exista ese backend, el backend por defecto informa «sin sesión» y el inicio de sesión falla. **Nunca concede acceso.**

Contrato del reparto: `iniciarSesion`, `cerrarSesion`, `usuarioActual`, `rolActual`. El reparto no define tipos. **Propuesta**, por avisar al grupo:

| Miembro | Propuesta |
| --- | --- |
| `iniciarSesion` | recibe correo y contraseña; asíncrono; falla con un error tipado |
| `cerrarSesion` | asíncrono, sin parámetros |
| `usuarioActual` | `Usuario?` (modelo existente en `models/usuario.dart`) |
| `rolActual` | rol reconocido o nulo |
| `cambiosSesion` | flujo de estados de sesión. **Es una adición al contrato** |

**Validación de la fila de `usuarios`.** `Usuario.fromMap` pone `rol = 'Empleado'` y `activo = true` cuando esos datos faltan, es decir, concedería acceso por defecto. `AuthService` valida la fila antes de construir el `Usuario`: sin fila, con `activo` ausente o falso, o con rol no reconocido, no hay acceso. La conversión del texto del rol se hace en un solo punto mientras no haya acuerdo (sección 13, D-1).

### 5.2 `LoginPage` y `LoginScreen`

- `LoginPage`: correo, contraseña oculta y botón «Iniciar sesión». Desaparecen los botones por rol y sus callbacks. No hay enlace de registro ni de recuperar contraseña.
- Se reutilizan `AppTextField` (`obscureText`, `controller`), `AppButton` (con `isLoading` deshabilita el botón) y `AppCard`.
- `LoginScreen`: controla la carga y el error, y llama a `AuthService`. **Deja de navegar** y de importar las screens de empleado y administrador.

### 5.3 `AppGate` y navegación

Estado actual de la navegación: `MaterialApp` solo con `home`; no hay rutas con nombre, `navigatorKey` ni paquete de rutas. En `EmployeeScreen`, la lista y el detalle cambian por estado (`MainFlowView`), igual que las pestañas. Solo agregan rutas el `pushReplacement` del login y de los dos cierres de sesión, y tres `showDialog` (dos en `admin_screen`, uno en `employee_screen`).

Diseño:

- `AppGate` es `home` y **cambia su hijo según el estado de sesión**, sin `push` ni rutas nuevas. No altera la navegación interna de las screens.
- Al terminar la sesión cierra lo que haya encima (`popUntil` hasta la primera ruta) y limpia los SnackBars.
- Como las pantallas protegidas no son rutas, volver atrás no las recupera.
- Las dos pantallas destino se pueden sustituir por constructor en las pruebas.
- Hay que revisar las operaciones asíncronas de los diálogos: si terminan después del cierre de sesión, no deben usar un contexto desmontado ni cerrar una ruta de más. Si ocurre en archivos de P3 o P4, se les reporta.

### 5.4 `main.dart`

El reparto dice: «En main.dart edita solo la línea `home:`». Este plan no asume permiso para nada más. La inicialización de Supabase es de P1, en líneas distintas.

Hay un obstáculo técnico: `main.dart` usa hoy `home: const LoginScreen()` y conoce esa clase por `import 'screens/login_screen.dart';`. Si solo se cambia la línea `home:` a `const AppGate()`, no compila, porque Dart exige que `AppGate` esté visible mediante un `import`. Cómo resolverlo queda pendiente (D-12). **`AppGate` se puede construir y probar completo sin resolverlo** (sección 12).

### Riesgo de integración con los cierres de sesión actuales

`screens/admin_screen.dart` (P3, línea 336) y `screens/employee_screen.dart` (P4, línea 344) hacen `pushReplacement` hacia `LoginScreen`. Cuando `LoginScreen` deje de navegar y exista `AppGate`, ese código elimina la ruta que contiene `AppGate`, no cierra la sesión y deja un login que ya no avanza: **la persona queda atascada**.

Ambos deben llamar a `AuthService().cerrarSesion()`, sin navegar, y quitar el `import` de `login_screen`. Falta acordar cómo entra ese cambio junto con el mío:

- (a) P3 y P4 lo hacen en sus ramas apenas se integre P2. Mientras tanto, `main` tendría el cierre de sesión atascado.
- (b) P3 y P4 autorizan que esos dos bloques vayan en el PR de P2.

No se editan sus archivos sin acuerdo.

Además, el login nuevo y `AppGate` como `home` (T-F01-03, 04 y 09) deben integrarse a `main` juntos: el login sin `AppGate` no lleva a ninguna pantalla.

## 6. Flujo de autenticación

1. Sin sesión, `AppGate` muestra el login.
2. La persona escribe correo y contraseña y pulsa «Iniciar sesión».
3. El botón muestra «Ingresando…» y no admite otro envío.
4. `AuthService` autentica con Supabase Auth.
5. Con el `uuid` de Auth lee la fila de `usuarios` y la valida.
6. **Solo después de validar** publica el estado «autenticado». Auth puede abrir la sesión antes de que se conozca `activo`, y en ese intervalo no se muestra ninguna pantalla protegida.
7. Si la cuenta está desactivada, cierra la sesión y muestra «Tu cuenta está desactivada».
8. `AppGate` muestra la búsqueda de anuncios al empleado o el módulo de gestión al administrador.

`LoginScreen` permanece montada durante todo el envío, para conservar el correo si hay un error (CA-8).

## 7. Flujo de cierre de sesión

1. La persona pulsa «Cerrar sesión» en el menú lateral.
2. La screen llama a `AuthService().cerrarSesion()` y no navega.
3. `AuthService` cierra la sesión, olvida el usuario y publica «sin sesión».
4. `AppGate` cierra diálogos, limpia SnackBars y muestra el login.
5. Volver atrás no muestra anuncios, y reabrir la app muestra el login (CP-2).

Está por verificar qué hace el SDK si se cierra sesión sin conexión. El criterio no cambia: la app no debe quedar mostrando anuncios ni afirmar que cerró una sesión que sigue guardada.

## 8. Recuperación de la sesión al reabrir

1. Al arrancar, `AppGate` está en «comprobando» y muestra solo un indicador de carga.
2. `AuthService` consulta si hay una sesión recuperable.
3. Sin sesión, o con sesión inválida o vencida: login.
4. Con sesión: lee y valida otra vez la fila de `usuarios`.
5. Cuenta válida: pantalla según el rol. Cuenta desactivada o sin acceso: cierra la sesión y muestra el login.
6. Sin conexión para verificar: error con reintento, sin anuncios.

No se da por hecho cómo guarda y recupera la sesión `supabase_flutter`: se verifica con la versión que instale P1.

## 9. Control de acceso por rol

| Estado | Anuncios | Módulo de empleados |
| --- | --- | --- |
| Sin sesión o comprobando | No | No |
| Empleado | Sí | No |
| Administrador | No es su pantalla (F-01, paso 4) | Sí |
| Sin fila, cuenta inactiva o rol no reconocido | No | No |

`GuardiaRol` envuelve el módulo de gestión: si el rol no es administrador muestra «No tienes permiso para ver esta sección» y no construye el contenido, así que no se cargan cuentas.

**Este control solo decide qué muestra la interfaz. No es una garantía de seguridad del backend:** quien tenga la publishable key puede llamar a la API sin pasar por la app. Proteger los datos depende de lo que se configure en Supabase (D-3). La spine ya advierte que, sin seguridad por filas, AD-04 no lo hace cumplir el servidor.

## 10. Estados de carga, errores y sesión

| Estado de sesión | Qué se ve |
| --- | --- |
| Comprobando (solo al arrancar) | Indicador de carga |
| Sin sesión | Login |
| Autenticado | Pantalla según el rol |
| Error al verificar | Error con reintento; sin anuncios |

| Situación en el login | Comportamiento | Fuente |
| --- | --- | --- |
| Enviando | «Ingresando…», sin segundo envío | F-01, Estados |
| Datos incorrectos | «Correo o contraseña incorrectos», sin decir cuál falló; se puede reintentar | CA-3, Reglas, A1 |
| Cuenta desactivada | «Tu cuenta está desactivada» | CA-4, A2 |
| Falla de conexión | «No se pudo iniciar sesión. Revisa tu conexión e inténtalo de nuevo», con el correo conservado | CA-8 |
| Sin fila o rol no reconocido | No entra. Mensaje por definir | D-6 |
| Campos vacíos | Por definir | D-7 |

La contraseña no se ve mientras se escribe (F-01, Reglas). Todos los textos van en español (RNF-01). No se muestran mensajes técnicos del SDK.

## 11. Estrategia de pruebas

- **Línea base (2026-11-26):** `flutter test` ejecuta 5 pruebas y todas pasan.
- **Pruebas del servicio** (`test/auth/`): backend falso con empleado activo, administrador activo, cuenta desactivada, credenciales incorrectas, sin conexión, sin fila, `activo` ausente, rol no reconocido y sesión recuperable.
- **Pruebas de widget:** login (carga, doble envío, mensajes, correo conservado, contraseña oculta, sin registro, 360 px), `AppGate` (cada estado y rol), `GuardiaRol`, cierre de sesión con un diálogo abierto y recuperación al arrancar.
- **Prueba 1 de `test/widget_test.dart`:** busca los dos botones actuales, así que dejará de pasar con el login nuevo. Además, la app completa tendrá que arrancar en un estado controlado. El archivo no tiene dueño en el reparto: se acuerda antes de editarlo.
- **Integración real** (con P1, P3 y P4): todos los criterios obligatorios y CP en web, con las cuentas de prueba. No hay carpeta `android/`, así que en Android no se puede probar hoy.
- **RNF-02:** revisar a 360 px y en los navegadores disponibles, anotando cuáles se probaron.
- **RNF-10:** medir el tiempo de inicio de sesión y anotar las condiciones de red.
- Las pruebas con backend falso no demuestran que la integración con Supabase funcione.
- `flutter pub get`, `test` y `analyze` pueden modificar `pubspec.lock` y los `generated_plugin*` de `windows/`; esos cambios no van en mis commits.

## 12. Dependencias y bloqueos

| De | Qué necesito | Qué bloquea |
| --- | --- | --- |
| P1 | `supabase_flutter` en `pubspec.yaml`; URL y publishable key por configuración; inicialización del cliente en `main.dart` | Backend real (T-F01-08) |
| P1 | Tabla `usuarios` con `id` igual al `uuid` de Auth, `rol` y `activo` | T-F01-08 |
| P1 | Permiso para que cada usuario lea su propia fila | T-F01-08 |
| P1 | Cuentas de prueba: empleado y administrador. **Pedir además una desactivada**, que el reparto no incluye | T-F01-10 a 12 |
| P3 | Cierre de sesión en `admin_screen` | T-F01-11 |
| P3 | Crear y desactivar cuentas | F-02 CA-2 y CA-6 en T-F01-12 |
| P4 | Cierre de sesión en `employee_screen` | T-F01-11 |

Al 2026-11-26 no se ve en el remoto ninguna rama de P1.

**Sin código de otros** se puede hacer: preparación, `AuthService` con su interfaz y falso, login, `AppGate`, control de rol, la parte propia del cierre y de la persistencia, y sus pruebas (T-F01-01 a 07). P2 no edita `pubspec.yaml`: si necesita un paquete, se lo pide a P1.

`AppGate` no espera a P1 ni a `main.dart`: las pruebas de widget montan `MaterialApp(home: AppGate(...))` con el `AuthService` real y un backend falso, así que login, rol, cierre y recuperación se integran y verifican desde la rama. El procedimiento está en [las tareas](../tasks/F-01-sesion.md), sección «Cómo avanzar con el backend falso», igual que el reparto de commits. Esto no sustituye la verificación con Supabase.

Orden de merge sugerido por el reparto: P1, luego P2, y los demás en cualquier orden.

## 13. Riesgos y decisiones pendientes

Ninguna está decidida. Las propuestas necesitan acuerdo.

| Id | Tema | Propuesta o riesgo | Quién decide |
| --- | --- | --- | --- |
| D-1 | Representación de roles: el contrato dice `empleado` / `administrador`; `Usuario` usa `Empleado` / `Administrador` y además `Particular` y `Concesionario` | Propuesta: los valores del contrato. `usuario.dart` no tiene dueño en el reparto | Equipo, con P1 y P3 |
| D-2 | Registro libre: la propuesta de P3 (`signUp` desde un cliente secundario, sin confirmación de correo) previsiblemente exige tener habilitado el registro público, y entonces cualquiera con la publishable key podría crear cuentas en Auth. **Por verificar** | La app niega el acceso sin fila válida. Evaluar además que nadie pueda insertarse en `usuarios` y que el cliente secundario no reemplace la sesión del administrador | Equipo, con P1 y P3 |
| D-3 | Seguridad en el servidor: el reparto pide políticas de acceso a P1; la spine dice que no se usa seguridad por filas | Resolver la contradicción antes de manejar datos reales del publicador | Equipo, con P1 |
| D-4 | Supabase sin verificar: persistencia de la sesión, cierre sin conexión y configuración de Auth | Verificar con la versión y el proyecto que entregue P1 | P1 y P2 |
| D-5 | Cuenta desactivada con una sesión ya abierta | No está especificado. CP-4 solo cubre la reapertura | Equipo |
| D-6 | Cuenta de Auth sin fila o con rol no reconocido; también errores inesperados y el texto del error al recuperar la sesión | Se niega el acceso; no hay mensajes definidos | Equipo |
| D-7 | Envío con campos vacíos | F-01 no tiene criterio | Equipo |
| D-8 | F-01 mantiene abierta la pregunta «¿correo y contraseña u otro medio?»; el reparto la resuelve con correo y contraseña | Este plan sigue el reparto; falta actualizar la spec | Equipo |
| D-9 | Persistencia frente a RNF-12 (cierre por inactividad), también si la app estuvo cerrada | Definirlo antes de hacer la tarea opcional | Equipo |
| D-10 | Cómo entran los cierres de sesión (opción a o b, sección 5) y quién actualiza `widget_test.dart` | Acordar antes de integrar | P2, P3, P4 |
| D-11 | Fecha: el PRD fija el MVP para el 30 de noviembre de 2026; el reparto no da fecha para la entrega Supabase | Confirmarla. Si es esa, el trabajo de P1 es urgente | Equipo |
| D-12 | Cómo hacer visible `AppGate` en `main.dart` si el reparto solo permite editar `home:` (sección 5.4) | Opción 1: autorizar además cambiar la línea 2, el `import` de `login_screen.dart` por el de `app_gate.dart` (si solo se agrega otro, el actual queda sin usar y el análisis lo advierte). Opción 2: sin tocar otra línea de `main.dart`, agregar `export 'app_gate.dart';` en `login_screen.dart`, que es mío; funciona como atajo, pero la dependencia queda oculta y los dos archivos se referencian entre sí. No se ha compilado ninguna de las dos | P2 con P1, que comparte `main.dart` |

Otro riesgo: si P1 se retrasa, las tareas T-F01-08 y 10 a 12 no se pueden completar, y una entrega solo con backend falso no cumple RF-22.

## Preguntas abiertas

Son las decisiones D-1 a D-12 de la sección 13. Además, siguen abiertas las de F-01 (medio de inicio de sesión y recuperación de contraseña; esta última está fuera de alcance en la spec).

## Historial

- 0.1.0 · 2026-11-26 · Primera versión.
