# Clean Onion Documentation (COD) - Template 🚀

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
🌐 **Language:** English

A concentric fractal architecture blueprint for modern software repositories. Built to enforce strict decoupling, prevent documentation technical debt, and optimized for AI-assisted development (Cursor, Claude Code, GitHub Copilot).

---

## 💡 The Philosophy Behind COD

While developers extensively apply **Clean Onion Architecture (COA)** to isolate core business rules from infrastructure code, software documentation is usually left unstructured. As projects scale, knowledge becomes decoupled, chaotic, and hard to track.

In the era of AI-driven development, this creates a critical issue: **AI Agents suffer from context drift, hallucinate, and waste tokens** due to messy file indexes and bloated text files.

**COD (Clean Onion Documentation)** solves this by introducing a concentric, modular, and fractal architecture for your repository's knowledge base. It treats documentation with the exact same rigor as production code.

## 🧩 The COD-COA Symbiosis

The **Clean Onion Documentation (COD)** is the practical materialization of **Clean Onion Architecture (COA)** principles into persistent knowledge artifacts. 

While COA mandates the separation of layers to protect the business core, COD ensures that this separation is not lost over time. If COA provides the rules for your code, COD provides the rules for your project's memory. As a foundational principle: **If you do not document your architectural boundaries with the same rigor as you write your code, the architecture will inevitably decay as the project evolves.**

The relationship between code and documentation is perfectly symmetrical:

| Clean Onion Architecture (Code) | Clean Onion Documentation (COD) |
| :--- | :--- |
| **Domain Core (Entities)** | **Layer 1:** Product Documentation |
| **Application Services** | **Layer 1/2:** Use Cases & Business Rules |
| **Infrastructure/Adapters** | **Layer 3:** Implementation Contracts |
| **Governance & Guidelines** | **Layer 5:** Standards & Policies |

By aligning your documentation with these boundaries, you transform the documentation from a passive summary into an active architectural guardrail.

---

## 📂 Concentric Repository Structure

The repository workspace is divided into concentric layers. Outer layers depend on inner layers, but the inner layers (the core business definition) remain 100% agnostic to technology or temporal changes.

```text
📁 clean-onion-documentation-template (Root)
├── 📄 LICENSE                   <-- MIT Open-Source Permission Matrix
├── 📄 README.md                 <-- International Entry Point (English)
├── 📄 GETTING_STARTED.md          <-- Clone, integrity hook, first commit
├── 📄 CONTRIBUTING.md             <-- External contributions and audit gates
├── 📄 AGENTS.md                 <-- Hub: constitution + registry + skills catalog
├── 📄 CLAUDE.md                 <-- Claude Code pointer (@AGENTS.md)
├── 📄 .editorconfig             <-- Canonical formatting (Forcing LF, character sets)
├── 📄 .gitattributes            <-- Cross-OS Git normalization (LF line endings for Windows)
├── 📄 .markdownlint.json        <-- Quality Assurance (Enforcing strict MD040 rule)
├── 📄 .gitignore                <-- AI Token Protection Filter (Blocking cache/logs)
│
├── 📁 .bootstrap/               <-- Global init orchestrator (init-system.sh)
├── 📁 .github/
│   └── copilot-instructions.md  <-- GitHub Copilot pointer to AGENTS.md
├── 📁 .gemini/
│   └── settings.json            <-- Gemini CLI: loads AGENTS.md
├── 📁 .cursor/
│   └── skills/                  <-- Cursor skill stubs (redirect → skills/)
├── 📁 skills/                   <-- Operational modes (source of truth)
│
├── 📁 1-product-documentation/  <-- CORE: Agnostic Use Cases, Domain Entities & C4 Diagrams
├── 📁 2-epics/                  <-- Scope Definition & Architectural Design Backlog (Tickets)
├── 📁 3-implementation/         <-- Technology Layer (Live source code, framework bootstraps)
├── 📁 4-sprints/                <-- Temporal tracking, evolutionary milestones & logs
└── 📁 5-governance/             <-- Cross-cutting concerns, SOLID guidelines & COD manifests
    └── multi-agent-governance.md  <-- Multi-agent hub-and-spoke architecture (maintainers)
```

### 🌀 The Atomic Fractal Pattern

To guarantee maximum efficiency and minimum token consumption, every significant subfolder inside these layers must mirror a predictable, self-contained ecosystem:

- `README.md`: Block-specific behavior, constraints, and operational scope.

- `index.md`: Live file directory and internal mapping for instant AI lookups.

- `history/`: Chronological modification logs to maintain context tracking.

- `doubts_and_resolutions/`: Atomic space to isolate issues, FAQs, and edge cases.

## 🤖 AI Agent Governance

This boilerplate comes pre-configured with a state-of-the-art orchestration layer designed to command autonomous AI Agents safely:

- **Single hub:** [`AGENTS.md`](AGENTS.md) is the constitution, Source of Truth Registry (§6), bootstrap sequence (§7), and skills catalog (§8). Cursor, Codex, and Windsurf load it automatically; Claude Code uses [`CLAUDE.md`](CLAUDE.md); Copilot uses [`.github/copilot-instructions.md`](.github/copilot-instructions.md).

- **Context Lock:** Forces agents to pull runtime variables dynamically (such as frozen date bugs in Cursor) instead of guessing — see §1 Get-Date mandate.

- **Anti-scan navigation:** Agents discover files via layer `index.md` — never recursive directory scans.

- **Shell Safeguards:** Pre-engineered protocols optimized for **Windows PowerShell 5.x** environments to prevent multiline string or `heredoc` crashes.

- **Syntax Enforcement:** The `.markdownlint.json` configuration isolates the **MD040** rule, preventing agents from writing unassigned code blocks that break markdown visual parsers.

- **Operational modes:** Six skills in [`skills/`](skills/) with Cursor redirect stubs in [`.cursor/skills/`](.cursor/skills/). See [`skills/README.md`](skills/README.md) to add or remove modes. Maintainer architecture: [`5-governance/multi-agent-governance.md`](5-governance/multi-agent-governance.md).

## 🛠️ Getting Started

1. Click **"Use this template"** on GitHub to instantly instantiate this structure into your new repository.

2. Clone your new repository locally:

```powershell
git clone <your-repository-url>
```

3. **Activate the integrity gate** (once per clone) — see [`GETTING_STARTED.md`](GETTING_STARTED.md) §2 (`git config core.hooksPath .githooks`).

4. **Bootstrap components** (when stacks exist) — see [`.bootstrap/README.md`](.bootstrap/README.md) and [3-implementation/bootstrap-policy.md](3-implementation/bootstrap-policy.md).

5. Introduce your core business rules inside `1-product-documentation/logical-domain/`.

6. **Contributing changes?** See [`CONTRIBUTING.md`](CONTRIBUTING.md) for pull requests and pre-commit gates.

7. Wake up your AI Agent by referencing [`AGENTS.md`](AGENTS.md) in your first prompt (or attach `@AGENTS.md` in Claude Code).

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

*Authored by serpegon11710-byte. Engineered for the next generation of software engineering architecture.*
