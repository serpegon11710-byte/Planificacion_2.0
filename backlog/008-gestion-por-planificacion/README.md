# Ticket 008 — Gestión por planificación (UC-02.4)

**Estado:** **Pendiente**  
**Prerequisito:** Ticket 007 cerrado  
**Módulos:** Ocurrencia · **ZC:** ZC-5 · **UC:** UC-02.4

> Protocolo: [protocolo-trabajo-tickets.md](../protocolo-trabajo-tickets.md)

---

## Alcance

Gestión de ocurrencias **físicas** de una planificación concreta (vista por planificación):

- Listar materializadas de un `planificacion_id`
- Anular/restaurar/eliminar ocurrencia a ocurrencia
- Respeto FAQ-311 en operaciones futuras de vaciado masivo (documentar límite; implementar solo individual)

## Fuera de alcance

- Feature vaciado masivo RE-4 en bloque (futura; requiere FAQ si se prioriza)

## Subtickets planificados

| ID | Título | Estado |
|----|--------|--------|
| T-008-01 | API listar ocurrencias por planificación | pendiente |
| T-008-02 | API operaciones UC-02.4 | pendiente |
| T-008-03 | FE vista por planificación | pendiente |
| T-008-04 | Tests FAQ-311 (un planificacion_id por TX) | pendiente |

## Criterio de cierre

- [ ] Usuario gestiona ocurrencias materializadas de una planificación desde vista dedicada
- [ ] Operaciones acotadas a un `planificacion_id` por transacción

## Referencias

- [UC-02.4](../../docs/casos-uso/UC-02.4-gestion-ocurrencias-por-planificacion.md)
- [FAQ-311](../dudas-y-resoluciones.md) (borrado acotado)
