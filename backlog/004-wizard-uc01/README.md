# Ticket 004 — Wizard UC-01.1

**Estado:** **Pendiente**  
**Prerequisito:** Tickets 002 y 003 cerrados  
**Módulos:** Orquestador aplicación · **ZC:** ZC-4 · **UC:** UC-01.1

> Protocolo: [protocolo-trabajo-tickets.md](../protocolo-trabajo-tickets.md)

---

## Alcance

Flujo guiado **wizard** de creación de proyecto completo en una sesión:

- Orquestador transaccional: Proyecto + Item + Planificación al confirmar
- FE wizard multi-paso (reutiliza UC-01.5 para captura de planificación)
- Rollback total si falla cualquier paso al confirmar

## Fuera de alcance

- Edición posterior vía wizard (solo creación inicial)
- Lógica nueva de dominio no ya cubierta en 002/003

## Subtickets planificados

| ID | Título | Estado |
|----|--------|--------|
| T-004-01 | Orquestador wizard (ZC-4) + tests TX | pendiente |
| T-004-02 | API endpoint confirmar wizard | pendiente |
| T-004-03 | FE wizard UC-01.1 | pendiente |
| T-004-04 | Test E2E flujo feliz wizard | pendiente |

## Criterio de cierre

- [ ] Usuario completa wizard → proyecto + item + planificación persistidos atómicamente
- [ ] Fallo en confirmación → ningún dato parcial en BD

## Referencias

- [UC-01.1](../../docs/casos-uso/UC-01.1-wizard-creacion-proyecto.md)
- [zc-4-orquestacion-aplicacion.md](../../docs/diagramas-c4/c4-nivel-4/pseudocodigo/zc-4-orquestacion-aplicacion.md)
- [granularidad-modulos-negocio.md](../../docs/arquitectura/granularidad-modulos-negocio.md) § Orquestadores
