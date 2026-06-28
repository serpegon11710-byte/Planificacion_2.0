# Pre-Commit Validation Rules

**Last updated:** 2026-06-29

**Source of truth** for the pre-commit integrity contract (`AGENTS.md` §9), auditor behavior ([skills/solid.md](../skills/solid.md)), and all validation criteria executed before `git commit`.

The optional Git hook (§8) validates only the audit **report artifact**. **L4 pseudocode mirror** validation is **agent-only** (§6.3, §9) — this template does not ship and will not ship a hook for that concern.

> **Related:** [clean-onion-documentation.md](clean-onion-documentation.md) §4 (COD matrix SSOT), [solid-principles-review-report.md](solid-principles-review-report.md) (gate artifact), [README.md](README.md) (report file structure).

---

## 1. Pre-Commit Integrity Contract

**Mandatory guardrail:** Any agent (Cursor, Claude Code, Aider, GitHub Copilot, or equivalent) that reads `AGENTS.md` **must** adopt this contract as a pre-commit gate. **No commit may proceed** until this audit completes successfully.

Before any commit, perform an architectural audit of all **staged** changes. Invoke [skills/solid.md](../skills/solid.md) and validate every criterion in this document.

### On failure

- **Reject** the commit process immediately.
- **Log** the conflict in the corresponding layer's `doubts_and_resolutions/index.md`.
- **Report** the violation to the user for manual correction and refactor.

---

## 2. Auditor Operating Mode (`skills/solid.md`)

1. **BLIND AUDIT:** Do not assume the code is correct. Analyze each component, interface, and class looking for encapsulation violations or unnecessary couplings.
2. **GOVERNANCE PRIORITY:** If a SOLID principle or a Layer 5 rule conflicts with a quick implementation, governance takes absolute priority.
3. **CONSTRUCTIVE CRITICISM:** Identify which specific principle (S, O, L, I, D) or COD rule is violated and propose a technical alternative aligned with the layered architecture.

For **non-commit** audits (ad-hoc review), respond in chat with:

1. **STATUS:** (Compliant / Non-Compliant / Requires Refactor).
2. **VIOLATION ANALYSIS:** Detailed list of ignored SOLID principles or decoupling rules.
3. **REFACTOR PROPOSAL:** How to decouple or improve the design (no code unless explicitly requested).
4. **GOVERNANCE LINK:** Reference to the specific `5-governance/` file that justifies the audit.

---

## 3. Regeneration Workflow

1. Review **staged** changes (`git diff --cached`).
2. Validate **COD** per [clean-onion-documentation.md](clean-onion-documentation.md) §4 (see §4 below).
3. Validate **SOLID** — at minimum **S** and **D** on staged changes (see §5 below).
4. Validate **L4 ZC pseudocode mirror** when staged changes touch Critical Zones or their Layer 3 projections (see §6 below).
5. Run `Get-Date -Format "yyyy-MM-ddTHH:mm:ss"` **once**, immediately before writing report headers.
6. Overwrite **only** `## Current audit` to EOF in [solid-principles-review-report.md](solid-principles-review-report.md).
7. Set `**STATUS:** PASS` only if **all** checks pass; otherwise `**STATUS:** KO` and **abort the commit**.

---

## 4. COD Validation Criteria

Normative rules: [clean-onion-documentation.md](clean-onion-documentation.md) §4.

| Check | Rule |
|-------|------|
| **Inward-only** | Layer N references only inner layers per the dependency matrix in §4 |
| **No stack leakage** | Only Layer 3 may name concrete stacks; forbidden in Layers 1, 2, 4, and 5 |
| **Fractal index** | Every `index.md` uses the same-level file catalog table per `clean-onion-documentation.md` §2 |

Record violations under **Findings** with `COD` and affected paths.

---

## 5. SOLID Validation Criteria

