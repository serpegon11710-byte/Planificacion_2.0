# Politicas transversales

Documentacion de politicas que aplican a todo el proyecto Planificacion 2.0, independientemente de un modulo o capa concreta.

## Objetivo

Centralizar criterios globales de calidad e implementacion que no pertenecen a:

- `docs/casos-uso/` — flujos funcionales
- `docs/entidades/` — reglas de dominio
- `docs/arquitectura/` — estructura, contratos y capas del sistema

## Documentos

| Archivo | Alcance | Step del plan |
|---------|---------|---------------|
| [revision-principios-solid.md](revision-principios-solid.md) | Cumplimiento SOLID en toda la documentacion | 9b |
| [internacionalizacion.md](internacionalizacion.md) | Politica de i18n en implementacion | 9b |
| [desambiguacion-implementacion.md](desambiguacion-implementacion.md) | Tres rutas «implementacion» en el repo (docs, codigo, N4) | 11+ |
| [desacoplamiento-componentes-contratos.md](desacoplamiento-componentes-contratos.md) | Restricciones para cambiar tecnologia por componente sin acoplar al vecino | 11+ |

## Criterio de inclusion

Un documento va aqui si:

- Aplica a mas de una fase o carpeta de `docs/`
- No define estructura arquitectonica ni reglas de negocio del dominio
- Es referenciado desde varios artefactos (arquitectura, casos de uso, implementacion)

No va aqui si define capas, puertos, modulos o transacciones → `docs/arquitectura/`.

## Relacion con arquitectura

La arquitectura puede referenciar estas politicas donde corresponda (por ejemplo, codigos de error e i18n), sin duplicar su contenido.
