# Ticket 002 — Proyecto e Item

**Estado:** **Pendiente**  
**Prerequisito:** Ticket 001 cerrado  
**Módulos:** Proyecto, Item · **ZC:** ZC-5 (repos) · **UC:** UC-01.2, UC-01.3

> Protocolo: [protocolo-trabajo-tickets.md](../protocolo-trabajo-tickets.md)

---

## Alcance

Implementar los dos primeros módulos de negocio y su frontera API/FE:

- Dominio + servicios de aplicación **Proyecto** e **Item**
- Repositorios reales (sustituyen stubs de 001)
- API REST: CRUD proyecto e item
- Pantallas FE: listado/edición proyecto e item
- Efectos colaterales: crear proyecto → item + planificación Sin planificar stub mínimo; crear item → planificación Sin planificar (transacción única)

## Fuera de alcance

- Wizard (UC-01.1) — Ticket 004
- Formularios de planificación temporal (UC-01.4/01.5) — Ticket 003
- Calendario / ocurrencias — Tickets 005+

## Subtickets planificados

| ID | Título | Estado |
|----|--------|--------|
| T-002-01 | Dominio Proyecto + tests reglas | pendiente |
| T-002-02 | Dominio Item + tests reglas | pendiente |
| T-002-03 | Repos Proyecto/Item (ZC-5) | pendiente |
| T-002-04 | API Proyecto (Nest) | pendiente |
| T-002-05 | API Item (Nest) | pendiente |
| T-002-06 | Orquestación crear proyecto (item + planif. mínima) | pendiente |
| T-002-07 | Orquestación crear item (planif. mínima) | pendiente |
| T-002-08 | FE proyectos e items | pendiente |
| T-002-09 | Tests integración API Proyecto/Item | pendiente |

## Criterio de cierre

- [ ] CRUD proyecto e item vía API con reglas de negocio documentadas
- [ ] Crear proyecto/item genera planificación Sin planificar en la misma transacción
- [ ] FE operativo para UC-01.2 y UC-01.3 (modalidad manual)

## Referencias

- [UC-01.2](../../docs/casos-uso/UC-01.2-gestion-proyecto.md), [UC-01.3](../../docs/casos-uso/UC-01.3-gestion-item.md)
- [granularidad-modulos-negocio.md](../../docs/arquitectura/granularidad-modulos-negocio.md) § Proyecto, Item
- [proyectos.md](../../docs/entidades/proyectos.md), [items.md](../../docs/entidades/items.md)
