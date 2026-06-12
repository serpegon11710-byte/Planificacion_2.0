# Entidad: Ocurrencias

**Última actualización:** 2026-06-12

---

## Propósito

Este documento define el comportamiento común de las ocurrencias derivadas de planificaciones, incluyendo su cálculo, estado y reglas de modificación.

---

## Definición

Una ocurrencia es una instancia concreta en fecha/hora de una planificación.

- Las ocurrencias no se crean físicamente por defecto al crear la planificación.
- Se calculan dinámicamente a partir de la configuración de la planificación.
- Solo se materializan cuando el usuario modifica una ocurrencia específica.

---

## Casos por Tipo de Planificación

### Puntual
- Una planificación puntual tiene una única ocurrencia.
- Esa ocurrencia coincide con la planificación base.
- Modificar la ocurrencia implica modificar directamente la planificación.

### Periódica
- Una planificación periódica genera múltiples ocurrencias según su configuración.
- Las ocurrencias se calculan dinámicamente y pueden materializarse al modificarse individualmente.

### Sin planificar

- Una planificación de tipo «Sin planificar» no genera ocurrencias.
- Persistencia: `PlanificacionesPuntuales` con `sin_planificar = true` (ver [planificaciones.md](planificaciones.md)).

---

## Estados de Ocurrencia

- **Pendiente**: ocurrencia no completada.
- **Completada**: ocurrencia marcada como realizada.
- **Expirada**: ocurrencia pendiente cuya fecha/hora ya pasó (estado calculado).

El estado efectivo de una ocurrencia se resuelve así:

1. Si la ocurrencia tiene estado propio registrado, se usa ese estado.
2. Si no tiene estado propio, se usa el estado de la planificación asociada.
3. Si el estado resultante es Pendiente y la fecha/hora ya pasó, puede visualizarse como Expirada (estado calculado).

---

## Reglas Comunes

### RO-1: Cálculo dinámico
Las ocurrencias naturales se obtienen en tiempo de consulta a partir de la planificación base.

### RO-2: Materialización por modificación
Cuando una ocurrencia **periódica** se modifica de forma individual (estado, fecha, hora u observaciones), se registra en `OcurrenciasMaterializadas`. En **puntual**, la modificación individual actualiza la planificación base (UC-02.2); no hay filas materializadas.

### RO-3: Precedencia de modificaciones
Si existe modificación registrada para una fecha original, la modificación prevalece sobre la ocurrencia natural calculada.

### RO-4: Eliminación individual
Una ocurrencia puede ocultarse/eliminarse de forma individual sin eliminar la planificación base.

### RO-5: Cambio de fecha
Si una ocurrencia cambia de fecha, debe preservarse el vínculo con su fecha original para resolver precedencias correctamente.

### RO-6: Separación fecha/hora
Fecha y hora se gestionan de forma separada para permitir ajustes parciales de la ocurrencia.

### RO-7: Resolución de estado
El estado de una ocurrencia puede estar registrado en la propia ocurrencia o, en su defecto, heredarse del estado de la planificación.

---

## Uso por Casos de Uso

- UC-02 debe usar este documento para visualización y gestión de ocurrencias.
- Cualquier caso de uso que modifique ocurrencias individuales debe respetar estas reglas.
- UC-01.4 no gestiona ocurrencias individuales; solo persiste la planificación base.
- UC-02.4 permite anular modificaciones o restaurar eliminaciones virtuales en planificaciones **periódicas**; es el camino para vaciar `OcurrenciasMaterializadas` antes de eliminar la planificación, el item o el proyecto (RE-4).

---

## Modelo de persistencia (ER)

Tabla `OcurrenciasMaterializadas` — ver [modelo-entidad-relacion.md](modelo-entidad-relacion.md).

| Campo | Obligatorio | Notas |
|-------|-------------|-------|
| `planificacion_periodica_id` | Sí | FK → `PlanificacionesPeriodicas` **solo periódicas** |
| `fecha_original` | Sí | Clave de precedencia (RO-5) |
| `fecha_efectiva` | Sí | Fecha mostrada / efectiva |
| `hora` | Sí | UTC |
| `observaciones` | Nullable | NULL = hereda; se persiste al editar |
| `estado` | Nullable | NULL = hereda; se persiste al interactuar |
| `eliminada_virtual` | Sí | RO-4 |

Las ocurrencias **naturales** no se persisten; solo las **materializadas** por interacción del usuario (RO-2).

---

## Referencias

- Completado por ocurrencia vs `InstanciaPlanificacion`: [dudas-y-resoluciones.md](../planificacion/dudas-y-resoluciones.md) (FAQ-003).
