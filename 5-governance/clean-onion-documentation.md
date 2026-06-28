# Clean Onion Documentation (COD) Standard

**Last updated:** 2026-06-29

This cross-cutting policy defines the **directionality**, **isolation**, and **internal fractal structure** of all documentation layers within the repository. It complements the Agent Governance rules defined in `AGENTS.md`.

## 1. Purpose and Onion Dependency Rule

The goal of this standard is to guarantee **absolute isolation of concerns** in project documentation. Following the concentric model of Onion Architecture, the conceptual core is located in the protected center, while management, technology, and timelines are deployed in the outer layers.

**Strict Dependency Rule:** Outer layers (higher numbers) **know**, **wrap**, and **reference** inner layers (lower numbers). Inner layers are **entirely agnostic** and **never** have visibility, links, or feedback loops regarding what happens outside them.

## 2. The Internal Fractal Block/Layer Pattern

To guarantee absolute optimization in token consumption and prevent AI context loss, **every relevant layer or sub-module** of the system must strictly follow an identical, fractal, and self-contained file system pattern.

Every block or main folder within the layers must replicate this exact scheme:

```text
📁 X-block-name/
├── 📄 README.md                 <-- Fixed instructions: HOW the AI must operate in this block.
├── 📄 index.md                  <-- Live directory/Map of all files in this section.
│
├── 📁 history/                  <-- Chronological modification log (Traceability).
│   ├── 📄 2026-W26-changes.md   <-- One file per period Week of Year.
│   └── 📄 2026-W27-changes.md
│
└── 📁 doubts_and_resolutions/   <-- Atomic management of doubts and FAQs.
    ├── 📄 README.md             <-- Strict protocol for opening/closing issues.
    ├── 📄 index.md              <-- Dashboard (Open vs. Solved doubts).
    ├── 📁 open/                 <-- Active tracking (work in progress).
    │   ├── 📄 doubt-001.md      <-- Isolated file exclusively for open doubt 001.
    │   └── 📄 doubt-002.md
    └── 📁 solved/               <-- Knowledge base (closed decisions / history).
        └── 📄 doubt-000.md      <-- Resolved doubt moved from open/.

```
### Fractal Component Specification:

- **`README.md` (Static):** Defines the folder scope and fixed AI behavioral rules. Minimizes token usage as it remains constant.

- **`index.md` (Dynamic):** File catalog for the **current directory only**. The table lists exclusively `.md` files at the same path level (excluding `index.md` itself). Subdirectories are **not** listed — each child folder maintains its own `index.md`.
- **`index.md` table contract (Mandatory):** Every `index.md` must include the file catalog table with header `| File name | Description |`. The table is **required even when empty** (header + separator, zero data rows). Placeholder or dummy rows are **forbidden**. An empty table renders correctly in GitHub, VS Code, and CommonMark parsers.

- **`history/`:** Records modifications chronologically in fragmented files. The past is frozen and does not contaminate the active chat context.

- **`doubts_and_resolutions/`:** Isolates issues in atomic format (one file per doubt). Active doubts live in **`open/`**; resolved ones are moved to **`solved/`**. The **`index.md`** dashboard must always stay in sync with both folders (Open Issues / Solved Issues tables). The AI only reads the specific doubt file it is working on, preventing cross-contamination. Files must never be moved between `open/` and `solved/` without updating `index.md`.

## 3. Structured Hierarchy (Inside-Out)

### Layer 1: Agnostic Documentation (The Core)

- **Nature:** The conceptual heart: logical domain model (`logical-domain/`), use cases, conceptual C4 diagrams, and ubiquitous language.

- **Rule:** Most protected layer. **100% timeless** and decoupled from technology, functional expansion, or management. **Does not know** any other system layer.

- **Prohibited:** Mentioning specific frameworks, libraries, databases (e.g., NestJS, PostgreSQL), development epics, or live code paths.

- **Path:** `1-product-documentation/`

### Layer 2: Epics (Business Functional Layer)

- **Nature:** Functional subdivision of the project scope.

- **Rule:** An epic (tagged as `T-XXX`) **maps** to a use case or sub-UC in Layer 1 to set practical boundaries. It looks **inward** to reference the core.

- **Prohibited:** Mentions of the tech stack (Layer 3), code paths, or temporal project organization (Layer 4).

- **Path:** `2-epics/`

### Layer 3: Implementation (Tech Layer)

- **Nature:** Real source code, adopted tech stack, bootstrap, and technical design guides.

- **Rule:** Acts as an **adapter** wrapping inner layers. Infrastructure-level code and C4 diagrams look **inward** to fulfill logical and business contracts.

- **Path:** `3-implementation/`

### Layer 4: Sprints (Temporal Management)

- **Nature:** Orchestration, project development timeline, and academic milestone tracking.

- **Rule:** Organizes tasks and delivery phases. Looks **inward** to plan which epics (Layer 2) are executed and which code deliverables (Layer 3) are completed.

- **Path:** `4-sprints/`

### Layer 5: Cross-cutting Policies (The Outer Crust)

- **Nature:** Governance, global standards, AI style guides (`.cursorrules`), and project directives.

- **Rule:** The outermost layer: wraps and protects the entire system. Defines absolute norms governing architecture and AI behavior across all layers.

- **Path:** `5-governance/`

## 4. Reference Directionality and Traceability

**Source of truth:** this section defines the layer dependency matrix and tech-agnosticism rules. [pre-commit-validation-rules.md](pre-commit-validation-rules.md) and any agent audit **must** validate COD against this section — do not duplicate the table elsewhere.

### Layer dependency matrix (inward-only)

Inner layers (Layer N) **must not** have knowledge, references, or dependencies on outer layers (Layer N+1, N+2, etc.). References flow **exclusively** from outside to inside (higher layer numbers → lower).

| Layer | Path | May reference only |
|-------|------|-------------------|
| **1** | `1-product-documentation/` | *(none — fully isolated core)* |
| **2** | `2-epics/` | Layer 1 |
| **3** | `3-implementation/` | Layers 2 and 1 |
| **4** | `4-sprints/` | Layers 3, 2, and 1 |
| **5** | `5-governance/` | Layers 4, 3, 2, and 1 |

- **Layer 1** must be entirely agnostic of Layers 2, 3, 4, and 5.
- **Any upward reference** (e.g., Layer 1 → Layer 2, Layer 3 → Layer 4) is a **grave architectural violation**.

### No stack leakage

- Only **Layer 3** (`3-implementation/`) may mention specific technology stacks, frameworks, libraries, databases, or infrastructure details.
- **Strictly forbidden** in Layers 1 and 2.
- **Also forbidden** in Layers 4 and 5 — temporal and governance documents must not embed Layers 3/4 implementation jargon or stack-specific paths.

### Traceability rules

- **Invariable unidirectional flow:** references, hyperlinks, and mentions are made **exclusively** from outside to inside (higher numbers to lower numbers).
- **Clear boundaries:** any attempt by an inner layer to reference or "link-delegate" to an outer layer is considered a **grave architectural violation**.