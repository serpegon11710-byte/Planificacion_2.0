# Shared — Guía de implementación

**Componente:** Tipos y contratos compartidos (Front-End + Back-End)  
**Código:** [`implementacion/shared/typescript/`](../../../implementacion/shared/typescript/)

> **Desambiguación:** [`desambiguacion-implementacion.md`](../../politicas-transversales/desambiguacion-implementacion.md)

---

## Propósito del componente

Centralizar DTOs, códigos de error, tipos de contrato e identificadores estables consumidos por la API y la SPA, evitando duplicación y desalineación entre capas.

---

## Contenido esperado en esta carpeta

| Tema | Ejemplos |
|------|----------|
| DTOs | Inputs/Outputs de [`contratos-minimos.md`](../../arquitectura/contratos-minimos.md) |
| Errores | Enum o const de `codigo`; payloads RE-5 (`bloqueos`) |
| Tipos | Identificables por usuario, rangos de fechas, naturalezas de planificación |
| Versionado | Criterio de cambio breaking en contratos API |
| Qué no incluir | Lógica de negocio, SQL, componentes UI |

---

## Referencias

- Contratos: [`contratos-minimos.md`](../../arquitectura/contratos-minimos.md)
- Errores por capa: [`errores-validaciones-capas.md`](../../arquitectura/errores-validaciones-capas.md)
- i18n (resolución en FE): [`internacionalizacion.md`](../../politicas-transversales/internacionalizacion.md)
