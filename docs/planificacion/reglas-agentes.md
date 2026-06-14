# Reglas para agentes

Índice de normas e instrucciones para agentes que **escriben en este repositorio** (modo agente). La normativa de fechas «de hoy» (incl. contexto del bug de Cursor) está en **[AGENTS.md](../../AGENTS.md)** en la raíz del repo.

---

| Regla / tema | Documento | Notas |
|--------------|-----------|--------|
| **Fechas «de hoy» al escribir en disco** | [AGENTS.md](../../AGENTS.md) | `Get-Date` antes de persistir; no usar `Today's date` del contexto del IDE |
| **Commits** (tipo, ámbito, cuerpo) | [protocolo-commits.md](protocolo-commits.md) | Obligatorio en todo commit del repo |
| **Tickets y subtickets** | [protocolo-trabajo-tickets.md](protocolo-trabajo-tickets.md) | Flujo, FAQ por ticket, refs `T-NNN#F-Gnn` / `T-NNN#S-YY` |
| **Un commit por TODO/subticket** | [protocolo_TODOs.md](protocolo_TODOs.md) | Remite a protocolo-commits para el título |
| **Checklist pre-implementación** | [vista-general.md](vista-general.md) §6 | Contratos antes de bootstrap / negocio |
| **Estado de épicas** | [historial-tickets.md](historial-tickets.md) | Solo épicas 000–008; subtickets en README de épica |
| **Roadmap e ticket activo** | [backlog/README.md](../../backlog/README.md) | Épicas; no duplicar transversales aquí |
| **Encoding / finales de línea** | [.editorconfig](../../.editorconfig), [.gitattributes](../../.gitattributes) | UTF-8 sin BOM, LF en repo; ver también [.vscode/settings.json](../../.vscode/settings.json) |

---

## Lectura recomendada al iniciar trabajo

1. [AGENTS.md](../../AGENTS.md) — fechas del sistema.
2. [protocolo-trabajo-tickets.md](protocolo-trabajo-tickets.md) — orden de lectura y ticket activo.
3. README de la épica y subticket concreto en `backlog/`.
