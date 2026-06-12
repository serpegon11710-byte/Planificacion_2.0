# Diagramas C4

Parte del **Step 8** del plan de documentacion. Visualiza la estructura del software Planificacion 2.0 e integra con arquitectura (Step 9a).

Dudas abiertas (trazabilidad UC, N3 Front-End, etc.): [dudas-y-resoluciones.md](../planificacion/dudas-y-resoluciones.md).

## Estructura por nivel

```
diagramas-c4/
├── c4-nivel-1/          # Contexto
├── c4-nivel-2/          # Contenedores
├── c4-nivel-3/          # Componentes
└── c4-nivel-4/          # Detalle (codigo)
    ├── zonas-criticas-n4.md
    ├── pseudocodigo/    # Canonico (independiente del stack)
    └── implementacion/  # Por stack (pendiente)
```

## Diagramas por nivel

| Nivel | Carpeta | Fichero(s) | Estado |
|-------|---------|------------|--------|
| N1 — Contexto | [c4-nivel-1/](c4-nivel-1/) | [c4-nivel-1-contexto.mmd](c4-nivel-1/c4-nivel-1-contexto.mmd) | Cerrado |
| N2 — Contenedores | [c4-nivel-2/](c4-nivel-2/) | [c4-nivel-2-contenedores.mmd](c4-nivel-2/c4-nivel-2-contenedores.mmd) | Cerrado |
| N3 — Componentes | [c4-nivel-3/](c4-nivel-3/) | [c4-nivel-3-componentes.mmd](c4-nivel-3/c4-nivel-3-componentes.mmd) | Cerrado |
| N4 — Detalle | [c4-nivel-4/](c4-nivel-4/) | [zonas-criticas-n4.md](c4-nivel-4/zonas-criticas-n4.md) + [pseudocodigo/](c4-nivel-4/pseudocodigo/) | Cerrado (canonico) |
| N4 — Implementacion | [c4-nivel-4/implementacion/](c4-nivel-4/implementacion/) | Pendiente | Requiere stack |

## Nivel 3

Un unico diagrama: componentes del Back-End, Capa de Persistencia y referencia al Front-End (detalle de presentacion en N4 ZC-6). No hay zoom separado por contenedor en este momento.

## Nivel 4

Las zonas criticas estan definidas en [zonas-criticas-n4.md](c4-nivel-4/zonas-criticas-n4.md).

El N4 canonico es **pseudocodigo independiente del stack** en [pseudocodigo/](c4-nivel-4/pseudocodigo/). Cada fichero `zc-*.md` incluye **trazabilidad con casos de uso** (FAQ-104); los UCs referencian las zonas criticas afectadas.

## Visualizacion

Los ficheros N1–N3 (`.mmd`) usan sintaxis Mermaid C4 (`C4Context`, `C4Container`, `C4Component`). Requieren herramienta o extension compatible.

Los documentos N4 (`.md`) incluyen diagramas Mermaid de estructura logica y bloques de pseudocodigo.
