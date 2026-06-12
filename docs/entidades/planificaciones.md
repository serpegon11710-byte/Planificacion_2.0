# Entidad: Planificaciones

**Última actualización:** 2026-06-12

---

## Propósito

Este documento define el catálogo común de tipos de planificación, sus reglas de configuración, el modelo de persistencia (ER) y las clases de dominio. Cualquier caso de uso que necesite capturar, validar o persistir planificaciones debe referenciar este documento como fuente única.

Decisiones de modelo físico y nomenclatura: [dudas-y-resoluciones.md](../planificacion/dudas-y-resoluciones.md) (FAQ-105, FAQ-106, FAQ-107).

---

## Catálogo de Tipos de Planificación

### 1. Puntual

Planificación que ocurre una única vez en una fecha y hora específica.

**Configuración requerida:**

- Fecha
- Hora
- Observaciones (opcional)

---

### 2. Periódica

Planificación que se repite según un patrón temporal.

**Configuración base requerida:**

- Fecha inicio
- Fecha fin
- Hora
- Observaciones (opcional)

#### Variantes de planificación periódica

**a) Diaria**

Subtipo **prefijado (enum)**, no lista libre (FAQ-001):

- Todos los días
- Lunes a Viernes
- Fin de semana

**b) Semanal**

- **Lista** de uno o más días de la semana (p. ej. martes y jueves en la misma planificación)

**c) Mensual**

- Día del mes (1-31)
- Para días mayores a 28, debe definirse uno de estos comportamientos cuando el mes no tenga ese día:
  - Usar el último día del mes
  - Mover al día 1 del mes siguiente
  - Omitir la ocurrencia de ese mes

---

### 3. Sin planificar

Planificación sin fecha ni hora asignada. En la UI y documentación funcional se denomina **«Sin planificar»** (FAQ-107).

**Configuración requerida:**

- Observaciones (opcional)

No genera ocurrencias.

---

## Catálogo de tipos (persistencia)

Tabla de referencia `TipoPlanificacion` (FAQ-106). El campo `periodica` distingue el almacenamiento y el motor de ocurrencias:

| Tipo (`codigo`) | `periodica` | Tabla destino |
|-----------------|-------------|---------------|
| `Puntual` | `false` | `PlanificacionesPuntuales` (`sin_planificar = false`) |
| `SinPlanificar` | `NULL` | `PlanificacionesPuntuales` (`sin_planificar = true`) |
| `Diario` | `true` | `PlanificacionesPeriodicas` |
| `Semanal` | `true` | `PlanificacionesPeriodicas` |
| `Mensual` | `true` | `PlanificacionesPeriodicas` |

Los subtipos diarios (`TODOS`, `LUN_VIE`, `FIN_SEMANA`) son configuración de la fila periódica con tipo `Diario`, no filas adicionales del catálogo.

---

## Modelo de persistencia (ER)

Dos tablas hijas por naturaleza temporal (FAQ-105). Campos comunes (item, observaciones, estado, tipo_id, etc.) en cada tabla o en cabecera compartida según diseño final del Step 10.

### `PlanificacionesPuntuales`

| Campo | Obligatorio | Notas |
|-------|-------------|-------|
| `fecha` | Si `sin_planificar = false` | UTC (FAQ-002) |
| `hora` | Si `sin_planificar = false` | UTC |
| `sin_planificar` | Si | `true` = tipo Sin planificar; `false` = Puntual con fecha/hora |

Un mismo registro puntual puede pasar de **Sin planificar** a **Puntual** (y viceversa) **mutando el flag** y los campos fecha/hora en la misma fila, sin cambiar de tabla.

### `PlanificacionesPeriodicas`

| Campo | Obligatorio | Notas |
|-------|-------------|-------|
| `fecha_inicio`, `fecha_fin`, `hora` | Si | UTC |
| Patrón según tipo | Si | Enum diario, lista días semanal, día mes + comportamiento mensual |

ZC-1 y flujos de ocurrencias operan sobre filas periódicas y puntuales con `sin_planificar = false`. UC-03 consulta puntuales con `sin_planificar = true`.

---

## Modelo de dominio (código)

En la capa de negocio existen clases especializadas que encapsulan la definición temporal; la persistencia usa las dos tablas anteriores:

| Clase de dominio | Persistencia | Notas |
|------------------|--------------|-------|
| `PlanificacionPuntual` | `PlanificacionesPuntuales` | `sin_planificar = false` |
| `PlanificacionSinPlanificar` | `PlanificacionesPuntuales` | `sin_planificar = true` |
| `PlanificacionPeriodica` | `PlanificacionesPeriodicas` | Subtipos Diario / Semanal / Mensual |

`PlanificacionSinPlanificar` no implica una tercera tabla: es la representación de dominio del flag `sin_planificar` en la tabla puntual.

---

## Estado de Planificación

Las planificaciones tienen estado base de negocio:

- **Pendiente**
- **Completada**

Este estado puede ser utilizado por las ocurrencias cuando una ocurrencia no tenga estado propio registrado (FAQ-003, FAQ-004).

---

## Reglas Comunes de Configuración

### RC-1: Aplicación de reglas por tipo

Cada tipo y variante aplica únicamente sus propias reglas de configuración.

### RC-2: Validación de rango temporal

Cuando exista fecha inicio/fin, la fecha fin debe ser posterior a la fecha inicio.

### RC-3: Validación de consistencia

La configuración debe ser válida y permitir generar al menos una ocurrencia para los tipos que generan ocurrencias (Puntual y Periódica), según su configuración y rango cuando aplique.

### RC-4: Mantenimiento planificaciones

La creación/modificación de planificaciones no gestiona ocurrencias individuales; solo persiste la planificación base.

### RC-5: Evolución del catálogo

Nuevos tipos o variantes deben incorporarse en este documento y en `TipoPlanificacion`, y luego ser consumidos por los casos de uso.

---

## Reglas de Cambio de Tipo de Planificación

### RT-1: Sin planificar hacia Puntual o Periódica

- **Sin planificar → Puntual:** misma tabla `PlanificacionesPuntuales`: `sin_planificar = false` y completar fecha/hora. Estado Pendiente.
- **Sin planificar → Periódica:** **anular** el registro en `PlanificacionesPuntuales` y **crear** registro en `PlanificacionesPeriodicas` con la configuración destino. **No afecta a ocurrencias** (no existían).

### RT-2: Puntual hacia Sin planificar

Solo si estado **Pendiente**. Misma tabla: `sin_planificar = true` y limpiar fecha/hora (o dejarlas ignoradas).

### RT-3: Periódica hacia Sin planificar

Precondiciones (sin cambio funcional):

- Estado **Pendiente**
- No existen ocurrencias materializadas de modificación ni eliminación

Operación: **anular** registro en `PlanificacionesPeriodicas` y **crear** registro en `PlanificacionesPuntuales` con `sin_planificar = true`.

### RT-4: Cambios no permitidos entre Puntual y Periódica

No se permite cambiar el tipo de planificación entre **Puntual** y **Periódica** en ningún sentido (salvo vía Sin planificar como estado intermedio implícito en RT-1 / RT-3).

### RT-5: Cambios no permitidos de subtipo periódico

No se permite modificar el subtipo de una planificación **Periódica** (Diaria, Semanal o Mensual) una vez creada.

---

## Uso por Casos de Uso

- UC-01.5 debe usar este documento para captura y validación, sin redefinir tipos internamente.
- UC-01.4 debe persistir la configuración resultante sin redefinir el catálogo.
- UC-03 lista planificaciones con `sin_planificar = true` (tipo Sin planificar).
- UC-01.2 y UC-01.3 deben referenciar [proyectos.md](proyectos.md) e [items.md](items.md) para reglas de unicidad y efectos automáticos.
- Cualquier otro caso de uso que opere con planificaciones debe referenciar este catálogo común.

---

## Trazabilidad C4

| Zona crítica N4 | Rol |
|-----------------|-----|
| [ZC-3](../diagramas-c4/c4-nivel-4/pseudocodigo/zc-3-planificacion-temporal.md) | Validación, catálogo, cambios de tipo (RT-*) |
| [ZC-5](../diagramas-c4/c4-nivel-4/pseudocodigo/zc-5-persistencia.md) | Persistencia en tablas puntuales / periódicas |

Los casos de uso referencian zonas críticas en sus propios documentos (FAQ-104).
