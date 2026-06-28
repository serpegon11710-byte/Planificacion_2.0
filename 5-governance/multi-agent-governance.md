# Multi-Agent Governance Architecture

Cross-cutting policy for configuring and operating AI agents (Cursor, Claude Code, GitHub Copilot, Codex, Windsurf, Gemini CLI, Aider) in this repository.

**Policy model:** authoritative specifications live in **Layer 5** (`5-governance/*.md`). Root `AGENTS.md` holds the **operational constitution** and **pointers** to those sources — never duplicate full policy text in adapters or stubs.

---

## 1. Design Goal

Agents must **know where truth lives** without:

- Scanning the repository recursively on every request
- Duplicating governance text across `.cursor/rules/`, Copilot files, and skills stubs
- Copying skill **bodies** into `.cursor/skills/` (content must stay in `skills/` only)

**Strategy:** A **hub-and-spoke** model. One root registry (`AGENTS.md`) lists every authoritative path. Agents navigate **only through index files** (`index.md`) and read **only what the task requires**.

```text
                    ┌─────────────────┐
                    │   AGENTS.md     │  ← HUB: constitution + pointers
                    │  (root, L0)     │
                    └────────┬────────┘
         ┌───────────────────┼───────────────────┐
         ▼                   ▼                   ▼
   README.md          5-governance/          skills/
   (onboarding)       index.md            *.md + README.md
                      (policy catalog)       (modes + how-to)
         │                   │
         ▼                   ▼
   {layer}/README.md   {layer}/index.md
   (scope rules)       (file catalog — NO scan)
```

---

## 2. Source of Truth Registry

All authoritative content lives in **one place per concern**. Adapters never copy it — they only **redirect** to the hub.

| Concern | Authoritative path | Agent action |
|---------|-------------------|--------------|
| **Constitution** (dates, shell, MD040, navigation law, pre-commit gate) | `AGENTS.md` | Loaded automatically (Cursor, Codex, Windsurf) or via `@AGENTS.md` (Claude) |
| **Repository map & philosophy** | `README.md` | Read once per session if task touches structure |
| **Cross-cutting policies** | `5-governance/index.md` → linked `*.md` | Open index; load **only** policies cited by the task |
| **COD fractal standard & layer dependency matrix** | `5-governance/clean-onion-documentation.md` (§4 = SSOT for inward-only + stack leakage) | Load when creating/editing layer structure or auditing commits |
| **Multi-agent architecture** (this document) | `5-governance/multi-agent-governance.md` | Maintainers configuring agents; not loaded during normal agent work |
| **Operational modes** | `skills/<name>.md` + `skills/README.md` + `AGENTS.md` §8 + agent stubs | Triple contract — see §5 below |
| **Layer scope & navigation** | `{N-layer}/README.md` | Read when working inside that layer |
| **Layer file catalog** | `{N-layer}/index.md` | **Mandatory** file discovery — never list-dir |
| **Doubts dashboard** | `{N-layer}/doubts_and_resolutions/index.md` | Load when managing doubts |
| **History map** | `{N-layer}/history/index.md` | Load when writing traceability logs |

### Navigation law (anti-scan)

```text
PROHIBITED:  glob **/*, recursive list_dir, "explore the codebase"
REQUIRED:    AGENTS.md → target layer README → target layer index → specific file
```

Token cost stays bounded because the agent reads **at most 3–5 index hops**, not the whole tree.

---

## 3. What We Explicitly Reject

| Rejected pattern | Why |
|------------------|-----|
| `.cursor/rules/cod-governance.mdc` duplicating `AGENTS.md` | Cursor already loads `AGENTS.md`; duplicate bootstrap wastes tokens and drifts |
| Migrating `skills/*.md` → `.cursor/skills/*/SKILL.md` **with full body** | Duplicates content; forbidden |
| Five `.github/instructions/cod-layer-*.md` copying layer rules | Layer rules already live in `{layer}/README.md` |
| Nested `AGENTS.md` per layer | Optional only at monorepo scale; root registry + layer README suffice for this template |
| Full-repo scan "to understand context" | Violates COD fractal index pattern |
| Duplicating Layer 5 policy bodies in `AGENTS.md` or adapters | SSOT lives in `5-governance/`; hub holds pointers only |

