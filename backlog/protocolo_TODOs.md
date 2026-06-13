# Protocolo de TODOs y commits

**Última actualización:** 2026-06-12

Cuando un plan de trabajo se diseña con **TODOs** o **subtickets** (`T-NNN-xx`), la ejecución debe seguir este protocolo. Marco: [protocolo-trabajo-tickets.md](protocolo-trabajo-tickets.md).

---

## Regla principal

**Un commit por cada TODO completado**, antes de pasar al siguiente paso.

- No acumular varios TODO en un solo commit.
- No dejar TODOs marcados como hechos sin commit asociado (salvo que el TODO no produzca cambios en el repositorio).
- No hacer push al remoto salvo petición explícita.

---

## Formato del commit

Cada commit debe usar **título + cuerpo breve**:

```
Título breve (imperativo, ~50–72 caracteres)

Explicación en una o dos líneas: qué se hizo, qué ficheros o ámbito tocó y qué entregable cierra.
```

### Ejemplo

```
feat(T-001-01): monorepo pnpm workspaces

Configura package.json raíz y workspaces para FE, BE, shared, persistencia.
```

### Criterios del título

- Indica el **ámbito** (p. ej. `docs`, `feat`, `T-001`) y la **épica o step** si aplica.
- Describe el **resultado** del TODO, no la intención genérica.

### Criterios del cuerpo

- Una o dos frases completas.
- Mencionar archivos, carpetas o decisiones relevantes cuando ayude a la trazabilidad.

---

## Flujo recomendado por TODO

1. Marcar el TODO como en curso.
2. Realizar los cambios acordados en el plan.
3. Verificar coherencia mínima (lint, enlaces, criterios del plan).
4. Crear el commit con el formato anterior.
5. Marcar el TODO como completado y continuar con el siguiente.

---

## Ámbito

Este protocolo aplica a **planes con TODOs o subtickets** ejecutados en el repositorio (documentación en `backlog/`, código en `implementacion/`). Los commits deben respetar además las reglas generales del proyecto (no incluir secretos, no amend salvo las excepciones acordadas en el flujo de git del equipo).
