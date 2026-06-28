# Domain Entities

The **WHAT** of the business model: domain objects, their attributes, constraints, and core behavior.

## Per-entity folder structure

```text
entities/{entity}/
├── README.md       # Definition, attributes, and constraints
└── logic.md        # Core domain methods and responsibilities
```

| File | Content |
|------|---------|
| `README.md` | Ubiquitous-language definition, attributes, invariants, and relationships to other entities. |
| `logic.md` | Technology-agnostic description of domain operations the entity owns or participates in. |

## Rules

- One folder per aggregate or core entity; name with ubiquitous language (kebab-case).
- No framework types, persistence mapping, or API shapes.
- Register each entity folder in [index.md](index.md).

## Navigation

- [index.md](index.md) — Live directory of entities.
- [../README.md](../README.md) — Logical domain standard.
