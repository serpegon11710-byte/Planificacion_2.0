# Contributing

**Last updated:** 2026-06-29

Thank you for improving this repository. All contributions — documentation, governance, or implementation — must respect **Clean Onion Documentation (COD)** layer boundaries and pass the **pre-commit integrity gates** before merge.

🌐 **Language:** English (persistence). Prose in pull requests and issues may be in any language the maintainers accept.

---

## 1. Before you start

1. Read [README.md](README.md) for repository philosophy and layer map.
2. Complete one-time setup in [GETTING_STARTED.md](GETTING_STARTED.md) (clone, `core.hooksPath`, optional bootstrap).
3. Load [AGENTS.md](AGENTS.md) when using an AI assistant — agents inherit the same pre-commit contract as humans.

---

## 2. Proposing changes (fork workflow)

1. **Fork** the repository (or create a branch if you are a maintainer with write access).
2. **Create a topic branch** from the default branch (`main` or as defined by maintainers).
3. **Make focused changes** — one concern per pull request when possible.
4. **Navigate by `index.md`** inside each layer; do not rely on recursive directory scans (see [AGENTS.md](AGENTS.md) §7).
5. **Open a pull request** with a clear summary: what changed, why, and which COD layers are affected.

---

## 3. Mandatory pre-commit gates

Every commit intended for merge **must** pass the integrity contract defined in [5-governance/pre-commit-validation-rules.md](5-governance/pre-commit-validation-rules.md) (`AGENTS.md` §9).

### What is validated

| Check | Source |
|-------|--------|
| **COD** — inward-only dependencies, no stack leakage | [clean-onion-documentation.md](5-governance/clean-onion-documentation.md) §4 |
| **SOLID** — at minimum **S** and **D** on staged changes | `pre-commit-validation-rules.md` §5 |
| **L4 ZC pseudocode mirror** — when ZC paths are staged | `pre-commit-validation-rules.md` §6 (agent audit) |

### Contributor workflow per commit

1. Stage your changes (`git add …`).
2. Run the pre-commit audit:
   - **With an AI agent:** ask it to invoke [skills/solid.md](skills/solid.md) and regenerate `## Current audit` in [solid-principles-review-report.md](5-governance/solid-principles-review-report.md).
   - **Manually:** follow the regeneration workflow in `pre-commit-validation-rules.md` §3.
3. Confirm `**STATUS:** PASS` and a fresh `**Audit completed:**` timestamp (≤ 60 seconds old).
4. Commit immediately:

```powershell
git commit -m "Your message"
```

If the Git hook is active (`git config core.hooksPath .githooks`), a stale or missing report blocks the commit with:

```text
Validaciones COD / SOLID KO, repita las validaciones
```

### Prohibited shortcuts

- Do **not** use `git commit --no-verify` unless a maintainer explicitly requests it for a documented exception.
- Do **not** commit with `STATUS: KO` in the audit report.
- Do **not** bypass layer rules (e.g., stack references in Layer 1, upward links from inner layers).

---

## 4. Pull request checklist

Before requesting review, confirm:

- [ ] Hook activated per [GETTING_STARTED.md](GETTING_STARTED.md) §2 (if contributing from a local clone).
- [ ] Every commit in the PR branch passed the pre-commit gate (or will pass before merge).
- [ ] `solid-principles-review-report.md` shows `STATUS: PASS` for the latest audit scope covering your changes.
- [ ] COD layer dependency matrix respected — no inward → outward references.
- [ ] Documentation uses English for persisted files ([repository-language-standard.md](5-governance/repository-language-standard.md)).
- [ ] Markdown code fences include a language identifier (MD040 — see [AGENTS.md](AGENTS.md) §4).

---

## 5. When the audit fails

1. Read **Findings** in `## Current audit` of [solid-principles-review-report.md](5-governance/solid-principles-review-report.md).
2. Fix violations (refactor, move content to the correct layer, restore traceability).
3. Log unresolved architectural conflicts in the affected layer's `doubts_and_resolutions/index.md` if debate is needed.
4. Re-run the audit and commit only after `STATUS: PASS`.

---

## 6. Scope and review expectations

| Change type | Review focus |
|-------------|--------------|
| Layer 1 (`1-product-documentation/`) | Agnosticism, SSOT, logical-domain and C4 consistency |
| Layer 3 (`3-implementation/`) | Contracts, decoupling, L4 / logical-domain shadowing |
| Layer 5 (`5-governance/`) | Policy coherence; avoid duplicating SSOT tables |
| Hooks / `AGENTS.md` | Alignment with `pre-commit-validation-rules.md` |

Maintainers may request additional changes. Approval implies the branch met COD and SOLID gates at commit time.

---

## 7. References

| Topic | Path |
|-------|------|
| Clone and hook setup | [GETTING_STARTED.md](GETTING_STARTED.md) |
| Pre-commit validation (SSOT) | [5-governance/pre-commit-validation-rules.md](5-governance/pre-commit-validation-rules.md) |
| Auditor skill | [skills/solid.md](skills/solid.md) |
| COD standard | [5-governance/clean-onion-documentation.md](5-governance/clean-onion-documentation.md) |
| Agent constitution | [AGENTS.md](AGENTS.md) |
