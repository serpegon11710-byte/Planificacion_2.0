# Business Rule Integration Contract

This contract defines how `use-cases/` and `logical-domain/business-rules/` interact to preserve a single source of truth and bidirectional traceability in Layer 1.

## Mandatory Rules

1. **Single source of truth:** Business logic is authored only in business rule files (`BR-XX.YY-*.md`).
2. **Reference-only consumption:** Use cases must reference business rule IDs and must not duplicate rule definitions.
3. **Bidirectional traceability:**  
   - Each business rule lists the consuming use cases (`Referenced by`).  
   - Each use case lists all consumed business rules in a dependency table.
4. **Impact review:** Any change in a business rule triggers review of all linked use cases.
5. **Layer isolation:** This contract is internal to `1-product-documentation/` and must not depend on outer layers.

## Required Traceability Format

### In business rule files

- **Definition**
- **Referenced by** (`UC-XX` / `UC-XX.YY`)
- **Context** (optional links to related Layer 1 documents)

### In use case files

| Rule ID | Description | Impact |
|---|---|---|
| `BR-XX.YY` | Rule description | `Critical` / `Minor` |

