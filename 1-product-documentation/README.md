# Product Documentation

This folder manages the **product documentation** layer.

# Product Documentation (Layer 1)

This layer contains the authoritative definition of product functionality and business logic.

## Core Domain Model (`logical-domain/`)

The business model — entities, business rules, and domain diagrams — lives under [logical-domain/](logical-domain/). It is the SSOT for what the business *is* and *how it behaves*, agnostic of technology.

## Core Integration Contract

All consumers within this layer (Use Cases, Functional Modules) must comply with the
[Business Rule Integration Contract](./business-rule-integration-contract.md).
This contract enforces SSOT and bidirectional traceability across all functional entities.

## C4 Diagrams (`diagrams-c4/`)

Technology-agnostic C4 architecture diagrams and Critical Zones (ZC) live under [diagrams-c4/](diagrams-c4/). Each C4 level has its own subfolder (`L1-context`, `L2-containers`, `L3-components`, `L4-critical-zones`).

## Traceability Architecture

1. **Business Rules Repository (`logical-domain/business-rules/`):**
   - Every `BR-XX.YY-description.md` must contain:
     - **Definition:** The authoritative business logic.
     - **Usage:** A list of `UC-XX` IDs that consume this rule.

2. **Use Case Repository (`use-cases/`):**
   - Every `UC-XX/README.md` must contain:
     - **Business Logic Reference:** A section citing the `BR-XX.YY` identifiers it relies upon.
     - **Impact Verification:** If a developer modifies a rule, they are mandated to review all associated Use Cases listed in the rule's "Usage" section.

## Navigation

- [index.md](index.md) — Live directory of all files in this layer.
- [doubts_and_resolutions/](doubts_and_resolutions/) — Atomic management of open and closed doubts.
