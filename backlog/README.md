# Backlog — Gestión del trabajo

**Última actualización:** 2026-06-13

Índice de **tickets y épicas** de Planificacion 2.0. La documentación de producto (dominio, arquitectura, C4) permanece en [`docs/`](../docs/). Protocolos, vista general e historial: [`docs/planificacion/`](../docs/planificacion/README.md) ([historial-tickets.md](../docs/planificacion/historial-tickets.md)).

> **Leer primero:** [protocolo-trabajo-tickets.md](../docs/planificacion/protocolo-trabajo-tickets.md) · [vista-general.md](../docs/planificacion/vista-general.md)

---

## Qué documento usar

| Necesitas… | Lee… |
|------------|------|
| Decisiones de diseño del T-000 (Steps 1–13) | [000-planificacion-inicial/dudas-y-resoluciones.md](000-planificacion-inicial/dudas-y-resoluciones.md) |
| Pasos 1–13 del plan documental, tabla paso ↔ FAQ | [000-planificacion-inicial/README.md](000-planificacion-inicial/README.md) |
| Roadmap tickets 001+, ticket activo | **Este README** (sección Épicas) |
| Detalle de una épica (alcance, subtickets) | `00N-nombre/README.md` |
| Protocolo de ejecución, commits, historial | [docs/planificacion/README.md](../docs/planificacion/README.md) |

---

```mermaid
flowchart LR
  T000[000 docs] --> T001[001 bootstrap]
  T001 --> T002[002 proyecto item]
  T002 --> T003[003 planificacion]
  T003 --> T004[004 wizard]
  T003 --> T005[005 consulta]
  T005 --> T006[006 puntual]
  T005 --> T007[007 periodica]
  T007 --> T008[008 por planif]
```

---

## Épicas

| ID | Carpeta | Estado | Alcance |
|----|---------|--------|---------|
| **000** | [000-planificacion-inicial/](000-planificacion-inicial/) | **En curso** | Steps 1–13: documentación y validación (Step 13 pendiente) |
| **001** | [001-bootstrap/](001-bootstrap/) | **Bloqueado** | Andamiaje ejecutable; sin negocio (hasta cierre T-000) |
| **002** | [002-proyecto-item/](002-proyecto-item/) | **Pendiente** | UC-01.2, UC-01.3 — módulos Proyecto e Item |
| **003** | [003-planificacion/](003-planificacion/) | **Pendiente** | UC-01.4, UC-01.5, UC-03 — módulo Planificación (ZC-3) |
| **004** | [004-wizard-uc01/](004-wizard-uc01/) | **Pendiente** | UC-01.1 — wizard creación (ZC-4) |
| **005** | [005-consulta-ocurrencias/](005-consulta-ocurrencias/) | **Pendiente** | UC-02.1 — calendario / consulta (ZC-1) |
| **006** | [006-gestion-puntual/](006-gestion-puntual/) | **Pendiente** | UC-02.2 — edición puntual individual |
| **007** | [007-gestion-periodica/](007-gestion-periodica/) | **Pendiente** | UC-02.3 — periódicas + materialización (ZC-2) |
| **008** | [008-gestion-por-planificacion/](008-gestion-por-planificacion/) | **Pendiente** | UC-02.4 — gestión por planificación |

---

## Ticket activo

**000-planificacion-inicial** — Step 13 pendiente de re-validación. Ver [000-planificacion-inicial/README.md](000-planificacion-inicial/README.md).

**001-bootstrap** permanece **bloqueado** hasta el cierre del T-000 (T10).
