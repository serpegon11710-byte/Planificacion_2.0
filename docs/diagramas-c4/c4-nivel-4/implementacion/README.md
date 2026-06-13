# N4 — Implementación (por stack)

Vista derivada del [pseudocódigo canónico](../pseudocodigo/). Documenta cómo se materializa cada zona crítica en un **stack tecnológico concreto**.

> **Desambiguación:** esta carpeta **no** es [`docs/implementacion/`](../../../implementacion/) (guías agnósticas por componente) ni [`implementacion/`](../../../../implementacion/) (código fuente). Ver [`desambiguacion-implementacion.md`](../../../politicas-transversales/desambiguacion-implementacion.md).

---

## Estado

**Pendiente (Step 12).** Stack definido en Step 11 (FAQ-101, FAQ-102). Ver [`analisis-inicial.md`](../../../stack-tecnologico/analisis-inicial.md).

**Stack activo:** NestJS + React + TypeScript + PostgreSQL. Carpeta prevista: `nestjs-react-postgresql/`.

---

## Política de stacks históricos (FAQ-007)

**Principio acordado:** conservar carpetas `{stack}/` al cambiar de stack; no mezclar implementaciones.

Al cambiar de stack se crea una carpeta `{stack}/` nueva; las anteriores se conservan como referencia histórica.

---

## Un C4 nivel 4 por stack

Se requiere **un conjunto completo de documentación C4 nivel 4 por cada stack** adoptado. Si el stack cambia, se crea (o regenera) una carpeta `{stack}/` a partir del [pseudocódigo canónico](../pseudocodigo/); el canónico no se modifica salvo que cambie la lógica de negocio.

---

## Estructura prevista

```
docs/diagramas-c4/c4-nivel-4/implementacion/
└── nestjs-react-postgresql/     # stack global (nombre compuesto válido aquí)
    ├── README.md                # mapeo global lógico → artefactos del stack
    ├── zc-1-consulta-ocurrencias.md
    ├── …
    └── zc-6-presentacion.md
```

Aquí el nombre **compuesto del stack** es correcto: cada carpeta describe la proyección N4 **completa** de todas las zonas críticas para esa combinación tecnológica. En el árbol de **código** (`implementacion/` en la raíz) cada componente usa solo su tecnología — ver desambiguación.

---

## Reglas

1. Cada fichero debe enlazar al canónico correspondiente en `pseudocodigo/`.
2. No se redefinen reglas de negocio; solo se traducen subcomponentes, empaquetado y detalle técnico (SQL, módulos NestJS, componentes React).
3. Si cambia el stack, se crea una nueva carpeta `{stack}/` derivada del mismo pseudocódigo canónico.
4. ZC-5 y ZC-6 suelen concentrar más detalle; ZC-1 a ZC-4 pueden limitarse a mapeo de módulos y empaquetado.

---

## Prioridad al crear implementación N4

1. ZC-5 (persistencia) y ZC-6 (presentación) — máximo detalle técnico.
2. ZC-4 (orquestación) — coordinadores, transacciones del framework.
3. ZC-1 a ZC-3 — empaquetado y nombres de clases; la lógica ya está en el canónico.

---

## Documentación relacionada

| Tema | Ubicación |
|------|-----------|
| Prácticas por componente (agnósticas) | [`docs/implementacion/`](../../../implementacion/) |
| Código fuente | [`implementacion/`](../../../../implementacion/) |
| Stack elegido | [`docs/stack-tecnologico/analisis-inicial.md`](../../../stack-tecnologico/analisis-inicial.md) |
