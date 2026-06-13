# Guías de implementación por componente

**Última actualización:** 2026-06-12

Prácticas y convenciones para implementar cada **contenedor lógico** de Planificacion 2.0. El contenido de esta carpeta es **agnóstico de tecnología**; el código concreto vive en [`implementacion/`](../../implementacion/) (raíz del repositorio).

> **Vista general:** [vista-general.md](../../backlog/vista-general.md) — contratos de **diseño interno** por componente (Step 12b) vs contratos **externos** en arquitectura.  
> **Tres rutas llamadas «implementación»:** leer [desambiguacion-implementacion.md](../politicas-transversales/desambiguacion-implementacion.md) antes de añadir documentación o código en otra ubicación.  
> **Desacoplamiento por contratos:** [desacoplamiento-componentes-contratos.md](../politicas-transversales/desacoplamiento-componentes-contratos.md) — restricciones para cambiar tecnología en un componente sin arrastrar al resto.

**Estado:** **Completado (Step 12b, 2026-06-12).** Cada guía incluye responsabilidades, mapeo UC/ZC, dependencias, tests/errores y referencias cruzadas.

---

## Componentes

| Componente | Guía | ZC | Código | N4 Step 12a |
|------------|------|-----|--------|-------------|
| Front-End | [front-end/README.md](front-end/README.md) | ZC-6 | `implementacion/front-end/react-typescript/` | [react-typescript/](../diagramas-c4/c4-nivel-4/implementacion/front-end/react-typescript/) |
| Back-End | [back-end/README.md](back-end/README.md) | ZC-1 … ZC-4 | `implementacion/back-end/nestjs-typescript/` | [nestjs-typescript/](../diagramas-c4/c4-nivel-4/implementacion/back-end/nestjs-typescript/) |
| Persistencia | [persistencia/README.md](persistencia/README.md) | ZC-5 | `implementacion/persistencia/typescript/` | [typescript/](../diagramas-c4/c4-nivel-4/implementacion/persistencia/typescript/) |
| Shared | [shared/README.md](shared/README.md) | — | `implementacion/shared/typescript/` | [typescript/](../diagramas-c4/c4-nivel-4/implementacion/shared/typescript/) |
| BBDD | [bbdd/README.md](bbdd/README.md) | ZC-5 (esquema) | `implementacion/bbdd/postgresql/` | [postgresql/](../diagramas-c4/c4-nivel-4/implementacion/bbdd/postgresql/) |

---

## Estructura de cada guía

1. Responsabilidades y límites  
2. Mapeo a casos de uso y zonas críticas  
3. Reglas de dependencia  
4. Convenciones de tests y errores  
5. Referencias cruzadas (arquitectura, entidades, pseudocódigo, N4, código)

---

## Relación con N4 y stack

- Pseudocódigo canónico: [`docs/diagramas-c4/c4-nivel-4/pseudocodigo/`](../diagramas-c4/c4-nivel-4/pseudocodigo/).
- Proyección N4 por componente (Step 12a): [`docs/diagramas-c4/c4-nivel-4/implementacion/`](../diagramas-c4/c4-nivel-4/implementacion/).
- Desacoplamiento por contratos: [`desacoplamiento-componentes-contratos.md`](../politicas-transversales/desacoplamiento-componentes-contratos.md).
- Stack activo: [`historial-stack.md`](../stack-tecnologico/historial-stack.md).
