# Modelo entidad-relación (ER)

**Última actualización:** 2026-06-12 (restricciones de eliminación)  
**Step:** 10

Modelo lógico de persistencia para Planificacion 2.0. Decisiones de origen: [dudas-y-resoluciones.md](../planificacion/dudas-y-resoluciones.md) (FAQ-002, 004, 105, 106, 108) y entidades en esta carpeta.

**Notas transversales:**

- Fechas y horas en **UTC** (FAQ-002). El formateo a locale es responsabilidad de la capa de presentación.
- Tipos físicos concretos (`TIMESTAMPTZ`, etc.) se fijan en Step 11 al elegir motor de BBDD.
- Registros **anulados** (`anulada = true`) conservan historial al cambiar de tabla en transiciones RT-1 / RT-3.

---

## Diagrama ER

```mermaid
erDiagram
    Proyectos ||--o{ Items : "1:N CASCADE"
    Items ||--o{ PlanificacionesPuntuales : "1:N CASCADE"
    Items ||--o{ PlanificacionesPeriodicas : "1:N CASCADE"

    TipoPlanificacion ||--o{ PlanificacionesPuntuales : "tipo"
    TipoPlanificacion ||--o{ PlanificacionesPeriodicas : "tipo"

    PlanificacionesPeriodicas ||--o{ PlanificacionesPeriodicasDiasSemana : "0:N CASCADE"
    PlanificacionesPuntuales ||--o{ OcurrenciasMaterializadas : "0:N CASCADE"
    PlanificacionesPeriodicas ||--o{ OcurrenciasMaterializadas : "0:N CASCADE"

    Proyectos {
        bigint id PK
        varchar nombre UK
        text descripcion
        timestamptz fecha_creacion
    }

    Items {
        bigint id PK
        bigint proyecto_id FK
        varchar nombre
        text descripcion
    }

    TipoPlanificacion {
        smallint id PK
        varchar codigo UK
        boolean periodica "NULL=SinPlanificar"
    }

    PlanificacionesPuntuales {
        bigint id PK
        bigint item_id FK
        smallint tipo_planificacion_id FK
        boolean sin_planificar
        date fecha "UTC, si puntual"
        time hora "UTC, si puntual"
        text observaciones
        varchar estado "Pendiente|Completada"
        boolean anulada
    }

    PlanificacionesPeriodicas {
        bigint id PK
        bigint item_id FK
        smallint tipo_planificacion_id FK
        date fecha_inicio "UTC"
        date fecha_fin "UTC"
        time hora "UTC"
        varchar variante_diaria "TODOS|LUN_VIE|FIN_SEMANA, solo Diario"
        smallint dia_mes "1-31, solo Mensual"
        varchar comportamiento_mes_corto "solo Mensual"
        text observaciones
        varchar estado "Pendiente|Completada"
        boolean anulada
    }

    PlanificacionesPeriodicasDiasSemana {
        bigint planificacion_periodica_id PK_FK
        smallint dia_semana PK "1=Lun..7=Dom"
    }

    OcurrenciasMaterializadas {
        bigint id PK
        bigint planificacion_puntual_id FK "nullable"
        bigint planificacion_periodica_id FK "nullable"
        date fecha_original "UTC"
        date fecha_efectiva "UTC"
        time hora "UTC"
        text observaciones "NULL hereda"
        varchar estado "NULL hereda"
        boolean eliminada_virtual
    }
```

---

## Catálogo `TipoPlanificacion` (FAQ-106)

| `codigo` | `periodica` | Tabla |
|----------|-------------|-------|
| `Puntual` | `false` | `PlanificacionesPuntuales` (`sin_planificar = false`) |
| `SinPlanificar` | `NULL` | `PlanificacionesPuntuales` (`sin_planificar = true`) |
| `Diario` | `true` | `PlanificacionesPeriodicas` |
| `Semanal` | `true` | `PlanificacionesPeriodicas` + `PlanificacionesPeriodicasDiasSemana` |
| `Mensual` | `true` | `PlanificacionesPeriodicas` |

---

## Reglas de eliminación

### Propósito de RE-3 y RE-4

