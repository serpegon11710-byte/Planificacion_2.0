# N4 Shared — Contratos API, DTOs y códigos de error

Proyección TypeScript de los contratos externos. **No redefine reglas de negocio**; solo shapes compilables alineados a arquitectura.

**Fuentes canónicas:**

- [contratos-minimos.md](../../../../../arquitectura/contratos-minimos.md) §3 (servicios de aplicación)
- [errores-validaciones-capas.md](../../../../../arquitectura/errores-validaciones-capas.md) § catálogo y payload RE-5
- [internacionalizacion.md](../../../../../politicas-transversales/internacionalizacion.md) (clave i18n `error.<CODIGO>`)

**Código previsto:** `implementacion/shared/typescript/src/`

---

## 1. DTOs por servicio de aplicación

### ProyectoApplicationService

| Contrato lógico | Tipo | Fichero TS previsto |
|-----------------|------|---------------------|
| `CrearProyectoInput` | Input | `dto/proyecto/crear-proyecto.input.ts` |
| `ActualizarProyectoInput` | Input | `dto/proyecto/actualizar-proyecto.input.ts` |
| `EliminarProyectoInput` | Input | `dto/proyecto/eliminar-proyecto.input.ts` |
| `ListarProyectosInput` | Input | `dto/proyecto/listar-proyectos.input.ts` |
| `ProyectoOutput` | Output | `dto/proyecto/proyecto.output.ts` |
| `ListaProyectoOutput` | Output | `dto/proyecto/lista-proyecto.output.ts` |

### ItemApplicationService

| Contrato lógico | Tipo | Fichero TS previsto |
|-----------------|------|---------------------|
| `CrearItemInput` | Input | `dto/item/crear-item.input.ts` |
| `ActualizarItemInput` | Input | `dto/item/actualizar-item.input.ts` |
| `EliminarItemInput` | Input | `dto/item/eliminar-item.input.ts` |
| `ListarItemsInput` | Input | `dto/item/listar-items.input.ts` |
| `ItemOutput` | Output | `dto/item/item.output.ts` |
| `ListaItemOutput` | Output | `dto/item/lista-item.output.ts` |

### PlanificacionApplicationService

| Contrato lógico | Tipo | Fichero TS previsto |
|-----------------|------|---------------------|
| `CrearPlanificacionInput` | Input | `dto/planificacion/crear-planificacion.input.ts` |
| `ActualizarPlanificacionInput` | Input | `dto/planificacion/actualizar-planificacion.input.ts` |
| `EliminarPlanificacionInput` | Input | `dto/planificacion/eliminar-planificacion.input.ts` |
| `ListarSinPlanificarInput` | Input | `dto/planificacion/listar-sin-planificar.input.ts` |
| `ListarOcurrenciasInput` | Input | `dto/ocurrencia/listar-ocurrencias.input.ts` |
| `PlanificacionOutput` | Output | `dto/planificacion/planificacion.output.ts` |
| `ListaPlanificacionOutput` | Output | `dto/planificacion/lista-planificacion.output.ts` |
| `ListaOcurrenciaOutput` | Output | `dto/ocurrencia/lista-ocurrencia.output.ts` |

### OcurrenciaApplicationService

| Contrato lógico | Tipo | Fichero TS previsto |
|-----------------|------|---------------------|
| `CompletarOcurrenciaInput` | Input | `dto/ocurrencia/completar-ocurrencia.input.ts` |
| `ReabrirOcurrenciaInput` | Input | `dto/ocurrencia/reabrir-ocurrencia.input.ts` |
| `OcurrenciaOutput` | Output | `dto/ocurrencia/ocurrencia.output.ts` |

### Tipos transversales

| Contrato lógico | Fichero TS previsto |
|-----------------|---------------------|
| Paginación / filtros de lectura | `dto/common/paginacion.ts`, `dto/common/filtros.ts` |
| Rango temporal (`desde` / `hasta`) | `dto/common/rango-fechas.ts` |
| Identificadores estables | `dto/common/ids.ts` |
| Respuesta de error API (`codigo`, `campo?`) | `dto/common/error-response.ts` |

---

## 2. Catálogo de códigos de error

Exportar como `ErrorCode` (const enum o union type) en `errors/error-codes.ts`. Clave i18n en Front-End: `error.<CODIGO>`.

