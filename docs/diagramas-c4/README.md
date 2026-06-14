# Diagramas C4

Parte del **[T-000#S-8](../../backlog/000-planificacion-inicial/planificacion-inicial.md)** del plan de documentacion. Visualiza la estructura del software Planificacion 2.0 e integra con arquitectura ([T-000#S-9a](../../backlog/000-planificacion-inicial/planificacion-inicial.md)).

Dudas y stack: [dudas-y-resoluciones.md](../../backlog/000-planificacion-inicial/dudas-y-resoluciones.md) (FAQ-100, 101; [T-000#S-12a](../../backlog/000-planificacion-inicial/planificacion-inicial.md) cerrado).

## Estructura por nivel

```
diagramas-c4/
├── c4-nivel-1/          # Contexto
├── c4-nivel-2/          # Contenedores
├── c4-nivel-3/          # Componentes (Back-End + Front-End)
└── c4-nivel-4/          # Detalle (codigo)
    ├── zonas-criticas-n4.md
    ├── pseudocodigo/    # Canonico (independiente del stack)
    └── implementacion/  # N4 por componente/tecnologia ([T-000#S-12a](../../backlog/000-planificacion-inicial/planificacion-inicial.md))
```

## Diagramas por nivel

| Nivel | Carpeta | Fichero(s) | Estado |
|-------|---------|------------|--------|
| N1 — Contexto | [c4-nivel-1/](c4-nivel-1/) | [c4-nivel-1-contexto.mmd](c4-nivel-1/c4-nivel-1-contexto.mmd) | Cerrado |
| N2 — Contenedores | [c4-nivel-2/](c4-nivel-2/) | [c4-nivel-2-contenedores.mmd](c4-nivel-2/c4-nivel-2-contenedores.mmd) | Cerrado |
| N3 — Componentes Back-End | [c4-nivel-3/](c4-nivel-3/) | [c4-nivel-3-componentes.mmd](c4-nivel-3/c4-nivel-3-componentes.mmd) | Cerrado |
| N3 — Componentes Front-End | [c4-nivel-3/](c4-nivel-3/) | [c4-nivel-3-componentes-frontend.mmd](c4-nivel-3/c4-nivel-3-componentes-frontend.mmd) | Cerrado |
| N4 — Detalle | [c4-nivel-4/](c4-nivel-4/) | [zonas-criticas-n4.md](c4-nivel-4/zonas-criticas-n4.md) + [pseudocodigo/](c4-nivel-4/pseudocodigo/) | Cerrado (canonico) |
| N4 — Implementacion | [c4-nivel-4/implementacion/](c4-nivel-4/implementacion/) | Cerrado [T-000#S-12a](../../backlog/000-planificacion-inicial/planificacion-inicial.md) | Por componente: `{componente}/{tecnologia}/` |

## Nivel 3

Dos diagramas de componentes (FAQ-200):

| Diagrama | Alcance |
|----------|---------|
| [c4-nivel-3-componentes.mmd](c4-nivel-3/c4-nivel-3-componentes.mmd) | Back-End, capa de negocio y persistencia |
| [c4-nivel-3-componentes-frontend.mmd](c4-nivel-3/c4-nivel-3-componentes-frontend.mmd) | Zoom del contenedor Front-End; complementa N4 [ZC-6](c4-nivel-4/pseudocodigo/zc-6-presentacion.md) |

El diagrama Back-End referencia al Front-End como contenedor; el detalle de presentacion vive en el diagrama Front-End y en ZC-6.

## Nivel 4

Las zonas criticas estan definidas en [zonas-criticas-n4.md](c4-nivel-4/zonas-criticas-n4.md).

El N4 canonico es **pseudocodigo independiente del stack** en [pseudocodigo/](c4-nivel-4/pseudocodigo/). La proyeccion por componente y tecnologia esta en [implementacion/](c4-nivel-4/implementacion/).

## Visualizacion

Los ficheros N1–N3 (`.mmd`) usan sintaxis Mermaid C4 (`C4Context`, `C4Container`, `C4Component`). Requieren herramienta o extension compatible.

Los documentos N4 (`.md`) incluyen diagramas Mermaid de estructura logica y bloques de pseudocodigo.
