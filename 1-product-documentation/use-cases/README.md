## Use Case Documentation Standard

1. **Hierarchy:** Each Use Case must be encapsulated in its own folder: `UC-XX-description`.
2. **Sub-UC Pattern:** If a UC requires sub-operations, create nested folders: `UC-XX.YY-sub-description`.
3. **Primary Definition:** Every folder must contain a `README.md` which acts as the Single Source of Truth for the functionality.
4. **Visual Traceability:**
   - Every UC group must include a `use-case-map.md` file containing the Mermaid representation of its flow/hierarchy.
   - The `README.md` of the parent folder must reference this diagram.
5. **Autonomy:** Each UC folder must be self-contained: it must not rely on files outside its immediate path for basic understanding.

## Business Rule Integration Standard

Any entity or use case that consumes a Business Rule must adhere to the following:

* **Reference Only:** Business logic must never be embedded or duplicated within Use Case flows. It is mandatory to reference the official `BR-XX.YY-ID`.
* **Traceability Requirement:** Every `UC-XX` must maintain an updated dependency table (referencing `BR-XX.YY`) to ensure bidirectional traceability.
* **Impact Awareness:** Changes to a referenced `BR-XX.YY` trigger an mandatory review of all consuming Use Cases.

## Business Rule Integration
All Use Cases must adhere to the [Business Rule Integration Contract](../business-rule-integration-contract.md). 
Ensure every `UC-XX` maintains the required dependency table for bidirectional traceability.