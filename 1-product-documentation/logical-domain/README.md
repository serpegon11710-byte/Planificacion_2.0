# Logical Domain (Core Domain Model)

**Last updated:** 2026-06-29

The `logical-domain/` folder is the authoritative source of truth for the system's business model. It encapsulates what the business *is* and *how it behaves*, completely decoupled from any technical implementation or operational framework.

## Directory Structure

```text
logical-domain/
├── README.md
├── index.md
├── history/
├── doubts_and_resolutions/
├── diagrams/                    # Visual projections (UML / ER / state machines)
│   ├── class-diagram.mmd
│   └── er-diagram.mmd
├── entities/                    # The "WHAT": domain objects
│   └── {entity}/
│       ├── README.md            # Definition, attributes, and constraints
│       └── logic.md             # Core domain methods and responsibilities
└── business-rules/              # The "HOW": logical constraints and validations
    └── {category}/
        └── BR-XX.YY-{description}.md
```

| Path | Role |
|------|------|
| `diagrams/` | Technology-agnostic Mermaid projections for human understanding. |
| `entities/{entity}/README.md` | Entity definition, attributes, and invariants. |
| `entities/{entity}/logic.md` | Core domain behavior and responsibilities for the entity. |
| `business-rules/{category}/` | Independent, atomic logical specifications (see [business-rules/README.md](business-rules/README.md)). |

## Governance Rules

- **Source of truth primacy:** `logical-domain/` is the authoritative definition. If a domain concept evolves, it must be updated here first. Visual diagrams are secondary projections and must be kept aligned with textual definitions in `entities/` and `business-rules/`.

- **Entity and rule independence:** Business rules are independent specifications. They exist outside the context of specific use cases or Critical Zones, so they can be applied across any part of the system.

- **Agnosticism:** No technical details (database schemas, framework-specific types, API endpoints) are permitted here. This layer describes concepts in pure business language.

- **Visual projection vs. logical reality:** The `diagrams/` folder is a convenience for human understanding. If a diagram disagrees with textual definitions in `entities/` or `business-rules/`, **the textual documentation prevails**.

- **Coherence:** When an entity or rule changes, update `logic.md` / rule files first, then reconcile `diagrams/` to match.

## Navigation

- [index.md](index.md) — Live directory of this folder.
- [entities/](entities/) — Domain entities.
- [business-rules/](business-rules/) — Business rules repository.
- [diagrams/](diagrams/) — Domain diagrams.
- [doubts_and_resolutions/](doubts_and_resolutions/) — Atomic management of open and closed doubts.
- [history/](history/) — Chronological modification log.
