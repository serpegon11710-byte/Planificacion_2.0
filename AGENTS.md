# Instrucciones para agentes

Normativa para **cualquier agente** que modifique este repositorio (modo agente: escritura en disco).

Índice de reglas del proyecto: [docs/planificacion/reglas-agentes.md](docs/planificacion/reglas-agentes.md).

---

## Fechas «de hoy» al documentar

### Por qué importa

Al interactuar con **Cursor**, el metadato `Today's date` del contexto del agente puede **quedar congelado** en conversaciones largas (sin cerrar el chat ni el ordenador): el IDE sigue inyectando, por ejemplo, el día 12 aunque el reloj del sistema ya esté en el día 14.

Si el agente usa esa fecha para «Última actualización», cierres de ticket/FAQ, historial u otras marcas del **momento actual**, la documentación queda desalineada del calendario real. **Mitigación:** no confiar en la fecha del contexto; obtener la fecha del sistema operativo antes de escribir.

### Regla (autónoma)

Cuando vayas a **introducir o actualizar** una fecha que signifique el **momento actual** del sistema (equivalente a «hoy»), por ejemplo:

- `**Última actualización:**`
- cabeceras de cierre con fecha del día (`FAQ cerrada (YYYY-MM-DD)`, columna **Cierre** en historial, etc.)
- notas «reabierto / re-validado» con la fecha **de esta operación**
- sustituir un placeholder `(YYYY-MM-DD)` por la fecha del cambio

**Entonces, en el mismo turno y antes del edit o commit:**

1. Ejecutar: `Get-Date -Format "yyyy-MM-dd"`
2. Usar **solo** la salida de ese comando para esa fecha.

**Prohibido:** usar `Today's date` del contexto de Cursor ni inferir «hoy» por el historial del chat o fechas ya presentes en el repo.

### Excepción

No aplica si solo **conservas, citas o editas** fechas **históricas** ya documentadas (acta, commits pasados, filas de historial que no estás fechando con «hoy»). Cambiar codificación, typos u otro contenido **sin** añadir una fecha «de hoy» no requiere `Get-Date`.

---

## Otras normas

Commits, tickets, TODOs y checklist: ver tabla en [reglas-agentes.md](docs/planificacion/reglas-agentes.md).
