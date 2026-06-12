# Entidad: Items

**Última actualización:** 2026-06-12

---

## Propósito

Este documento define el modelo funcional de **Item**, sus atributos, reglas de negocio y efectos colaterales al crear o eliminar. Es la fuente única para UC-01.1, UC-01.2, UC-01.3 y cualquier operación que gestione items dentro de un proyecto.

Registro FAQ: [dudas-y-resoluciones.md](../planificacion/dudas-y-resoluciones.md) (FAQ-005).

---

## Definición

Un **item** es una unidad de trabajo o entregable dentro de un **proyecto**. Cada item agrupa una o más **planificaciones** que definen cuándo (o si) se ejecuta el trabajo asociado.

- Todo item pertenece a **exactamente un** proyecto.
- Todo item debe tener **al menos una** planificación (garantizado por la creación automática Sin planificar al dar de alta el item).

---

## Atributos

| Atributo | Obligatorio | Notas |
|----------|-------------|-------|
| `id` | Si (persistencia) | Identificador interno |
| `proyecto_id` | Si | FK al proyecto padre |
| `nombre` | Si | Único **dentro del mismo proyecto** (RI-1) |
| `descripcion` | No | Texto libre |

La edición de un item **no modifica** las planificaciones existentes; solo actualiza nombre y descripción del item.

---

## Modelo de persistencia (orientativo)

Tabla `Items` (detalle en Step 10):

| Campo | Tipo orientativo | Restricción |
|-------|------------------|-------------|
| `id` | PK | |
| `proyecto_id` | FK → `Proyectos` | NOT NULL |
| `nombre` | texto | UNIQUE (`proyecto_id`, `nombre`) |
| `descripcion` | texto | nullable |

Relaciones:

- **Proyecto 1:N Item**
- **Item 1:N Planificación** (tablas `PlanificacionesPuntuales` y `PlanificacionesPeriodicas`; ver [planificaciones.md](planificaciones.md))

---

## Origen del item

| Origen | Caso de uso | Descripción |
|--------|-------------|-------------|
| Automático | UC-01.2 | Al crear proyecto; nombre = nombre del proyecto (RI-2) |
| Wizard | UC-01.1 | Datos capturados en la sesión del wizard |
| Manual | UC-01.3 | Usuario crea item adicional en un proyecto existente |

En los tres casos aplica la planificación Sin planificar por defecto (RI-4), salvo que UC-01.1 permita configurar otra planificación al confirmar el wizard.

---

## Operaciones

| Operación | Caso de uso | Notas |
|-----------|-------------|-------|
| Crear | UC-01.1, UC-01.2 (automático), UC-01.3 | Con planificación Sin planificar (RI-4) |
| Editar | UC-01.3 | Solo nombre y descripción |
| Eliminar | UC-01.3 | Cascada; bloqueado si es el último (RI-3) |
| Listar por proyecto | UC-01.2, UC-01.3 | Filtro por `proyecto_id` |

---

## Efectos automáticos al crear

Al persistir un **nuevo** item (manual UC-01.3, automático UC-01.2, o wizard UC-01.1), en la **misma transacción**:

1. Se vincula al `proyecto_id` indicado.
2. Se crea una **planificación Sin planificar** asociada al item.

Valores por defecto de la planificación automática:

| Campo | Valor inicial |
|-------|---------------|
| Tipo | Sin planificar (`sin_planificar = true` en `PlanificacionesPuntuales`) |
| `observaciones` | Nombre del item |
| Estado | Pendiente |

Este efecto **no** ejecuta el flujo completo de UC-01.4; el coordinador (ZC-4) persiste con `definicionSinPlanificarPorDefecto()` y observaciones = nombre del item.

---

## Reglas de negocio

### RI-1: Unicidad de nombre por proyecto

El **nombre del item** debe ser único dentro del **mismo proyecto**. Dos proyectos distintos **pueden** tener items con el mismo nombre.

Ejemplos:

| Situación | Válido |
|-----------|--------|
| Proyecto A → Item «Fase 1»; Proyecto B → Item «Fase 1» | Sí |
| Proyecto A → dos items «Fase 1» | No |

Código de error orientativo: `ITEM_NOMBRE_DUPLICADO` (ver [errores-validaciones-capas.md](../arquitectura/errores-validaciones-capas.md)).

### RI-2: Item automático al crear proyecto

Cuando se crea un proyecto (UC-01.2), el sistema genera un item con:

- `nombre` = nombre del proyecto
- `descripcion` = vacío

Detalle del agregado Proyecto: [proyectos.md](proyectos.md) (RP-2).

### RI-3: Mínimo un item por proyecto

No se puede eliminar el **último** item de un proyecto. Si el usuario intenta hacerlo, el sistema rechaza la operación e indica que debe eliminar el proyecto completo.

Código de error orientativo: `ITEM_ULTIMO_NO_ELIMINABLE`.

### RI-4: Planificación Sin planificar al crear

Toda creación de item genera una planificación **Sin planificar** en la misma transacción. No puede quedar un item sin al menos una planificación.

Relacionado con la regla de planificaciones: cada item debe poder listarse en UC-03 mientras permanezca Sin planificar.

### RI-5: Eliminación en cascada

Al eliminar un item (cuando RI-3 lo permite) se eliminan en cascada:

- Todas las **planificaciones** del item
- Todas las **ocurrencias materializadas** de esas planificaciones

La operación es **atómica**.

### RI-6: Pertenencia a proyecto existente

Todo item debe referenciar un `proyecto_id` válido. No se admite item huérfano.

---

## Uso por casos de uso

| UC | Uso de este documento |
|----|------------------------|
| UC-01.1 | Captura y creación de item en wizard; validación de nombre |
| UC-01.2 | Item automático al crear proyecto (RI-2) |
| UC-01.3 | CRUD manual; reglas RI-1 a RI-6 |
| UC-01.4 | Planificaciones adicionales o edición sobre un item existente |
| UC-03 | Filtro opcional por proyecto al listar Sin planificar |

---

## Trazabilidad C4

| Zona crítica N4 | Rol |
|-----------------|-----|
| [ZC-4](../diagramas-c4/c4-nivel-4/pseudocodigo/zc-4-orquestacion-aplicacion.md) | `CoordinadorCreacionItem`, item automático en creación de proyecto |
| [ZC-5](../diagramas-c4/c4-nivel-4/pseudocodigo/zc-5-persistencia.md) | Repositorio `Item`; `findByProyectoId` |

---

## Referencias

- Proyectos: [proyectos.md](proyectos.md)
- Planificaciones: [planificaciones.md](planificaciones.md)
- Transacciones: [transacciones-consistencia.md](../arquitectura/transacciones-consistencia.md)
