---
id: F-02
titulo: Gestionar cuentas de empleados
version: 0.1.0
fecha: 2026-11-06
estado: borrador
autores: [Equipo del proyecto]
requisitos: [RF-19, RF-20, RF-21, RF-25]
depende_de: [F-01]
---

# F-02 · Gestionar cuentas de empleados

## Objetivo

El administrador crea, consulta, edita y desactiva las cuentas de los empleados, y comprueba que cada empleado puede entrar con la suya.

## Flujo principal

1. El administrador inicia sesión y ve la lista de empleados con su nombre, correo y estado.
2. Pulsa «Crear empleado».
3. Ingresa el nombre, el correo y una contraseña inicial de al menos 8 caracteres.
4. Pulsa «Guardar» y el sistema muestra al nuevo empleado en la lista como «Activa».
5. El empleado inicia sesión con esos datos (ver F-01).

## Flujos alternos

- **A1 · Correo repetido:** el correo ya pertenece a otra cuenta; el sistema lo avisa y no crea la cuenta.
- **A2 · Contraseña corta:** la contraseña tiene menos de 8 caracteres; el sistema lo avisa y no crea la cuenta.
- **A3 · Editar:** el administrador cambia el nombre o el correo de un empleado y guarda; la lista muestra los datos nuevos.
- **A4 · Desactivar:** el administrador desactiva una cuenta; el empleado ya no puede iniciar sesión. Puede volver a activarla.
- **A5 · Empleado en el módulo:** si un empleado intenta abrir el módulo de gestión, el sistema se lo impide.

## Reglas

- Solo el administrador crea, edita y desactiva cuentas.
- Cada correo pertenece a una sola cuenta.
- La contraseña tiene mínimo 8 caracteres.
- Desactivar una cuenta no borra al empleado de la lista; queda con estado «Desactivada».
- Nunca se muestra la contraseña de un empleado.

## Estados

- **Cargando:** la lista muestra un indicador de carga.
- **Vacío:** «Aún no hay empleados» y el botón «Crear empleado».
- **Error:** «No se pudo completar la acción» con un botón para reintentar; los datos escritos se conservan.

## Datos

- Empleado: nombre, correo, estado (activa o desactivada).

## Criterios de aceptación

- **CA-1** Dado el administrador en el módulo, cuando crea un empleado con nombre, correo nuevo y contraseña de 8 caracteres, entonces el empleado aparece en la lista con estado «Activa».
- **CA-2** Dado un empleado recién creado, cuando inicia sesión con su correo y su contraseña, entonces entra a la búsqueda de anuncios.
- **CA-3** Dado un correo que ya tiene cuenta, cuando el administrador intenta crear otra, entonces ve «Ese correo ya tiene una cuenta» y la lista no cambia.
- **CA-4** Dado una contraseña de 6 caracteres, cuando el administrador pulsa «Guardar», entonces ve «La contraseña debe tener al menos 8 caracteres» y no se crea la cuenta.
- **CA-5** Dado un empleado en la lista, cuando el administrador cambia su nombre y guarda, entonces la lista muestra el nombre nuevo.
- **CA-6** Dado un empleado activo, cuando el administrador lo desactiva, entonces su estado es «Desactivada» y al intentar iniciar sesión el empleado ve «Tu cuenta está desactivada».
- **CA-7** Dado un empleado con sesión iniciada, cuando intenta abrir el módulo de gestión, entonces ve «No tienes permiso para ver esta sección» y ninguna cuenta.
- **CA-8** Dado que no hay empleados, cuando el administrador abre el módulo, entonces ve «Aún no hay empleados» y el botón «Crear empleado».
- **CA-9** Dado que falla la conexión, cuando el administrador pulsa «Guardar», entonces ve «No se pudo completar la acción», un botón para reintentar y los datos escritos intactos.

## Fuera de alcance

- Borrar cuentas de forma definitiva.
- Gestionar portales, extracciones o modelos.
- Asignar permisos distintos a cada empleado.

## Preguntas abiertas

- ¿Puede haber más de un administrador y quién lo crea?
- ¿Quién define la contraseña inicial y cómo se la entregan al empleado?
- ¿El administrador puede reiniciar la contraseña de un empleado?

## Historial

- 0.1.0 · 2026-11-06 · Primera versión.
