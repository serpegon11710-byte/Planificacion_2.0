# N4 — Implementación (por componente y tecnología)

Vista derivada del [pseudocódigo canónico](../pseudocodigo/). Documenta cómo materializa cada zona crítica el **componente** concreto que la implementa, con su **tecnología** adoptada.

> **Desambiguación:** esta carpeta **no** es [`docs/implementacion/`](../../../implementacion/) (guías agnósticas por componente) ni [`implementacion/`](../../../../implementacion/) (código fuente). Ver [`desambiguacion-implementacion.md`](../../../politicas-transversales/desambiguacion-implementacion.md).  
> **Desacoplamiento:** [`desacoplamiento-componentes-contratos.md`](../../../politicas-transversales/desacoplamiento-componentes-contratos.md).  
> **Marco:** [`vista-general.md`](../../../planificacion/vista-general.md) — N4 implementación = contrato de **diseño interno** (mapeo lógico → clases del stack).

---

## Estado

**Completado ([T-000#S-12a](../../../../backlog/000-planificacion-inicial/planificacion-inicial.md), 2026-06-12).** Tecnologías activas: [historial-stack.md](../../../stack-tecnologico/historial-stack.md).

---

## Índice por componente

| Componente | Tecnología | README | ZC / ámbito |
|------------|------------|--------|-------------|
| Front-End | `react-typescript` | [front-end/react-typescript/](front-end/react-typescript/) | ZC-6 |
| Back-End | `nestjs-typescript` | [back-end/nestjs-typescript/](back-end/nestjs-typescript/) | ZC-1 … ZC-4 |
| Persistencia | `typescript` | [persistencia/typescript/](persistencia/typescript/) | ZC-5 |
| Shared | `typescript` | [shared/typescript/](shared/typescript/) | Contratos API/DTOs (sin ZC) |
| BBDD | `postgresql` | [bbdd/postgresql/](bbdd/postgresql/) | ZC-5 (esquema) |

---

## Política

Cada componente mantiene su proyección N4 **de forma independiente**. Cambiar tecnología renombra la carpeta saliente a `{tecnologia} (obsoleto)` — [cambio-tecnologia-componente.md](../../../stack-tecnologico/cambio-tecnologia-componente.md).

### Dos tecnologías activas en el mismo componente

Excepción prevista en [cambio-tecnologia-componente.md](../../../stack-tecnologico/cambio-tecnologia-componente.md) y registro en [historial-stack.md](../../../stack-tecnologico/historial-stack.md): un componente puede tener **varias carpetas `{tecnologia}/` activas a la vez** (ninguna con sufijo `(obsoleto)`).

En ese caso, la proyección N4 **no se comparte entre tecnologías**: hay que **replicar el proceso de documentación en cada carpeta activa** — README del componente, ficheros `zc-*.md` y detalle técnico propio de esa tecnología. El pseudocódigo canónico sigue siendo único; lo que cambia es la traducción (p. ej. dialecto SQL distinto si coexisten dos motores de BBDD como PostgreSQL y MySQL).

Al retirar una de las tecnologías paralelas, aplicar el procedimiento habitual de sustitución (`(obsoleto)` en la carpeta retirada).

---

## Estructura

```
docs/diagramas-c4/c4-nivel-4/implementacion/
├── front-end/react-typescript/
├── back-end/nestjs-typescript/
├── persistencia/typescript/
├── shared/typescript/
└── bbdd/postgresql/
```

Coincide con `implementacion/{componente}/{tecnologia}/` en la raíz del repositorio.

---

## Reglas

1. Cada fichero enlaza al canónico en `pseudocodigo/`.
2. No se redefinen reglas de negocio; solo traducción técnica.
3. ZC-5 repartida entre persistencia (adaptadores) y bbdd (esquema SQL).

---

## Documentación relacionada

| Tema | Ubicación |
|------|-----------|
| Prácticas por componente (agnósticas) | [`docs/implementacion/`](../../../implementacion/) |
| Código fuente | [`implementacion/`](../../../../implementacion/) |
| Stack activo e historial | [`historial-stack.md`](../../../stack-tecnologico/historial-stack.md) |
| Cambio de tecnología | [`cambio-tecnologia-componente.md`](../../../stack-tecnologico/cambio-tecnologia-componente.md) |
