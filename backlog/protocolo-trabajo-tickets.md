# Protocolo de trabajo por tickets

**Última actualización:** 2026-06-12

Reglas para ejecutar trabajo en Planificacion 2.0 tras el cierre del **Ticket 000** (documentación Steps 1–13). Ver [FAQ-103](dudas-y-resoluciones.md#faq-103--gestion-del-trabajo-por-tickets-y-carpeta-backlog).

---

## 1. Orden de lectura obligatorio

Antes de abrir un subticket de código:

1. [vista-general.md](vista-general.md) §6 — checklist de contratos.
2. Guía 12b del componente: [`docs/implementacion/`](../docs/implementacion/).
3. N4 12a del componente: [`docs/diagramas-c4/c4-nivel-4/implementacion/`](../docs/diagramas-c4/c4-nivel-4/implementacion/).
4. README de la épica activa (p. ej. [001-bootstrap/README.md](001-bootstrap/README.md)).
5. Subticket concreto (`T-001-xx.md`).

---

## 2. Convención de IDs

| Nivel | Formato | Ejemplo |
|-------|---------|---------|
| Épica | `NNN-nombre/` | `000-planificacion-inicial/`, `001-bootstrap/` |
| Subticket | `T-NNN-xx-nombre.md` | `T-001-01-monorepo-pnpm.md` |

- El prefijo `T-NNN` corresponde a la épica `NNN`.
- **Ticket 000:** cerrado; no admite subtickets de código.

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
4. **Un commit por subticket** — ver [protocolo_TODOs.md](protocolo_TODOs.md).
5. Marcar **hecho** y actualizar README de épica.

---

## 6. FAQ vs ticket

| Situación | Acción |
|-----------|--------|
| Duda de diseño / contrato / ER | Nueva o actualización en [dudas-y-resoluciones.md](dudas-y-resoluciones.md) (FAQ) |
| Tarea ejecutable acotada | Subticket en la épica correspondiente |
| Cambio breaking de contrato API/DTO | FAQ + actualizar N4 shared + historial-stack |

No cerrar un subticket si queda una FAQ **abierta** que lo bloquea.

---

## 7. Separación docs/ vs backlog/

| Carpeta | Contenido |
|---------|-----------|
| [`docs/`](../docs/) | Producto: dominio, arquitectura, C4, entidades |
| [`backlog/`](README.md) | Trabajo: épicas, subtickets, protocolos |

---

## Referencias

- [README.md](README.md) — índice de épicas
- [protocolo_TODOs.md](protocolo_TODOs.md) — formato de commits
- [FAQ-103](dudas-y-resoluciones.md#faq-103--gestion-del-trabajo-por-tickets-y-carpeta-backlog)
