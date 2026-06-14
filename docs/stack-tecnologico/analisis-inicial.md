# Análisis inicial de stack tecnológico

**Proyecto:** Planificacion 2.0  
**Fecha:** 2026-06-12  
**Step:** 11 (cierre de arquitectura)  
**Estado:** Propuesta de análisis — sin implementación

---

## 1. Contexto y objetivo

Este documento cierra el **[T-000#S-11](../../backlog/000-planificacion-inicial/planificacion-inicial.md)** del plan de documentación: evaluar opciones de stack alineadas con la arquitectura ya definida (Steps 9–10), elegir una recomendación y justificarla frente a las alternativas.

**Referencias analizadas:**

| Área | Documentos |
|------|------------|
| Arquitectura lógica | `docs/arquitectura/README.md`, `contratos-minimos.md`, `granularidad-modulos-negocio.md`, `transacciones-consistencia.md`, `errores-validaciones-capas.md` |
| Modelo de datos | `docs/entidades/modelo-entidad-relacion.md` y entidades asociadas |
| Casos de uso | UC-01.*, UC-02.*, UC-03 |
| Zonas críticas N4 | `docs/diagramas-c4/c4-nivel-4/zonas-criticas-n4.md` (ZC-1 a ZC-6) |
| Políticas transversales | `docs/politicas-transversales/internacionalizacion.md`, `revision-principios-solid.md` |
| Contenedores C4 | Front-End SPA, Back-End API REST, Capa de Persistencia, BBDD relacional externa |

---

## 2. Requisitos técnicos derivados de la documentación

Antes de proponer stacks, se extraen criterios obligatorios del diseño acordado:

### 2.1 Arquitectura y capas

- Aplicación **web por capas**: Presentación → API/Aplicación → Negocio → Persistencia → BBDD externa.
- **Puertos y adaptadores**: el dominio consume `*RepositoryPort` y `DatabaseConnectionPort`; no conoce el motor SQL.
- **4 módulos de negocio** con dependencias unidireccionales: Proyecto → Item → Planificación → Ocurrencia.
- **Orquestadores de aplicación** para flujos multi-agregado (wizard UC-01.1, creación automática UC-01.2/01.3).
- Cumplimiento explícito de **SOLID** (revisión global en [T-000#S-9b](../../backlog/000-planificacion-inicial/planificacion-inicial.md)).

### 2.2 Complejidad de dominio (prioridad de implementación)

| Zona | Complejidad | Implicación para el stack |
|------|-------------|---------------------------|
| **ZC-1** Consulta y cálculo de ocurrencias | **Alta** | Lógica de fechas, generación incremental, composición dinámica + materializada |
| **ZC-2** Materialización de ocurrencias | Alta | Transacciones, reglas distintas puntual vs periódico |
| **ZC-3** Definición temporal | Alta | Value objects, validación condicional por catálogo `TipoPeriodo` |
| **ZC-4** Orquestación multi-agregado | Media-alta | Unidad transaccional compartida, rollback |
| **ZC-5** Persistencia | Media-alta | Adaptadores por agregado, consultas en rango, cascadas |
| **ZC-6** Presentación (calendario + captura) | Media | SPA, formularios dinámicos, i18n, vista calendario mensual/semanal |

### 2.3 Modelo de datos (ER)

- Motor **relacional** con 6 tablas, FK en cascada, restricciones `CHECK`, índice `UNIQUE` parcial (`WHERE fecha_inicio IS NULL`).
- Fechas/horas en **UTC** (`TIMESTAMPTZ`, `date`, `time`); formateo en UI.
- Clase de dominio **inferida** sin columnas discriminadoras: el ORM/mapper debe soportar herencia lógica sin flags en BD.
- FAQ-311: operaciones de borrado acotadas por `planificacion_id`; sensibilidad a bloqueos en READ COMMITTED.

### 2.4 Interfaz y API

- **SPA** en navegador (C4 N3 Front-End).
- API **REST JSON/HTTPS**.
- **i18n** principalmente en Presentación; errores de negocio por `codigo` estable.
- Componente reutilizable de captura (UC-01.5) y vista de calendario (UC-02.1).

### 2.5 Restricciones no funcionales inferidas

- Proyecto **greenfield** (solo documentación, sin código existente).
- Escala prevista: aplicación de gestión personal/equipo pequeño; no requiere microservicios ni event sourcing.
- Sin requisitos de autenticación/autorización documentados en v1.
- Documentación y UX de referencia en **español**; i18n preparado para ampliación.

---

## 3. Criterios de evaluación

Cada propuesta se valora del 1 al 5 (5 = excelente) en:

| Criterio | Peso | Descripción |
|----------|------|-------------|
| **Alineación arquitectónica** | Alto | Facilidad para implementar capas, puertos y módulos de negocio desacoplados |
| **Expresividad de dominio** | Alto | Tipado, value objects, lógica de fechas/ocurrencias |
| **Soporte ER/SQL** | Alto | Constraints, índices parciales, transacciones, UTC |
| **Ecosistema UI** | Medio | Calendario, formularios dinámicos, i18n |
| **Productividad inicial** | Medio | Curva de arranque en proyecto greenfield |
| **Mantenibilidad a largo plazo** | Medio | Convenciones, tooling, tests |
| **Portabilidad de persistencia** | Medio | Desacoplamiento real del motor (ZC-5) |

---

## 4. Propuestas de stack

### Propuesta 1 — Stack Java enterprise

| Capa | Tecnología |
|------|------------|
| Back-End | **Java 21** + **Spring Boot 3** (Web, Validation, JDBC/JPA opcional) |
| Persistencia | Adaptadores JDBC/JPA + **Flyway** (migraciones) |
| BBDD | **PostgreSQL 16** |
| Front-End | **React 18** + **TypeScript** + **Vite** |
| i18n FE | **react-i18next** |
| Calendario | **FullCalendar** (React) |
| API | REST OpenAPI 3 (springdoc-openapi) |
| Tests | JUnit 5, Testcontainers (PostgreSQL) |

#### Pros

- Encaja de forma natural con **arquitectura hexagonal**: paquetes `domain`, `application`, `infrastructure`, inyección de dependencias nativa (DIP).
- Tipado fuerte y ecosistema maduro para **value objects** y reglas de dominio complejas (ZC-1, ZC-3).
- Spring `@Transactional` facilita orquestación multi-módulo (ZC-4) con rollback explícito.
- PostgreSQL soporta índices parciales, `CHECK` y `TIMESTAMPTZ` tal como exige el ER.
- Amplia documentación y patrones de referencia para Clean Architecture en Java.
- Testcontainers permite probar constraints y cascadas contra PostgreSQL real.

#### Contras

- **Ceremonia elevada**: mucho boilerplate (DTOs, mappers, configuración) para un dominio acotado.
- JPA/Hibernate puede **luchar** con el modelo inferido sin discriminador y con consultas híbridas ZC-1 (cálculo + SQL); suele requerir JDBC nativo o QueryDSL en zonas críticas.
- Tiempo de arranque y consumo de recursos superiores a stacks más ligeros.
- Front y back en lenguajes distintos: contratos API requieren generación OpenAPI o mantenimiento manual.
- Curva de aprendizaje alta si el equipo no domina el ecosistema Spring.

#### Valoración resumida

| Criterio | Nota |
|----------|------|
| Alineación arquitectónica | 5 |
| Expresividad de dominio | 5 |
| Soporte ER/SQL | 5 |
| Ecosistema UI | 4 |
| Productividad inicial | 2 |
| Mantenibilidad | 5 |
| Portabilidad persistencia | 4 |

---

### Propuesta 2 — Stack .NET

| Capa | Tecnología |
|------|------------|
| Back-End | **C# / .NET 8** + **ASP.NET Core** (Minimal APIs o Controllers) |
| Persistencia | **Dapper** o **EF Core** (solo adaptadores) + **FluentMigrator** |
| BBDD | **PostgreSQL 16** (alternativa: SQL Server; ver contras) |
| Front-End | **React 18** + **TypeScript** + **Vite** |
| i18n FE | **react-i18next** |
| Calendario | **FullCalendar** |
| API | REST + Swashbuckle (OpenAPI) |
| Tests | xUnit, Testcontainers |

#### Pros

- .NET es referente en **Clean Architecture** con capas bien definidas; encaja con los contratos documentados.
- Tipado fuerte, `record` types y pattern matching útiles para definiciones temporales y estados.
- Transacciones (`IDbTransaction`, `TransactionScope`) bien integradas para ZC-4.
- Dapper ofrece **control SQL fino** en ZC-1/ZC-5 sin ORM que imponga discriminadores.
- PostgreSQL evita acoplamiento a SQL Server; el puerto `DatabaseConnectionPort` abstrae el driver (`Npgsql`).
- Tooling excelente (Visual Studio, Rider, analizadores estáticos).

#### Contras

- Ecosistema front-end desacoplado (mismo inconveniente que Java): dos codebases, dos pipelines.
- EF Core, si se usa en exceso, reproduce los mismos problemas de mapeo polimórfico que JPA.
- Despliegue en Linux/containers es maduro pero tradicionalmente menos habitual que Java/Node en entornos heterogéneos.
- Menor oferta de librerías de calendario/planificación listas que en el ecosistema JS.
- Comunidad hispanohablante algo menor que Java/JS para proyectos open source de referencia.

#### Valoración resumida

| Criterio | Nota |
|----------|------|
| Alineación arquitectónica | 5 |
| Expresividad de dominio | 5 |
| Soporte ER/SQL | 5 |
| Ecosistema UI | 4 |
| Productividad inicial | 3 |
| Mantenibilidad | 5 |
| Portabilidad persistencia | 5 |

---

### Propuesta 3 — Stack TypeScript full-stack (NestJS)

| Capa | Tecnología |
|------|------------|
| Back-End | **Node.js 22** + **NestJS 10** + **TypeScript 5** |
| Persistencia | **node-postgres (pg)** + adaptadores manuales + **node-pg-migrate** |
| BBDD | **PostgreSQL 16** |
| Front-End | **React 18** + **TypeScript** + **Vite** |
| Monorepo (opcional) | **pnpm workspaces** — paquete `shared` para DTOs/tipos |
| i18n FE | **react-i18next** |
| Calendario | **FullCalendar** o **react-big-calendar** |
| API | REST + `@nestjs/swagger` |
| Tests | Jest/Vitest, Testcontainers |

#### Pros

- **TypeScript en front y back**: los contratos de `contratos-minimos.md` (Inputs/Outputs, códigos de error) pueden compartirse vía paquete común.
- NestJS organiza el código en **módulos** que mapean directamente a Proyecto, Item, Planificación, Ocurrencia + capa de aplicación.
- Inyección de dependencias nativa; interfaces TypeScript implementan puertos (DIP).
- SQL explícito con `pg` respeta el desacoplamiento de ZC-5 sin presión de ORM sobre el modelo inferido.
- PostgreSQL + migraciones SQL alineadas con FAQ-308/309/310 del ER.
- Ecosistema React muy maduro para calendario, formularios dinámicos (UC-01.5) e i18n.
- Productividad alta en greenfield; arranque rápido, hot reload en FE y BE.
- Despliegue sencillo (contenedor Node + PostgreSQL).

#### Contras

- TypeScript **no garantiza** invariantes de dominio en runtime; requiere disciplina (validación con class-validator en bordes, tests unitarios en ZC-1/ZC-3).
- NestJS puede inducir acoplamiento a decorators/framework si no se aísla el dominio en carpetas libres de `@Injectable` de infraestructura.
- Gestión de fechas en JS (`Temporal` aún en adopción) exige librería auxiliar (**date-fns** / **Luxon**) y tests exhaustivos para ZC-1.
- Menos precedentes "enterprise" que Java/.NET para auditorías formales de arquitectura (aunque hexagonal es viable).
- Single-thread Node: cálculo intensivo de ocurrencias en rangos muy amplios puede requerir optimización (paginación, límites de rango).

#### Valoración resumida

| Criterio | Nota |
|----------|------|
| Alineación arquitectónica | 4 |
| Expresividad de dominio | 4 |
| Soporte ER/SQL | 5 |
| Ecosistema UI | 5 |
| Productividad inicial | 5 |
| Mantenibilidad | 4 |
| Portabilidad persistencia | 5 |

---

### Propuesta 4 — Stack Python (FastAPI)

| Capa | Tecnología |
|------|------------|
| Back-End | **Python 3.12** + **FastAPI** |
| Persistencia | **SQLAlchemy Core** (no ORM de entidades) + **Alembic** |
| BBDD | **PostgreSQL 16** |
| Front-End | **React 18** + **TypeScript** + **Vite** |
| i18n FE | **react-i18next** |
| Calendario | **FullCalendar** |
| API | REST + OpenAPI automático (FastAPI) |
| Tests | pytest, Testcontainers |

#### Pros

- **Legibilidad** del dominio: pseudocódigo N4 (ZC-1 a ZC-4) se traslada casi literalmente a Python.
- Excelente soporte de fechas con **`datetime`**, **`zoneinfo`** (UTC FAQ-001) y potencial uso de **python-dateutil** para recurrencias.
- FastAPI genera OpenAPI y validación Pydantic en bordes (DTOs de entrada/salida).
- SQLAlchemy Core permite SQL parametrizado alineado con ZC-5 sin imponer mapeo ORM.
- Curva de entrada suave; ideal para prototipado rápido de reglas complejas.
- pytest facilita tests table-driven de reglas RC-*, RT-*, RO-*.

#### Contras

- Tipado opcional en runtime: Pydantic valida en API pero el **núcleo de dominio** necesita tests rigurosos para sustituir garantías de compilación.
- FastAPI no impone estructura modular; hay que **disciplinarse** manualmente para replicar módulos y puertos documentados.
- Inyección de dependencias menos integrada que NestJS/Spring; orquestadores (ZC-4) requieren wiring explícito.
- GIL y rendimiento inferior en escenarios de alta concurrencia (poco relevante en v1, pero existente).
- Dos lenguajes (Python + TS) sin paquete compartido de tipos.
- Despliegue ASGI (uvicorn/gunicorn) menos estandarizado en equipos solo .NET/Java.

#### Valoración resumida

| Criterio | Nota |
|----------|------|
| Alineación arquitectónica | 3 |
| Expresividad de dominio | 4 |
| Soporte ER/SQL | 5 |
| Ecosistema UI | 4 |
| Productividad inicial | 4 |
| Mantenibilidad | 3 |
| Portabilidad persistencia | 4 |

---

### Propuesta 5 — Stack PHP moderno (Laravel API)

| Capa | Tecnología |
|------|------------|
| Back-End | **PHP 8.3** + **Laravel 11** (modo API) |
| Persistencia | **Eloquent** (adaptadores) o **Query Builder** raw + **Laravel Migrations** |
| BBDD | **PostgreSQL 16** |
| Front-End | **Vue 3** + **TypeScript** + **Vite** (Inertia.js opcional) |
| i18n FE | **vue-i18n** |
| Calendario | **FullCalendar** (Vue) |
| API | REST + Laravel Sanctum (futuro auth) |
| Tests | PHPUnit, Pest |

#### Pros

- **Productividad muy alta** en CRUD, migraciones, validación de formularios y capa API.
- Laravel migrations soportan índices parciales en PostgreSQL (`where` en unique).
- Convenciones claras aceleran UC-01.2/01.3 (creación automática, cascadas).
- Despliegue económico (hosting PHP compartido o VPS ligero).
- vue-i18n maduro; Vue 3 Composition API encaja con componente de captura reutilizable (UC-01.5).
- Comunidad hispanohablante amplia y documentación en español abundante.

#### Contras

- Laravel favorece **Active Record** (Eloquent); desviación respecto a puertos/adaptadores puros documentados — requiere capa de repositorio explícita y disciplina para no filtrar Eloquent al dominio.
- Modelo inferido sin discriminador es **poco idiomático** en Eloquent; ZC-1/ZC-3 necesitan servicios de dominio separados de modelos AR.
- PHP tipado mejorado pero inferior a Java/C#/TS para invariantes complejas.
- Menor trazabilidad con diagramas C4 "enterprise"; arquitectura hexagonal en Laravel es posible pero no convencional.
- Acoplamiento al framework en capa de aplicación si no se aísla el dominio.

#### Valoración resumida

| Criterio | Nota |
|----------|------|
| Alineación arquitectónica | 2 |
| Expresividad de dominio | 3 |
| Soporte ER/SQL | 4 |
| Ecosistema UI | 4 |
| Productividad inicial | 5 |
| Mantenibilidad | 3 |
| Portabilidad persistencia | 3 |

---

## 5. Comparativa global

| Propuesta | Arq. | Dominio | ER/SQL | UI | Prod. | Mant. | Persist. | **Total ponderado** |
|-----------|------|---------|--------|-----|-------|-------|----------|---------------------|
| 1. Java/Spring | 5 | 5 | 5 | 4 | 2 | 5 | 4 | **4,3** |
| 2. .NET | 5 | 5 | 5 | 4 | 3 | 5 | 5 | **4,5** |
| 3. NestJS/TS | 4 | 4 | 5 | 5 | 5 | 4 | 5 | **4,5** |
| 4. FastAPI | 3 | 4 | 5 | 4 | 4 | 3 | 4 | **3,7** |
| 5. Laravel | 2 | 3 | 4 | 4 | 5 | 3 | 3 | **3,4** |

*Ponderación: Arq. y Dominio ×2; resto ×1.*

### Motor de base de datos

Para **todas** las propuestas se recomienda **PostgreSQL 16** como motor único en v1:

| Requisito ER | Soporte PostgreSQL |
|--------------|-------------------|
| `UNIQUE` parcial (`WHERE fecha_inicio IS NULL`) | Nativo |
| `CHECK` condicionales referenciando catálogo | Nativo |
| `TIMESTAMPTZ` UTC (FAQ-001) | Nativo |
| Cascadas FK multi-nivel | Nativo |
| Control de bloqueos (FAQ-311) | READ COMMITTED configurable; borrados acotados por diseño |

SQL Server sería alternativa viable en Propuesta 2 (.NET), pero añade coste de licencia y el ER ya contempla sintaxis genérica pendiente de [T-000#S-11](../../backlog/000-planificacion-inicial/planificacion-inicial.md) — PostgreSQL maximiza portabilidad del SQL documentado.

---

## 6. Stack elegido

### Recomendación: **Propuesta 3 — TypeScript full-stack (NestJS + React + PostgreSQL)**

```
┌─────────────────────────────────────────────────────────────┐
│  Front-End: React 18 + TypeScript + Vite                  │
│  i18n: react-i18next | Calendario: FullCalendar           │
└──────────────────────────┬──────────────────────────────────┘
                           │ REST JSON / HTTPS
┌──────────────────────────▼──────────────────────────────────┐
│  Back-End: NestJS 10 + TypeScript                           │
│  Capas: Presentación(API) → Aplicación → Dominio            │
│  Orquestadores ZC-4 | Servicios ZC-1/2/3                    │
└──────────────────────────┬──────────────────────────────────┘
                           │ Puertos (*RepositoryPort)
┌──────────────────────────▼──────────────────────────────────┐
│  Persistencia: adaptadores pg + SQL explícito + migraciones   │
└──────────────────────────┬──────────────────────────────────┘
                           │ SQL
┌──────────────────────────▼──────────────────────────────────┐
│  BBDD: PostgreSQL 16                                         │
└─────────────────────────────────────────────────────────────┘
```

#### Estructura de proyecto sugerida (orientativa)

```
/
├── apps/
│   ├── api/          # NestJS — capas dominio/aplicación/infra
│   └── web/          # React SPA
├── packages/
│   └── shared/       # DTOs, códigos de error, tipos de contrato
├── migrations/       # SQL versionado (node-pg-migrate o similar)
└── docs/             # Documentación existente
```

---

## 7. Justificación de la elección

### 7.1 Por qué NestJS + React + PostgreSQL sobre las demás propuestas

**Frente a Java/Spring (Propuesta 1):**

- La arquitectura documentada ya fija contratos explícitos y pseudocódigo N4; no se necesita el peso de Spring para garantizar modularidad — NestJS ofrece módulos + DI suficientes con **menos boilerplate**.
- El riesgo de JPA con modelo inferido sin discriminador se evita igualmente usando SQL explícito; NestJS/`pg` lo hace con menor overhead de arranque.
- Spring sigue siendo superior si el equipo ya es Java-first o si se prevén requisitos enterprise (auditoría, integración corporativa); **no es el caso inferido** de un proyecto greenfield documentado en SPA + API REST sencilla.

**Frente a .NET (Propuesta 2):**

- .NET empata en solidez arquitectónica y persistencia, y sería la **segunda opción** si el equipo domina C#.
- NestJS gana en **ecosistema UI unificado** (TypeScript en FE/BE), productividad inicial y alineación con SPA React ya definida en C4 N3.
- Compartir tipos DTO entre API y Front reduce desalineaciones con `contratos-minimos.md` (Inputs/Outputs tipados).

**Frente a FastAPI (Propuesta 4):**

- Python expresa bien el dominio temporal, pero la documentación exige **DIP estricto** y módulos con puertos — NestJS impone más estructura por convención.
- TypeScript aporta verificación estática en contratos compartidos; Python depende de tests para lo que TS detecta en compilación.
- FastAPI sería preferible si la prioridad absoluta fuera prototipar ZC-1 en pocas iteraciones con un solo desarrollador Python.

**Frente a Laravel (Propuesta 5):**

- Laravel optimiza CRUD rápido, pero **desalinea** con arquitectura hexagonal acordada: Active Record invita a mezclar persistencia y dominio, contrario a `docs/arquitectura/README.md` y revisión SOLID.
- Las zonas críticas ZC-1 y ZC-3 requieren servicios de dominio puros; reimplementarlos "contra" convenciones Laravel añade fricción constante.
- Laravel sigue siendo válido si se sacrifica pureza arquitectónica por velocidad de entrega — **rechazado** porque la documentación prioriza desacoplamiento explícito.

### 7.2 Alineación con decisiones documentadas

| Decisión documentada | Cómo la cubre el stack elegido |
|---------------------|--------------------------------|
| 4 módulos de negocio + orquestadores | Módulos NestJS `@Module()` por agregado + providers de aplicación |
| Puertos sin dependencia de framework | Interfaces TS en capa `domain/ports`; implementaciones en `infrastructure/` |
| `DatabaseConnectionPort` | Wrapper sobre pool `pg` con begin/commit/rollback |
| Errores por `codigo` + i18n en FE | Enum/const compartido en `packages/shared`; react-i18n resuelve `error.<CODIGO>` |
| UTC en persistencia, locale en UI | PostgreSQL `timestamptz`; date-fns/Luxon + i18n locale en React |
| ZC-1 cálculo + materialización | Servicio de dominio puro testeable + adaptador SQL para materializadas |
| Transacciones multi-módulo (ZC-4) | Unit of Work sobre `pg` client en scope de request |
| N4 implementación por componente | `docs/diagramas-c4/c4-nivel-4/implementacion/{componente}/{tecnologia}/` (**[T-000#S-12a](../../backlog/000-planificacion-inicial/planificacion-inicial.md) cerrado**) |

### 7.3 Riesgos del stack elegido y mitigaciones

| Riesgo | Mitigación |
|--------|------------|
| Dominio acoplado a NestJS | Regla de importación: `domain/` no importa `@nestjs/*` |
| Fechas incorrectas en ZC-1 | Librería `Temporal`/Luxon; batería de tests con casos RO-*, RC-3 |
| SQL disperso | Migraciones versionadas; repositorios centralizados por agregado (ZC-5) |
| Sin autenticación en v1 | Diseño API stateless; Sanctum/JWT reservado para iteración futura |

---

## 8. Decisiones derivadas (FAQ-100, FAQ-101, FAQ-102)

| FAQ | Decisión |
|-----|----------|
| **FAQ-100** Motor BBDD | **PostgreSQL 16** |
| **FAQ-101** Stack aplicación | **NestJS 10 + Node 22 + React 18 + TypeScript 5** (monorepo pnpm recomendado) |
| **FAQ-102** Política N4 e histórico | N4 por `{componente}/{tecnologia}/`; sufijo `(obsoleto)` y coexistencia: [cambio-tecnologia-componente.md](cambio-tecnologia-componente.md); registro: [historial-stack.md](historial-stack.md) |

### Herramientas complementarias recomendadas

| Ámbito | Herramienta |
|--------|-------------|
| Migraciones | node-pg-migrate o Flyway vía CLI |
| Tests integración | Testcontainers (PostgreSQL) |
| Lint/format | ESLint + Prettier (FE y BE) |
| API docs | Swagger UI vía `@nestjs/swagger` |
| CI (futuro) | GitHub Actions: lint + test + migrate check |

---

## 9. Próximos pasos (sin implementación)

1. **[T-000#S-12a](../../backlog/000-planificacion-inicial/planificacion-inicial.md):** ~~Proyectar N4 canónico~~ **Completado** — [implementacion/](../diagramas-c4/c4-nivel-4/implementacion/).
2. **[T-000#S-12b](../../backlog/000-planificacion-inicial/planificacion-inicial.md):** ~~Redactar prácticas~~ **Completado** — [docs/implementacion/](../implementacion/).
3. **[T-000#S-13](../../backlog/000-planificacion-inicial/planificacion-inicial.md):** Validar coherencia documental — **pendiente re-validación** ([T-000#S-13](../../backlog/000-planificacion-inicial/planificacion-inicial.md) reabierto 2026-06-13) — [validacion-documental-step13.md](../../backlog/000-planificacion-inicial/validacion-documental-step13.md).
4. **Ticket 001:** Bootstrap del monorepo en `implementacion/` — ver [001-bootstrap/README.md](../../backlog/001-bootstrap/README.md).

FAQ-100, FAQ-101 y FAQ-102 cerradas en [T-000#S-11](../../backlog/000-planificacion-inicial/planificacion-inicial.md) — ver [dudas-y-resoluciones.md](../../backlog/000-planificacion-inicial/dudas-y-resoluciones.md).

---

## 10. Resumen ejecutivo

Se evaluaron **cinco stacks** alineados con la arquitectura por capas, los contratos de puertos y el modelo ER de Planificacion 2.0. **PostgreSQL** es el motor común recomendado por soporte nativo de constraints del ER.

**Stack seleccionado:** NestJS + React + TypeScript + PostgreSQL.

**Motivo principal:** equilibrio óptimo entre **fidelidad a la arquitectura hexagonal documentada**, **productividad en greenfield**, **tipado compartido en contratos API/UI** y **ecosistema maduro para calendario e i18n**, sin el coste de ceremonia de Java/.NET ni la tensión arquitectónica de Laravel.

**Alternativa preferente si el equipo lo exige:** Propuesta 2 (.NET 8 + Dapper + PostgreSQL + React) — equivalente en solidez, superior en tipado runtime del dominio, inferior en unificación TypeScript FE/BE.

---

## Referencias

- `docs/arquitectura/README.md`
- `docs/entidades/modelo-entidad-relacion.md`
- `docs/diagramas-c4/c4-nivel-4/zonas-criticas-n4.md`
- `backlog/000-planificacion-inicial/planificacion-inicial.md` ([T-000#S-11](../../backlog/000-planificacion-inicial/planificacion-inicial.md))
- `docs/politicas-transversales/internacionalizacion.md`
- [historial-stack.md](historial-stack.md) — stack activo e historial por componente
- [cambio-tecnologia-componente.md](cambio-tecnologia-componente.md) — procedimiento `(obsoleto)` y excepciones
