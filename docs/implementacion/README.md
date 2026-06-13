# Guías de implementación por componente

**Última actualización:** 2026-06-12

Prácticas y convenciones para implementar cada **contenedor lógico** de Planificacion 2.0. El contenido de esta carpeta es **agnóstico de tecnología**; el código concreto vive en [`implementacion/`](../../implementacion/) (raíz del repositorio).

> **Tres rutas llamadas «implementación»:** leer [desambiguacion-implementacion.md](../politicas-transversales/desambiguacion-implementacion.md) antes de añadir documentación o código en otra ubicación.  
> **Desacoplamiento por contratos:** [desacoplamiento-componentes-contratos.md](../politicas-transversales/desacoplamiento-componentes-contratos.md) — restricciones para cambiar tecnología en un componente sin arrastrar al resto.

**Estado:** plantillas README por componente (Step 11). Contenido de prácticas pendiente — **Step 12b (Opción A)**. Ver [planificacion-inicial.md](../planificacion/planificacion-inicial.md).

---

## Componentes

| Componente | Guía | Contenedor C4 | Código |
|------------|------|---------------|--------|
| Front-End | [front-end/README.md](front-end/README.md) | SPA, UC-01/02/03 | `implementacion/front-end/react-typescript/` |
| Back-End | [back-end/README.md](back-end/README.md) | API REST, dominio, aplicación | `implementacion/back-end/nestjs-typescript/` |
| Persistencia | [persistencia/README.md](persistencia/README.md) | Adaptadores, repos, conexión | `implementacion/persistencia/typescript/` |
| Shared | [shared/README.md](shared/README.md) | Contratos compartidos FE/BE | `implementacion/shared/typescript/` |
| BBDD | [bbdd/README.md](bbdd/README.md) | Esquema, migraciones, seeds | `implementacion/bbdd/postgresql/` |

---

## Qué documentar aquí (por componente)

- Responsabilidades y límites de la capa.
- Mapeo a casos de uso y zonas críticas N4 (ZC-*).
- Reglas de dependencia (qué puede importar qué).
- Convenciones de pruebas y manejo de errores **propias del componente**.
- Enlaces a `docs/arquitectura/`, entidades y pseudocódigo canónico.

## Qué no documentar aquí

- Reglas de negocio del dominio → `docs/entidades/`, `docs/casos-uso/`.
- Estructura arquitectónica global → `docs/arquitectura/`.
- Mapeo detallado clase-a-clase del stack → `docs/diagramas-c4/c4-nivel-4/implementacion/{componente}/{tecnologia}/`.
- Políticas que aplican a todo el proyecto → `docs/politicas-transversales/`.

---

## Relación con N4 y stack

- Pseudocódigo canónico: [`docs/diagramas-c4/c4-nivel-4/pseudocodigo/`](../diagramas-c4/c4-nivel-4/pseudocodigo/).
- Proyección N4 por componente: [`docs/diagramas-c4/c4-nivel-4/implementacion/`](../diagramas-c4/c4-nivel-4/implementacion/).
- Desacoplamiento por contratos: [`desacoplamiento-componentes-contratos.md`](../politicas-transversales/desacoplamiento-componentes-contratos.md).
- Decisión de stack (análisis): [`analisis-inicial.md`](../stack-tecnologico/analisis-inicial.md).
- Stack activo e historial: [`historial-stack.md`](../stack-tecnologico/historial-stack.md).
- Cambio de tecnología: [`cambio-tecnologia-componente.md`](../stack-tecnologico/cambio-tecnologia-componente.md).
