# L1 — System Context

Defines the **system boundary** at the highest C4 level: who uses the system, which external systems interact with it, and the single product scope.

## Definition Standard

| Artifact | Requirement |
|----------|-------------|
| **Diagram** | One primary context diagram per product (Mermaid `C4Context` or equivalent agnostic notation). |
| **Actors** | Human or system actors outside the boundary; named with ubiquitous language. |
| **External systems** | Third-party or legacy systems; no vendor-specific SDK names. |
| **System** | The product under documentation; one clear boundary box. |

## File Convention

- Store the diagram in a dedicated `.md` file at this level (for example, `system-context.md`).
- Register every file in [index.md](index.md).

## Constraints

- **No containers or components** at this level — only the whole system and its environment.
- **No technology stack** — integration style (REST, messaging) may be noted only as a logical protocol, not as a framework.

## Navigation

- [index.md](index.md) — Live directory of this level.
