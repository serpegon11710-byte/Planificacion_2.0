# Ticket 006 — Gestión puntual individual (UC-02.2)

**Estado:** **Pendiente**  
**Prerequisito:** Ticket 005 cerrado  
**Módulos:** Planificación · **ZC:** ZC-4 (parcial) · **UC:** UC-02.2

> Protocolo: [protocolo-trabajo-tickets.md](../protocolo-trabajo-tickets.md)

---

## Alcance

Modificación individual de planificaciones **puntuales** desde el calendario (ocurrencia = planificación):

- Actualización directa en `Planificaciones` (sin materialización)
- API + acciones FE desde vista calendario
- Transacción única por operación

## Fuera de alcance

- Periódicas (Ticket 007)
- Operaciones masivas por planificación (Ticket 008)

## Subtickets planificados

| ID | Título | Estado |
|----|--------|--------|
| T-006-01 | Caso de uso editar puntual desde ocurrencia | pendiente |
| T-006-02 | API PATCH planificación puntual | pendiente |
| T-006-03 | FE acciones UC-02.2 en calendario | pendiente |
| T-006-04 | Tests integración UC-02.2 | pendiente |

## Criterio de cierre

- [ ] Editar ocurrencia puntual actualiza la planificación subyacente
- [ ] Calendario refleja cambio tras consulta (005)

## Referencias

- [UC-02.2](../../docs/casos-uso/UC-02.2-gestion-individual-planificacion-puntual.md)
