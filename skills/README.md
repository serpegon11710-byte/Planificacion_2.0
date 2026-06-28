# Skills — Authoring Guide

Operational modes for AI agents. **Skill bodies live only in `skills/<name>.md`.** This file documents how to register, update, and remove skills — not the operational rules themselves.

For architecture rationale, see [5-governance/multi-agent-governance.md](../5-governance/multi-agent-governance.md) §5 (maintainers only — do not load during normal agent work).

---

## Purpose

- **Skills** = task-specific behavioral modes (analyze, implement, PO debate, etc.).
- **Body** = `skills/<name>.md` (source of truth for rules).
- **Discovery** = `AGENTS.md` §8 Skills catalog + agent stubs (redirect only).

---

## Triple Contract

Every registered skill requires **three artifacts** with the **same `<name>`**:

| # | Artifact | Path |
|---|----------|------|
| 1 | Skill body | `skills/<name>.md` |
| 2 | Hub catalog row | `AGENTS.md` §8 Skills catalog |
| 3+ | Agent stubs | See [Stub registry](#stub-registry) below |

If any piece is missing, the skill is **not registered**.

```text
skills/README.md  ──procedure──►  (read first when creating a skill)
       │
       ▼
skills/<name>.md  ──content──►  (authoritative body)
       ▲                              ▲
       │                              │
AGENTS.md §8 row              agent stubs (redirect)
```

---

## Stub Registry

Maintain this table when adding agents or skills. Stubs are **redirect-only** — never copy skill bodies.

| Agent / tool | Stub path (per skill) | Status | Stub content |
|--------------|----------------------|--------|--------------|
| **Cursor** | `.cursor/skills/<name>/SKILL.md` | **Required** | YAML frontmatter + redirect → `skills/<name>.md` |
| **Claude Code** | *(none per skill)* | N/A | `@skills/<name>.md` or `AGENTS.md` §8 |
| **GitHub Copilot** | *(none per skill)* | N/A | `AGENTS.md` §8 + `@skills/<name>.md` |
| **Codex / Windsurf / Aider / Zed** | *(none per skill)* | N/A | Native `AGENTS.md` + `@skills/<name>.md` |
| **Future agents** | TBD under `.cursor/`, `.claude/`, `.github/`, etc. | Add when adopted | Redirect only — same `<name>`, link to `skills/<name>.md` |

### Registered skills (Cursor stubs)

| Skill file | Cursor stub | Purpose |
|------------|-------------|---------|
| `skills/analyze.md` | `.cursor/skills/analyze/SKILL.md` | Feasibility analysis, no code |
| `skills/architect.md` | `.cursor/skills/architect/SKILL.md` | Conceptual contract extraction |
| `skills/document.md` | `.cursor/skills/document/SKILL.md` | Documentation-only turns |
| `skills/implement.md` | `.cursor/skills/implement/SKILL.md` | Atomic code changes |
| `skills/product-owner.md` | `.cursor/skills/product-owner/SKILL.md` | PO debate and resolution |
| `skills/solid.md` | `.cursor/skills/solid/SKILL.md` | SOLID and coupling audit |

When a new agent requires its own stub format, **update this table first**, then create stubs.

---

## Naming Rule

For every skill at `skills/<name>.md`:

```text
.cursor/skills/<name>/SKILL.md
```

The folder name **must equal** the basename of the source file (without `.md`).

- `skills/analyze.md` → `.cursor/skills/analyze/SKILL.md`
- `skills/product-owner.md` → `.cursor/skills/product-owner/SKILL.md`

**Never** rename or diverge: one source file, one stub folder, same `<name>`.

---

## Add a Skill (checklist)

Complete **all steps** in the same change:

1. Create `skills/<name>.md` with full operational instructions.
2. Add one row to `AGENTS.md` §8 Skills catalog (path, when to use).
3. Create `.cursor/skills/<name>/SKILL.md` (redirect stub — see template below).
4. Add a row to the [Registered skills](#registered-skills-cursor-stubs) table in this file.
5. Do **not** add skill content anywhere else (no body in stubs, no duplicate rules in `AGENTS.md`).

---

## Remove a Skill (checklist)

1. Delete `skills/<name>.md`.
2. Remove the row from `AGENTS.md` §8.
3. Delete `.cursor/skills/<name>/` (and any other stubs for that `<name>`).
4. Remove the row from the [Registered skills](#registered-skills-cursor-stubs) table in this file.

---

## Templates

### Cursor stub (`.cursor/skills/<name>/SKILL.md`)

```markdown
---
name: <name>
description: <one line — must match AGENTS.md §8 intent; see existing stubs>
---

Read and strictly follow all instructions in [skills/<name>.md](../../skills/<name>.md).

Do not proceed until that file has been loaded in full. Do not infer rules from this stub.
```

| Allowed in stub | Forbidden in stub |
|-----------------|-------------------|
| `name` + `description` frontmatter | Copying paragraphs from `skills/<name>.md` |
| Single redirect link to `skills/<name>.md` | Extra rules, examples, or COD governance text |
| “Load in full before acting” guard | Paraphrasing or summarizing the skill body |

### AGENTS.md §8 catalog row

```markdown
| <name> | [skills/<name>.md](skills/<name>.md) | <when to use — one line> |
```

---

## How Agents Consume Skills

1. **Cursor skill picker:** `.cursor/skills/<name>/SKILL.md` → redirect → `skills/<name>.md`.
2. **Explicit @ mention:** `@skills/<name>.md` — source file is authoritative.
3. **Passive registry:** `AGENTS.md` §8 lists modes without loading bodies.

All paths converge on **one file:** `skills/<name>.md`.
