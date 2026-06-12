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

- Observaciones (**obligatorias**; únicas por item — RC-8)

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

Definición canónica: [modelo-entidad-relacion.md](modelo-entidad-relacion.md).

Dos tablas hijas por naturaleza temporal (FAQ-105). Campos comunes (`item_id`, `tipo_planificacion_id`, `observaciones`, `estado`, `anulada`) en cada tabla.

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

## IdentificablePorUsuario

Característica de la entidad Planificación: conjunto de atributos que permiten al usuario **distinguir sin ambigüedad** una planificación concreta dentro del proyecto. Se usa en listados, mensajes de error (RE-5), avisos de bloqueo al eliminar item/proyecto y cualquier UI que deba referirse a «cuál» planificación.

La identificación **siempre** incluye el **proyecto** y el **item** de pertenencia (resueltos a nombre visible en la capa de presentación).

| Naturaleza | Componentes de `IdentificablePorUsuario` |
|------------|------------------------------------------|
| **Periódica** | Proyecto + Item + **Subtipo** (`Diario` \| `Semanal` \| `Mensual`) + Observaciones + Fecha inicio + Fecha fin + Hora |
| **Puntual** | Proyecto + Item + **Tipo** (`Puntual`) + Observaciones + Fecha + Hora |
| **Sin planificar** | Proyecto + Item + **Tipo** (`Sin planificar`) + Observaciones |

Notas:

- **Subtipo** en periódica es el código de catálogo `Diario`, `Semanal` o `Mensual`, no el flag `periodica` de `TipoPlanificacion`.
- **Tipo** en puntual y sin planificar es el código de catálogo `Puntual` o `SinPlanificar`.
- Fechas y hora se muestran en el **locale** del usuario; en persistencia están en UTC (FAQ-002).
- La capa de negocio expone `construirIdentificablePorUsuario(planificacion) -> IdentificablePorUsuario`; Presentación formatea el texto visible a partir de esa estructura (ZC-6).

Ejemplo de texto formateado (orientativo):

- Periódica: `Proyecto «Marketing» · Item «Q1» · Semanal · «Reunión seguimiento» · 01/03/2026–31/12/2026 · 10:00`
- Puntual: `Proyecto «Marketing» · Item «Q1» · Puntual · «Entrega informe» · 15/06/2026 · 18:00`
- Sin planificar: `Proyecto «Marketing» · Item «Q1» · Sin planificar · «Backlog diseño»`

---

## Reglas Comunes de Configuración

### RC-1: Aplicación de reglas por tipo

Cada tipo y variante aplica únicamente sus propias reglas de configuración.

### RC-2: Validación de rango temporal

Cuando exista fecha inicio/fin, la fecha fin debe ser posterior a la fecha inicio.

### RC-3: Validación de consistencia

La configuración debe ser válida y permitir generar al menos una ocurrencia para los tipos que generan ocurrencias (Puntual y Periódica), según su configuración y rango cuando aplique.

### RC-4: Mantenimiento planificaciones

La creación/modificación de planificaciones no gestiona ocurrencias individuales; solo persiste la planificación base. **Excepción:** UC-01.4 permite editar el **estado** de la planificación (Pendiente ↔ Completada) como parte de la configuración.

### RC-5: Evolución del catálogo

Nuevos tipos o variantes deben incorporarse en este documento y en `TipoPlanificacion`, y luego ser consumidos por los casos de uso.

### RC-6: Eliminación de planificación restringida

**Propósito:** evitar borrados masivos accidentales de planificaciones Completadas o de historial de ocurrencias gestionadas. RE-3 y RE-4 bloquean **cualquier** borrado de planificación en esas condiciones, lo que a su vez **bloquea** la eliminación del item o proyecto que la contiene.

No se puede eliminar una planificación — ni en UC-01.4 ni como paso de cascada al eliminar item o proyecto — si:

1. **`estado = Completada`** (RE-3) — el usuario debe editarla manualmente en UC-01.4 y pasarla a Pendiente.
2. **Existen ocurrencias materializadas** vinculadas (RE-4), ya sean modificadas o con `eliminada_virtual = true` — el usuario debe anular o restaurar cada registro en UC-02.4 hasta vaciar la planificación.

Solo cuando todas las planificaciones del ámbito cumplen RE-3 y RE-4 puede completarse la eliminación del item (RI-5) o del proyecto (RP-4).

### RC-7: Aviso al bloquear borrado de item o proyecto (RE-5)

Si UC-01.2 o UC-01.3 rechazan el borrado, el sistema debe mostrar **todas** las planificaciones bloqueantes usando su **`IdentificablePorUsuario`** más el motivo de bloqueo. Códigos `ELIMINACION_PROYECTO_BLOQUEADA` / `ELIMINACION_ITEM_BLOQUEADA` — ver [errores-validaciones-capas.md](../arquitectura/errores-validaciones-capas.md).

### RC-8: Unicidad de observaciones en Sin planificar

Las **observaciones** de las planificaciones **Sin planificar** del mismo item deben ser **únicas** dentro de ese item (`UNIQUE (item_id, observaciones)` con `sin_planificar = true`).

- Aplica en creación y edición (UC-01.4 / UC-01.5).
- Las observaciones son obligatorias en Sin planificar para garantizar identificación y unicidad (la creación automática de item usa el nombre del item).
- Código de error orientativo: `PLANIFICACION_SIN_PLANIFICAR_OBSERVACIONES_DUPLICADAS`.

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
