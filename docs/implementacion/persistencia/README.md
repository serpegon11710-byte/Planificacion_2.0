# Persistencia — Guía de implementación

**Componente:** Capa de Persistencia  
**Código:** [`implementacion/persistencia/typescript/`](../../../implementacion/persistencia/typescript/)

> **Desambiguación:** [`desambiguacion-implementacion.md`](../../politicas-transversales/desambiguacion-implementacion.md)

---

## Propósito del componente

Implementar los puertos de repositorio y conexión definidos por el dominio (ZC-5). Traduce agregados y consultas a operaciones sobre el almacén **sin filtrar detalles del motor** al Back-End.

---

## Contenido esperado en esta carpeta

| Tema | Ejemplos |
|------|----------|
| Adaptadores | Implementación de `*RepositoryPort`, `DatabaseConnectionPort` |
| Repositorios | Un repositorio por agregado; SQL explícito o query builder acotado |
| Mappers | Persistencia ↔ entidades de dominio; inferencia de clase de planificación |
| Transacciones | Unit of Work, begin/commit/rollback (ZC-4, ZC-5) |
| Consultas en rango | Ocurrencias materializadas, listados por item/proyecto |
| Borrados (FAQ-116) | Vaciado RE-4 acotado a un `planificacion_id`; evitar DELETE multi-planificación en una TX |
| Pruebas | Integración con BBDD (Testcontainers u homólogo) |

**No nombrar el motor en las reglas de esta carpeta:** las decisiones PostgreSQL concretas van en [`docs/implementacion/bbdd/`](../bbdd/) y en `implementacion/bbdd/postgresql/`.

---

## Referencias

- ER: [`modelo-entidad-relacion.md`](../../entidades/modelo-entidad-relacion.md)
- FAQ-116 (bloqueos): [`dudas-y-resoluciones.md`](../../planificacion/dudas-y-resoluciones.md)
- Pseudocódigo ZC-5: [`zc-5-persistencia.md`](../../diagramas-c4/c4-nivel-4/pseudocodigo/zc-5-persistencia.md)
