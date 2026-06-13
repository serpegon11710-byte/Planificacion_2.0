# Ticket 007 — Gestión periódica individual (UC-02.3)

**Estado:** **Pendiente**  
**Prerequisito:** Ticket 005 cerrado  
**Módulos:** Ocurrencia · **ZC:** ZC-2, ZC-4 · **UC:** UC-02.3

> Protocolo: [protocolo-trabajo-tickets.md](../protocolo-trabajo-tickets.md)

---

## Alcance

Modificación individual de ocurrencias **periódicas** con materialización cuando aplique:

- Módulo Ocurrencia (escritura)
- ZC-2 materialización + reglas RO-*
- Anular / restaurar ocurrencia materializada
- API + FE desde calendario

## Fuera de alcance

- Vaciado masivo RE-4 por planificación (Ticket 008)
- Cambio de patrón periódico completo (UC-01.4)

## Subtickets planificados

| ID | Título | Estado |
|----|--------|--------|
| T-007-01 | Dominio Ocurrencia materializada | pendiente |
| T-007-02 | ZC-2 materializar / anular / restaurar | pendiente |
| T-007-03 | Repos OcurrenciasMaterializadas | pendiente |
| T-007-04 | API UC-02.3 | pendiente |
| T-007-05 | FE acciones periódicas en calendario | pendiente |
| T-007-06 | Tests RO-3, RO-5, materialización | pendiente |

## Criterio de cierre

- [ ] Editar/anular/restaurar ocurrencia periódica persiste materialización correcta
- [ ] Consulta (005) muestra estado materializado

## Referencias

- [UC-02.3](../../docs/casos-uso/UC-02.3-gestion-individual-ocurrencias-periodicas.md)
- [zc-2-materializacion-ocurrencias.md](../../docs/diagramas-c4/c4-nivel-4/pseudocodigo/zc-2-materializacion-ocurrencias.md)
