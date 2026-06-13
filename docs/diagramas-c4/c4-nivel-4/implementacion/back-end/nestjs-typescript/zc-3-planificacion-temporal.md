# ZC-3 — Planificación temporal (NestJS)

**Canónico:** [zc-3-planificacion-temporal.md](../../../pseudocodigo/zc-3-planificacion-temporal.md)  
**Código:** `implementacion/back-end/nestjs-typescript/src/domain/planificacion/`

---

## Mapeo subcomponentes → clases

| Canónico | Clase TS | Archivo |
|----------|----------|---------|
| `AgregadoPlanificacion` | `Planificacion` (entidad raíz) | `planificacion.entity.ts` |
| `InferenciaNaturaleza` | `PlanificacionNatureInference` | `nature.inference.ts` |
| `CatalogoTipoPeriodo` | `TipoPeriodoCatalog` | `tipo-periodo.catalog.ts` |
| `ValidadorConfiguracion` | `PlanificacionConfigurationValidator` | `configuration.validator.ts` |
| `GestorCambioNaturaleza` | `PlanificacionNatureChangeManager` | `nature-change.manager.ts` |

Subclases de dominio: `PlanificacionSinPlanificar`, `PlanificacionPuntual`, `PlanificacionDiaria`, `PlanificacionSemanal`, `PlanificacionMensual` en `entities/`.

---

## Application service

`PlanificacionApplicationService`:

| Método canónico | HTTP |
|---------------|------|
| `crear` | `POST /items/:itemId/planificaciones` |
| `editar` | `PUT /planificaciones/:id` |
| `listarSinPlanificar` | `GET /planificaciones/sin-planificar` (UC-03) |
| Validación UC-01.5 | `POST /planificaciones/validar` (sin persistir) |

---

## Controller y DTOs

- `PlanificacionController` + pipes `ValidationPipe` sobre DTOs de `@planificacion/shared`.
- Mapeo HTTP ↔ dominio en capa `api/mappers/planificacion.mapper.ts` (no en entidad).

---

## Puertos

`PlanificacionRepositoryPort` — implementación [zc-5-persistencia.md](../../persistencia/typescript/zc-5-persistencia.md).

Consulta ocurrencias para RT-3/RE-4: `OcurrenciaRepositoryPort.contarPorPlanificacion`.

---

## Errores RT-* y RC-*

Todos emitidos como `DomainException` con `codigo` estable; tabla en [errores-validaciones-capas.md](../../../../../arquitectura/errores-validaciones-capas.md).
