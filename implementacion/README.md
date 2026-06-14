# Implementación — Código fuente

**Última actualización:** 2026-06-12

Árbol de **código ejecutable** de Planificacion 2.0, organizado por **componente lógico** (contenedores C4) y **tecnología concreta** en cada subcarpeta.

> **Desambiguación:** este directorio no es `docs/implementacion/` (guías agnósticas) ni `docs/diagramas-c4/.../implementacion/` (N4 por stack). Ver [`desambiguacion-implementacion.md`](../docs/politicas-transversales/desambiguacion-implementacion.md).  
> **Antes de codificar negocio:** [vista-general.md](../docs/planificacion/vista-general.md) §6 (checklist de contratos).

---

## Stack activo (FAQ-100, FAQ-101)

| Capa | Tecnología |
|------|------------|
| Front-End | React 18 + TypeScript + Vite |
| Back-End | NestJS 10 + TypeScript |
| Persistencia | TypeScript + adaptadores (`pg`) |
| Shared | TypeScript |
| BBDD | PostgreSQL 16 |

Detalle: [`docs/stack-tecnologico/analisis-inicial.md`](../docs/stack-tecnologico/analisis-inicial.md).  
Stack activo e historial: [`historial-stack.md`](../docs/stack-tecnologico/historial-stack.md).  
Cambio de tecnología: [`cambio-tecnologia-componente.md`](../docs/stack-tecnologico/cambio-tecnologia-componente.md).

---

## Estructura de carpetas

```
implementacion/
├── front-end/
│   └── react-typescript/
│       └── src/
│           ├── api/           # cliente REST
│           ├── assets/
│           ├── components/
│           ├── features/
│           ├── hooks/
│           ├── i18n/
│           ├── pages/
│           └── routes/
├── back-end/
│   └── nestjs-typescript/
│       └── src/
│           ├── api/                    # controllers / módulos HTTP
│           ├── application/
│           │   └── orchestrators/      # ZC-4
│           └── domain/
│               ├── proyecto/
│               ├── item/
│               ├── planificacion/
│               ├── ocurrencia/
│               └── ports/
├── persistencia/
│   └── typescript/
│       └── src/
│           ├── adapters/
│           ├── connection/             # DatabaseConnectionPort
│           ├── mappers/
│           └── repositories/
│               ├── proyecto/
│               ├── item/
│               ├── planificacion/
│               └── ocurrencia/
├── shared/
│   └── typescript/
│       └── src/
│           ├── dto/
│           ├── errors/
│           ├── types/
│           └── constants/
└── bbdd/
    └── postgresql/
        ├── migrations/
        ├── seeds/
        └── scripts/
```

---

## Nomenclatura

| Nivel | Convención | Ejemplo |
|-------|------------|---------|
| Componente | Contenedor C4; **estable** al cambiar detalles del stack | `front-end`, `back-end` |
| Tecnología | Nombre **exacto** de la tech del componente | `react-typescript`, `nestjs-typescript`, `postgresql` |
| Evitar | Pack global del stack en carpetas de un solo componente | ~~`nestjs-react-postgresql`~~ en `front-end/` |
| Obsoleto | Al sustituir tecnología, renombrar carpeta saliente | `{tecnologia} (obsoleto)` — ver [cambio-tecnologia-componente.md](../docs/stack-tecnologico/cambio-tecnologia-componente.md) |

Solo **BBDD** incluye el nombre del motor en su ruta. Persistencia y Back-End no llevan `postgresql` en el path (desacoplamiento vía puertos).

---

## Documentación asociada

| Tema | Ubicación |
|------|-----------|
| Prácticas por componente (agnósticas) | [`docs/implementacion/`](../docs/implementacion/) |
| Desacoplamiento por contratos | [`desacoplamiento-componentes-contratos.md`](../docs/politicas-transversales/desacoplamiento-componentes-contratos.md) |
| Arquitectura y contratos | [`docs/arquitectura/`](../docs/arquitectura/) |
| N4 por componente | [`docs/diagramas-c4/c4-nivel-4/implementacion/`](../docs/diagramas-c4/c4-nivel-4/implementacion/) |
| Pseudocódigo canónico | [`docs/diagramas-c4/c4-nivel-4/pseudocodigo/`](../docs/diagramas-c4/c4-nivel-4/pseudocodigo/) |

---

**Estado:** estructura base creada ([T-000#S-11](../backlog/000-planificacion-inicial/planificacion-inicial.md)). Bootstrap de proyectos (package.json, Nest, Vite, migraciones) pendiente — **Ticket 001**. Ver [001-bootstrap/README.md](../backlog/001-bootstrap/README.md).
