# Bootstrap & Initialization Policy

## 1. Governance Definition
Bootstrap refers to the technical procedures required to configure, initialize, and set up a component or the entire system for development or execution. This policy mandates a **decoupled, discovery-based initialization** strategy.

## 2. Directory Structure & Roles

### 2.1 Component Level (Implementation Layer)
Every technological stack within a component MUST define its own configuration procedures.
- `3-implementation/{componente}/{tecnologia}/BOOTSTRAP.md`: 
  - The "Intention" document.
  - Contains human-readable requirements, environment variables, dependencies, and configuration steps.
- `3-implementation/{componente}/{tecnologia}/.bootstrap/`: 
  - The "Execution" folder.
  - Contains `setup.sh` (or other executable scripts) that perform the actual configuration.
  - Must be **idempotent**: running it multiple times should result in the same consistent state.

### 2.2 Root Level (Global Orchestration)
The root directory acts as the master orchestrator.
- `/.bootstrap/README.md`:
  - Human entry point for global vs. per-component bootstrap.
- `/.bootstrap/init-system.sh`:
  - The Global Bootstrap Orchestrator.
  - Responsibility: Dynamically discover all component stacks in `3-implementation/`, locate their internal `.bootstrap/setup.sh` scripts, and execute them in the correct dependency order.

## 3. Technology Lifecycle Events
Bootstrap is intrinsically linked to the Technology Lifecycle:

- **Technology Expansion:** Adding a new stack requires a new `BOOTSTRAP.md` and `.bootstrap/` folder.
- **Technology Replacement (Migration):** - The `setup.sh` from the new technology must be configured to transition state from the old technology (if applicable).
  - The obsolete technology's `.bootstrap/` folder remains as a read-only historical record.

## 4. Operational Rules

1. **Autodiscovery:** No hardcoded component lists are allowed in the root orchestrator. The `init-system.sh` must scan the `3-implementation/` directory recursively.
2. **Granular Execution:** Developers MUST be able to run `3-implementation/{componente}/{tecnologia}/.bootstrap/setup.sh` in isolation for unit-level development.
3. **Environment Agnosticism:** Bootstrap scripts must accept arguments (e.g., `--env=dev|prod`) to adapt configuration without modifying the script code.
4. **Contractual Integrity:** Bootstrapping a component MUST NOT violate the logical contracts defined in `1-product-documentation/logical-domain/`.
5. **Idempotency Requirement:** All bootstrap scripts must be safe to execute against an already configured environment.

## 5. Agent Governance (For AI collaborators)
- Agents must never hardcode configuration steps in READMEs.
- Agents must update the `BOOTSTRAP.md` whenever a dependency or configuration requirement changes in the `src/` or `L4` code.
- During any migration, agents are responsible for ensuring the `BOOTSTRAP.md` clearly states the transition requirements from the old technology.