Evitar **borrados masivos accidentales** de datos que deben persistir: una planificación marcada como Completada, o el historial de ocurrencias que el usuario gestionó de forma individual. Por eso **no** se puede eliminar ninguna planificación en esas condiciones — ni desde UC-01.4 ni como paso intermedio al borrar un item o un proyecto.

**Consecuencia:** la eliminación de un **item** (UC-01.3) o de un **proyecto** (UC-01.2) queda **bloqueada** mientras alguna planificación del ámbito incumpla RE-3 o RE-4. El usuario debe revertir la situación manualmente con UC-01.4 (cambiar estado) y UC-02.4 (anular o restaurar ocurrencias gestionadas); solo entonces puede completarse el borrado.

### RE-3 y RE-4 — guardas (bloquean siempre)

| Regla | Bloquea si… | Reversión manual del usuario |
|-------|---------------|------------------------------|
| **RE-3** | `estado = 'Completada'` | UC-01.4 — editar planificación y pasar a Pendiente |
| **RE-4** | Existe ≥1 fila en `OcurrenciasMaterializadas` (modificada **o** `eliminada_virtual = true`) | UC-02.4 — anular o restaurar cada registro hasta vaciar la planificación |

Estas guardas se evalúan **antes** de borrar cada planificación, incluida la cascada desde item o proyecto. Si fallan, la operación entera se rechaza (sin borrado parcial).

**RN-4.2** (no eliminar la última planificación del item) aplica solo a UC-01.4, no al borrado del item entero.

### RE-1 y RE-2 — cascada solo tras cumplir RE-3 y RE-4

Cuando **todas** las planificaciones del ámbito satisfacen RE-3 y RE-4, la eliminación de proyecto o item es **atómica** y la cascada FK borra en una sola transacción:

| Origen | Destino | Regla |
|--------|---------|-------|
| `Proyectos` | `Items` | RE-1 |
| `Items` | `PlanificacionesPuntuales`, `PlanificacionesPeriodicas` | RE-2 |
| `PlanificacionesPeriodicas` | `PlanificacionesPeriodicasDiasSemana` | Días de semana |
| Planificación | `OcurrenciasMaterializadas` | Solo si RE-4 ya cumplida (sin filas) |

### RE-5 — Aviso inequívoco al bloquear borrado de item o proyecto

Al rechazar UC-01.2 o UC-01.3 por RE-3 y/o RE-4, el sistema **debe** informar al usuario de **todas** las planificaciones que impiden el borrado, sin mensajes genéricos.

| Requisito | Regla |
|-----------|-------|
| Alcance | Listar **cada** planificación bloqueante del ámbito (todo el proyecto en UC-01.2; solo el item en UC-01.3) |
| Identificación | Por entrada: **`IdentificablePorUsuario`** de la planificación (ver [planificaciones.md](planificaciones.md)) |
| Motivo por entrada | Indicar si bloquea por **Completada** (RE-3), por **ocurrencias gestionadas** (RE-4) o por **ambos** |
| Detalle RE-4 | Incluir el **número** de ocurrencias materializadas cuando aplique |
| Agregación | Una sola respuesta con la lista completa; no fallar solo en la primera planificación encontrada |

Estructura lógica del detalle (API / capa de aplicación): ver `BloqueoEliminacionPlanificacion` en [errores-validaciones-capas.md](../arquitectura/errores-validaciones-capas.md).

Códigos de error: `ELIMINACION_PROYECTO_BLOQUEADA`, `ELIMINACION_ITEM_BLOQUEADA` (con payload de bloqueos). UC-01.4 mantiene `PLANIFICACION_COMPLETADA_NO_ELIMINABLE` y `PLANIFICACION_CON_OCURRENCIAS_NO_ELIMINABLE` para una sola planificación.

FAQs de uso: [FAQ.md](../../FAQ.md). Pseudocódigo: [zc-5-persistencia.md](../diagramas-c4/c4-nivel-4/pseudocodigo/zc-5-persistencia.md).

---

## Restricciones e índices

### `Proyectos`

| Restricción | Regla |
|-------------|-------|
| `UNIQUE (nombre)` | RP-1 |

### `Items`

