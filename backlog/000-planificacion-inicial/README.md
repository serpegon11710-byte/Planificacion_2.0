# Ticket 000 — Planificación inicial

**Estado:** **Cerrada** (Step 13 re-validado, 2026-06-13)  
**Cometido:** planificar y definir la documentación del proyecto (Steps 1–13). **No incluye código ni bootstrap.**

> Las FAQ de diseño referencian pasos como **«Ticket 000 — Paso N»**. El historico FAQ **termina en el Paso 13** (FAQ cerrada). La implementacion continua en tickets **001+** — ver [backlog/README.md](../README.md).

---

## Dónde va cada cosa

| Ubicación | Qué contiene | Qué **no** contiene |
|-----------|--------------|---------------------|
| [`docs/`](../../docs/) | Producto: dominio, arquitectura, C4, entidades, casos de uso | Tickets, estado de ejecución |
| [`docs/planificacion/`](../../docs/planificacion/README.md) | Transversales: vista-general, protocolos, historial de épicas | Épicas ni subtickets |
| [`backlog/`](../) (raíz) | **Solo épicas** (`000`…`008`) e índice [README.md](../README.md) | Protocolos ni FAQ global en raíz |
| **`backlog/000-planificacion-inicial/`** (este ticket) | Plan por fases, FAQ de diseño (cerrada), validación Step 13, tabla pasos ↔ FAQ | Código, subtickets de implementación |
| [`backlog/001-bootstrap/`](../001-bootstrap/) … | Épicas de implementación (bootstrap, UC, …) | Decisiones de diseño del T-000 (→ FAQ aquí) |
| [`implementacion/`](../../implementacion/) | Código fuente | Documentación de producto |

---

## Entregables principales

| Documento | Descripción |
|-----------|-------------|
| [planificacion-inicial.md](planificacion-inicial.md) | Plan por fases y pasos 1–13 |
| [dudas-y-resoluciones.md](dudas-y-resoluciones.md) | FAQ de diseño (Steps 1–13, **cerrada**) |
| [validacion-documental-step13.md](validacion-documental-step13.md) | Informe validación global (Step 13) |

---

## Pasos del Ticket 000 (1–13) — estado y trazabilidad FAQ

**Todos cerrados** (Step 13 re-validado 2026-06-13). Detalle en [planificacion-inicial.md](planificacion-inicial.md).

| Paso | Descripción breve | FAQ / artefactos principales |
|------|-------------------|------------------------------|
| **1** | README raíz | — |
| **2** | Estructura `docs/` | — |
| **3–6** | Casos de uso UC-01, UC-02, UC-03 + índice | — |
| **7** | Modelos funcionales dominio | FAQ-000 |
| **7b** | Entidades Proyecto e Item | [FAQ-004](dudas-y-resoluciones.md#faq-004--entidades-proyecto-e-item); `docs/entidades/proyectos.md`, `items.md` |
| **8** | Diagramas C4 N1–N4 canónico | FAQ-102, 303 |
| **8b** | C4 N3 Front-End | [FAQ-200](dudas-y-resoluciones.md#faq-200--diagrama-c4-n3-para-front-end) |
| **8c** | Trazabilidad UC ↔ C4 | [FAQ-201](dudas-y-resoluciones.md#faq-201--trazabilidad-c4--casos-de-uso) |
| **9a** | Arquitectura lógica y contratos | FAQ-004, 007 |
| **9b** | Verificación transversal pre-stack | FAQ-007; `docs/politicas-transversales/` |
| **10** | Modelo entidad-relación | FAQ-001, 003, 300–311; `modelo-entidad-relacion.md`, entidades, pseudocódigo |
| **11** | Stack tecnológico | [FAQ-100](dudas-y-resoluciones.md#faq-100--motor-de-base-de-datos), [101](dudas-y-resoluciones.md#faq-101--stack-de-aplicacion), [102](dudas-y-resoluciones.md#faq-102--n4-implementacion-al-cambiar-de-tecnologia-en-un-componente); `analisis-inicial.md`, `implementacion/`, `docs/implementacion/` |
| **12a** | N4 implementación por componente | `docs/diagramas-c4/c4-nivel-4/implementacion/{componente}/{tecnologia}/` |
| **12b** | Guías agnósticas por componente | `docs/implementacion/{componente}/` |
| **13** | Validación documental global | [validacion-documental-step13.md](validacion-documental-step13.md); checklist [vista-general.md](../../docs/planificacion/vista-general.md) §6 |

> **Bootstrap:** **[Ticket 001 — bootstrap](../001-bootstrap/README.md)**.

---

## Cierre

- Step 13 re-validado (2026-06-13); FAQ del T-000 cerrada.
- Trabajo de implementación: **[Ticket 001](../001-bootstrap/README.md)** — [roadmap](../README.md#epicas).

---

## Referencias

- [vista-general.md](../../docs/planificacion/vista-general.md) §6 — checklist pre-implementación
- [dudas-y-resoluciones.md](dudas-y-resoluciones.md) — acta histórica Steps 1–13
- [protocolo-trabajo-tickets.md](../../docs/planificacion/protocolo-trabajo-tickets.md) — flujo por tickets
