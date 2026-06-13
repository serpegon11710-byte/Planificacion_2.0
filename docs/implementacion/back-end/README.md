# Back-End — Guía de implementación

**Componente:** Back-End (API REST + dominio + aplicación)  
**Código:** [`implementacion/back-end/nestjs-typescript/`](../../../implementacion/back-end/nestjs-typescript/)

> **Desambiguación:** [`desambiguacion-implementacion.md`](../../politicas-transversales/desambiguacion-implementacion.md)  
> **Desacoplamiento por contratos:** [`desacoplamiento-componentes-contratos.md`](../../politicas-transversales/desacoplamiento-componentes-contratos.md) (restricciones transversales y de este componente)

---

## Propósito del componente

Punto de entrada HTTP/JSON, orquestación de casos de uso (ZC-4) y lógica de negocio en cuatro módulos: Proyecto → Item → Planificación → Ocurrencia. Consume **puertos** de persistencia; no ejecuta SQL directo en el dominio.

---

## Responsabilidades y límites

### Responsabilidades

- Exponer la **API REST** (entrada/salida JSON) al Front-End.
- Orquestar casos de uso multi-agregado en la capa de **aplicación** (wizard, cascadas, transacciones).
- Implementar **reglas de negocio** en la capa de **dominio** (Proyecto, Item, Planificación, Ocurrencia).
- Definir **puertos** (`*RepositoryPort`, servicios de dominio) que la persistencia implementará.
- Propagar hacia la API solo **`codigo`** de error estable (sin literales de negocio ni SQL).

### Sí hace / No hace

| Sí hace | No hace |
|---------|---------|
| Validar DTOs de entrada en API/aplicación | Ejecutar SQL ni conocer el motor de BBDD |
| Coordinar ZC-1 a ZC-4 (consulta, materialización, temporal, orquestación) | Renderizar UI ni resolver i18n de mensajes |
| Invocar puertos de persistencia dentro de unidades de trabajo | Duplicar restricciones del ER (CHECK, UNIQUE) que ya garantiza la BBDD |
| Traducir errores de infraestructura a `ERROR_INTERNO` | Importar adaptadores concretos de persistencia en dominio |

### Frontera con vecinos

| Vecino | Contrato externo | Rol del Back-End |
|--------|------------------|------------------|
| Front-End | API REST + DTOs ([`contratos-minimos.md`](../../arquitectura/contratos-minimos.md)) | Expone endpoints; consume requests validados |
| Persistencia | Puertos de repositorio y conexión | Define interfaces en dominio; inyecta implementación en aplicación |
| Shared | Tipos y códigos compartidos | Importa DTOs/`codigo`; no redefine contratos en silos |

Ver contratos externos en [`vista-general.md`](../../planificacion/vista-general.md) §3.1.

---

## Referencias

- Arquitectura: [`docs/arquitectura/`](../../arquitectura/)
- Granularidad: [`granularidad-modulos-negocio.md`](../../arquitectura/granularidad-modulos-negocio.md)
- Transacciones: [`transacciones-consistencia.md`](../../arquitectura/transacciones-consistencia.md)
- Pseudocódigo: [`docs/diagramas-c4/c4-nivel-4/pseudocodigo/`](../../diagramas-c4/c4-nivel-4/pseudocodigo/)
