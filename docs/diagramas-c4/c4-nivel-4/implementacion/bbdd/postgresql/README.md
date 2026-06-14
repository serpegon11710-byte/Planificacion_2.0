# N4 — BBDD (PostgreSQL 16)

**Componente:** Base de datos  
**Tecnología:** PostgreSQL 16  
**Código:** [`implementacion/bbdd/postgresql/`](../../../../../../implementacion/bbdd/postgresql/)  
**Canónico ZC-5:** [zc-5-persistencia.md](../../pseudocodigo/zc-5-persistencia.md)  
**Adaptadores:** [persistencia/typescript/zc-5-persistencia.md](../persistencia/typescript/zc-5-persistencia.md)

---

## Compatibilidad

| Campo | Valor |
|-------|-------|
| Estado | **activa** |
| Contratos | ER v1 |

---

## Contenido del componente

| Carpeta código | Propósito |
|----------------|-----------|
| `migrations/` | DDL versionado alineado al ER |
| `seeds/` | Catálogo `TipoPeriodo`, datos de desarrollo |
| `scripts/` | Mantenimiento operativo (fuera de runtime app) |

---

## Documentos N4

| ZC | Fichero |
|----|---------|
| ZC-5 (esquema) | [zc-5-persistencia-esquema.md](zc-5-persistencia-esquema.md) |

---

## Referencias

- ER: [modelo-entidad-relacion.md](../../../../../entidades/modelo-entidad-relacion.md)
- FAQ-100: [analisis-inicial.md](../../../../stack-tecnologico/analisis-inicial.md)
- Guía agnóstica: [docs/implementacion/bbdd/](../../../../../implementacion/bbdd/)
