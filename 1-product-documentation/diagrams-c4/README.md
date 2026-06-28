# C4 Diagrams (Layer 1)

This folder orchestrates all **technology-agnostic C4 diagrams** for the product core. Each C4 level lives in its own subfolder; definitions here are the **authoritative logical model** for architecture visualization and traceability.

## C4 Level Map

| Level | Folder | Scope |
|-------|--------|-------|
| **L1** | [L1-context/](L1-context/) | System context: actors, external systems, system boundary |
| **L2** | [L2-containers/](L2-containers/) | Containers: deployable/runtime boundaries and collaborations |
| **L3** | [L3-components/](L3-components/) | Components: internal structure inside a single container |
| **L4** | [L4-critical-zones/](L4-critical-zones/) | Critical Zones (ZC): cross-cutting orchestration contracts |

## Operating Rules

1. **Agnosticism:** No framework, library, database, or implementation path may appear in this tree.
2. **Single source of truth:** Each diagram or ZC entity is defined once under its level folder. Consumers reference by identifier (`ZC-XX`, container name, component name), never by duplicating logic.
3. **Inward traceability:** L2 references L1 boundaries; L3 references L2 containers; L4 ZCs declare which logical components they affect.
4. **Fractal pattern:** Each level subfolder that owns active content follows the COD fractal block (`README.md`, `index.md`, `history/`, `doubts_and_resolutions/` when applicable).

## Navigation

- [index.md](index.md) — Live directory of this folder.
- [doubts_and_resolutions/](doubts_and_resolutions/) — Atomic management of open and closed doubts.
- [history/](history/) — Chronological modification log.
