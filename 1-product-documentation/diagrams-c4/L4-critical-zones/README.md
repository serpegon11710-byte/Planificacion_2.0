# L4 — Critical Zones (ZC)

**Last updated:** 2026-06-29

Authoritative **logical model** for Critical Zones at C4 Level 4. This README defines only what belongs in Layer 1.

## 1. Governance Concept: Critical Zones (ZC)

Critical Zones are **cross-cutting functional contracts** that govern orchestration and flow across multiple components. Unlike Business Rules (logical validations), ZCs define *how* components collaborate to maintain system integrity.

| Principle | Rule |
|-----------|------|
| **Definition** | ZCs are first-class entities under `diagrams-c4/L4-critical-zones/`. |
| **Source of truth** | Each ZC is an independent entity. If the flow of a ZC changes, it is updated in a single place. |
| **Traceability** | Each ZC explicitly lists which logical components it affects and their role in the zone. |

## 2. Per-ZC Folder Structure (Layer 1)

Every `ZC-XX-{description}/` folder **must** contain these assets:

```text
1-product-documentation/diagrams-c4/L4-critical-zones/ZC-XX-{description}/
├── README.md
├── logic-model.md
├── flow-chart.mmd
└── implementation-contracts/
    └── {logical-component-name}.md
```

| File | Layer 1 content |
|------|-----------------|
| `README.md` | Narrative description: purpose, criticality, affected components table, pointers to sibling files. |
| `logic-model.md` | Technology-agnostic imperative logical model for the whole zone. |
| `flow-chart.mmd` | Technology-agnostic Mermaid source for the zone flow. |
| `implementation-contracts/{logical-component-name}.md` | Per-component ports, pre/postconditions, failure semantics, and a **Pseudocode** section (component-local slice aligned with `logic-model.md`). |

### Format constraints

- No framework, language, implementation file extension, or repository path outside this layer.
- `flow-chart.mmd` contains raw Mermaid notation only.

### ZC `README.md` required sections

1. **Purpose** — Why the zone exists and what integrity it protects.
2. **Criticality** — `Critical` / `High` / `Moderate` with impact statement.
3. **Logic Model** — Pointer to `logic-model.md`.
4. **Flow Chart** — Pointer to `flow-chart.mmd`.
5. **Affected Components** — Table of logical component identifiers and role in the zone.
6. **Contract Summary** — Pointer to files under `implementation-contracts/`.

### `implementation-contracts/` file required sections

1. **Component** — Logical name (aligned with the L3 C4 component diagram).
2. **Pseudocode** — Component-local slice of the zone logic; must stay consistent with `logic-model.md`.
3. **Ports** — Input/output logical ports (signatures in pseudocode).
4. **Preconditions / Postconditions** — What the component guarantees within the ZC.
5. **Failure Semantics** — Logical error outcomes (stable codes by identifier, not localized messages).

## 3. Layer 1 Operational Rules

- **Agnosticism:** L4 definitions must remain technology-agnostic. Stack-specific artifacts never appear here.
- **Single definition:** A ZC flow is not duplicated inside use cases or business rules; those layers reference `ZC-XX` when they participate in the zone.
- **Coherence:** `logic-model.md`, each `implementation-contracts/` **Pseudocode** section, and `flow-chart.mmd` must describe the same zone; maintain them together when the zone evolves.
- **Ownership:** The product/architecture owner maintains the ZC folder. Maintainers of each affected logical component keep their `implementation-contracts/` file aligned with `logic-model.md`.

## Navigation

- [index.md](index.md) — Live directory of ZC entities.
- [history/](history/) — Chronological modification log.
- [doubts_and_resolutions/](doubts_and_resolutions/) — Atomic management of open and closed doubts.
