# N4 — Implementación (por componente y tecnología)

Vista derivada del [pseudocódigo canónico](../pseudocodigo/). Documenta cómo materializa cada zona crítica el **componente** concreto que la implementa, con su **tecnología** adoptada.

> **Desambiguación:** esta carpeta **no** es [`docs/implementacion/`](../../../implementacion/) (guías agnósticas por componente) ni [`implementacion/`](../../../../implementacion/) (código fuente). Ver [`desambiguacion-implementacion.md`](../../../politicas-transversales/desambiguacion-implementacion.md).  
> **Desacoplamiento:** [`desacoplamiento-componentes-contratos.md`](../../../politicas-transversales/desacoplamiento-componentes-contratos.md).

---

## Estado

**Pendiente (Step 12).** Tecnologías activas definidas en Step 11 (FAQ-101, FAQ-102). Ver [`analisis-inicial.md`](../../../stack-tecnologico/analisis-inicial.md).

---

## Política

Cada componente mantiene su proyección N4 **de forma independiente**. Cambiar React, NestJS, el adaptador de persistencia o PostgreSQL **no** exige regenerar la documentación N4 de los demás componentes, salvo que cambie un **contrato** compartido (API, puertos, ER).

Al adoptar una nueva tecnología en un componente:

1. Renombrar la carpeta saliente a `{tecnologia} (obsoleto)` en código y N4 (ver [cambio-tecnologia-componente.md](../../../stack-tecnologico/cambio-tecnologia-componente.md)).
2. Crear subcarpeta `{nueva-tecnologia}/` sin sufijo `(obsoleto)`.
3. Actualizar [historial-stack.md](../../../stack-tecnologico/historial-stack.md) (stack activo + historial de cambios).

---

## Estructura prevista

```
docs/diagramas-c4/c4-nivel-4/implementacion/
├── front-end/react-typescript/
│   ├── README.md
│   └── zc-6-presentacion.md
├── back-end/nestjs-typescript/
│   ├── README.md
│   ├── zc-1-consulta-ocurrencias.md
│   ├── zc-2-materializacion-ocurrencias.md
│   ├── zc-3-planificacion-temporal.md
│   └── zc-4-orquestacion-aplicacion.md
├── persistencia/typescript/
│   ├── README.md
│   └── zc-5-persistencia.md
└── bbdd/postgresql/
    ├── README.md
    └── zc-5-persistencia-esquema.md   # SQL/migraciones de referencia (complemento a persistencia)
```

La convención de carpetas **coincide** con el árbol de código en `implementacion/{componente}/{tecnologia}/`. Tecnologías sustituidas: `{tecnologia} (obsoleto)` — [cambio-tecnologia-componente.md](../../../stack-tecnologico/cambio-tecnologia-componente.md).

---

## Reglas

1. Cada fichero debe enlazar al canónico correspondiente en `pseudocodigo/`.
2. No se redefinen reglas de negocio; solo se traducen subcomponentes, empaquetado y detalle técnico.
3. ZC-5 puede repartirse entre `persistencia/` (adaptadores) y `bbdd/` (esquema); enlazar ambos READMEs.
4. ZC-5 y ZC-6 suelen concentrar más detalle; ZC-1 a ZC-4 en Back-End pueden limitarse a mapeo de módulos y empaquetado.

---

## Prioridad al crear implementación N4

1. `persistencia/` y `bbdd/` (ZC-5) + `front-end/` (ZC-6) — máximo detalle técnico.
2. `back-end/` — ZC-4 (orquestación) y mapeo ZC-1 a ZC-3.
3. README de índice por componente con mapeo lógico → artefactos.

---

## Documentación relacionada

| Tema | Ubicación |
|------|-----------|
| Prácticas por componente (agnósticas) | [`docs/implementacion/`](../../../implementacion/) |
| Código fuente | [`implementacion/`](../../../../implementacion/) |
| Desacoplamiento por contratos | [`desacoplamiento-componentes-contratos.md`](../../../politicas-transversales/desacoplamiento-componentes-contratos.md) |
| Stack / tecnologías activas | [`docs/stack-tecnologico/historial-stack.md`](../../../stack-tecnologico/historial-stack.md) |
| Cambio de tecnología | [`cambio-tecnologia-componente.md`](../../../stack-tecnologico/cambio-tecnologia-componente.md) |
