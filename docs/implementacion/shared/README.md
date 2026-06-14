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

## Mapeo a casos de uso y zonas críticas

Shared no implementa ZC; provee **tipos y códigos** consumidos en los flujos UC.

| UC / ámbito | Artefactos shared típicos |
|-------------|---------------------------|
| UC-01.* | DTOs creación/edición proyecto, item, planificación |
| UC-01.5 | Tipos de captura parcial (wizard) |
| UC-02.* | DTOs ocurrencia, filtros de rango, estados |
| UC-02.4 / RE-5 | Payload `bloqueos` y códigos de restricción previa |
| UC-03 | DTO listado Sin planificar |
| Transversal | Catálogo `TipoPeriodo` (respuesta API), enum `codigo` error |

Sin pseudocódigo ZC propio. Contrato fuente: [`contratos-minimos.md`](../../arquitectura/contratos-minimos.md). Código: [`implementacion/shared/typescript/`](../../../implementacion/shared/typescript/).

---

## Reglas de dependencia

Política transversal: [`desacoplamiento-componentes-contratos.md`](../../politicas-transversales/desacoplamiento-componentes-contratos.md).

| Desde | Puede importar | No puede importar |
|-------|----------------|-------------------|
| `shared/` | — (solo std/lib) | `back-end/`, `front-end/`, `persistencia/`, `bbdd/` |

Shared es **hoja** del grafo de dependencias: consumido por Front-End y Back-End, sin dependencias hacia otros componentes de aplicación.

---

## Convenciones de tests y errores

Taxonomía global: [`errores-validaciones-capas.md`](../../arquitectura/errores-validaciones-capas.md).

### Tests

| Tipo | Alcance |
|------|---------|
| Tipos | Compilación estricta FE + BE contra el paquete |
| Contrato | Cambio en DTO exige actualización coordinada FE/BE |
| Códigos | Catálogo `codigo` sin duplicados ni sin traducción i18n |

**No testear aquí:** lógica de negocio, SQL, componentes visuales.

### Errores

| Situación | Comportamiento |
|-----------|----------------|
| Nuevo `codigo` | Añadir a catálogo + clave i18n en FE |
| Cambio breaking DTO | Versionar API o acordar migración ([desacoplamiento](../../politicas-transversales/desacoplamiento-componentes-contratos.md)) |
| Payload RE-5 | Tipar `bloqueos`; no strings libres |

---

## Referencias cruzadas

| Bloque | Enlaces |
|--------|---------|
| Arquitectura | [contratos-minimos.md](../../arquitectura/contratos-minimos.md), [errores-validaciones-capas.md](../../arquitectura/errores-validaciones-capas.md) |
| Políticas | [internacionalizacion.md](../../politicas-transversales/internacionalizacion.md), [desacoplamiento-componentes-contratos.md](../../politicas-transversales/desacoplamiento-componentes-contratos.md) |
| Pseudocódigo | — (tipos derivados de contratos API) |
| N4 [T-000#S-12a](../../../backlog/000-planificacion-inicial/planificacion-inicial.md) | [shared/typescript/](../diagramas-c4/c4-nivel-4/implementacion/shared/typescript/) (contratos API/DTOs; sin ZC) |
| Código | [`implementacion/shared/typescript/`](../../../implementacion/shared/typescript/) |
