# BBDD — Guía de implementación

**Componente:** Base de datos (esquema y datos iniciales)  
**Código:** [`implementacion/bbdd/postgresql/`](../../../implementacion/bbdd/postgresql/)

> **Desambiguación:** [`desambiguacion-implementacion.md`](../../politicas-transversales/desambiguacion-implementacion.md)  
> **Desacoplamiento por contratos:** [`desacoplamiento-componentes-contratos.md`](../../politicas-transversales/desacoplamiento-componentes-contratos.md) (restricciones transversales y de este componente)

---

## Propósito del componente

Definir el esquema relacional, migraciones versionadas, seeds y scripts operativos del **motor externo**. Es el único componente cuya carpeta de código nombra la tecnología del motor (`postgresql`).

---

## Responsabilidades y límites

### Responsabilidades

- Materializar el **modelo ER** en tablas, índices y restricciones (CHECK, UNIQUE parcial, FK).
- Versionar **migraciones** y mantener historial reproducible (up/down en entornos de prueba).
- Proveer **seeds** de catálogo (`TipoPeriodo`) y datos de desarrollo opcionales.
- Documentar **disciplina de datos**: PK `{tabla}_id`, orden físico (FAQ-308/309), UTC (FAQ-001).

### Sí hace / No hace

| Sí hace | No hace |
|---------|---------|
| DDL y DML de esquema/seeds | Lógica de repositorios (Persistencia) |
| Restricciones de integridad referencial | Reglas de negocio RT/RO en triggers de aplicación |
| Scripts operativos de mantenimiento | Exponer API HTTP |

La capa de **Persistencia** consume este esquema vía SQL; ver [`persistencia/README.md`](../persistencia/README.md).

**Coexistencia de motores (excepción):** varios motores activos en paralelo — [historial-stack.md](../../stack-tecnologico/historial-stack.md), [cambio-tecnologia-componente.md § Excepciones](../../stack-tecnologico/cambio-tecnologia-componente.md#excepciones-coexistencia-de-dos-tecnologías-activas).

### Frontera con vecinos

| Vecino | Contrato externo | Rol de BBDD |
|--------|------------------|-------------|
| Persistencia | Esquema + migraciones aplicadas | Almacén físico; no invocado por dominio directo |
| Entidades / ER | [`modelo-entidad-relacion.md`](../../entidades/modelo-entidad-relacion.md) | Implementación relacional del modelo acordado |

Ver contratos externos en [`vista-general.md`](../../planificacion/vista-general.md) §3.1.

---

## Referencias

- Modelo ER: [`modelo-entidad-relacion.md`](../../entidades/modelo-entidad-relacion.md)
- Stack motor: FAQ-100 en [`analisis-inicial.md`](../../stack-tecnologico/analisis-inicial.md); activo en [`historial-stack.md`](../../stack-tecnologico/historial-stack.md)
- Migraciones en código: `implementacion/bbdd/postgresql/migrations/`