---

## 4. Minimal Adapter Files (Non-Cursor Tools)

Cursor needs **no governance duplicate** in `.cursor/rules/` — it auto-loads `AGENTS.md`. Redirect stubs in `.cursor/skills/` point to `skills/<name>.md` only.

Other tools need a **one-line redirect** — not a second constitution.

| Tool | File | Content strategy |
|------|------|------------------|
| **Cursor** | `.cursor/skills/<name>/SKILL.md` stubs | Native `AGENTS.md` auto-load + redirect stubs (no rules duplicated) |
| **Claude Code** | `CLAUDE.md` | Single line: `@AGENTS.md` |
| **GitHub Copilot** | `.github/copilot-instructions.md` | Pointer to `/AGENTS.md`; use layer indexes per registry |
| **Gemini CLI** | `.gemini/settings.json` | `{ "context": { "fileName": "AGENTS.md" } }` |
| **Codex / Windsurf / Aider / Zed** | *(none)* | Native `AGENTS.md` |

### Example `.github/copilot-instructions.md`

```markdown
# COD Template — Copilot pointer

Authoritative instructions: [AGENTS.md](/AGENTS.md) at repository root.

Before editing: follow the Source of Truth Registry in AGENTS.md (§6).
Do not scan directories recursively — use layer `index.md` files only.
```

### Example `CLAUDE.md`

```markdown
@AGENTS.md
```

---

## 5. Skills — Centralized in `skills/`

**Source of truth:** `skills/<name>.md` only. All skill **content** lives here and nowhere else.

### `skills/README.md` — Skill authoring guide

Procedural source of truth for creating, updating, or removing operational modes. **Not** a skill body.

- Step-by-step checklist for adding, updating, or removing a skill
- Canonical **stub registry** per agent (redirect-only)
- Templates (catalog row, Cursor stub)
- Naming rules (`<name>` parity across paths)

`AGENTS.md` §8 links to [skills/README.md](../skills/README.md).

### Triple contract

Every registered skill requires **three artifacts** with the **same `<name>`**:

| # | Artifact | Path |
|---|----------|------|
| 0 | Authoring guide | `skills/README.md` |
| 1 | Skill body | `skills/<name>.md` |
| 2 | Hub catalog row | `AGENTS.md` §8 |
| 3+ | Agent stubs | See stub registry in `skills/README.md` |

```text
skills/README.md  ──procedure──►  (read first when creating a skill)
       │
       ▼
skills/<name>.md  ──content──►  (authoritative body)
       ▲                              ▲
       │                              │
AGENTS.md §8 row              agent stubs (redirect)
```

**Rule:** If `skills/<name>.md` exists, the `AGENTS.md` catalog entry and every stub in `skills/README.md` for active agents **must** exist.

### Agent stub registry

Maintain in **`skills/README.md`**. When a new agent requires stubs, update that README first.

| Agent / tool | Stub path (per skill) | Stub content |
|--------------|----------------------|--------------|
| **Cursor** | `.cursor/skills/<name>/SKILL.md` | YAML frontmatter + redirect → `skills/<name>.md` |
| **Claude Code** | *(none per skill)* | `@skills/<name>.md` or `AGENTS.md` §8 |
| **GitHub Copilot** | *(none per skill)* | `AGENTS.md` §8 + `@skills/<name>.md` |
| **Codex / Windsurf / Aider / Zed** | *(none per skill)* | Native `AGENTS.md` + `@skills/<name>.md` |
| **Future agents** | TBD | Redirect only — same `<name>`, link to `skills/<name>.md` |

### Registered skills (Cursor stubs)

| Skill file | Cursor stub |
|------------|-------------|
| `skills/analyze.md` | `.cursor/skills/analyze/SKILL.md` |
| `skills/architect.md` | `.cursor/skills/architect/SKILL.md` |
| `skills/document.md` | `.cursor/skills/document/SKILL.md` |
| `skills/implement.md` | `.cursor/skills/implement/SKILL.md` |
| `skills/product-owner.md` | `.cursor/skills/product-owner/SKILL.md` |
| `skills/solid.md` | `.cursor/skills/solid/SKILL.md` |

