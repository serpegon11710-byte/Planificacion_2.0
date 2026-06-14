# Ticket 001 — Bootstrap

**Estado:** **Pendiente**  
**Épica:** andamiaje ejecutable (histórico [Ticket 001 — bootstrap](../000-planificacion-inicial/../001-bootstrap/README.md))  
**Prerequisito:** Ticket 000 en curso; [T-000#S-13](../000-planificacion-inicial/planificacion-inicial.md) pendiente de re-validación (no iniciar bootstrap)

> Protocolo: [protocolo-trabajo-tickets.md](../../docs/planificacion/protocolo-trabajo-tickets.md) · Checklist previo: [vista-general.md](../../docs/planificacion/vista-general.md) §6

---

## 1. Alcance

**Bootstrap** = andamiaje ejecutable **mínimo**, **sin lógica de negocio**.

Incluye:

- Monorepo pnpm, `package.json`, scripts `dev` / `build` / `test`
- NestJS arranca (p. ej. `GET /health`); Vite/React arranca en navegador
- PostgreSQL: migraciones iniciales ER v1, seed `TipoPeriodo`, conexión desde persistencia
- Paquete `shared` compilable (DTOs/códigos según N4)
- Wiring DI: implementaciones de puertos registradas en Nest (stubs)

**Objetivo:** clonar → instalar → migrar → ejecutar **sin error**, aunque UC-01/02/03 no estén implementados.

**Fuera de alcance:** wizard UC-01.1, calendario UC-02.1, reglas RT/RO, materialización ZC-2, endpoints de negocio completos.

---

## 2. Stack inicial v1

Fuente: [FAQ-100](../000-planificacion-inicial/dudas-y-resoluciones.md#faq-100--motor-de-base-de-datos), [FAQ-101](../000-planificacion-inicial/dudas-y-resoluciones.md#faq-101--stack-de-aplicacion), [historial-stack.md](../../docs/stack-tecnologico/historial-stack.md).

| Componente | Tecnología | Código | N4 12a | Guía 12b |
|------------|------------|--------|--------|----------|
| Front-End | React 18 + TS 5 + Vite | `implementacion/front-end/react-typescript/` | [react-typescript/](../../docs/diagramas-c4/c4-nivel-4/implementacion/front-end/react-typescript/) | [front-end/](../../docs/implementacion/front-end/) |
| Back-End | NestJS 10 + Node 22 + TS 5 | `implementacion/back-end/nestjs-typescript/` | [nestjs-typescript/](../../docs/diagramas-c4/c4-nivel-4/implementacion/back-end/nestjs-typescript/) | [back-end/](../../docs/implementacion/back-end/) |
| Persistencia | TypeScript + `pg` | `implementacion/persistencia/typescript/` | [typescript/](../../docs/diagramas-c4/c4-nivel-4/implementacion/persistencia/typescript/) | [persistencia/](../../docs/implementacion/persistencia/) |
| Shared | TypeScript | `implementacion/shared/typescript/` | [shared/typescript/](../../docs/diagramas-c4/c4-nivel-4/implementacion/shared/typescript/) | [shared/](../../docs/implementacion/shared/) |
| BBDD | PostgreSQL 16 | `implementacion/bbdd/postgresql/` | [postgresql/](../../docs/diagramas-c4/c4-nivel-4/implementacion/bbdd/postgresql/) | [bbdd/](../../docs/implementacion/bbdd/) |

**Monorepo:** pnpm workspaces (recomendado FAQ-101).

---

## 3. Requisitos previos

| Herramienta | Versión mínima | Notas |
|-------------|----------------|-------|
| **Node.js** | 22 LTS | Runtime Back-End y tooling |
| **pnpm** | 9+ | Gestor del monorepo |
| **PostgreSQL** | 16 | Motor v1 (local o Docker) |
| **Git** | 2.x | Clonar repositorio |

Opcional: **Docker** / Docker Compose para PostgreSQL en desarrollo.

Herramientas complementarias (post-bootstrap o subtickets): ESLint, Prettier, node-pg-migrate, Testcontainers, Swagger — ver [analisis-inicial.md](../../docs/stack-tecnologico/analisis-inicial.md) §8.

---

## 4. Instalación local (orientativa)

> Los comandos concretos se fijan al ejecutar **T-001-01** (aún no hay `package.json` en raíz).

1. Clonar el repositorio.
2. Instalar dependencias: `pnpm install` (raíz monorepo).
3. Configurar variables de entorno (`.env` / `.env.example`): URL PostgreSQL, puertos FE/BE.
4. Levantar PostgreSQL (local o contenedor).
5. Ejecutar migraciones: script en `implementacion/bbdd/postgresql/migrations/`.
6. Ejecutar seeds (`TipoPeriodo`) si aplica.
7. Arrancar desarrollo: `pnpm dev` (FE + BE según scripts del monorepo).
8. Verificar: health check API + SPA carga sin error.

---

## 5. Subtickets planificados

| ID | Título | Estado |
|----|--------|--------|
| T-001-01 | Monorepo pnpm | pendiente |
| T-001-02 | Paquete shared compilable | pendiente |
| T-001-03 | Migraciones ER v1 | pendiente |
| T-001-04 | Seed TipoPeriodo | pendiente |
| T-001-05 | Persistencia: conexión `pg` | pendiente |
| T-001-06 | Persistencia: repos stub | pendiente |
| T-001-07 | Back-end Nest bootstrap + health | pendiente |
| T-001-08 | Wiring DI puertos | pendiente |
| T-001-09 | Front-end Vite bootstrap | pendiente |
| T-001-10 | i18n skeleton FE | pendiente |
| T-001-11 | Scripts `pnpm dev` integrados | pendiente |
| T-001-12 | Smoke test bootstrap | pendiente |

Cada subticket tendrá fichero `T-001-xx-*.md` al iniciarse.

---

## 6. Criterio de cierre del Ticket 001

- [ ] Clonar → `pnpm install` → migraciones → `pnpm dev` sin error.
- [ ] API responde health check.
- [ ] SPA carga (shell; sin pantallas de negocio).
- [ ] PostgreSQL con esquema ER v1 y seed mínimo.
- [ ] Sin reglas de negocio UC implementadas.

---

## Referencias

- [vista-general.md](../vista-general.md) — capas y contratos
- [implementacion/README.md](../../implementacion/README.md) — árbol de código
- [protocolo-trabajo-tickets.md](../../docs/planificacion/protocolo-trabajo-tickets.md) — modelo tickets y backlog