| Restricción | Regla |
|-------------|-------|
| `UNIQUE (proyecto_id, nombre)` | RI-1 |
| `FK proyecto_id → Proyectos ON DELETE CASCADE` | RE-1, RI-6 |

### `PlanificacionesPuntuales`

| Restricción | Regla |
|-------------|-------|
| `FK item_id → Items ON DELETE CASCADE` | RE-2 |
| `CHECK (sin_planificar = true OR (fecha IS NOT NULL AND hora IS NOT NULL))` | Puntual exige fecha/hora |
| `CHECK (sin_planificar = false OR (fecha IS NULL AND hora IS NULL))` | Sin planificar sin fechas |
| `CHECK (sin_planificar = false OR observaciones IS NOT NULL)` | RC-8: observaciones obligatorias en Sin planificar |
| `UNIQUE (item_id, observaciones)` parcial | RC-8: `WHERE sin_planificar = true` |
| `FK tipo_planificacion_id` | Solo tipos `Puntual` o `SinPlanificar` |
| Eliminación | RE-3, RE-4 (siempre; ver sección anterior) |
| Índice parcial | `(item_id) WHERE sin_planificar = true` para UC-03 |

### `PlanificacionesPeriodicas`

| Restricción | Regla |
|-------------|-------|
| `FK item_id → Items ON DELETE CASCADE` | RE-2 |
| `CHECK (fecha_fin > fecha_inicio)` | RC-2 |
| `FK tipo_planificacion_id` | Solo `Diario`, `Semanal`, `Mensual` |
| `CHECK variante_diaria` | Obligatorio si tipo = Diario; NULL si no |
| `CHECK dia_mes` | Obligatorio si tipo = Mensual; entre 1 y 31 |
| `CHECK comportamiento_mes_corto` | Obligatorio si `dia_mes > 28` y tipo = Mensual |
| Eliminación | RE-3, RE-4 (siempre; ver sección anterior) |

### `PlanificacionesPeriodicasDiasSemana`

| Restricción | Regla |
|-------------|-------|
| `FK planificacion_periodica_id ON DELETE CASCADE` | Cascada desde planificación periódica |
| Al menos un día | Obligatorio si tipo = Semanal (validación de negocio) |
| `dia_semana` | 1–7 (lunes–domingo) |

### `OcurrenciasMaterializadas` (FAQ-004)

| Restricción | Regla |
|-------------|-------|
| `FK` planificación `ON DELETE CASCADE` | Solo tras validar RE-4; la guarda bloquea cualquier borrado de planificación mientras existan filas |
| `CHECK` XOR FK | Exactamente una de `planificacion_puntual_id` o `planificacion_periodica_id` |
| `UNIQUE (planificacion_periodica_id, fecha_original)` | RO-3, RO-5 (precedencia por fecha original) |
| `UNIQUE (planificacion_puntual_id, fecha_original)` | Idem para puntual si aplica materialización |
| `observaciones`, `estado` NULL | Herencia visible; se persisten al interactuar (FAQ-004) |
| `eliminada_virtual` | RO-4; cuenta para RE-4 aunque la ocurrencia esté «eliminada» |

---

## Relaciones resumidas

```
Proyectos 1──N Items                          ON DELETE CASCADE (RE-1)
Items 1──N PlanificacionesPuntuales           ON DELETE CASCADE (RE-2)
Items 1──N PlanificacionesPeriodicas          ON DELETE CASCADE (RE-2)
TipoPlanificacion 1──N PlanificacionesPuntuales | Periodicas
PlanificacionesPeriodicas 1──N PlanificacionesPeriodicasDiasSemana   CASCADE
PlanificacionesPuntuales 1──N OcurrenciasMaterializadas   RE-4 bloquea borrado; CASCADE solo si guarda superada
PlanificacionesPeriodicas 1──N OcurrenciasMaterializadas    idem
```

---

## Referencias

- [proyectos.md](proyectos.md), [items.md](items.md), [planificaciones.md](planificaciones.md), [ocurrencias.md](ocurrencias.md)
- [internacionalizacion.md](../politicas-transversales/internacionalizacion.md) — UTC almacenamiento vs locale UI
