# Git hooks (COD integrity gate)

Validates `5-governance/solid-principles-review-report.md` before each commit.

## One-time setup (per clone)

Full walkthrough: [GETTING_STARTED.md](../GETTING_STARTED.md) §2 · [CONTRIBUTING.md](../CONTRIBUTING.md).

```powershell
git config core.hooksPath .githooks
```

On Unix:

```bash
chmod +x .githooks/pre-commit
```

## Checks (all required)

1. Report file **exists**.
2. `**STATUS:** PASS` (exact value).
3. `**Audit completed:**` timestamp is **≤ 60 seconds** old (`yyyy-MM-ddTHH:mm:ss`).

If **any** check fails, the hook prints:

```text
Validaciones COD / SOLID KO, repita las validaciones
```

Regenerate the report per [pre-commit-validation-rules.md](../5-governance/pre-commit-validation-rules.md) before retrying `git commit`. Report file usage: [5-governance/README.md](../5-governance/README.md).