### Naming rule

```text
skills/<name>.md  ↔  .cursor/skills/<name>/SKILL.md  ↔  AGENTS.md §8 row
```

Folder name **must equal** the skill basename (without `.md`).

### Cursor stub format (redirect only)

```yaml
---
name: <name>
description: <one line — match AGENTS.md §8 intent>
---
```

```markdown
Read and strictly follow all instructions in [skills/<name>.md](../../skills/<name>.md).

Do not proceed until that file has been loaded in full. Do not infer rules from this stub.
```

| Allowed in stub | Forbidden in stub |
|-----------------|-------------------|
| `name` + `description` frontmatter | Copying paragraphs from `skills/<name>.md` |
| Single redirect link | Extra rules, COD governance text, paraphrasing |

### How agents consume skills

1. **Cursor skill picker:** stub → redirect → `skills/<name>.md`
2. **Explicit @ mention:** `@skills/<name>.md` — authoritative with or without stub
3. **Passive registry:** `AGENTS.md` §8 lists modes without loading bodies

### Add / remove skill (summary)

**Add:** follow `skills/README.md` → create body → register §8 row → create stubs → update stub table in `skills/README.md`.

**Remove:** delete body, §8 row, all stubs, and stub table row — in one change.

---

## 6. Target File Tree

```text
📁 clean-onion-documentation-template/
├── 📄 AGENTS.md                    ← Hub: constitution + pointers
├── 📄 README.md
├── 📄 CLAUDE.md                    ← @AGENTS.md
│
├── 📁 .github/copilot-instructions.md
├── 📁 .gemini/settings.json
├── 📁 skills/                      ← Operational modes (content SSOT)
│   ├── README.md
│   └── *.md
├── 📁 .cursor/skills/              ← Cursor stubs (redirect only)
│
├── 📁 1-product-documentation/
├── 📁 2-epics/
├── 📁 3-implementation/
├── 📁 4-sprints/
└── 📁 5-governance/                ← Policy SSOT (this file)
```

**Deliberately omitted:** `.cursor/rules/` for COD governance; skill bodies inside `.cursor/skills/`; `.github/instructions/cod-layer-*`.

---

## 7. Agent Loading Matrix

| Agent | Auto-loads `AGENTS.md` | Extra files | Repo scan |
|-------|:----------------------:|-------------|:---------:|
| Cursor | Yes | `.cursor/skills/<name>/SKILL.md` stubs | No — indexes only |
| Claude Code | Via `CLAUDE.md` | `CLAUDE.md` = `@AGENTS.md` | No |
| Copilot CLI / VS Code | Partial / Yes | `.github/copilot-instructions.md` | No |
| Codex CLI | Yes | None | No |
| Windsurf | Yes | None | No |
| Gemini CLI | Config | `.gemini/settings.json` | No |

---

## 8. Maintenance

1. **New policy?** Add under `5-governance/`, update `index.md` + `index.md`. Do **not** duplicate in adapters.
2. **New skill?** Follow `skills/README.md` — body, `AGENTS.md` §8 row, stubs in one change.
3. **New agent stub format?** Update `skills/README.md` stub registry first.
4. **Behavior change for all agents?** Edit `AGENTS.md` for operational rules; edit Layer 5 policy files for architectural rules.
5. **Layer dependency or stack rules?** Edit `clean-onion-documentation.md` §4 only — validation criteria live in `pre-commit-validation-rules.md`; do not duplicate the matrix.

---

## 9. References

| Resource | Role |
|----------|------|
| [agents.md](https://agents.md/) | Portable hub file format |
| [clean-onion-documentation.md](clean-onion-documentation.md) | COD fractal structure; §4 = layer dependency SSOT |
| [pre-commit-validation-rules.md](pre-commit-validation-rules.md) | Pre-commit validation SSOT (`AGENTS.md` §9) |
| [solid-principles-review-report.md](solid-principles-review-report.md) | SOLID & COD pre-commit gate artifact |
