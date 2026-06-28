# Governance

This folder manages the **governance** layer (Layer 5): cross-cutting policies, COD standards, and agent orchestration rules.

## Navigation

- [index.md](index.md) — Live directory of all files in this layer.
- [doubts_and_resolutions/](doubts_and_resolutions/) — Atomic management of open and closed doubts.

## Pre-commit audit report (`solid-principles-review-report.md`)

### Purpose

[solid-principles-review-report.md](solid-principles-review-report.md) is the **machine gate artifact** for [AGENTS.md](../AGENTS.md) §9. Before each `git commit`, the agent regenerates it after invoking [skills/solid.md](../skills/solid.md) per [pre-commit-validation-rules.md](pre-commit-validation-rules.md).

Humans read this file to inspect the last audit; the agent owns regeneration. **All validation criteria** (COD, SOLID, L4 ZC pseudocode mirror) live in `pre-commit-validation-rules.md` — not here.

### File structure

| Section | Who maintains it |
|---------|------------------|
| Everything **above** `## Current audit` | Fixed template (do not overwrite on audit) |
| `## Current audit` to end of file | **Regenerated** by the agent before each commit |

### Regeneration workflow

Follow [pre-commit-validation-rules.md](pre-commit-validation-rules.md) §3.

### Header contract (hook-readable)

Inside `## Current audit`, these lines **must** appear first, in this order:

```markdown
**Audit completed:** yyyy-MM-ddTHH:mm:ss
**STATUS:** PASS
```

| Field | Rule |
|-------|------|
| `Audit completed` | Exact `Get-Date -Format "yyyy-MM-ddTHH:mm:ss"` output at audit end |
| `STATUS` | `PASS` if all checks in `pre-commit-validation-rules.md` pass; `KO` otherwise (exact token `PASS`) |

### Hook enforcement

See [pre-commit-validation-rules.md](pre-commit-validation-rules.md) §8.

One-time setup per clone — full guide: [GETTING_STARTED.md](../GETTING_STARTED.md) §2.

```powershell
git config core.hooksPath .githooks
```

### Related paths

| Topic | Path |
|-------|------|
| Pre-commit validation (SSOT) | [pre-commit-validation-rules.md](pre-commit-validation-rules.md) |
| Constitution pointer | [AGENTS.md](../AGENTS.md) §9 |
| Auditor skill | [skills/solid.md](../skills/solid.md) |
| Layer dependency SSOT | [clean-onion-documentation.md](clean-onion-documentation.md) §4 |
