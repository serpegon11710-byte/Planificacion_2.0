# ZC-4 — Orquestación multi-agregado (NestJS)

**Canónico:** [zc-4-orquestacion-aplicacion.md](../../../pseudocodigo/zc-4-orquestacion-aplicacion.md)  
**Código:** `implementacion/back-end/nestjs-typescript/src/application/orchestrators/`

---

## Mapeo subcomponentes → clases

| Canónico | Clase TS | Archivo |
|----------|----------|---------|
| `OrquestadorWizard` | `WizardOrchestrator` | `wizard.orchestrator.ts` |
| `CoordinadorCreacionProyecto` | `ProjectCreationOrchestrator` | `project-creation.orchestrator.ts` |
| `CoordinadorCreacionItem` | `ItemCreationOrchestrator` | `item-creation.orchestrator.ts` |
| `GestorTransaccion` | `TransactionManager` | `transaction.manager.ts` |

---

## `TransactionManager`

Envuelve `DatabaseConnectionPort` de persistencia:

```typescript
async executeAtomic<T>(block: (tx: Transaction) => Promise<T>): Promise<T>
```

Equivalente a `ejecutarAtomico` del canónico. Usado por los tres orquestadores.

---

## Endpoints API

| UC | Controller | Método |
|----|------------|--------|
| UC-01.1 | `WizardController` | `POST /wizard/iniciar`, `/avanzar`, `/capturar-planificacion`, `/confirmar`, `/cancelar` |
| UC-01.2 | `ProyectoController` | `POST /proyectos` → `ProjectCreationOrchestrator.crearProyectoConAcoplamiento` |
| UC-01.2 | `ProyectoController` | `DELETE /proyectos/:id` → eliminación con bloqueos RE-5 |
| UC-01.3 | `ItemController` | `POST /proyectos/:id/items` → `ItemCreationOrchestrator` |
| UC-01.3 | `ItemController` | `DELETE …/items/:id` |

Sesión wizard: almacenamiento en memoria o store efímero (Redis opcional futuro); **no** persiste hasta `confirmarWizard`.

---

## Agregados invocados

| Orquestador | Servicios dominio / aplicación |
|-------------|-------------------------------|
| Wizard | `ProyectoApplicationService`, `ItemApplicationService`, `PlanificacionApplicationService` |
| Creación proyecto | Idem + `definicionSinPlanificarPorDefecto()` |
| Creación item | `ItemApplicationService`, `PlanificacionApplicationService` |

CRUD simple de Proyecto/Item sin acoplamiento automático permanece fuera de orquestadores (UC directos).

---

## Eliminación y RE-5

Antes de TX:

```typescript
const bloqueos = await planificacionPort.listarBloqueosEliminacionProyecto(proyectoId);
if (bloqueos.length) throw new DomainException('ELIMINACION_PROYECTO_BLOQUEADA', { bloqueos });
```

Payload `bloqueos` serializado en JSON para ZC-6 / i18n.

---

## Persistencia transaccional

Todos los `executeAtomic` comparten TX vía `PgConnectionAdapter` — [zc-5-persistencia.md](../../persistencia/typescript/zc-5-persistencia.md).
