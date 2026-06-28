# Component Decoupling Through Contracts

**Last updated:** 2026-06-12

Implementation contract (Layer 3) ensuring that **changing the technology of a component** (React, NestJS, PostgreSQL, etc.) affects **only that component**, except when a shared **contract** is consciously modified.

> **Related contracts:** [i18n-implementation-contract.md](i18n-implementation-contract.md), [../1-product-documentation/business-rule-integration-contract.md](../1-product-documentation/business-rule-integration-contract.md).

---

## Purpose

Maximize the evolutionary independence of each C4 container (Front-End, Back-End, Persistence, Shared, DB) **through explicit, stable contracts**, so that:

- a change of framework, library, or engine **does not force** rewriting another component;
- stack coupling (same language, same monorepo, same shared package) remains **limited and documented**;
- business rules continue to live in the product documentation layer, **not** in cross-cutting technical details.

---

## Guiding Principle

| Type of change | Expected impact on other components |
|----------------|-------------------------------------|
| **Internal** technology change (same contracts at boundaries) | **None** in neighbor code or documentation |
| **Contract** change (API, port, schema, error code, transactional semantics) | **Only** on consumers of that contract, with explicit versioning |
| **Business rule** change | Per UC/ZC traceability; not a stack change |

Collaboration between components **always** goes through a contract. Decoupling does not remove boundaries; it **fixes** them outside the implementation.

---

## Boundaries and Contracts

Each pair of adjacent components has **a single contract type** as the logical source of truth:

| Boundary | Contract | Reference documentation | Implements | Consumes |
|----------|----------|---------------------------|------------|----------|
| Front-End ↔ Back-End | REST API (HTTP/JSON), DTOs, pagination, error codes | Project architecture contracts (Layer 3 guides) | Back-End | Front-End |
| Back-End ↔ Persistence | Repository and connection ports (`*RepositoryPort`, `DatabaseConnectionPort`) | Project architecture contracts (Layer 3 guides) | Persistence | Back-End (domain/application) |
| Persistence ↔ DB | Relational schema, migrations, constraints, SQL policies | ER model and DB guides (Layer 3) | DB (+ SQL in Persistence) | Persistence |
| Front-End ↔ Back-End (types) | Stable catalog of `codigo`, DTO shapes | Shared **or** schema/OpenAPI generated from contract | Shared (artifact) | Front-End, Back-End |
| Presentation ↔ user | i18n by `codigo` | [i18n-implementation-contract.md](i18n-implementation-contract.md) | Front-End | — |

**Rule:** a component's implementation documentation (Layer 3) **must not** name the neighbor's stack as a mandatory dependency. It only references **contracts**.

---

## Cross-cutting Constraints (Mandatory)

1. **One technology per code folder.** Each component lives in `implementacion/{componente}/{tecnologia}/`. Changing technology = new `{tecnologia}` subfolder; do not mix frameworks in the same path.

2. **No cross-implementation imports.** A component **must not** import source code from another component except **Shared** as a contract artifact (DTOs/codes). In particular:
   - Front-End **must not** import Back-End, Persistence, or DB.
   - Back-End **must not** import concrete Persistence in the domain; only port **interfaces**.
   - Persistence **must not** import NestJS, React, or HTTP controllers.

3. **Contracts before stack convenience.** Prefer an explicit contract (OpenAPI, JSON Schema, documented port interfaces) over coupling two components because they share TypeScript in a monorepo. The monorepo is **organization**, not an architectural boundary.

4. **Errors by `codigo`, not by message.** Back-End emits a stable `codigo`; Front-End resolves text via i18n. Changing the UI library **does not** require changing texts in the API.

5. **Neutral serialization in the contract.** Dates, times, enums, and `null` vs. omitted field are defined in the API/Shared contract; they do not depend on implicit framework conventions.

6. **Business logic outside infrastructure.** Domain rules remain in the product core and canonical pseudocode. SQL, React components, and Nest modules are **projections**, not the functional source of truth.

7. **Breaking contract versioning.** If a DTO, port, or column changes incompatibly, increment the documented contract version and update **only** producers/consumers of that contract. Do not propagate the change to unaffected components.

8. **N4 implementation documentation per component.** The technical projection of each zone is documented under the **component and technology** folder that materializes it (not under an indivisible stack pack).

9. **Tests at the boundary.** When changing technology in a component, run **contract** tests (API, ports, migrations) at the affected boundary; do not re-run the neighbor's full suite unless the contract breaks.

---

