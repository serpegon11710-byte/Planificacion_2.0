# Ticket 005 — Consulta de ocurrencias (UC-02.1)

**Estado:** **Pendiente**  
**Prerequisito:** Ticket 003 cerrado  
**Módulos:** Ocurrencia (lectura) · **ZC:** ZC-1 · **UC:** UC-02.1

> Protocolo: [protocolo-trabajo-tickets.md](../protocolo-trabajo-tickets.md)

---

## Alcance

Visualización de ocurrencias planificadas en rango temporal (calendario):

- `OcurrenciaQueryPort` + implementación (ZC-1)
- Cálculo dinámico periódicas + lectura puntuales/materializadas
- API consulta por rango
- FE calendario / vista temporal (ZC-6)

## Fuera de alcance

- Modificar ocurrencias (Tickets 006–008)
- Materialización explícita al editar (Ticket 007)

## Subtickets planificados

| ID | Título | Estado |
|----|--------|--------|
| T-005-01 | Servicio consulta ZC-1 (dominio/aplicación) | pendiente |
| T-005-02 | Query repos + SQL optimizado rango | pendiente |
| T-005-03 | API GET ocurrencias por rango | pendiente |
| T-005-04 | FE calendario UC-02.1 | pendiente |
| T-005-05 | Tests RO-3 / RO-7 en consulta | pendiente |

## Criterio de cierre

- [ ] Calendario muestra ocurrencias puntuales y periódicas calculadas en rango
- [ ] Materializadas prevalecen sobre calculadas según RO-*

## Referencias

- [UC-02.1](../../docs/casos-uso/UC-02.1-visualizacion-ocurrencias.md)
- [zc-1-consulta-ocurrencias.md](../../docs/diagramas-c4/c4-nivel-4/pseudocodigo/zc-1-consulta-ocurrencias.md)
- [ocurrencias.md](../../docs/entidades/ocurrencias.md)