| Principle | Question | §9 minimum |
|-----------|----------|------------|
| **S** | Does each changed unit have a single reason to change? | **Required** |
| **O** | Can behavior be extended without modifying existing source code? | If relevant |
| **L** | Do implementations break the base interface contract? | If relevant |
| **I** | Are there unused methods in interfaces clients do not need? | If relevant |
| **D** | Do dependents target abstractions, not concrete outer-layer details? | **Required** |

Record violations under **Findings** with principle id (S/O/L/I/D) and affected paths.

---

## 6. L4 Critical Zone — Pseudocode Mirror Validation

### 6.1 Layer 1 artifacts (structure)

Each Critical Zone (`ZC-XX-{description}`) in [1-product-documentation/diagrams-c4/L4-critical-zones/](../1-product-documentation/diagrams-c4/L4-critical-zones/) **must** follow the folder layout defined in that layer's README (`README.md`, `logic-model.md`, `flow-chart.mmd`, `implementation-contracts/`).

Roles, shadowing consistency, and mirror semantics: [3-implementation/README.md](../3-implementation/README.md) (L4 Critical Zones section).

### 6.2 Layer 3 projection (what must mirror)

For each component that implements a ZC, the **active technology** folder must contain:

```text
3-implementation/{component}/{active-technology}/L4-critical-zones/ZC-XX-{description}/logic-implementation.{ext}
```

`logic-implementation.{ext}` is a **direct translation** of the **Pseudocode** section from:

```text
1-product-documentation/diagrams-c4/L4-critical-zones/ZC-XX-{description}/implementation-contracts/{logical-component-name}.md
```

That slice must stay aligned with `logic-model.md` per the **Shadowing Consistency Rule** in Layer 3.

The validated pair is:

```text
{pseudocode}  ←—— mirror ——→  {active-technology code}
     Layer 1                         Layer 3
```

`flow-chart.mmd` is **not** mirrored as code. When a ZC changes, update `logic-model.md`, affected **Pseudocode** slices, matching `logic-implementation.{ext}` files, then derive `flow-chart.mmd`.

### 6.3 Pre-commit check (agent audit)

When staged files include any path under:

- `1-product-documentation/diagrams-c4/L4-critical-zones/`, or
- `3-implementation/*/L4-critical-zones/`, or
- a component `README.md` listing `ZC-XX` implementations,

the auditor **must**:

1. Identify each affected `ZC-XX` and logical component.
2. Locate `logic-model.md` and the **Pseudocode** section in the matching `implementation-contracts/{component}.md`.
3. Apply the **Shadowing Consistency Rule** from [3-implementation/README.md](../3-implementation/README.md) if `flow-chart.mmd` is part of the staged change.
4. Locate the Layer 3 `logic-implementation.{ext}` under the component's **active** technology folder.
5. Verify structural and behavioral parity (control flow, ports invoked, failure semantics). Naming may follow the target language; logic must not drift.
6. If Layer 1 pseudocode changed without a matching Layer 3 update (or vice versa), set `**STATUS:** KO`.

Obsolete technology folders (`logic-frozen.{ext}`) are excluded from the active mirror check unless the staged change explicitly touches frozen history.

### 6.4 Bidirectional traceability (Layer 3 obligation)

Each `3-implementation/{component}/README.md` **must** list every `ZC-XX` the component implements. Cross-check against the **Affected Components** table in the Layer 1 ZC `README.md`. Layer 1 is the SSOT for participation; Layer 3 declares materialization.

---

## 7. Audit Report Format

Update [solid-principles-review-report.md](solid-principles-review-report.md) per [README.md](README.md):

- **Preserve** everything above `## Current audit`.
- **Overwrite** from `## Current audit` to EOF:

