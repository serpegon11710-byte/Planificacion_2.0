# Desambiguación: tres «implementación» en el repositorio

**Última actualización:** 2026-06-12

En Planificacion 2.0 coexisten **tres rutas distintas** cuyo nombre incluye «implementación». No son intercambiables. Este documento fija el matiz para evitar mezclar documentación, código y proyección C4.

---

## Resumen

| Ruta | Qué es | ¿Acoplada al stack? |
|------|--------|---------------------|
| [`docs/implementacion/`](../implementacion/) | Prácticas y guías **por componente**, agnósticas de tecnología | **No** |
| [`implementacion/`](../../implementacion/) (raíz del repo) | **Código fuente** y estructura de carpetas por componente y tecnología | **Sí** (por subcarpeta) |
| [`docs/diagramas-c4/c4-nivel-4/implementacion/`](../diagramas-c4/c4-nivel-4/implementacion/) | Proyección **C4 N4** del pseudocódigo canónico a un stack concreto | **Sí** (por subcarpeta `{stack}/`) |

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

## 3. `docs/diagramas-c4/c4-nivel-4/implementacion/` — N4 por stack

**Propósito:** traducir el [pseudocódigo canónico](../diagramas-c4/c4-nivel-4/pseudocodigo/) (ZC-1 a ZC-6) a artefactos concretos del stack activo (clases, módulos, SQL, componentes UI). Es **documentación de diseño técnico**, no código.

**Estructura prevista (FAQ-007):**

```
docs/diagramas-c4/c4-nivel-4/implementacion/
└── {stack}/                    # p. ej. nestjs-react-postgresql/
    ├── README.md
    ├── zc-1-consulta-ocurrencias.md
    └── … zc-6-presentacion.md
```

Aquí sí tiene sentido un nombre **compuesto del stack global**, porque cada carpeta `{stack}/` describe la **implementación documental completa** de todas las zonas críticas para esa combinación tecnológica.

**Reglas:**

- No redefinir reglas de negocio; enlazar al canónico en `pseudocodigo/`.
- Al cambiar de stack, crear una carpeta `{stack}/` nueva; conservar las anteriores como histórico (FAQ-007).

**Stack activo (FAQ-101, FAQ-102):** NestJS + React + TypeScript + PostgreSQL — ver [`docs/stack-tecnologico/analisis-inicial.md`](../stack-tecnologico/analisis-inicial.md).

---

## Flujo recomendado al implementar

1. Leer arquitectura y pseudocódigo canónico (`docs/arquitectura/`, `pseudocodigo/`).
2. Consultar prácticas del componente en `docs/implementacion/{componente}/`.
3. Consultar proyección N4 del stack en `docs/diagramas-c4/c4-nivel-4/implementacion/{stack}/` (cuando exista).
4. Escribir código en `implementacion/{componente}/{tecnologia}/`.

---

## Referencias cruzadas

| Tema | Documento |
|------|-----------|
| Stack elegido | [`docs/stack-tecnologico/analisis-inicial.md`](../stack-tecnologico/analisis-inicial.md) |
| Políticas globales (SOLID, i18n) | [`docs/politicas-transversales/README.md`](README.md) |
| Estructura de código | [`implementacion/README.md`](../../implementacion/README.md) |
| N4 por stack | [`docs/diagramas-c4/c4-nivel-4/implementacion/README.md`](../diagramas-c4/c4-nivel-4/implementacion/README.md) |
