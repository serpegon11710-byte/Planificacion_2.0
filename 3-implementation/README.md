# Implementation

This folder manages the **implementation** layer.

## Logical Domain — Technical Mirror (Layer 3)

**Last updated:** 2026-06-29

Layer 3 materializes the core domain defined in [1-product-documentation/logical-domain/](../1-product-documentation/logical-domain/). Folder layout is specified there; this section defines roles, shadowing, and consistency policy.

### 1. Role of each Layer 1 artifact (the *what* vs. the *how*)

| Artifact (Layer 1) | Role in Layer 3 |
|--------------------|-----------------|
| **`entities/{entity}/logic.md` (logic)** | **Source of truth** for entity behavior. Agents use it with `README.md` constraints to validate domain code in `3-implementation/`. |
| **`business-rules/{category}/BR-XX.YY-*.md` (rules)** | **Source of truth** for logical constraints. Implementation must enforce these rules without redefining them in code comments or outer layers. |
| **`diagrams/*.mmd` (visualization)** | **Communicative projection** for humans (class, ER, state views). Not the audit anchor for code parity. |

### 2. Shadowing Consistency Rule

1. Diagrams in `logical-domain/diagrams/` are **visual projections** of definitions in `entities/` and `business-rules/`.
2. If a diagram disagrees with `logic.md`, entity `README.md`, or a business rule file, **the textual documentation prevails**.
3. Agents **must** prioritize `entities/` and `business-rules/` when generating or refactoring code in `3-implementation/`. Update textual logic first, then sync implementation, then **derive or regenerate** diagrams — never the reverse.

### 3. Agent shadowing obligation

Implementation code is a **technical mirror** of the logical domain. Domain invariants and rule semantics must not drift from Layer 1. When staged changes touch domain code, cross-check against the relevant `logic.md` and `BR-XX.YY` files.

---

## L4 Critical Zones — Technical Mirror (Layer 3)

**Last updated:** 2026-06-29

Layer 3 materializes Critical Zones defined in [1-product-documentation/diagrams-c4/L4-critical-zones/](../1-product-documentation/diagrams-c4/L4-critical-zones/). Folder layout for each ZC in Layer 1 is specified there; this section defines roles, mirror rules, and consistency policy.

### 1. Role of each Layer 1 artifact (the *what* vs. the *how*)

| Artifact (Layer 1) | Role in Layer 3 |
|--------------------|-----------------|
| **`logic-model.md` (logic)** | **Source of truth** for the zone. Agnostic, imperative, logical. Defines the pure contract. Agents use it — together with the component **Pseudocode** slice in `implementation-contracts/` — to verify that `logic-implementation.{ext}` behaves as required. |
| **`flow-chart.mmd` (visualization)** | **Communicative projection** for humans. Surfaces data flow, ports, and cross-component collaboration at a glance. Not the audit anchor for code parity. |
| **`implementation-contracts/{component}.md` → Pseudocode** | Component-local slice used as the direct mirror target for `logic-implementation.{ext}` in this component's active stack. Must stay aligned with `logic-model.md`. |

Layer 3 **does not** duplicate `logic-model.md`, `flow-chart.mmd`, or the ZC `README.md` as code artifacts. It translates the component **Pseudocode** section into runnable code.

### 2. Mirror pair (agent-validated)

```text
Layer 1  implementation-contracts/{component}.md  →  Pseudocode section
Layer 3  {active-technology}/L4-critical-zones/ZC-XX-{description}/logic-implementation.{ext}
```

`logic-implementation.{ext}` is a **direct translation** of the component **Pseudocode** section into the active stack's language.

### 3. Shadowing Consistency Rule

To prevent documentation drift:

1. Diagrams (`flow-chart.mmd`) are **visual projections** of the logic defined in `logic-model.md` and the component **Pseudocode** slices.
2. If `flow-chart.mmd` and `logic-model.md` (or a **Pseudocode** slice) disagree, **`logic-model.md` prevails** as the highest authority; reconcile the **Pseudocode** slice to match, then fix the diagram.
3. Agents **must** update `logic-model.md` and the affected **Pseudocode** sections first, then update `logic-implementation.{ext}`, and **derive or regenerate** `flow-chart.mmd` from the updated logic — never the reverse.

### Directory structure per component

Every component that implements a ZC must follow this structure:

```text
3-implementation/{component}/
├── README.md
├── {active-technology}/
│   ├── L4-critical-zones/
│   │   └── ZC-XX-{description}/
│   │       └── logic-implementation.{ext}
│   └── src/
└── {obsolete-technology}/
    ├── L4-critical-zones/
    │   └── ZC-XX-{description}/
    │       └── logic-frozen.{ext}
    └── src/
```

| Path | Content (Layer 3 only) |
|------|------------------------|
| `{component}/README.md` | Active technology row, contract versions, and table of `ZC-XX` IDs implemented by this component. |
| `.../logic-implementation.{ext}` | Runnable translation of the component **Pseudocode** section for the active stack. |
| `.../logic-frozen.{ext}` | Read-only snapshot under obsolete technology after migration. |

### Layer 3 operational rules

- **Shadowing:** Each `logic-implementation.{ext}` mirrors the **Pseudocode** section in `implementation-contracts/{logical-component-name}.md`. Control flow, ports, and failure semantics must remain aligned with `logic-model.md`.
- **Freeze policy:** When a ZC evolves, update the **active** technology folder only. Move the previous version to `{obsolete-technology}/`, mark it **read-only/frozen**, and **never** patch it.
- **Single component ownership:** Each component owns its ZC implementation files. Cross-component orchestration remains in Layer 1; Layer 3 materializes local responsibilities only.
- **Bidirectional traceability:** Each component `README.md` **must** list every `ZC-XX` it implements. Cross-check against **Affected Components** in the Layer 1 ZC `README.md`.

## Navigation

- [index.md](index.md) — Live directory of files in this layer (same-level catalog only).
- [bootstrap-policy.md](bootstrap-policy.md) — Bootstrap and initialization policy (component `.bootstrap/`, root orchestrator).
- [component-decoupling-contracts.md](component-decoupling-contracts.md) — Component decoupling through explicit contracts.
- [i18n-implementation-contract.md](i18n-implementation-contract.md) — Localization boundaries for implementation.
- [doubts_and_resolutions/](doubts_and_resolutions/) — Atomic management of open and closed doubts.
