# N4 — Implementacion (por stack)

Vista derivada del [N4 pseudocodigo canonico](../pseudocodigo/). Documenta como se materializa cada zona critica en un stack tecnologico concreto.

## Estado

**Pendiente (Step 9c).** Se creara cuando el stack este definido. Ver FAQ-007, FAQ-101 y FAQ-102 en [dudas-y-resoluciones.md](../../../planificacion/dudas-y-resoluciones.md).

## Politica de stacks historicos (FAQ-007)

**Principio acordado:** conservar carpetas `{stack}/` al cambiar de stack; no mezclar implementaciones.

**Pendiente Step 9c:** redactar la politica de archivo detallada (cuando retener, como nombrar, si se mueven a subcarpeta `archivo/`, etc.).

## Un C4 nivel 4 por stack

Se requiere **un conjunto completo de documentacion C4 nivel 4 por cada stack** adoptado. Si el stack cambia, se crea (o regenera) una carpeta `{stack}/` nueva a partir del [pseudocodigo canonico](../pseudocodigo/); el canonico no se modifica salvo que cambie la logica de negocio.

Los stacks anteriores se conservan como referencia historica (FAQ-007); la politica de archivo se cierra en Step 9c.

## Estructura prevista

```
implementacion/
└── {stack}/          # p. ej. typescript-nest/, java-spring/
    ├── README.md     # Mapeo global logico → artefactos del stack
    ├── zc-1-consulta-ocurrencias.md
    ├── ...
    └── zc-6-presentacion.md
```

## Reglas

1. Cada fichero debe enlazar al canonico correspondiente en `pseudocodigo/`.
2. No se redefinen reglas de negocio; solo se traducen subcomponentes, empaquetado y detalle tecnico (ORM, SQL, componentes UI).
3. Si cambia el stack, se crea una nueva carpeta `{stack}/` derivada del mismo pseudocodigo canonico.
4. ZC-5 y ZC-6 suelen concentrar mas detalle de implementacion; ZC-1 a ZC-4 pueden limitarse a mapeo de modulos y empaquetado.

## Prioridad al crear implementacion

1. ZC-5 (persistencia) y ZC-6 (presentacion) — maximo detalle tecnico.
2. ZC-4 (orquestacion) — coordinadores, transacciones del framework.
3. ZC-1 a ZC-3 — empaquetado y nombres de clases; la logica ya esta en el canonico.
