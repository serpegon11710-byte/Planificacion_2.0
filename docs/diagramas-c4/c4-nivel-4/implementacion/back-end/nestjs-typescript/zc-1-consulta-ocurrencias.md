# ZC-1 — Consulta de ocurrencias (NestJS)

**Canónico:** [zc-1-consulta-ocurrencias.md](../../../pseudocodigo/zc-1-consulta-ocurrencias.md)  
**Persistencia:** [zc-5-persistencia.md](../../persistencia/typescript/zc-5-persistencia.md)  
**Código:** `implementacion/back-end/nestjs-typescript/src/domain/ocurrencia/consulta/`

---

## Mapeo subcomponentes → clases

| Canónico | Clase TS | Archivo |
|----------|----------|---------|
| `ServicioConsultaOcurrencias` | `OccurrenceQueryService` | `occurrence-query.service.ts` |
| `FiltroPlanificaciones` | `PlanificationFilter` | `planification-filter.ts` |
| `CompositorOcurrenciasEnRango` | `OccurrenceRangeComposer` | `occurrence-range.composer.ts` |
| `MotorCalculoOcurrencias` | `OccurrenceCalculationEngine` | `occurrence-calculation.engine.ts` |
| `ResolucionEstadoEfectivo` | `EffectiveStateResolver` | `effective-state.resolver.ts` |

---

## Puertos inyectados

```typescript
constructor(
  private readonly planificacionPort: PlanificacionRepositoryPort,
  private readonly ocurrenciaPort: OcurrenciaRepositoryPort,
  private readonly calculationEngine: OccurrenceCalculationEngine,
) {}
```

- Lecturas materializadas: `OcurrenciaRepositoryPort` / `OcurrenciaQueryPort` (implementación en persistencia).
- Polimorfismo patrón periódico: clases dominio `PlanificacionDiaria | Semanal | Mensual` ([modelo-clases-planificacion.md](../../../../../entidades/modelo-clases-planificacion.md)).

---

## API REST (UC-02.1, UC-02.4)

| Endpoint | Servicio |
|----------|----------|
| `GET /ocurrencias?desde&hasta` | `OccurrenceQueryService.obtenerOcurrenciasEnRango` |
| `GET /planificaciones/:id/ocurrencias/fisicas` | `listarOcurrenciasFisicas` |

Controller: `OcurrenciaController` — validación DTO (`ListarOcurrenciasInput` desde shared); errores `RANGO_FECHAS_INVALIDO`.

---

## Application layer

`PlanificacionApplicationService.listarOcurrencias` delega en `OccurrenceQueryService`; mapea `OcurrenciaVista` → `OcurrenciaOutput` (DTO shared).

---

## Tests

- Unitarios: compositor + motor con puertos mock (sin SQL).
- Casos RO-3, RO-7, RO-10 según escenarios en [ocurrencias.md](../../../../../entidades/ocurrencias.md).
