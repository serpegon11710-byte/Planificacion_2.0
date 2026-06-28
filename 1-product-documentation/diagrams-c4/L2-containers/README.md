# L2 — Containers

Defines **runtime/deployable boundaries** inside the system: the major collaborating parts that could be deployed or scaled independently.

## Definition Standard

| Artifact | Requirement |
|----------|-------------|
| **Diagram** | Container diagram scoped to the system defined in L1 (Mermaid `C4Container` or equivalent). |
| **Containers** | Named logical deployables (for example, API application, web client, persistence service). |
| **Relationships** | Protocol and data flow between containers; no framework or ORM names. |
| **L1 alignment** | Every container must fit inside the L1 system boundary. |

## File Convention

- One container diagram file per scope (for example, `containers.md`).
- Register every file in [index.md](index.md).

## Constraints

- **No internal component detail** — that belongs in L3.
- **No implementation paths** — refer to containers by logical name only.
- Containers map to logical component identifiers by **name**, not by repository path.

## Navigation

- [index.md](index.md) — Live directory of this level.
- [../L1-context/](../L1-context/) — Parent system context.
