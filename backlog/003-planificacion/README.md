# Ticket 003 — Planificación

**Estado:** **Pendiente**  
**Prerequisito:** Ticket 002 cerrado  
**Módulos:** Planificación · **ZC:** ZC-3 · **UC:** UC-01.4, UC-01.5, UC-03

> Protocolo: [protocolo-trabajo-tickets.md](../protocolo-trabajo-tickets.md)

---

## Alcance

Módulo **Planificación** completo (puntual, periódica, Sin planificar):

- Dominio + reglas RT-* / RC-* / cambio de tipo (ZC-3)
- UC-01.5: componente FE de captura/validación (**sin persistir**)
- UC-01.4: CRUD planificación con persistencia
- UC-03: listado de planificaciones Sin planificar
- API + pantallas FE asociadas

## Fuera de alcance

- Wizard multi-paso (Ticket 004)
- Cálculo/materialización de ocurrencias (Tickets 005–007)

## Subtickets planificados

| ID | Título | Estado |
|----|--------|--------|
| T-003-01 | Dominio Planificación + inferirClase (ZC-3) | pendiente |
| T-003-02 | Repos Planificación / PlanificacionPeriodo | pendiente |
| T-003-03 | API planificaciones | pendiente |
| T-003-04 | Componente FE UC-01.5 (captura) | pendiente |
| T-003-05 | Pantallas UC-01.4 (gestión) | pendiente |
| T-003-06 | Pantalla UC-03 (listar Sin planificar) | pendiente |
| T-003-07 | i18n tipos y errores planificación | pendiente |
| T-003-08 | Tests reglas RT/RC críticas | pendiente |

## Criterio de cierre

- [ ] Crear/editar/eliminar planificaciones de los tres tipos según entidades
- [ ] UC-01.5 reutilizable desde formularios de UC-01.4
- [ ] UC-03 lista Sin planificar con filtros acordados

## Referencias

- [UC-01.4](../../docs/casos-uso/UC-01.4-gestion-planificacion.md), [UC-01.5](../../docs/casos-uso/UC-01.5-captura-datos-planificacion.md), [UC-03](../../docs/casos-uso/UC-03-listar-sin-planificar.md)
- [zc-3-planificacion-temporal.md](../../docs/diagramas-c4/c4-nivel-4/pseudocodigo/zc-3-planificacion-temporal.md)
- [planificaciones.md](../../docs/entidades/planificaciones.md)
