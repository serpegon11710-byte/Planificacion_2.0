# Protocolo de trabajo por tickets

**Última actualización:** 2026-06-13

Reglas para ejecutar trabajo en Planificacion 2.0. Durante la reorganización del backlog, el **Ticket 000** está **en curso** (Step 13 pendiente de re-validación); el **Ticket 001** permanece bloqueado hasta el cierre del T-000. Ver [FAQ-103](../../backlog/dudas-y-resoluciones.md#faq-103--gestion-del-trabajo-por-tickets-y-carpeta-backlog).

---

## 1. Orden de lectura obligatorio

Antes de abrir un subticket de código:

1. [vista-general.md](vista-general.md) §6 — checklist de contratos.
2. Guía 12b del componente: [`docs/implementacion/`](../implementacion/).
3. N4 12a del componente: [`docs/diagramas-c4/c4-nivel-4/implementacion/`](../diagramas-c4/c4-nivel-4/implementacion/).
4. README de la épica activa (p. ej. [001-bootstrap/README.md](../../backlog/001-bootstrap/README.md)).
5. Subticket concreto (`T-001-xx.md`).

---

## 2. Convención de IDs

| Nivel | Formato | Ejemplo |
|-------|---------|---------|
| Épica | `NNN-nombre/` | `000-planificacion-inicial/`, `001-bootstrap/` |
| Subticket | `T-NNN-xx-nombre.md` | `T-001-01-monorepo-pnpm.md` |

- El prefijo `T-NNN` corresponde a la épica `NNN`.
- **Ticket 000:** plan documental Steps 1–13; **en curso** (Step 13 pendiente). No admite subtickets de código.

---

## 3. Estados

| Estado | Significado |
|--------|-------------|
| **pendiente** | Documentado; no iniciado |
| **en curso** | Desarrollo activo |
| **hecho** | Criterios de aceptación cumplidos y commit asociado |
| **bloqueado** | Dependencia externa o decisión FAQ pendiente |

Actualizar el README de la épica al cambiar estado de subtickets.

---

## 4. Plantilla de subticket

```markdown
# T-NNN-xx — Título breve

**Épica:** NNN-nombre  
**Componente:** front-end | back-end | persistencia | shared | bbdd | raíz  
**Estado:** pendiente

## Objetivo

Una frase.

## Alcance incluido

- …

## Alcance excluido

- …

## Criterios de aceptación

- [ ] …

## Referencias

- N4 / guía / ER / UC

## Dependencias

- T-NNN-yy (si aplica)
```

---

## 5. Flujo de ejecución

1. Elegir subticket **pendiente** con dependencias resueltas.
2. Marcar **en curso** en el fichero del subticket y en el README de la épica.
3. Implementar según alcance (sin ampliar negocio no acordado).
4. **Un commit por subticket** — formato según [protocolo-commits.md](protocolo-commits.md); cadencia según [protocolo_TODOs.md](protocolo_TODOs.md).
5. Marcar **hecho** y actualizar README de épica.

---

## 6. FAQ vs ticket

| Situación | Acción |
|-----------|--------|
| Duda de diseño / contrato / ER | [dudas-y-resoluciones.md](../../backlog/dudas-y-resoluciones.md) (Ticket 000, Pasos 1–13) |
| Tarea ejecutable acotada | Subticket en la épica ([backlog/README.md](../../backlog/README.md)) |
| Cambio breaking de contrato API/DTO | FAQ + actualizar N4 shared + historial-stack |

No cerrar un subticket si queda una FAQ **abierta** que lo bloquea.

---

## 7. Separación docs/ vs backlog/

| Carpeta | Contenido |
|---------|-----------|
| [`docs/`](../) | Producto: dominio, arquitectura, C4, entidades |
| [`docs/planificacion/`](README.md) | Transversales: vista-general, protocolos, historial |
| [`backlog/`](../../backlog/README.md) | Épicas 000–008 y subtickets |

---

## Referencias

- [backlog/README.md](../../backlog/README.md) — índice de épicas
- [protocolo-commits.md](protocolo-commits.md) — formato de commits
- [protocolo_TODOs.md](protocolo_TODOs.md) — un commit por subticket
- [FAQ-103](../../backlog/dudas-y-resoluciones.md#faq-103--gestion-del-trabajo-por-tickets-y-carpeta-backlog)
