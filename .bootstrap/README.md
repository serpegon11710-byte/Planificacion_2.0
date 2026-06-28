# Global Bootstrap (`.bootstrap/`)

**Last updated:** 2026-06-29

Root-level orchestration for component initialization. Policy and structure: [3-implementation/bootstrap-policy.md](../3-implementation/bootstrap-policy.md).

## `init-system.sh`

The **Global Bootstrap Orchestrator**. It discovers every `setup.sh` under `3-implementation/{component}/{technology}/.bootstrap/` and runs them in deterministic order (sorted path). No hardcoded component list.

### Full system bootstrap

From the repository root (Git Bash, WSL, or Unix shell):

```bash
chmod +x .bootstrap/init-system.sh
.bootstrap/init-system.sh
```

Optional environment flag (forwarded to each component `setup.sh`):

```bash
.bootstrap/init-system.sh --env=dev
```

Dry run (list scripts that would run, without executing):

```bash
.bootstrap/init-system.sh --dry-run
```

### Single component bootstrap

To initialize **one** stack only, run that stack's script directly — do not use `init-system.sh`:

```bash
chmod +x 3-implementation/{component}/{technology}/.bootstrap/setup.sh
3-implementation/{component}/{technology}/.bootstrap/setup.sh --env=dev
```

Replace `{component}` and `{technology}` with the folders defined in your project.

## Prerequisites

- Each active technology stack must provide `BOOTSTRAP.md` (intention) and `.bootstrap/setup.sh` (idempotent execution) per the bootstrap policy.
- Stacks marked obsolete in their path are **skipped** by `init-system.sh` (read-only historical record).
- When no `setup.sh` files exist yet, the orchestrator exits successfully and reports that nothing was found.

## Related paths

| Topic | Path |
|-------|------|
| Bootstrap policy (SSOT) | [3-implementation/bootstrap-policy.md](../3-implementation/bootstrap-policy.md) |
| Implementation layer | [3-implementation/README.md](../3-implementation/README.md) |
