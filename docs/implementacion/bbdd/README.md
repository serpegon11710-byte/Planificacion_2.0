# BBDD — Guía de implementación

**Componente:** Base de datos (esquema y datos iniciales)  
**Código:** [`implementacion/bbdd/postgresql/`](../../../implementacion/bbdd/postgresql/)

> **Desambiguación:** [`desambiguacion-implementacion.md`](../../politicas-transversales/desambiguacion-implementacion.md)

---

## Propósito del componente

Definir el esquema relacional, migraciones versionadas, seeds y scripts operativos del **motor externo**. Es el único componente cuya carpeta de código nombra la tecnología del motor (`postgresql`).

---

## Contenido esperado en esta carpeta

Documentación de **disciplina de datos** (parte agnóstica en el texto; el SQL concreto referencia PostgreSQL):

| Tema | Ejemplos |
|------|----------|
| Alineación con ER | Tablas, PK `{tabla}_id`, orden físico FAQ-113/114 |
| Migraciones | Versionado, idempotencia, rollback |
| Restricciones | CHECK, UNIQUE parcial Sin planificar, FK CASCADE |
| UTC | `timestamptz`, `date`, `time` (FAQ-002) |
| Seeds | Catálogo `TipoPeriodo`, datos de desarrollo |
| Operación | Scripts de mantenimiento (fuera de la app) |

La capa de **Persistencia** consume este esquema vía SQL; no duplicar aquí la lógica de repositorios (ver [`persistencia/README.md`](../persistencia/README.md)).

---

## Referencias

- Modelo ER: [`modelo-entidad-relacion.md`](../../entidades/modelo-entidad-relacion.md)
- Stack motor: FAQ-101 en [`analisis-inicial.md`](../../stack-tecnologico/analisis-inicial.md)
- Migraciones en código: `implementacion/bbdd/postgresql/migrations/`
