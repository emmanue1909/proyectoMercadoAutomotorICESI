# Reporte de specs · Plataforma inteligente para el análisis del mercado automotor colombiano

Fecha: 2026-11-06 · Revisado: prd 0.1.0 · requisitos 0.2.0 · spine 0.1.1 · 6 specs (F-01 0.1.1, F-02 0.1.0, F-03 0.2.0, F-04 0.1.1, F-05 0.1.1, F-06 0.1.1)

## Métricas

- **Completitud** (verde): 26/26 · 100 %
- **Trazabilidad** (verde): RF → objetivo 26/26 · 100 %; spec → RF 6/6 · 100 %
- **Verificabilidad** (verde): 55/55 · 100 %; ninguna spec sin criterios
- **Ambigüedad** (verde): 0
- **Consistencia** (verde): 0
- **Atomicidad** (verde): 0
- **Pureza funcional** (verde): 0
- **Preguntas abiertas:** 17 (F-01: 2, F-02: 3, F-03: 3, F-04: 4, F-05: 3, F-06: 2); eran 18 en la revisión anterior
- **Avance de implementación:** todo en borrador (0 aprobadas, 0 implementadas)
- **Estabilidad:** sin cambios mayores (F-03 subió una versión menor, a 0.2.0)

## Correcciones propuestas

Las 3 correcciones de la revisión anterior ya se aplicaron:

1. **F-03 · Criterios CA-1, CA-5 y CA-7:** reescritos con un resultado que el empleado ve (buscar un anuncio nuevo, total sin filtros, dato del publicador que no aparece en la ficha).
2. **F-01, F-03, F-04, F-05 y F-06 · Reglas:** el cierre de sesión a los 30 minutos, el mínimo de 1.000 anuncios y los tiempos de respuesta quedan marcados como *Deseable*, igual que la prioridad de sus requisitos.
3. **F-03 y requisitos · Anuncios repetidos:** se agregó RF-26, que F-03 cubre con una regla, un flujo alterno (A3), el identificador del portal en *Datos* y el criterio CA-8. Con eso F-03 coincide con AD-07 de la spine.

No hay correcciones nuevas. Lo que sigue pendiente son las preguntas abiertas.

## Lo que está bien

- Los 26 RF tienen spec y las 6 specs citan RF; ningún objetivo del PRD queda sin requisito.
- Los 55 criterios tienen la forma Dado / cuando / entonces y un resultado visible; cada flujo y cada estado de error tiene el suyo.
- Ninguna spec nombra tecnología ni usa palabras vagas.
- Las specs no contradicen entre sí, ni a los requisitos ni a la spine.
- «No disponible» y las unidades (COP, km) se tratan igual en F-04, F-05 y F-06, y coinciden con AD-05.
- Los títulos de F-01, F-03 y F-04 llevan «y», pero cada una describe un solo recorrido con pasos que dependen uno del otro.

## Notas del cálculo

- Criterios por spec: F-01 8, F-02 9, F-03 8, F-04 12, F-05 9, F-06 9 = 55.
- Los RNF no entran en la completitud. Ninguna spec cubre RNF-01 (idioma), RNF-02 (dispositivos) ni RNF-06 (peso de la primera pantalla); son transversales.
- Las fotos de perfil que la spine pone en Storage no las cubre ningún requisito ni spec (pendiente decidir si se retiran).
- Los anuncios que el portal retira siguen sin requisito (pregunta abierta en F-03, F-05 y `requisitos.md`).
- No existe `docs/modelo.md`, así que no se revisó la consistencia contra él.
