# Protocolo de trabajo por tickets

**Última actualización:** 2026-06-13

Reglas para ejecutar trabajo en Planificacion 2.0. **Ticket 000 cerrado** ([T-000#S-13](../../backlog/000-planificacion-inicial/planificacion-inicial.md), 2026-06-13). **Ticket activo: 001-bootstrap.**

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
- **Ticket 000:** plan documental Steps 1–13; **cerrado** ([T-000#S-13](../../backlog/000-planificacion-inicial/planificacion-inicial.md)). No admite subtickets de código ni bootstrap.

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

**Ticket 000** (`backlog/000-planificacion-inicial/`): planificar y definir la documentación del proyecto (Steps 1–13). Tabla pasos ↔ FAQ: [000-planificacion-inicial/README.md](../../backlog/000-planificacion-inicial/README.md). **Cerrado** ([T-000#S-13](../../backlog/000-planificacion-inicial/planificacion-inicial.md)). No admite subtickets de código.

**Tickets 001+** (bootstrap, UC, …): índice y roadmap en [backlog/README.md](../../backlog/README.md). Convención subtickets `T-NNN-xx`. **Ticket activo: 001-bootstrap.**

**FAQ vs backlog:** el FAQ del T-000 registra **decisiones de diseño** (Steps 1–13). **No** duplicar en él el listado ni el estado de tickets 001+.

---

## 8. Gestión de FAQs por ticket

### Referencias externas (FAQ y Steps) {#referencias-externas-faq-y-steps}

Fuera de la carpeta del ticket origen, usar ID con prefijo `T-NNN`:

| Tipo | ID visible (externo) | Canónico (dentro del ticket) | Destino del enlace |
|------|----------------------|------------------------------|-------------------|
| **FAQ** | `T-NNN#F-Gnn` | `FAQ-Gnn` en `dudas-y-resoluciones.md` | `backlog/NNN-…/dudas-y-resoluciones.md#faq-Gnn--…` |
| **Step** | `T-NNN#S-YY` | `Step YY:` en el plan del ticket | `backlog/NNN-…/planificacion-inicial.md#s-YY--…` |

Reglas Steps (simétricas a FAQ):

- **`S-YY`** = forma corta de Step `YY` (`S-10` ↔ Step 10), igual que **`F-Gnn`** ↔ `FAQ-Gnn`.
- Fuera de la carpeta del ticket **NNN**: no escribir «Step 10» a secas; usar **`T-NNN#S-10`** + enlace al doc canónico del ticket.
- Dentro del ticket: redacción nativa («**Step 13:** Validar…»).
- Migración masiva de refs existentes: auditoría periódica; convención documentada aquí.

Enlazar a [protocolo-commits.md](protocolo-commits.md) para ámbitos `(T-NNN#F-Gnn)` y `(T-NNN#S-YY)` en commits.

### Reglas generales (FAQ)

| Regla | Contenido |
|-------|-----------|
| FAQ 000 | Tras re-cierre Step 13: archivo **cerrado** (cabecera protocolizada); no bloquea ejecución de épicas 001+ |
| FAQ 001+ | Dudas de la épica (Abiertas y **Resueltas** conservadas como acta); numeración **FAQ-Gnn** local; grupos semánticos propios documentados en cabecera |
| Cierre de duda | Producto → actualizar `docs/` + marcar resuelta; proceso → protocolo |
| Bloqueo | Subticket bloqueado solo por FAQ **abierta del ticket activo** |
| Referencia externa | Formato **`T-NNN#F-Gnn`** (ej. `T-000#F-311`; equivale a FAQ-311 del ticket NNN) |
| Enlace en markdown | Ruta al fichero + ancla `#faq-Gnn--…`; texto visible **`T-NNN#F-Gnn`** (ticket explícito) |
| Reversión de decisión | Nueva entrada o nota: «Decisión revertida en T-NNN#F-Gnn» |

Grupos semánticos de referencia del T-000 (plantilla para épicas 001+): **0** dominio, **1** stack, **2** C4, **3** ER — ver [FAQ del T-000](../../backlog/000-planificacion-inicial/dudas-y-resoluciones.md).

### Cierre de FAQ de épica (protocolizado)

Cuando una épica **cierra** (criterios del README cumplidos + commit de cierre):

1. **Comprobar** que no quedan entradas con estado **Abierta** en `dudas-y-resoluciones.md` del ticket.
2. **Sustituir** la cabecera del fichero (o añadir bloque bajo el título `# FAQ`) por la plantilla de cierre:

```markdown
> **Ticket NNN — FAQ cerrada (YYYY-MM-DD).** Solo lectura; no admite entradas nuevas.
> Resoluciones ejecutables: ver entregables en `docs/` o README de la épica (acta histórica en este fichero).
```

- **Ticket 000:** fecha = commit que re-cierra Step 13; texto cita «Step 13».
- **Tickets 001+:** fecha = día del commit que cierra la épica.

3. **No añadir** más entradas FAQ en ese fichero; nuevas dudas de producto → `docs/` + FAQ del ticket activo.
4. **Actualizar** [historial-tickets.md](historial-tickets.md) (fecha cierre, commit) y README de la épica (estado **Cerrada**).
5. **Commit de cierre** de épica: título con ámbito `(T-NNN)`; cuerpo menciona `FAQ cerrada T-NNN`.

**Estados de FAQ por ticket:**

| Estado del fichero | Cabecera | ¿Bloquea subtickets? |
|--------------------|----------|---------------------|
| **Viva** | Sin bloque de cierre; leyenda Abierta/Resuelta | Solo entradas **Abiertas** |
| **Cerrada** | Plantilla de cierre (solo lectura) | No |

---

## Referencias

- [README.md](README.md) — índice de transversales
- [backlog/README.md](../../backlog/README.md) — índice de épicas
- [protocolo-commits.md](protocolo-commits.md) — formato de commits
- [protocolo_TODOs.md](protocolo_TODOs.md) — un commit por subticket
