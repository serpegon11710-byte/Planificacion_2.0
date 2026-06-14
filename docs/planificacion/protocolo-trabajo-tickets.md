# Protocolo de trabajo por tickets

**Última actualización:** 2026-06-13

Reglas para ejecutar trabajo en Planificacion 2.0. Durante la reorganización del backlog, el **Ticket 000** está **en curso** (Step 13 pendiente de re-validación); el **Ticket 001** permanece bloqueado hasta el cierre del T-000.

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
- **Ticket 000:** plan documental Steps 1–13; **en curso** (Step 13 pendiente). No admite subtickets de código ni bootstrap.

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
| Duda de diseño / contrato / ER (Ticket 000) | [dudas-y-resoluciones.md](../../backlog/000-planificacion-inicial/dudas-y-resoluciones.md) (Pasos 1–13) |
| Duda durante ejecución de épica 001+ | `dudas-y-resoluciones.md` de la épica activa |
| Tarea ejecutable acotada | Subticket en la épica ([backlog/README.md](../../backlog/README.md)) |
| Cambio breaking de contrato API/DTO | FAQ del ticket + actualizar N4 shared + historial-stack |

No cerrar un subticket si queda una FAQ **abierta** que lo bloquea.

---

## 7. Separación docs/ vs backlog/

| Ubicación | Contenido |
|-----------|-----------|
| **`docs/`** | Producto: dominio, arquitectura, C4, entidades, casos de uso |
| **`docs/planificacion/`** | Transversales: [vista-general.md](vista-general.md), [protocolo-trabajo-tickets.md](protocolo-trabajo-tickets.md), [protocolo-commits.md](protocolo-commits.md), [protocolo_TODOs.md](protocolo_TODOs.md), [historial-tickets.md](historial-tickets.md) (cuando exista) |
| **`backlog/`** (raíz) | Solo **épicas** (`000`…`008`) e índice [README.md](../../backlog/README.md) |
| **`backlog/000-planificacion-inicial/`** | Ticket 000: plan documental Steps 1–13, FAQ de diseño, validación Step 13 |
| **`backlog/00N-…/`** (N ≥ 1) | Épica de implementación; detalle en cada `README.md` y subtickets `T-NNN-xx` |
| **`implementacion/`** | Código fuente |

**Referencias comunes** (no son tickets): transversales en [`docs/planificacion/`](README.md); épicas en [`backlog/README.md`](../../backlog/README.md).

**Ticket 000** (`backlog/000-planificacion-inicial/`): planificar y definir la documentación del proyecto (Steps 1–13). Tabla pasos ↔ FAQ: [000-planificacion-inicial/README.md](../../backlog/000-planificacion-inicial/README.md). **En curso** (Step 13 pendiente de re-validación). No admite subtickets de código.

**Tickets 001+** (bootstrap, UC, …): índice y roadmap en [backlog/README.md](../../backlog/README.md). Convención subtickets `T-NNN-xx`. **001 bloqueado** hasta cierre del T-000.

**FAQ vs backlog:** el FAQ del T-000 registra **decisiones de diseño** (Steps 1–13). **No** duplicar en él el listado ni el estado de tickets 001+.

---

## Referencias

- [README.md](README.md) — índice de transversales
- [backlog/README.md](../../backlog/README.md) — índice de épicas
- [protocolo-commits.md](protocolo-commits.md) — formato de commits
- [protocolo_TODOs.md](protocolo_TODOs.md) — un commit por subticket
