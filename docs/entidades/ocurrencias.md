# Entidad: Ocurrencias

**Última actualización:** 2026-06-12

---

## Propósito

Este documento define el comportamiento común de las ocurrencias derivadas de planificaciones, incluyendo cálculo dinámico, materialización, visibilidad y reglas de modificación.

---

## Definición

Una ocurrencia es una instancia concreta en fecha/hora de una planificación.

- Las ocurrencias **naturales** se calculan dinámicamente (no se persisten por defecto).
- Solo las **periódicas** materializan filas en `OcurrenciasMaterializadas` al interactuar el usuario.
- Las **puntuales** exponen una única ocurrencia dinámica; UC-02.2 modifica `Planificaciones`.

---

## Comportamiento por clase de planificación

Jerarquía: [modelo-clases-planificacion.md](modelo-clases-planificacion.md).

| Clase | `listarOcurrencias` |
|-------|---------------------|
| `PlanificacionSinPlanificar` | Lista vacía |
| `PlanificacionPuntual` | Un elemento dinámico con datos de `Planificaciones` |
| `PlanificacionDiaria` / `PlanificacionSemanal` / `PlanificacionMensual` | Dinámicas (`generarNaturales`) ∪ materializadas en BD |

---

## Estados de Ocurrencia

- **Pendiente** / **Completada** / **Expirada** (calculada si Pendiente y fecha pasada).

Resolución (RO-7):

1. Estado propio registrado en materializada, si existe.
2. Si no, estado de la planificación.
3. Expirada si Pendiente y fecha/hora ya pasó.

---

## Reglas Comunes

### RO-1: Cálculo dinámico
Ocurrencias naturales en tiempo de consulta.

### RO-2: Materialización por modificación
Solo **periódicas** → `OcurrenciasMaterializadas` (FK `planificacion_periodo_id`). Puntuales: mutación directa de `Planificaciones`.

### RO-3: Precedencia de modificaciones
Materializada prevalece sobre natural para la misma `fecha_original`.

### RO-4: Eliminación individual
`eliminada_virtual = true` en periódicas; cuenta para RE-4.

### RO-5: Cambio de fecha
Preservar `fecha_original` al cambiar `fecha_efectiva`.

### RO-6: Separación fecha/hora
Ajustes parciales permitidos.

### RO-7: Resolución de estado
Herencia desde planificación si NULL en materializada.

### RO-8: Fecha efectiva dentro del rango (periódicas)
No modificar una ocurrencia si la **fecha efectiva** resultante queda fuera de `[fecha_inicio, fecha_fin]` de la planificación.

### RO-9: Cambio de fechas de la planificación (periódicas)
Tras acortar el rango, las materializadas fuera de rango **permanecen en BD** pero **no son visibles ni recuperables**. Debe seguir existiendo **al menos una ocurrencia visible** (dinámica o materializada, incluidas eliminaciones virtuales registradas).

### RO-10: `fecha_original` fuera de rango, `fecha_efectiva` dentro
Ocurrencia materializada **válida y visible** en consultas del rango vigente.

---

## Visibilidad en consulta (periódicas)

Una ocurrencia materializada es **visible** en un rango `[desde, hasta]` si:

- `fecha_efectiva` intersecta el rango de consulta **y** el rango `[fecha_inicio, fecha_fin]` vigente de la planificación, **o**
- Cumple RO-10 (`fecha_original` fuera del rango vigente pero `fecha_efectiva` dentro).

Las materializadas con `fecha_efectiva` fuera del rango vigente de la planificación: **no visibles** (RO-9).

---

## Uso por Casos de Uso

- UC-02: visualización y gestión según naturaleza.
- UC-02.2: puntuales — actualizar `Planificaciones`.
- UC-02.3 / UC-02.4: periódicas — materialización y gestión por planificación.
- UC-01.4: solo planificación base; no ocurrencias individuales.
- UC-02.4: vaciar materializadas antes de eliminar planificación / item / proyecto (RE-4).

---

## Modelo de persistencia (ER)

Tabla `OcurrenciasMaterializadas` — ver [modelo-entidad-relacion.md](modelo-entidad-relacion.md).

| Campo | Obligatorio | Notas |
|-------|-------------|-------|
| `planificacion_periodo_id` | Sí | FK → `PlanificacionPeriodo` |
| `fecha_original` | Sí | RO-5 |
| `fecha_efectiva` | Sí | Visibilidad RO-8, RO-9, RO-10 |
| `hora` | Sí | UTC |
| `observaciones` | Nullable | Herencia FAQ-004 |
| `estado` | Nullable | Herencia FAQ-004 |
| `eliminada_virtual` | Sí | RO-4 |

---

## Referencias

- [modelo-clases-planificacion.md](modelo-clases-planificacion.md), [planificaciones.md](planificaciones.md)
- [dudas-y-resoluciones.md](../planificacion/dudas-y-resoluciones.md) (FAQ-003, FAQ-004)
