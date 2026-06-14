# Protocolo de mensajes de commit

**Última actualización:** 2026-06-13  
**Vigente desde:** commit T1 de reorganización FAQ/backlog (Ticket 000, T-000#S-13).

Fuente única para formato de commits en Planificacion 2.0. Los planes con TODOs enlazan desde [protocolo_TODOs.md](protocolo_TODOs.md); la ejecución por tickets desde [protocolo-trabajo-tickets.md](protocolo-trabajo-tickets.md).

---

## Forma del título

```
<tipo>(<ámbito>): <resumen en imperativo>
```

Opcional: **cuerpo** breve (una o dos frases) tras una línea en blanco.

---

## Tipos `<tipo>`

| Tipo | Cuándo usarlo | Ejemplo |
|------|---------------|---------|
| **`feat`** | Nueva capacidad de producto o comportamiento visible (API, UI, regla de negocio) | `feat(T-002-04): API CRUD proyectos` |
| **`fix`** | Corrección de bug o incoherencia respecto a docs/contratos ya acordados | `fix(T-007-03): FK planificacion_id en materializadas` |
| **`docs`** | Solo documentación (`backlog/`, `docs/`); sin cambio de código ejecutable | `docs(T-000#S-13): re-validacion documental` |
| **`chore`** | Mantenimiento de repo: mover/renombrar, scripts, config; reorganización sin cambiar semántica de producto | `chore(T-000): mover FAQ a planificacion-inicial` |
| **`refactor`** | Reestructuración interna de código sin cambiar comportamiento observable ni contratos acordados | `refactor(T-001-02): extraer modulo health Nest` |
| **`test`** | Añadir o modificar pruebas (unitarias, integración, e2e) sin cambiar producción | `test(T-002-03): casos Item herencia NULL` |
| **`build`** | Cambios en compilación, dependencias, scripts de build, empaquetado o contenedores | `build(T-001-01): workspaces pnpm y scripts raiz` |

Elegir el tipo que describe el **efecto principal** del commit. Un commit no mezcla dos tipos: si hay doc + código, prevalece el del cambio dominante (`feat`/`fix`/`refactor` sobre `docs`).

---

## Ámbito `<ámbito>` (obligatorio en todo commit del repo)

| Formato | Significado | Ejemplo |
|---------|-------------|---------|
| **`T-NNN`** | Épica / ticket | `docs(T-000): …` |
| **`T-NNN-xx`** | Subticket | `feat(T-001-01): monorepo pnpm` |
| **`T-NNN#F-Gnn`** | Commit que cierra/implementa FAQ `FAQ-Gnn` del ticket | `docs(T-002#F-101): cerrar duda puertos Item` |
| **`T-NNN#S-YY`** | Commit ligado a entregable o cierre de Step `YY` del ticket | `docs(T-000#S-13): re-validacion documental` |
| **`planificacion`** | Transversales en `docs/planificacion/` sin épica concreta (protocolos, historial, vista-general) | `docs(planificacion): actualizar protocolo-trabajo-tickets` |

Reglas ámbito: `F-Gnn` ↔ `FAQ-Gnn`; `S-YY` ↔ Step `YY`; no usar `(000)` sin `T-`. Si el commit menciona un **Step** concreto (título, ámbito o cuerpo) → **`(T-NNN#S-YY)`**. Si cierra o implementa una FAQ concreta → **`(T-NNN#F-Gnn)`**.

**Doc canónico Steps 1–13 (T-000):** [backlog/000-planificacion-inicial/planificacion-inicial.md](../../backlog/000-planificacion-inicial/planificacion-inicial.md).

---

## Referencias en markdown (T1 — solo FAQ; Steps en T4)

| Tipo | Texto visible | Destino del enlace |
|------|---------------|-------------------|
| FAQ | `T-NNN#F-Gnn` | `backlog/NNN-…/dudas-y-resoluciones.md#faq-Gnn--…` |

---

## Cuerpo del commit

Una o dos frases; repetir `T-NNN#F-Gnn` o `T-NNN#S-YY` cuando el commit esté ligado a esa FAQ o Step.

---

## Commits históricos

- No reescribir git.
- Protocolo vigente desde **2026-06-13** (commit T1).
- Commits anteriores pueden usar formato libre; a partir de esa fecha aplicar este protocolo.

Esta normativa **no** va en `historial-tickets.md` (historial = solo estado de épicas).

---

## Referencias

- [protocolo-trabajo-tickets.md](protocolo-trabajo-tickets.md) — flujo por tickets
- [protocolo_TODOs.md](protocolo_TODOs.md) — un commit por TODO/subticket
