# i18n Implementation Contract

**Status:** Technical Standard  
**Scope:** Application implementation (Domain, Adapter, Presentation layers)

## Objective

Decouple business logic from user-facing text to support multiple locales without modifying core logic.

## Technical Rules

1. **Language neutrality:** Business rules and domain models must use language-agnostic stable identifiers (for example `ERR_AUTH_001`, `PAYMENT_SUCCESS`).
2. **Decoupling at boundaries:** Translated strings belong strictly to Presentation/Adapter layers.
3. **Message catalogs:** Use centralized message catalogs for all localized text.
4. **Implementation rule:** Never hardcode translated user-facing text in services or entities.

