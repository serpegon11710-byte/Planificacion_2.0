# Desambiguación: tres «implementación» en el repositorio

**Última actualización:** 2026-06-12

En Planificacion 2.0 coexisten **tres rutas distintas** cuyo nombre incluye «implementación». No son intercambiables. Este documento fija el matiz para evitar mezclar documentación, código y proyección C4.

> **Marco:** [vista-general.md](../../backlog/vista-general.md) — capas, contratos externos/internos y orden documentar → implementar.

---

## Resumen

| Ruta | Qué es | ¿Acoplada al stack? |
|------|--------|---------------------|
| [`docs/implementacion/`](../implementacion/) | Prácticas y guías **por componente**, agnósticas de tecnología | **No** |
| [`implementacion/`](../../implementacion/) (raíz del repo) | **Código fuente** y estructura de carpetas por componente y tecnología | **Sí** (por subcarpeta) |
| [`docs/diagramas-c4/c4-nivel-4/implementacion/`](../diagramas-c4/c4-nivel-4/implementacion/) | Proyección **C4 N4** del pseudocódigo canónico **por componente y tecnología** | **Sí** (por subcarpeta `{componente}/{tecnologia}/`) |

---

## 1. `docs/implementacion/` — Guías de implementación por componente

**Propósito:** documentar *cómo* implementar cada contenedor lógico (Front-End, Back-End, Persistencia, Shared, BBDD) respetando arquitectura, contratos y políticas — **sin** atarse a React, NestJS o PostgreSQL en el texto.

**Contenido esperado:**

- Convenciones de carpetas lógicas (capas, módulos de negocio, puertos).
- Relación con casos de uso, zonas críticas N4 (ZC-1 a ZC-6) y `docs/arquitectura/`.
- Prácticas de testing, errores, transacciones aplicables al componente.
- Enlaces al código en `implementacion/` (raíz) y a la proyección N4 cuando exista.

**No va aquí:** código fuente, migraciones SQL concretas, mapeo clase-a-clase del stack (eso es N4 o código).

---

## 2. `implementacion/` (raíz) — Árbol de código

**Propósito:** albergar el **código ejecutable** del proyecto, organizado por **componente C4** y, dentro de cada uno, por **tecnología concreta** adoptada.

**Estructura:**

```
implementacion/
├── front-end/react-typescript/     # React + TypeScript + Vite
├── back-end/nestjs-typescript/     # NestJS + TypeScript
├── persistencia/typescript/      # Adaptadores y repos (TS; motor vía puerto)
├── shared/typescript/              # DTOs, códigos de error, tipos compartidos
└── bbdd/postgresql/                # Migraciones, seeds, scripts del motor
```

**Reglas de nomenclatura:**

- La carpeta de **componente** (`front-end`, `back-end`, …) es **estable** y refleja el contenedor lógico.
- La subcarpeta de **tecnología** lleva el nombre **exacto** de la tecnología con la que se implementa ese componente — no un «pack» global del stack (p. ej. evitar `nestjs-react-postgresql` en Front-End).
- Solo `bbdd/postgresql/` nombra el motor; el resto de componentes **no** incluyen `postgresql` en su ruta (desacoplamiento del dominio y la persistencia respecto al motor).

**Documentación asociada:** [`implementacion/README.md`](../../implementacion/README.md) (estructura de código) y [`docs/implementacion/`](../implementacion/) (prácticas por componente).

---

## 3. `docs/diagramas-c4/c4-nivel-4/implementacion/` — N4 por componente y tecnología

**Propósito:** traducir el [pseudocódigo canónico](../diagramas-c4/c4-nivel-4/pseudocodigo/) (ZC-1 a ZC-6) a artefactos concretos del **componente** que materializa cada zona (clases, módulos, SQL, componentes UI). Es **documentación de diseño técnico**, no código.

**Política de desacoplamiento:** ver [desacoplamiento-componentes-contratos.md](desacoplamiento-componentes-contratos.md). Cada componente evoluciona su proyección N4 **sin** obligar a regenerar la de los demás, salvo cambio de contrato.

**Estructura prevista:**

```
docs/diagramas-c4/c4-nivel-4/implementacion/
├── front-end/react-typescript/       # ZC-6
├── back-end/nestjs-typescript/       # ZC-1, ZC-2, ZC-3, ZC-4
├── persistencia/typescript/            # ZC-5 (adaptadores, repos)
├── shared/typescript/                  # Contratos API/DTOs y códigos (sin ZC)
└── bbdd/postgresql/                    # ZC-5 (esquema, SQL de referencia)
```

Cada subcarpeta sigue la misma convención que el **código** en `implementacion/{componente}/{tecnologia}/`. Al sustituir una tecnología, renombrar la carpeta saliente a `{tecnologia} (obsoleto)`; coexistencia paralela (p. ej. dos motores BBDD) sin `(obsoleto)` — ver [cambio-tecnologia-componente.md](../stack-tecnologico/cambio-tecnologia-componente.md) y [historial-stack.md](../stack-tecnologico/historial-stack.md).

**Reglas:**

- No redefinir reglas de negocio; enlazar al canónico en `pseudocodigo/`.
- Un fichero `zc-*.md` por zona crítica dentro de la carpeta del componente que la implementa.
- Índice de compatibilidad (tecnología activa + versión de contratos) en [historial-stack.md](../stack-tecnologico/historial-stack.md) y README del componente.

**Tecnologías activas v1 (FAQ-100, FAQ-101):** [historial-stack.md](../stack-tecnologico/historial-stack.md) (tabla «Stack activo»); análisis en [analisis-inicial.md](../stack-tecnologico/analisis-inicial.md).

---

## Flujo recomendado al implementar

1. Leer arquitectura, pseudocódigo canónico y [desacoplamiento por contratos](desacoplamiento-componentes-contratos.md).
2. Consultar prácticas del componente en `docs/implementacion/{componente}/`.
3. Consultar proyección N4 del componente en `docs/diagramas-c4/c4-nivel-4/implementacion/{componente}/{tecnologia}/` (cuando exista).
4. Escribir código en `implementacion/{componente}/{tecnologia}/`.

---

## Referencias cruzadas

| Tema | Documento |
|------|-----------|
| Stack elegido | [`docs/stack-tecnologico/analisis-inicial.md`](../stack-tecnologico/analisis-inicial.md) |
| Stack activo e historial | [`historial-stack.md`](../stack-tecnologico/historial-stack.md) |
| Cambio de tecnología | [`cambio-tecnologia-componente.md`](../stack-tecnologico/cambio-tecnologia-componente.md) |
| Políticas globales (SOLID, i18n, desacoplamiento) | [`docs/politicas-transversales/README.md`](README.md) |
| Estructura de código | [`implementacion/README.md`](../../implementacion/README.md) |
| N4 por componente | [`docs/diagramas-c4/c4-nivel-4/implementacion/README.md`](../diagramas-c4/c4-nivel-4/implementacion/README.md) |
