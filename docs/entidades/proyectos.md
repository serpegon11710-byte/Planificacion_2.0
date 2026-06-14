# Entidad: Proyectos

**Última actualización:** 2026-06-12

---

## Propósito

Este documento define el modelo funcional de **Proyecto**, sus atributos, reglas de negocio y efectos colaterales al crear o eliminar. Es la fuente única para UC-01.1, UC-01.2 y cualquier operación que gestione proyectos.

Registro FAQ: [dudas-y-resoluciones.md](../../backlog/000-planificacion-inicial/dudas-y-resoluciones.md) (FAQ-004).

---

## Definición

Un **proyecto** es el contenedor de nivel superior del dominio. Agrupa **items**; cada item a su vez agrupa planificaciones.

Jerarquía:

```
Proyecto
└── Item (1..N)
    └── Planificación (1..N por item)
        └── Ocurrencia (calculadas / materializadas)
```

Un proyecto siempre debe tener **al menos un item** (garantizado por la creación automática al dar de alta el proyecto).

---

## Atributos

| Atributo | Obligatorio | Notas |
|----------|-------------|-------|
| `proyecto_id` | Si (persistencia) | Identificador interno (PK; FAQ-310) |
| `nombre` | Si | Único en todo el sistema (RP-1) |
| `descripcion` | No | Texto libre |
| `fecha_creacion` | Si (persistencia) | Metadato; UTC si incluye hora (FAQ-001) |

La edición de un proyecto **no modifica** los items ni planificaciones existentes; solo actualiza nombre y descripción del proyecto.

---

## Modelo de persistencia (orientativo)

Tabla `Proyectos` — ver [modelo-entidad-relacion.md](modelo-entidad-relacion.md). Orden físico por `proyecto_id`; índice `UNIQUE (nombre)` (FAQ-308).

| Campo | Tipo orientativo | Restricción |
|-------|------------------|-------------|
| `proyecto_id` | PK | FAQ-310 |
| `nombre` | texto | UNIQUE global |
| `descripcion` | texto | nullable |
| `fecha_creacion` | timestamptz | UTC |

Relación: **Proyecto 1:N Item** (`ON DELETE CASCADE`, RE-1).

---

## Operaciones

| Operación | Caso de uso | Notas |
|-----------|-------------|-------|
| Crear | UC-01.1 (wizard), UC-01.2 | Con efectos automáticos (RP-2, RP-3) |
| Editar | UC-01.2 | Solo nombre y descripción |
| Eliminar | UC-01.2 | Cascada (RP-4) |
| Listar / consultar | UC-01.2, navegación general | Solo lectura |

---

## Efectos automáticos al crear

Al persistir un **nuevo** proyecto (UC-01.2 o confirmación del wizard UC-01.1), en la **misma transacción**:

1. Se crea un **item automático** (ver [items.md](items.md), RI-2).
2. Ese item recibe una **planificación Sin planificar** por defecto (ver [planificaciones.md](planificaciones.md)).

Valores por defecto del item automático (UC-01.2):

| Campo item | Valor inicial |
|------------|---------------|
| `nombre` | Igual al nombre del proyecto |
| `descripcion` | Vacío |

Valores por defecto de la planificación automática:

| Campo | Valor inicial |
|-------|---------------|
| Tipo | Sin planificar (fechas NULL en `Planificaciones`) |
| `observaciones` | Nombre del item |
| Estado | Pendiente |

Estos efectos **no** ejecutan los flujos completos de UC-01.3 ni UC-01.4; los coordinadores de aplicación (ZC-4) persisten directamente con valores por defecto.

---

## Reglas de negocio

### RP-1: Unicidad de nombre

El **nombre del proyecto** debe ser único en todo el sistema. No se permiten dos proyectos con el mismo nombre.

Código de error orientativo: `PROYECTO_NOMBRE_DUPLICADO` (ver [errores-validaciones-capas.md](../arquitectura/errores-validaciones-capas.md)).

### RP-2: Item automático al crear

Toda creación de proyecto genera exactamente **un item** inicial vinculado al proyecto, salvo que el wizard (UC-01.1) defina explícitamente los datos del item en la sesión antes de confirmar.

### RP-3: Planificación inicial del item automático

El item creado en RP-2 recibe una planificación **Sin planificar** en la misma unidad transaccional. No puede quedar un proyecto con item sin planificación inicial.

### RP-4: Eliminación en cascada

**RE-3 y RE-4 bloquean esta operación** mientras alguna planificación del proyecto esté Completada o tenga ocurrencias materializadas. El usuario debe revertir manualmente con UC-01.4 y UC-02.4; solo entonces puede eliminarse el proyecto.

**RE-5:** si el borrado se rechaza, el aviso debe listar **inequívocamente** cada planificación bloqueante mediante su **`IdentificablePorUsuario`** + motivo. Ver UC-01.2 FA-4, RN-2.6 y `ELIMINACION_PROYECTO_BLOQUEADA`.

Cuando se cumple la precondición, al eliminar un proyecto se borran en cascada:

- Todos los **items** del proyecto
- Todas las **planificaciones** de esos items (puntuales y periódicas)
- Todas las **ocurrencias materializadas** asociadas

La operación es **atómica** (todo o nada).

### RP-5: Mínimo un item por proyecto

Un proyecto no puede quedar sin items. La validación de «último item no eliminable» se aplica en el agregado Item (RI-3); si el usuario quiere vaciar el proyecto, debe **eliminar el proyecto** (RP-4).

---

## Uso por casos de uso

| UC | Uso de este documento |
|----|------------------------|
| UC-01.1 | Validación de nombre; creación atómica con item y planificación al confirmar |
| UC-01.2 | CRUD completo; reglas RP-1 a RP-4 |
| UC-01.3 | Referencia de pertenencia (item dentro de proyecto) |
| UC-01.4 | No opera sobre proyecto; solo valida que el item pertenezca a un proyecto existente |

Los casos de uso **no redefinen** las reglas de proyecto; referencian este documento.

---

## Trazabilidad C4

| Zona crítica N4 | Rol |
|-----------------|-----|
| [ZC-4](../diagramas-c4/c4-nivel-4/pseudocodigo/zc-4-orquestacion-aplicacion.md) | `CoordinadorCreacionProyecto`, wizard, eliminación en cascada |
| [ZC-5](../diagramas-c4/c4-nivel-4/pseudocodigo/zc-5-persistencia.md) | Repositorio `Proyecto`; transacciones |

---

## Referencias

- Items: [items.md](items.md)
- Planificaciones (tipo Sin planificar): [planificaciones.md](planificaciones.md)
- Transacciones: [transacciones-consistencia.md](../arquitectura/transacciones-consistencia.md)
