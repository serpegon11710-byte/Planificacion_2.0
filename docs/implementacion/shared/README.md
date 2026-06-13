# Shared — Guía de implementación

**Componente:** Tipos y contratos compartidos (Front-End + Back-End)  
**Código:** [`implementacion/shared/typescript/`](../../../implementacion/shared/typescript/)

> **Desambiguación:** [`desambiguacion-implementacion.md`](../../politicas-transversales/desambiguacion-implementacion.md)  
> **Desacoplamiento por contratos:** [`desacoplamiento-componentes-contratos.md`](../../politicas-transversales/desacoplamiento-componentes-contratos.md) (restricciones transversales y de este componente)

---

## Propósito del componente

Centralizar DTOs, códigos de error, tipos de contrato e identificadores estables consumidos por la API y la SPA, evitando duplicación y desalineación entre capas.

---

## Responsabilidades y límites

### Responsabilidades

- Publicar **DTOs** de request/response alineados a [`contratos-minimos.md`](../../arquitectura/contratos-minimos.md).
- Centralizar **`codigo`** de error estables y payloads transversales (p. ej. RE-5 `bloqueos`).
- Definir tipos de **identificadores**, rangos de fechas y enumeraciones compartidas FE/BE.
- Documentar criterio de **versionado breaking** cuando cambie un contrato API.

### Sí hace / No hace

| Sí hace | No hace |
|---------|---------|
| Tipos TypeScript compilables por FE y BE | Lógica de negocio ni validaciones RT-* |
| Catálogo de códigos reutilizable | SQL, migraciones ni componentes UI |
| Shapes de API estables | Depender de Back-End, Front-End o Persistencia |

### Frontera con vecinos

| Vecino | Contrato externo | Rol de Shared |
|--------|------------------|---------------|
| Front-End | Importa DTOs y `codigo` | Consumidor; no amplía contratos en local |
| Back-End | Serializa/deserializa mismos tipos | Productor/consumidor simétrico en API |
| Arquitectura | [`contratos-minimos.md`](../../arquitectura/contratos-minimos.md) | Materializa en código lo acordado documentalmente |

Ver contratos externos en [`vista-general.md`](../../planificacion/vista-general.md) §3.1.

---

## Referencias

- Contratos: [`contratos-minimos.md`](../../arquitectura/contratos-minimos.md)
- Errores por capa: [`errores-validaciones-capas.md`](../../arquitectura/errores-validaciones-capas.md)
- i18n (resolución en FE): [`internacionalizacion.md`](../../politicas-transversales/internacionalizacion.md)
