# Domain Diagrams

Visual projections of the logical domain. Mermaid source files only — no embedded implementation detail.

## Expected files

| File | Purpose |
|------|---------|
| `class-diagram.mmd` | Domain classes, attributes, and relationships. |
| `er-diagram.mmd` | Conceptual entity-relationship view (logical, not physical schema). |

Additional `.mmd` files may be added for state machines or other views. Register each file in [index.md](index.md).

## Layer 1 rule

Diagrams are **secondary** to textual definitions in `../entities/` and `../business-rules/`. If content diverges, textual documentation prevails.

## Navigation

- [index.md](index.md) — Live directory of this folder.
- [../README.md](../README.md) — Logical domain standard.
