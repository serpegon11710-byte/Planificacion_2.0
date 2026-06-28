# L3 — Components

Defines the **internal structure of a single L2 container**: logical modules, their responsibilities, and collaborations inside one deployable boundary.

## Definition Standard

| Artifact | Requirement |
|----------|-------------|
| **Diagram** | One component diagram per L2 container (Mermaid `C4Component` or equivalent). |
| **Components** | Logical modules with a single responsibility; named in ubiquitous language. |
| **Relationships** | Dependencies and data flow inside the container only. |
| **L2 alignment** | Diagram header must cite the parent L2 container identifier. |

## File Convention

- One file per container scope (for example, `api-application-components.md`).
- Register every file in [index.md](index.md).

## Constraints

- **No code-level orchestration** — cross-cutting flows that span containers belong in L4 Critical Zones.
- **No stack references** — interfaces are logical (ports, DTO contracts), not language-specific types.
- Component names used here are the same identifiers referenced by L4 ZC `implementation-contracts/`.

## Navigation

- [index.md](index.md) — Live directory of this level.
- [../L2-containers/](../L2-containers/) — Parent containers.