```markdown
## Current audit

**Audit completed:** <yyyy-MM-ddTHH:mm:ss from Get-Date -Format "yyyy-MM-ddTHH:mm:ss">
**STATUS:** PASS

### Scope of last audit

<staged files / layers touched>

### Findings

<S, O, L, I, D + COD notes; or "No violations.">

### COD cross-check

<inward-only + stack leakage + fractal index per clean-onion-documentation.md §4>

### SOLID cross-check

<DIP + SRP at minimum; other principles if relevant>

### L4 ZC pseudocode mirror cross-check

<per §6.3: ZC/component pairs reviewed, parity result, or "Not applicable — no ZC paths staged.">
```

- Use **`STATUS: PASS`** only when COD §4, SOLID (S + D minimum), and L4 mirror (when applicable) all pass.
- Run **`Get-Date`** immediately before writing `**Audit completed:**` — hooks reject timestamps older than **60 seconds**.

---

## 8. Hook Enforcement (Optional — Audit Report Only)

The template ships [validate-integrity-report.ps1](../.githooks/validate-integrity-report.ps1) for teams that choose to activate it (`git config core.hooksPath .githooks`). **Activation is optional** per [GETTING_STARTED.md](../GETTING_STARTED.md) §2.

When active, `.githooks/pre-commit` and `.cursor/hooks.json` block `git commit` unless:

1. `5-governance/solid-principles-review-report.md` **exists**.
2. `**STATUS:** PASS` in `## Current audit`.
3. `**Audit completed:**` is **≤ 60 seconds** old.

On failure:

```text
Validaciones COD / SOLID KO, repita las validaciones
```

One-time setup per clone: [GETTING_STARTED.md](../GETTING_STARTED.md) §2.

---

## 9. L4 Mirror Validation — Agent-Only (No Template Hook)

### Policy

This template **does not** and **will not** include a Git hook (or any scripted gate) that compares Layer 1 pseudocode to Layer 3 `logic-implementation.{ext}` files. That decision is **out of scope** for the template.

Teams that fork this template may add project-specific automation on their own responsibility. The template assumes they will **not** — **agent enforcement is sufficient**.

### Why no mirror hook ships here

| Factor | Implication |
|--------|-------------|
| **Unknown stacks** | `{component}`, `{active-technology}`, and `logic-implementation.{ext}` are defined per project, not in the template. |
| **Semantic parity** | File-existence checks are weak; behavioral equivalence requires agent or human review. |
| **Maintenance cost** | A generic mirror hook would be fragile and unused in practice. |

### Enforcement model

| Concern | Enforced by |
|---------|-------------|
| **L4 pseudocode mirror** (§6.3) | **Agent** — mandatory audit before commit when ZC paths are staged; `**STATUS:** KO` on drift |
| **Audit report freshness** (§8) | **Optional Git hook** — `validate-integrity-report.ps1` only; teams enable via `core.hooksPath` per [GETTING_STARTED.md](../GETTING_STARTED.md) §2 |

The agent contract (`AGENTS.md` §9 + this document) is the **authoritative guarantee** that ZC changes replicate to Layer 3 code. No additional template artifact is required.

---

## 10. Related Paths

| Topic | Path |
|-------|------|
| Constitution pointer | [AGENTS.md](../AGENTS.md) §9 |
| Getting started | [GETTING_STARTED.md](../GETTING_STARTED.md) |
| Contributing | [CONTRIBUTING.md](../CONTRIBUTING.md) |
| Auditor skill stub | [skills/solid.md](../skills/solid.md) |
| COD dependency matrix | [clean-onion-documentation.md](clean-onion-documentation.md) §4 |
| L4 ZC logical standard | [1-product-documentation/diagrams-c4/L4-critical-zones/README.md](../1-product-documentation/diagrams-c4/L4-critical-zones/README.md) |
| Logical domain standard | [1-product-documentation/logical-domain/README.md](../1-product-documentation/logical-domain/README.md) |
| L4 ZC technical mirror | [3-implementation/README.md](../3-implementation/README.md) |
| Gate artifact | [solid-principles-review-report.md](solid-principles-review-report.md) |
| Hook script | [validate-integrity-report.ps1](../.githooks/validate-integrity-report.ps1) |
