---
id: F-01
titulo: Iniciar y cerrar sesión
version: 0.1.1
fecha: 2026-11-06
estado: borrador
autores: [Equipo del proyecto]
requisitos: [RF-22, RF-23, RF-24]
depende_de: []
---

# F-01 · Iniciar y cerrar sesión

## Objetivo

El empleado y el administrador entran a la plataforma con la cuenta que se les creó, y solo quien ha entrado puede consultar anuncios.

## Flujo principal

1. La persona abre la plataforma y ve la pantalla de inicio de sesión.
2. Ingresa su correo y su contraseña, y pulsa «Iniciar sesión».
3. Si es empleado, el sistema le muestra la búsqueda de anuncios.
4. Si es administrador, el sistema le muestra el módulo de gestión de empleados.
5. Cuando quiere salir, pulsa «Cerrar sesión» y el sistema vuelve a la pantalla de inicio de sesión.

## Flujos alternos

- **A1 · Datos incorrectos:** el correo o la contraseña no coinciden; el sistema lo avisa y la persona puede intentarlo otra vez.
- **A2 · Cuenta desactivada:** el sistema avisa que la cuenta está desactivada y no deja entrar.
- **A3 · Sin sesión:** si alguien intenta abrir una pantalla de anuncios sin haber iniciado sesión, el sistema lo lleva al inicio de sesión.
- **A4 · Sesión inactiva (deseable):** tras 30 minutos sin actividad, el sistema cierra la sesión y pide iniciar de nuevo.

## Reglas

- No hay registro libre: solo entran quienes tienen una cuenta creada por el administrador (ver F-02).
- Sin sesión iniciada no se muestra ningún anuncio.
- El mensaje de datos incorrectos no dice si falló el correo o la contraseña.
- La contraseña no se muestra en pantalla mientras se escribe.
- Deseable: el inicio de sesión toma menos de 3 segundos con una conexión de 10 Mbps.

## Estados

- **Cargando:** el botón «Iniciar sesión» muestra «Ingresando…» y no admite otro envío.
- **Vacío:** no aplica.
- **Error:** «No se pudo iniciar sesión. Revisa tu conexión e inténtalo de nuevo», con el correo conservado.

## Datos

- Cuenta: correo, contraseña, rol (empleado o administrador), estado (activa o desactivada).

## Criterios de aceptación

- **CA-1** Dado un empleado con cuenta activa, cuando ingresa su correo y su contraseña correctos, entonces ve la búsqueda de anuncios.
- **CA-2** Dado el administrador con cuenta activa, cuando inicia sesión, entonces ve el módulo de gestión de empleados.
- **CA-3** Dado un correo con contraseña incorrecta, cuando pulsa «Iniciar sesión», entonces ve «Correo o contraseña incorrectos» y sigue en la pantalla de inicio de sesión.
- **CA-4** Dado una cuenta desactivada, cuando intenta iniciar sesión con datos correctos, entonces ve «Tu cuenta está desactivada» y no entra.
- **CA-5** Dado que no ha iniciado sesión, cuando intenta abrir la lista de anuncios, entonces ve la pantalla de inicio de sesión y ningún anuncio.
- **CA-6** Dado un empleado con sesión iniciada, cuando pulsa «Cerrar sesión», entonces ve la pantalla de inicio de sesión y, al volver atrás, no ve anuncios.
- **CA-7** (Deseable) Dado un empleado con sesión iniciada, cuando pasan 30 minutos sin actividad, entonces el sistema cierra la sesión y muestra «Tu sesión se cerró por inactividad».
- **CA-8** Dado que falla la conexión, cuando pulsa «Iniciar sesión», entonces ve «No se pudo iniciar sesión. Revisa tu conexión e inténtalo de nuevo» y su correo sigue escrito.

## Fuera de alcance

- Registro libre de cuentas.
- Recuperar la contraseña.
- Cambiar la contraseña desde la cuenta.

## Preguntas abiertas

- ¿Se inicia sesión con correo y contraseña u otro medio?
- ¿Se necesita recuperar la contraseña en el MVP?

## Historial

- 0.1.1 · 2026-11-06 · La sesión por inactividad y el tiempo de inicio de sesión quedan como deseables, igual que sus requisitos.
- 0.1.0 · 2026-11-06 · Primera versión.