| Codigo | Clave i18n | Fichero / módulo |
|--------|------------|------------------|
| `PROYECTO_NOMBRE_DUPLICADO` | `error.PROYECTO_NOMBRE_DUPLICADO` | `errors/error-codes.ts` |
| `PROYECTO_NO_ENCONTRADO` | `error.PROYECTO_NO_ENCONTRADO` | idem |
| `ITEM_NOMBRE_DUPLICADO` | `error.ITEM_NOMBRE_DUPLICADO` | idem |
| `ITEM_NO_ENCONTRADO` | `error.ITEM_NO_ENCONTRADO` | idem |
| `ITEM_ULTIMO_NO_ELIMINABLE` | `error.ITEM_ULTIMO_NO_ELIMINABLE` | idem |
| `PLANIFICACION_NO_ENCONTRADA` | `error.PLANIFICACION_NO_ENCONTRADA` | idem |
| `PLANIFICACION_ULTIMA_NO_ELIMINABLE` | `error.PLANIFICACION_ULTIMA_NO_ELIMINABLE` | idem |
| `PLANIFICACION_COMPLETADA_NO_ELIMINABLE` | `error.PLANIFICACION_COMPLETADA_NO_ELIMINABLE` | idem |
| `PLANIFICACION_CON_OCURRENCIAS_NO_ELIMINABLE` | `error.PLANIFICACION_CON_OCURRENCIAS_NO_ELIMINABLE` | idem |
| `ELIMINACION_PROYECTO_BLOQUEADA` | `error.ELIMINACION_PROYECTO_BLOQUEADA` | idem + payload |
| `ELIMINACION_ITEM_BLOQUEADA` | `error.ELIMINACION_ITEM_BLOQUEADA` | idem + payload |
| `PLANIFICACION_CONFIGURACION_INVALIDA` | `error.PLANIFICACION_CONFIGURACION_INVALIDA` | idem |
| `PLANIFICACION_SIN_PLANIFICAR_OBSERVACIONES_DUPLICADAS` | `error.PLANIFICACION_SIN_PLANIFICAR_OBSERVACIONES_DUPLICADAS` | idem |
| `PLANIFICACION_CAMBIO_TIPO_NO_PERMITIDO` | `error.PLANIFICACION_CAMBIO_TIPO_NO_PERMITIDO` | idem |
| `PLANIFICACION_A_SIN_PLANIFICAR_BLOQUEADA` | `error.PLANIFICACION_A_SIN_PLANIFICAR_BLOQUEADA` | idem |
| `OCURRENCIA_NO_ENCONTRADA` | `error.OCURRENCIA_NO_ENCONTRADA` | idem |
| `OCURRENCIA_TIPO_NO_SOPORTADO` | `error.OCURRENCIA_TIPO_NO_SOPORTADO` | idem |
| `RANGO_TEMPORAL_INVALIDO` | `error.RANGO_TEMPORAL_INVALIDO` | idem |
| `ENTRADA_INVALIDA` | `error.ENTRADA_INVALIDA` | idem |
| `ERROR_INTERNO` | `error.ERROR_INTERNO` | idem |

Catálogo completo y reglas de propagación: [errores-validaciones-capas.md](../../../../../arquitectura/errores-validaciones-capas.md).

---

## 3. Payload RE-5 (bloqueos)

| Estructura lógica | Fichero TS previsto |
|-------------------|---------------------|
| `IdentificablePorUsuario` | `dto/common/identificable-por-usuario.ts` |
| `BloqueoEliminacionPlanificacion` | `dto/common/eliminacion-bloqueada.payload.ts` |
| `MotivoBloqueo` | `dto/common/motivo-bloqueo.ts` |

Usado por `ELIMINACION_PROYECTO_BLOQUEADA` y `ELIMINACION_ITEM_BLOQUEADA`. Fuente funcional: [planificaciones.md](../../../../../entidades/planificaciones.md) § IdentificablePorUsuario.

---

## 4. Reglas N4 Shared

1. No importar módulos de `back-end/`, `front-end/`, `persistencia/` ni `bbdd/`.
2. Cambios breaking en DTOs o `ErrorCode` requieren versionado de contrato (ver [historial-stack.md](../../../../../stack-tecnologico/historial-stack.md)).
3. Implementación concreta en código: Step 14 (`implementacion/shared/typescript/`).

---

## Referencias cruzadas

| Bloque | Enlace |
|--------|--------|
| Guía 12b | [docs/implementacion/shared/](../../../../../implementacion/shared/) |
| Índice N4 | [implementacion/README.md](../README.md) |
| Desambiguación rutas | [desambiguacion-implementacion.md](../../../../../politicas-transversales/desambiguacion-implementacion.md) |
