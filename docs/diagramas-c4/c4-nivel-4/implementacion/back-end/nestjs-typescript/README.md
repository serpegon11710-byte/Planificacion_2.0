# N4 — Back-End (NestJS 10 + TypeScript)

**Componente:** Back-End (API REST + dominio + aplicación)  
**Tecnología:** NestJS 10, Node 22, TypeScript 5  
**Código:** [`implementacion/back-end/nestjs-typescript/`](../../../../../../implementacion/back-end/nestjs-typescript/)  
**Canónicos:** ZC-1 … ZC-4 en [pseudocodigo/](../../pseudocodigo/)

---

## Compatibilidad

| Campo | Valor |
|-------|-------|
| Estado | **activa** |
| Contratos | API v1, puertos v1 |

Registro: [historial-stack.md](../../../../../stack-tecnologico/historial-stack.md).

---

## Capas NestJS

```
src/
├── api/                         # Controllers, DTO pipes, Swagger
│   ├── proyecto.controller.ts
│   ├── item.controller.ts
│   ├── planificacion.controller.ts
│   ├── ocurrencia.controller.ts
│   └── wizard.controller.ts
├── application/
│   ├── services/                # *ApplicationService (contratos-minimos)
│   └── orchestrators/           # ZC-4
│       ├── wizard.orchestrator.ts
│       ├── proyecto-creation.orchestrator.ts
│       └── item-creation.orchestrator.ts
└── domain/
    ├── proyecto/
    ├── item/
    ├── planificacion/           # ZC-3
    ├── ocurrencia/              # ZC-1, ZC-2
    │   ├── consulta/
    │   ├── materializacion/
    │   └── ports/
    └── ports/                   # Interfaces *RepositoryPort, DatabaseConnectionPort
```

**Regla:** dominio sin imports de `@nestjs/*` ni `pg`.

---

## Módulos Nest (previstos Ticket 001)

| Módulo | Agregados / ZC |
|--------|-----------------|
| `ProyectoModule` | Proyecto + coordinador UC-01.2 |
| `ItemModule` | Item + coordinador UC-01.3 |
| `PlanificacionModule` | ZC-3 |
| `OcurrenciaModule` | ZC-1, ZC-2 |
| `WizardModule` | ZC-4 wizard |
| `PersistenceModule` | Importa providers desde paquete persistencia |

---

## Documentos N4

| ZC | Fichero |
|----|---------|
| ZC-1 | [zc-1-consulta-ocurrencias.md](zc-1-consulta-ocurrencias.md) |
| ZC-2 | [zc-2-materializacion-ocurrencias.md](zc-2-materializacion-ocurrencias.md) |
| ZC-3 | [zc-3-planificacion-temporal.md](zc-3-planificacion-temporal.md) |
| ZC-4 | [zc-4-orquestacion-aplicacion.md](zc-4-orquestacion-aplicacion.md) |

Persistencia (ZC-5): [persistencia/typescript/zc-5-persistencia.md](../persistencia/typescript/zc-5-persistencia.md).

---

## Referencias

- Guía agnóstica: [docs/implementacion/back-end/](../../../../../implementacion/back-end/)
- Contratos API/DTO: [contratos-minimos.md](../../../../../arquitectura/contratos-minimos.md)
- Transacciones: [transacciones-consistencia.md](../../../../../arquitectura/transacciones-consistencia.md)
