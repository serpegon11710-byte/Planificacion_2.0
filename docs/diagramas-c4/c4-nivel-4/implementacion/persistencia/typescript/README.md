# N4 — Persistencia (TypeScript + `pg`)

**Componente:** Capa de Persistencia  
**Tecnología:** TypeScript, `node-postgres` (`pg`)  
**Código:** [`implementacion/persistencia/typescript/`](../../../../../../implementacion/persistencia/typescript/)  
**Canónico:** [zc-5-persistencia.md](../../pseudocodigo/zc-5-persistencia.md)  
**Esquema SQL:** [bbdd/postgresql/zc-5-persistencia-esquema.md](../bbdd/postgresql/zc-5-persistencia-esquema.md)

---

## Compatibilidad

| Campo | Valor |
|-------|-------|
| Estado | **activa** |
| Contratos | puertos v1, ER v1 |
| Motor BBDD | PostgreSQL 16 (`implementacion/bbdd/postgresql/`) |

Registro global: [historial-stack.md](../../../../stack-tecnologico/historial-stack.md).

---

## Mapeo lógico → artefactos

| Canónico (ZC-5) | Artefacto TypeScript | Ruta prevista |
|-----------------|----------------------|---------------|
| `PuertoConexion` | `PgConnectionAdapter` | `src/connection/pg-connection.adapter.ts` |
| `AdaptadorBase` | `TransactionalAdapter` (mixin/base) | `src/adapters/transactional.adapter.ts` |
| `PuertoProyecto` | `ProyectoRepository` | `src/repositories/proyecto/` |
| `PuertoItem` | `ItemRepository` | `src/repositories/item/` |
| `PuertoPlanificacion` | `PlanificacionRepository` | `src/repositories/planificacion/` |
| `PuertoOcurrenciaMaterializada` | `OcurrenciaRepository` | `src/repositories/ocurrencia/` |
| `AdaptadorConsultaOcurrencias` | `OcurrenciaQueryRepository` | `src/repositories/ocurrencia/ocurrencia-query.repository.ts` |
| `MapeadorErroresTecnicos` | `PgErrorMapper` | `src/adapters/pg-error.mapper.ts` |
| Mappers dominio ↔ filas | `*Mapper` | `src/mappers/` |

Los **puertos** (interfaces) viven en Back-End: `implementacion/back-end/nestjs-typescript/src/domain/ports/`. Persistencia **implementa** esas interfaces; no las redefine.

---

## Inyección (NestJS)

En bootstrap (Ticket 001), registrar providers:

```typescript
{ provide: PROYECTO_REPOSITORY_PORT, useClass: ProyectoRepository }
// … Item, Planificacion, Ocurrencia, DatabaseConnectionPort
```

El paquete persistencia exporta clases concretas; el módulo Nest `PersistenceModule` las enlaza a tokens de puerto del dominio.

---

## Documentos N4

| ZC | Fichero |
|----|---------|
| ZC-5 | [zc-5-persistencia.md](zc-5-persistencia.md) |

---

## Referencias

- Guía agnóstica: [docs/implementacion/persistencia/](../../../../../implementacion/persistencia/)
- Contratos: [contratos-minimos.md](../../../../../arquitectura/contratos-minimos.md)
- Desacoplamiento: [desacoplamiento-componentes-contratos.md](../../../../../politicas-transversales/desacoplamiento-componentes-contratos.md)
