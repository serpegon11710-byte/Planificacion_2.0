# ZC-2 — Materialización de ocurrencias (NestJS)

**Canónico:** [zc-2-materializacion-ocurrencias.md](../../../pseudocodigo/zc-2-materializacion-ocurrencias.md)  
**Depende de:** ZC-1 (`OccurrenceCalculationEngine` para `crearDesdeNatural`)  
**Código:** `implementacion/back-end/nestjs-typescript/src/domain/ocurrencia/materializacion/`

---

## Mapeo subcomponentes → clases

| Canónico | Clase TS | Archivo |
|----------|----------|---------|
| `EnrutadorPorNaturaleza` | `OccurrenceMutationRouter` | `occurrence-mutation.router.ts` |
| `MutadorPuntual` | `PuntualOccurrenceMutator` | `puntual.mutator.ts` |
| `MutadorPeriodico` | `PeriodicOccurrenceMutator` | `periodic.mutator.ts` |
| `MaterializadorOcurrencia` | `OccurrenceMaterializer` | `occurrence.materializer.ts` |
| `GestorEstadoOperativo` | `OperationalStateHandler` | `operational-state.handler.ts` |

---

## Flujo HTTP

| UC | Endpoint (previsto) | Router |
|----|---------------------|--------|
| UC-02.2 | `PATCH /planificaciones/:id/puntual` | → `PuntualOccurrenceMutator` (actualiza planificación, ZC-3) |
| UC-02.3 | `PATCH /planificaciones/:id/ocurrencias/:fechaOriginal` | → `PeriodicOccurrenceMutator` |
| UC-02.4 | `DELETE …`, `POST …/restaurar`, `POST …/anular` | → mutador periódico |

`OccurrenceMutationService.mutarOcurrencia` expone el punto de entrada canónico.

---

## Integración ZC-3

`PuntualOccurrenceMutator` invoca `PlanificacionConfigurationValidator` antes de `planificacionPort.guardar`.

---

## Persistencia

Escrituras vía `OcurrenciaRepositoryPort.guardar | eliminar | buscarPorFechaOriginal` — ver [zc-5-persistencia.md](../../persistencia/typescript/zc-5-persistencia.md).

---

## Errores (`codigo`)

`TIPO_SIN_OCURRENCIAS`, `OCURRENCIA_FECHA_FUERA_DE_RANGO`, `OCURRENCIA_NO_ELIMINADA`, `OCURRENCIA_NO_MODIFICADA` — propagados sin mensaje traducido (i18n en FE).
