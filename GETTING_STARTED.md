# Getting started — COD template repository

Instructions to **clone**, **activate the integrity gate**, and **run your first compliant commit**. The root [README.md](README.md) describes the product philosophy; this document covers **repository operations** for humans and maintainers.

External contributors proposing changes via pull request should also read [CONTRIBUTING.md](CONTRIBUTING.md).

🌐 **Language:** English

**Last updated:** 2026-06-29

---

## 1. Instantiate and clone

**Option A — GitHub template**

1. Click **Use this template** on GitHub to create your repository.
2. Clone your copy:

```powershell
git clone <your-repository-url>
cd <your-repository-folder>
```

**Option B — Fork this template**

Use the same `git clone` flow against your fork URL.

---

## 2. Activate the pre-commit hook (once per clone)

Git does **not** run `.githooks/` automatically. After **every new clone**, point Git at the versioned hooks folder:

```powershell
git config core.hooksPath .githooks
```

On Unix or macOS, make the hook executable:

```bash
chmod +x .githooks/pre-commit
```

### Verify activation

```powershell
git config core.hooksPath
```

Expected output:

```text
.githooks
```

### What the hook validates

Before each `git commit` or `git commit --amend`, [validate-integrity-report.ps1](.githooks/validate-integrity-report.ps1) checks [5-governance/solid-principles-review-report.md](5-governance/solid-principles-review-report.md):

1. The report file **exists**.
2. `**STATUS:** PASS` inside `## Current audit` (exact token `PASS`).
3. `**Audit completed:**` timestamp is **≤ 60 seconds** old (`yyyy-MM-ddTHH:mm:ss`).

On any failure, Git prints:

```text
Validaciones COD / SOLID KO, repita las validaciones
```

Full workflow and header contract: [5-governance/README.md](5-governance/README.md). Hook reference: [.githooks/README.md](.githooks/README.md).

### Manual dry-run (optional)

```powershell
.\.githooks\validate-integrity-report.ps1
echo exit:$LASTEXITCODE
```

Exit code `0` = gate would allow a commit; `1` = blocked.

---

## 3. Three layers of protection

| Layer | Where | What it does |
|-------|-------|--------------|
| **1. Git hook (local)** | Your machine after §2 | Blocks `git commit` / `--amend` if the audit report is missing, stale, or `KO` |
| **2. Cursor shell hook** | [`.cursor/hooks.json`](.cursor/hooks.json) | Blocks `git commit` launched from Cursor when layer 1 would fail |
| **3. Agent contract** | [pre-commit-validation-rules.md](5-governance/pre-commit-validation-rules.md) | Requires the agent to run [skills/solid.md](skills/solid.md) and regenerate the report before committing |

Layers 2 and 3 do **not** replace layer 1. Commits from an external terminal or another IDE only pass through the Git hook when `core.hooksPath` is set.

---

## 4. First compliant commit

1. Stage your changes (`git add …`).
2. Ask your AI agent to run the pre-commit audit (or invoke [skills/solid.md](skills/solid.md) yourself) per [pre-commit-validation-rules.md](5-governance/pre-commit-validation-rules.md).
3. The agent regenerates **only** `## Current audit` in [solid-principles-review-report.md](5-governance/solid-principles-review-report.md) with a fresh `Get-Date` timestamp and `STATUS: PASS` if [clean-onion-documentation.md](5-governance/clean-onion-documentation.md) §4 and SOLID checks pass.
4. Commit within **60 seconds** of that timestamp:

```powershell
git commit -m "Your message"
```

If the report still shows `STATUS: KO` or placeholder `1970-01-01T00:00:00`, the commit is **expected to fail** once the hook is active.

---

## 5. Bootstrap the implementation layer (optional)

When component stacks exist under `3-implementation/{component}/{technology}/`, each stack provides `.bootstrap/setup.sh` per [bootstrap-policy.md](3-implementation/bootstrap-policy.md).

**All components** (Git Bash, WSL, or Unix):

```bash
chmod +x .bootstrap/init-system.sh
.bootstrap/init-system.sh --env=dev
```

**One component only** — run that stack's script directly:

```bash
3-implementation/{component}/{technology}/.bootstrap/setup.sh --env=dev
```

Details: [.bootstrap/README.md](.bootstrap/README.md).

---

## 6. Populate the COD layers

After hooks are active:

1. Define core business rules in [1-product-documentation/logical-domain/](1-product-documentation/logical-domain/).
2. Wake your agent with [`AGENTS.md`](AGENTS.md) (or `@AGENTS.md` in Claude Code).
3. Navigate via layer `index.md` — never recursive directory scans (see [AGENTS.md](AGENTS.md) §7).

---

## 7. References

| Topic | Path |
|-------|------|
| Contributing (PRs, audit gates) | [CONTRIBUTING.md](CONTRIBUTING.md) |
| Constitution & §9 pointer | [AGENTS.md](AGENTS.md) |
| Pre-commit validation (SSOT) | [5-governance/pre-commit-validation-rules.md](5-governance/pre-commit-validation-rules.md) |
| Audit report usage | [5-governance/README.md](5-governance/README.md) |
| Machine gate artifact | [5-governance/solid-principles-review-report.md](5-governance/solid-principles-review-report.md) |
| COD layer matrix (SSOT) | [5-governance/clean-onion-documentation.md](5-governance/clean-onion-documentation.md) §4 |
| SOLID auditor skill | [skills/solid.md](skills/solid.md) |
| Git hooks folder | [.githooks/README.md](.githooks/README.md) |
| Bootstrap policy | [3-implementation/bootstrap-policy.md](3-implementation/bootstrap-policy.md) |
| Global bootstrap | [.bootstrap/README.md](.bootstrap/README.md) |
| Repository map | [README.md](README.md) |