## Constraints by Component

### Front-End

- Consumes **only** documented HTTP API; direct access to DB or persistence ports is prohibited.
- HTTP client and view ↔ DTO mapping are internal responsibilities; **do not** filter business logic that belongs to Back-End (uniqueness, domain rules, materialization).
- Local validation: format and interface constraints; everything else delegated via API.
- Changing SPA (e.g., React → another framework) **must not** require Back-End changes if the API contract is maintained.

### Back-End

- Domain and application depend on **ports**, not concrete adapters.
- Controllers/API translate HTTP ↔ DTO; **do not** expose persistence entities or SQL.
- Transactional orchestration uses `DatabaseConnectionPort`; **not** SQL driver APIs in application.
- Changing HTTP framework (e.g., NestJS → another) **must not** require Front-End or Persistence changes if ports and JSON are maintained.

### Persistence

- Implements ports defined by Back-End; **does not** redefine business rules.
- SQL and mappers are internal; technical errors are translated to agreed codes toward application, without leaking stack traces externally.
- **Do not** couple table/column names to the domain beyond the mapper (domain uses ubiquitous language, DB uses the ER).
- Changing ORM/driver/SQL library **must not** require Front-End changes; in Back-End only wiring/DI if **ports** do not change.

### Shared

- **Only** contract artifacts: DTOs, error codes, identifier types, API constants.
- **Prohibited:** business logic, SQL, UI components, framework imports (Nest, React).
- Treat Shared as a **materialized contract**, not a domain layer. If Back-End stops being TypeScript, DTOs must be **regenerable** from the same logical contract (OpenAPI/Schema) without forcing Front-End to rewrite business logic.
- Changes in Shared that alter DTO shape or semantics = **contract change** → coordinate Front-End and Back-End.

### DB

- Schema and migrations aligned to the ER; concrete engine only in the DB implementation folder.
- SQL policies documented in DB guides; Persistence consumes them, **does not** redefine them in Back-End.
- Changing engine (e.g., PostgreSQL → another) impacts **DB + Persistence**; Front-End intact; Back-End intact if ports and equivalent transactional semantics.

---

## Procedure: Technology Change in a Component

1. Confirm that contracts at the boundary (API, ports, ER) are **not** altered, or plan a **new version** of the contract.
2. **Rename** the outgoing technology folder to `{tecnologia} (obsoleto)` in code and N4 (if they exist).
3. **Create** `implementacion/{componente}/{nueva-tecnologia}/` and, if applicable, N4 projection under the component's documentation tree.
4. Update **only** the affected component's Layer 3 documentation and stack history.
5. **Do not** update other components' implementation documentation unless the contract breaks.
6. Run contract tests at touched boundaries.

---

## Prohibited Couplings

| Pattern | Why it breaks decoupling |
|---------|--------------------------|
| Front-End imports types/classes from Back-End | Couples SPA to server framework and deployment |
| Domain imports `pg`, TypeORM, Nest, React | Mixes business with infrastructure |
| Persistence exposes SQL or raw rows to the API | Skips layers and fixes the engine at the external boundary |
| Shared with services, business validators, or UI hooks | Turns contract into shared domain |
| Documenting "the stack" as an indivisible unit in single-component guides | Forces neighbors' docs/code to change when migrating one layer |
| Translated error messages generated in Back-End for the UI | Couples API to client locale |

---

## Compatibility Matrix

Each component README may summarize the local row (active technology + contract versions). Example v1:

| Component | Active technology | Contracts |
|-----------|-------------------|-----------|
| Front-End | `react-typescript` | API v1, errors v1 |
| Back-End | `nestjs-typescript` | API v1, ports v1 |
| Persistence | `typescript` | ports v1, ER v1 |
| DB | `postgresql` | ER v1 |

When changing only Front-End, update its row; the others remain if API v1 does not change.

---

## Quick Checklist Before Merge

- [ ] Is the change confined to one component or a documented contract?
- [ ] Does any import cross an implementation boundary without going through a contract?
- [ ] Does Shared still have no business logic or framework dependencies?
- [ ] Are DTOs/error codes still aligned with documented architecture contracts?
- [ ] Does the component guide avoid naming neighbor technologies as a requirement?

---

## References

| Topic | Location |
|-------|----------|
| Business rule integration | [../1-product-documentation/business-rule-integration-contract.md](../1-product-documentation/business-rule-integration-contract.md) |
| i18n contract | [i18n-implementation-contract.md](i18n-implementation-contract.md) |
