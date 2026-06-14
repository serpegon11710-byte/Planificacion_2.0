# FAQ — Dudas y resoluciones

> **Ticket 000 — FAQ cerrada en Step 13 (2026-06-13).** Solo lectura; no admite entradas nuevas.
> Resoluciones ejecutables: ver entregables en `docs/` (acta histórica en este fichero).

Registro centralizado de preguntas abiertas, decisiones tomadas y cambios de nomenclatura del proyecto Planificacion 2.0.

**Ultima actualizacion:** 2026-06-13

Los documentos funcionales (`docs/entidades/`, `docs/arquitectura/`, etc.) deben **referenciar este FAQ** en lugar de mantener dudas duplicadas. Las resoluciones aqui prevalecen sobre borradores antiguos del plan (p. ej. `DefinicionFechaHora`, `InstanciaPlanificacion`).

**Alcance:** decisiones de **diseno** vinculadas al **[Ticket 000 — Pasos 1–13](README.md)**. El historico FAQ **termina en el Paso 13**. Roadmap de implementacion (tickets 001+), estados y subtickets: **[backlog/README.md](../README.md)** — no se duplican aqui.

**FAQ de uso del producto** (por qué no puedo borrar, cómo preparar planificaciones antes de eliminar): [FAQ.md](../../../FAQ.md) en la raíz del repositorio. Este archivo (`dudas-y-resoluciones.md`) es solo para decisiones de diseño.

---

## Leyenda

| Estado | Significado |
|--------|-------------|
| **Resuelta** | Decision acordada; el detalle documental puede quedar como entregable del **Ticket 000 — Paso** indicado en cada FAQ |
| **Abierta** | Requiere decision; ver **Ticket 000 — Paso** indicado en cada FAQ |
| **Supersedida** | Duda historica; ver resolucion y nota de nomenclatura |

---

## Numeracion FAQ por grupos

Formato: **`FAQ-Gnn`** — `G` = grupo (0–9), `nn` = secuencia dentro del grupo (00–99).

**Reglas de alta:**
- Cada FAQ nueva se añade **al final de su grupo**, incrementando `nn`.
- Si no encaja en ningun grupo existente, se abre un **grupo nuevo** (siguiente `G`) con `FAQ-G00`.
- Las FAQ **Supersedida** conservan entrada e ID; solo se actualizan referencias cruzadas al ID vigente.

| Grupo | Prefijo | Ambito | Ticket 000 — Paso tipico |
|-------|---------|--------|-------------|
| **0** | FAQ-0xx | Dominio funcional / plan inicial | 1–9 |
| **1** | FAQ-1xx | Stack e implementacion (politicas N4, motor, stack app) | 11 |
| **2** | FAQ-2xx | Diagramas C4 | 8b, 8c |
| **3** | FAQ-3xx | Modelo ER y persistencia fisica | 10 |

**Indice de grupos:** [Grupo 0](#grupo-0-dominio-funcional) · [Grupo 1](#grupo-1-stack-e-implementacion) · [Grupo 2](#grupo-2-diagramas-c4) · [Grupo 3](#grupo-3-modelo-er)

---

## Grupo 0 — Dominio funcional {#grupo-0-dominio-funcional}

### FAQ-000 — Periodos diarios y semanales

**Origen:** `planificacion-inicial.md` (consideracion 1).

**Pregunta:** ¿Atributos fijos o lista flexible de dias de la semana?

**Resolucion (2026-06-12):**

- **Periodica diaria:** subtipo **prefijado / enum** (`TODOS`, `LUN_VIE`, `FIN_SEMANA`). No es lista libre.
- **Periodica semanal:** **lista de dias de la semana** (p. ej. martes y jueves en la misma planificacion). Puede haber varios dias seleccionados.
- **Periodica mensual:** sin cambio respecto al catalogo funcional (`planificaciones.md`).

**Reflejado en:** `planificaciones.md`, `zc-3-planificacion-temporal.md`.

**Nota:** El plan original recomendaba lista flexible para diarios; queda **supersedida**.

---

### FAQ-001 — Zona horaria

**Origen:** `planificacion-inicial.md` (consideracion 2).

**Pregunta:** ¿Una sola zona horaria o multi-zona?

**Resolucion (2026-06-12):** Persistir y comparar fechas/horas en **UTC**. Formateo a locale del usuario en presentacion (i18n).

**Entregable Ticket 000 — Paso 10:** tipos UTC en el ER (`docs/entidades/modelo-entidad-relacion.md`) y nota en `internacionalizacion.md` (almacenamiento vs visualizacion). **Completado (2026-06-12).**

---

### FAQ-002 — Completado en planificaciones periodicas

**Origen:** `planificacion-inicial.md` (consideracion 3).

**Pregunta:** ¿Se completa la ocurrencia concreta o la planificacion entera?

**Nota de nomenclatura:** La duda inicial mencionaba una entidad `InstanciaPlanificacion`. Ese nombre quedo **sustituido por Ocurrencia** (`docs/entidades/ocurrencias.md`).

**Resolucion (2026-06-12):**

- Se completa la **ocurrencia individual**.
- Toda ocurrencia tiene **estado propio**; puede quedar **NULL** en persistencia (= hereda el estado de la planificacion; el usuario lo ve reflejado hasta que interactue).
- Modificar el completado de la **planificacion** no arrastra ocurrencias ya materializadas.
- No se requiere entidad aparte de **Ocurrencia**.

---

### FAQ-003 — Ocurrencias materializadas en el ER

**Origen:** Ticket 000 — Paso 10 / modelo de datos.

**Pregunta:** ¿Incluir tabla de ocurrencias materializadas en el diagrama ER?

**Resolucion (2026-06-12):** **Si**, en Ticket 000 — Paso 10.

**Semantica de herencia** (observaciones, estado / completada):

- En **persistencia**, **NULL** significa que la ocurrencia no tiene valor propio para ese campo; el valor **efectivo** se resuelve desde la planificacion.
- En **presentacion**, el usuario **ve** el valor heredado (el mismo que muestra la planificacion para ese campo).
- Al **interactuar** con el dato (editar observaciones, marcar completada, etc.), se **registra** en la ocurrencia materializada lo que el usuario indico; ese campo deja de heredar.

Relacionado con FAQ-002 (estado vacio = hereda).

**Campos acordados:**

| Campo | Obligatorio | Notas |
|-------|-------------|-------|
| Campos comunes con planificacion (estado, observacion, fecha, hora) | Si (estructura) | Misma semantica que la planificacion de origen |
| `fecha_original` | Si | Clave de precedencia (RO-5) |
| `fecha_efectiva` | Si | Fecha mostrada / efectiva |
| `hora` | Si | |
| `observaciones` | Nullable | NULL = hereda; usuario ve las de la planificacion; se persiste al editar |
| `completada` / estado | Nullable | NULL = hereda; usuario ve el estado de la planificacion; se persiste al interactuar |
| Eliminacion virtual | Si (flag/tipo) | RO-4 |

**Entregable Ticket 000 — Paso 10:** tabla `OcurrenciasMaterializadas` en `modelo-entidad-relacion.md`; seccion de persistencia en `ocurrencias.md` alineada al ER. **Completado (2026-06-12).**

---

### FAQ-004 — Entidades Proyecto e Item

**Origen:** `revision-principios-solid.md` (deuda documental).

**Pregunta:** ¿Documentar Proyecto e Item en `docs/entidades/`?

**Resolucion:** **Si**, crear `proyectos.md` e `items.md` **antes** del Ticket 000 — Paso 10 (ER).

**Estado de ejecucion:** **Completado** (2026-06-12) — `docs/entidades/proyectos.md`, `docs/entidades/items.md`.

---

### FAQ-005 — Idiomas (i18n)

**Origen:** Ticket 000 — Paso 9b / `internacionalizacion.md`.

**Pregunta:** ¿Que locales en la primera implementacion?

**Resolucion (2026-06-12):** **Espanol** en la UI. **Infraestructura i18n** preparada para cualquier idioma. **Sin literales en la capa de negocio** (solo `codigo`; mensajes en presentacion).

---

### FAQ-006 — Composicion de ocurrencias en consulta (ZC-1)

**Origen:** Diseno N4 / optimizacion SQL.

**Pregunta:** ¿Calcular todas las naturales y fusionar con fisicas, o evitar doble trabajo?

**Resolucion (2026-06-12):** Algoritmo acordado y documentado en `zc-1-consulta-ocurrencias.md`.

---

### FAQ-007 — Mensajes de error en casos de uso

**Origen:** `revision-principios-solid.md`.

**Resolucion (2026-06-12):** Literales en UCs solo como **referencia UX** en documentacion. Implementacion: `codigo` + i18n; negocio sin literales (FAQ-005).

---

## Grupo 1 — Stack e implementacion {#grupo-1-stack-e-implementacion}

### FAQ-100 — Motor de base de datos

**Origen:** Ticket 000 — Paso 11.

**Resolucion (2026-06-12):** **PostgreSQL 16** como motor unico en v1. Motivos: soporte nativo de restricciones del ER (UNIQUE parcial, CHECK, TIMESTAMPTZ, cascadas FK), alineacion con FAQ-308/309/311 y portabilidad del SQL documentado.

**Entregable Ticket 000 — Paso 11:** [`docs/stack-tecnologico/analisis-inicial.md`](../../docs/stack-tecnologico/analisis-inicial.md) (seccion 5 y 8). Codigo: `implementacion/bbdd/postgresql/`. **Completado (2026-06-12).**

---

### FAQ-101 — Stack de aplicacion

**Origen:** Ticket 000 — Paso 11.

**Resolucion (2026-06-12):**

| Capa | Tecnologia |
|------|------------|
| Back-End | **NestJS 10** + **Node.js 22** + **TypeScript 5** |
| Front-End | **React 18** + **TypeScript 5** + **Vite** |
| Persistencia | TypeScript + **node-postgres (`pg`)** + migraciones SQL |
| Shared | TypeScript (DTOs, codigos de error, tipos de contrato) |
| Monorepo | **pnpm workspaces** (recomendado) |

**Entregable Ticket 000 — Paso 11:** [`docs/stack-tecnologico/analisis-inicial.md`](../../docs/stack-tecnologico/analisis-inicial.md), esqueleto [`implementacion/`](../../../implementacion/), guias [`docs/implementacion/`](../../../implementacion/). **Completado (2026-06-12).**

---

### FAQ-102 — N4 implementacion al cambiar de tecnologia en un componente

**Origen:** `c4-nivel-4/implementacion/README.md`.

**Resolucion (2026-06-12; actualizada misma fecha — desacoplamiento por contratos):**

1. **Principio:** cada **componente** conserva su historico de tecnologias en subcarpetas `{tecnologia}`; no mezclar implementaciones en la misma carpeta. Cambiar tecnologia en un componente **no** obliga a regenerar la documentacion N4 de los demas salvo cambio de contrato compartido.
2. **Alcance N4 (docs):** `docs/diagramas-c4/c4-nivel-4/implementacion/{componente}/{tecnologia}/` — misma convencion que el codigo. Proyeccion ZC-1 a ZC-6 repartida por componente (Back-End: ZC-1–4; Persistencia/BBDD: ZC-5; Front-End: ZC-6). **Shared:** N4 de contratos API/DTOs y codigos de error (sin ZC) en `shared/typescript/`. Ver [desacoplamiento-componentes-contratos.md](../../docs/politicas-transversales/desacoplamiento-componentes-contratos.md).
3. **Alcance codigo (raiz):** `implementacion/{componente}/{tecnologia}/` — una tecnologia exacta por componente; ver [desambiguacion-implementacion.md](../../docs/politicas-transversales/desambiguacion-implementacion.md).
4. **Politica de archivo (v1):** al sustituir una tecnologia, **renombrar** la carpeta saliente a `{tecnologia} (obsoleto)` en codigo y N4; crear carpeta de la tecnologia entrante sin sufijo. Procedimiento: [cambio-tecnologia-componente.md](../../docs/stack-tecnologico/cambio-tecnologia-componente.md). Historial: [historial-stack.md](../../docs/stack-tecnologico/historial-stack.md). **Excepcion:** coexistencia paralela (p. ej. PostgreSQL + MySQL en BBDD) — varias carpetas activas sin `(obsoleto)`; ver mismo documento § Excepciones.
5. **Contratos:** API, puertos, ER y codigos de error son la frontera entre componentes; versionar cambios breaking. Matriz de compatibilidad en [historial-stack.md](../../docs/stack-tecnologico/historial-stack.md) y README del componente.

**Entregable Ticket 000 — Paso 11:** [desambiguacion-implementacion.md](../../docs/politicas-transversales/desambiguacion-implementacion.md), [desacoplamiento-componentes-contratos.md](../../docs/politicas-transversales/desacoplamiento-componentes-contratos.md), [historial-stack.md](../../docs/stack-tecnologico/historial-stack.md), [cambio-tecnologia-componente.md](../../docs/stack-tecnologico/cambio-tecnologia-componente.md), [implementacion/README.md](../../../implementacion/README.md), [c4-nivel-4/implementacion/README.md](../../docs/diagramas-c4/c4-nivel-4/implementacion/README.md). Proyeccion N4 concreta: **Ticket 000 — Paso 12a**. **Completado (2026-06-12).**

---

## Grupo 2 — Diagramas C4 {#grupo-2-diagramas-c4}

### FAQ-200 — Diagrama C4 N3 para Front-End

**Origen:** Ticket 000 — Paso 8.

**Resolucion (2026-06-12):** **Si**, crear un **segundo diagrama N3** de componentes Front-End (ademas del N3 Back-End/Persistencia existente).

**Estado de ejecucion:** **Completado** — `docs/diagramas-c4/c4-nivel-3/c4-nivel-3-componentes-frontend.mmd` (Ticket 000 — Paso 8b).

---

### FAQ-201 — Trazabilidad C4 ↔ casos de uso

**Origen:** Ticket 000 — Paso 8 (`planificacion-inicial.md`).

**Resolucion (2026-06-12):** Trazabilidad **distribuida**, no fichero central:

- Cada **zona critica N4** (`docs/diagramas-c4/c4-nivel-4/pseudocodigo/zc-*.md`) documenta los casos de uso que la justifican y su rol al implementar.
- Cada **caso de uso** referencia las zonas criticas N4 que le afectan.

Asi quien implementa una ZC ve de inmediato el origen funcional; quien lee un UC sabe donde buscar el detalle arquitectonico.

**Estado de ejecucion:** Reflejado en ZC N4 y UCs (Ticket 000 — Paso 8c).

---

## Grupo 3 — Modelo ER {#grupo-3-modelo-er}

### FAQ-300 — Modelo fisico de planificaciones: una tabla o varias

**Origen:** Ticket 000 — Paso 10 / decision de modelo de datos.

**Estado:** Resolucion inicial (dos tablas puntuales/periodicas) **supersedida por FAQ-305** (tabla unica `Planificaciones` + `PlanificacionPeriodo` 1:1). Conservada como historial.

**Entregable vigente:** `docs/entidades/modelo-entidad-relacion.md` (FAQ-305).

---

### FAQ-301 — Tabla catalogo de tipos de planificacion

**Estado:** **Supersedida por FAQ-306** (`TipoPeriodo` con visibilidades de campos). Conservada como historial (modelo intermedio `TipoPlanificacion` + `periodica`).

---

### FAQ-302 — Nomenclatura «Sin planificar»

**Origen:** FAQ-300 / modelo ER.

**Resolucion (2026-06-12):** Usar **«Sin planificar»** en toda la documentacion y **`SinPlanificar`** como codigo de tipo. Clase de dominio: `PlanificacionSinPlanificar`. Sustituye la nomenclatura anterior «No planificado» / `NoPlanificado`.

**Reflejado en:** documentacion funcional y pseudocodigo (renombrado 2026-06-12).

---

### FAQ-303 — Borrador ER del plan: `DefinicionFechaHora`

**Origen:** `planificacion-inicial.md` (Ticket 000 — Paso 10 y «Decisiones tomadas»).

**Resolucion (2026-06-12):** Sustituir `DefinicionFechaHora` por el modelo FAQ-300 / FAQ-301. **Entregable Ticket 000 — Paso 10:** `docs/entidades/modelo-entidad-relacion.md`. **Completado (2026-06-12).**

---

### FAQ-304 — Vista unificada, dias semana y ocurrencias solo periódicas

**Estado:** **Supersedida por FAQ-305** (2026-06-12). Conservada como historial de la iteracion intermedia (dos tablas + vista).

---

### FAQ-305 — Tabla unica Planificaciones + PlanificacionPeriodo 1:1

**Origen:** Revision del ER; simplificar duplicacion de campos comunes y escalabilidad.

**Resolucion (2026-06-12):**

1. **Una tabla `Planificaciones`** con campos comunes: `item_id`, `fecha_inicio`, `fecha_fin`, `hora`, `observaciones`, `estado`. Sin flags: la naturaleza se infiere (Sin planificar = fechas NULL; Puntual = inicio = fin sin periodo; Periódica = existe `PlanificacionPeriodo` y fin > inicio).
2. **`PlanificacionPeriodo`** 1:1 opcional: solo periódicas. Valores de patron aqui; visibilidad por tipo en **`TipoPeriodo`** (FAQ-306).
3. **Ocurrencias:** Sin planificar → lista vacia; Puntual → una dinamica; Periódica → dinamicas + `OcurrenciasMaterializadas` (FK `planificacion_id`). Restricciones RO-8 a RO-10 (rango, visibilidad tras cambio de fechas).
4. Se eliminan `PlanificacionesPuntuales`, `PlanificacionesPeriodicas`, `V_Planificacion` y flags `sin_planificar`.

**Entregable Ticket 000 — Paso 10:** `docs/entidades/modelo-entidad-relacion.md`, `planificaciones.md`, pseudocodigo ZC-1/3/5. **Completado (2026-06-12).**

---

### FAQ-306 — `TipoPeriodo`: catalogo de visibilidad de campos de patron

**Origen:** Refinamiento ER; `TipoPlanificacion` no aportaba valor como mero almacen de `codigo` (redundante con el periodo).

**Resolucion (2026-06-12):**

1. Renombrar **`TipoPlanificacion` → `TipoPeriodo`**.
2. Rol del catalogo: declarar **que campos de `PlanificacionPeriodo` son visibles/exigibles** por tipo, no duplicar el patron:
   - `visibilidad_variante_diaria`
   - `visibilidad_dias_semana`
   - `visibilidad_dia_mes`
   - `visibilidad_comportamiento_mes_corto`
3. `PlanificacionPeriodo.tipo_periodo_id` FK → `TipoPeriodo`. Los **valores** (`variante_diaria`, `dias_semana`, etc.) permanecen en el periodo.
4. `codigo` en `TipoPeriodo` (`Diario`, `Semanal`, `Mensual`) sigue siendo clave estable para i18n y motor de ocurrencias.

**Entregable:** `modelo-entidad-relacion.md`, `planificaciones.md`, pseudocodigo ZC-3/6. **Completado (2026-06-12).**

---

### FAQ-307 — Diagrama de clases de Planificacion

**Origen:** Alineacion dominio / persistencia / pseudocodigo.

**Resolucion (2026-06-12):**

Jerarquia canonica en `docs/entidades/modelo-clases-planificacion.md` (+ `.mmd`):

- `Planificacion` (abstracta) → `PlanificacionSinPlanificar`, `PlanificacionPuntual`, `PlanificacionPeriodica` (abstracta) → `PlanificacionDiaria`, `PlanificacionSemanal`, `PlanificacionMensual`.
- Factory `inferirClase` / `Planificacion.desdePersistencia` enlaza ER con clases concretas.
- Nombres `PlanificacionPeriodicaDiaria` etc. quedan **obsoletos**; usar subclases directas de `PlanificacionPeriodica`.

**Entregable:** trazabilidad en `planificaciones.md`, `ocurrencias.md`, ZC-1, ZC-3. **Completado (2026-06-12).**

---

### FAQ-308 — Orden fisico de tablas (cluster) frente a PK `{tabla}_id`

**Origen:** Refinamiento ER; la PK no basta como criterio de localidad de lectura.

**Resolucion (2026-06-12):**

| Tabla | Orden fisico | Indice adicional de negocio |
|-------|--------------|----------------------------|
| `Proyectos` | `proyecto_id` | `UNIQUE (nombre)` |
| `Items` | `(proyecto_id, item_id)` | `UNIQUE (proyecto_id, nombre)` |
| `Planificaciones` | `(item_id, fecha_inicio, hora, planificacion_id)` | `UNIQUE (item_id, observaciones)` parcial Sin planificar |

En `Planificaciones`, `fecha_inicio NULL` agrupa Sin planificar por item; puntuales y periodicas se ordenan por fecha y hora, no por subtipo. Sintaxis en Ticket 000 — Paso 11.

**Entregable:** seccion en `modelo-entidad-relacion.md`. **Completado (2026-06-12).** Actualizado por FAQ-310 (nombres PK).

---

### FAQ-309 — Tablas satelite: PK y orden fisico

**Origen:** Refinamiento ER; `PlanificacionPeriodo` y `OcurrenciasMaterializadas`.

**Resolucion (2026-06-12):**

1. **`PlanificacionPeriodo`:** sin `id` propio; **PK = `planificacion_id`** (1:1). Orden fisico por `planificacion_id`. No coincide con el orden de `Planificaciones` (por item/fecha).
2. **`OcurrenciasMaterializadas`:** PK fila **`ocurrencia_id`**; FK **`planificacion_id`** (semantica planificacion periodica, misma clave que el periodo). Orden fisico **`(planificacion_id, fecha_original, hora, ocurrencia_id)`**. Alineado con `PlanificacionPeriodo` por `planificacion_id`; no alineado con `Planificaciones`.

**Entregable:** ER + pseudocodigo ZC-1/2/5. **Completado (2026-06-12).**

---

### FAQ-310 — Convencion de nombres PK: `{tabla}_id`

**Origen:** Refinamiento ER; alinear nombre de PK con la entidad/tabla.

**Resolucion (2026-06-12):**

La clave primaria de cada tabla se nombra **`{entidad}_id`**, equivalente al nombre de la tabla en singular:

| Tabla | PK |
|-------|-----|
| `Proyectos` | `proyecto_id` |
| `Items` | `item_id` |
| `Planificaciones` | `planificacion_id` |
| `TipoPeriodo` | `tipo_periodo_id` |
| `OcurrenciasMaterializadas` | `ocurrencia_id` |

**Excepcion:** `PlanificacionPeriodo` no tiene PK propia; **PK = `planificacion_id`** heredada de `Planificaciones` (FAQ-309). Sustituye el generico `id` en todo el modelo y pseudocodigo.

**Entregable:** `modelo-entidad-relacion.md`, entidades, pseudocodigo ZC-1 a ZC-5. **Completado (2026-06-12).**

---

### FAQ-311 — Bloqueos en borrado masivo de `OcurrenciasMaterializadas` (RE-4)

**Origen:** Analisis de concurrencia (escenario multi-usuario / SQL Server); feature futura de vaciado masivo para resolver RE-4 desde UC-02.4.

**Contexto:** Orden fisico de la tabla (FAQ-309): **`(planificacion_id, fecha_original, hora, ocurrencia_id)`**. La PK surrogate `ocurrencia_id` no define la localidad de lectura/borrado.

**Resolucion (2026-06-12):**

1. **Escrituras ligeras (UC-02.3):** actualizar solo `observaciones` (u otros campos) de una fila ya localizada implica bloqueo minimo (UPDATE puntual).

2. **Borrado masivo por planificacion (feature futura RE-4):** patron SQL recomendado:
   ```sql
   DELETE FROM OcurrenciasMaterializadas WHERE planificacion_id = @planificacion_id;
   ```
   Un solo prefijo del indice agrupado → rango contiguo, transaccion corta. Alineado con UC-02.4 (ambito: **una planificacion**).

3. **Patron a evitar (READ COMMITTED con locking, p. ej. SQL Server sin RCSI):**
   ```sql
   DELETE FROM OcurrenciasMaterializadas WHERE planificacion_id IN (@id1, @id2, …);
   ```
   Aunque los `planificacion_id` del DELETE y los de un `SELECT … WHERE planificacion_id IN (…)` **no compartan filas**, en la practica puede bloquear lecturas concurrentes sobre **otros** prefijos del mismo indice (locks en claves/paginas, planes de acceso amplios, **lock escalation**). RCSI / SNAPSHOT mitiga el bloqueo lector/escritor, pero aumenta coste de servidor (version store); no siempre es viable a gran escala.

4. **Cascada item/proyecto:** no vaciar ocurrencias de **varias planificaciones** en una unica sentencia ni en una transaccion larga. Para cumplir RE-4 antes de UC-01.4 / UC-01.3 / UC-01.2: **una planificacion por operacion** (commit breve entre planificaciones si aplica).

5. **Lectura calendario (UC-02.1):** con borrado acotado a un solo `planificacion_id`, el conflicto con lecturas de otras planificaciones es **extremadamente improbable** en READ COMMITTED locking. Bucle por planificacion o lectura batch del alumno: ambos son viables; el riesgo venia del DELETE multi-`planificacion_id`, no del shape del SELECT.

**Entregable:** trazabilidad en `modelo-entidad-relacion.md` (RE-4), `ocurrencias.md`, UC-02.4. Implementacion concreta (aislamiento, RCSI, lotes) en **Ticket 000 — Paso 11** (FAQ-100).

---

## Abiertas

_Ninguna (2026-06-12). FAQ-100, FAQ-101 y FAQ-102 cerradas en Ticket 000 — Paso 11._

---

## Indice rapido por documento origen

| Documento | IDs FAQ |
|-----------|---------|
| `planificacion-inicial.md` | FAQ-000, 001, 002, 303; **Pasos 1–13** → [README Ticket 000](README.md) |
| `../../docs/planificacion/vista-general.md` | Capas, contratos externo/interno, bootstrap |
| `docs/entidades/modelo-entidad-relacion.md` | FAQ-001, 003, 300, 301, 303, 308, 309, **310**, **311** |
| `docs/entidades/ocurrencias.md` | FAQ-002, 003, **311** |
| `docs/entidades/proyectos.md`, `items.md` | FAQ-004, **310** |
| `docs/entidades/planificaciones.md`, `modelo-clases-planificacion.md` | FAQ-000, 300, 301, 302, 305, 306, 307, **310**, **311** |
| `docs/casos-uso/UC-02.4` | **311** (borrado masivo RE-4) |
| `docs/politicas-transversales/revision-principios-solid.md` | FAQ-004, 007 |
| `docs/diagramas-c4/` | FAQ-200, 201, 102, 303 |
| `docs/stack-tecnologico/analisis-inicial.md` | FAQ-100, 101 |
| `implementacion/` (raiz), `docs/implementacion/` | FAQ-102, 101 |
| `docs/politicas-transversales/desambiguacion-implementacion.md` | FAQ-102 |
| `docs/stack-tecnologico/historial-stack.md` | FAQ-102 |
| `docs/stack-tecnologico/cambio-tecnologia-componente.md` | FAQ-102 |

**Trazabilidad Ticket 000 — Paso ↔ FAQ:** [README.md](README.md).  
**Tickets de implementacion (001+):** [README.md](../README.md).

---

## Historial del FAQ

Referencia de migración (IDs pre-renumeración → vigentes). Solo para trazabilidad histórica; usar siempre los IDs vigentes en documentación nueva.

| Legacy | Vigente | Tema |
|--------|---------|------|
| FAQ-103 | [FAQ-200](#faq-200--diagrama-c4-n3-para-front-end) | N3 Front-End |
| FAQ-104 | [FAQ-201](#faq-201--trazabilidad-c4--casos-de-uso) | Trazabilidad UC ↔ C4 |
| FAQ-105 | [FAQ-300](#faq-300--modelo-fisico-de-planificaciones-una-tabla-o-varias) | Modelo ER planificaciones |
| FAQ-106 | [FAQ-306](#faq-306--tipoperiodo-catalogo-de-visibilidad-de-campos-de-patron) | TipoPeriodo (supersedida por FAQ-111 legacy) |
| FAQ-107 | [FAQ-301](#faq-301--tabla-catalogo-de-tipos-de-planificacion) | Catálogo tipos |
| FAQ-108 | [FAQ-302](#faq-302--nomenclatura-sin-planificar) | Sin planificar |
| FAQ-109 | [FAQ-304](#faq-304--vista-unificada-dias-semana-y-ocurrencias-solo-periódicas) | Vista unificada (supersedida) |
| FAQ-110 | [FAQ-305](#faq-305--tabla-unica-planificaciones--planificacionperiodo-11) | Tabla única + PlanificacionPeriodo |
| FAQ-111 | [FAQ-306](#faq-306--tipoperiodo-catalogo-de-visibilidad-de-campos-de-patron) | TipoPeriodo visibilidad |
| FAQ-112 | [FAQ-307](#faq-307--diagrama-de-clases-de-planificacion) | Diagrama de clases |
| FAQ-113 | [FAQ-308](#faq-308--orden-fisico-de-tablas-cluster-frente-a-pk-tabla_id) | Orden físico cluster |
| FAQ-114 | [FAQ-309](#faq-309--tablas-satelite-pk-y-orden-fisico) | Satélites PK |
| FAQ-115 | [FAQ-310](#faq-310--convencion-de-nombres-pk-tabla_id) | Convención PK |
| FAQ-116 | [FAQ-311](#faq-311--bloqueos-en-borrado-masivo-de-ocurrenciasmaterializadas-re-4) | Bloqueos RE-4 |
| FAQ-007 (stack/N4) | [FAQ-102](#faq-102--n4-implementacion-al-cambiar-de-tecnologia-en-un-componente) | Política N4 / desacoplamiento |

| Fecha | Cambio |
|-------|--------|
| 2026-06-12 | Creacion del documento; migracion de consideraciones del plan y respuestas del cuestionario |
| 2026-06-12 | Anadidas [FAQ-300](#faq-300--modelo-fisico-de-planificaciones-una-tabla-o-varias) a [FAQ-303](#faq-303--borrador-er-del-plan-definicionfechahora) (modelo ER, tablas por tipo, nomenclatura Sin planificar) |
| 2026-06-12 | [FAQ-004](#faq-004--entidades-proyecto-e-item): aclarada semantica herencia (NULL en BD, valor visible heredado, persistencia al interactuar) |
| 2026-06-12 | [FAQ-201](#faq-201--trazabilidad-c4--casos-de-uso) resuelta; trazabilidad distribuida; [FAQ-300](#faq-300--modelo-fisico-de-planificaciones-una-tabla-o-varias) modelo dos tablas; [FAQ-302](#faq-302--nomenclatura-sin-planificar) Sin planificar |
| 2026-06-12 | Ticket 000 — Paso 7b: entidades proyectos.md e items.md ([FAQ-004](#faq-004--entidades-proyecto-e-item)) |
| 2026-06-12 | Ticket 000 — Paso 8b: diagrama N3 Front-End ([FAQ-200](#faq-200--diagrama-c4-n3-para-front-end)) |
| 2026-06-12 | Renumeracion plan: ER (Ticket 000 — Paso 10) antes que stack (Ticket 000 — Paso 11); Ticket 000 — Paso 12 N4 implementacion |
| 2026-06-12 | [FAQ-304](#faq-304--vista-unificada-dias-semana-y-ocurrencias-solo-periódicas): V_Planificacion, dias_semana LMXJVSD, ocurrencias solo periodicas |
| 2026-06-12 | [FAQ-305](#faq-305--tabla-unica-planificaciones--planificacionperiodo-11): tabla unica Planificaciones + PlanificacionPeriodo; supersedida [FAQ-304](#faq-304--vista-unificada-dias-semana-y-ocurrencias-solo-periódicas) |
| 2026-06-12 | [FAQ-306](#faq-306--tipoperiodo-catalogo-de-visibilidad-de-campos-de-patron): TipoPeriodo (visibilidad campos patron) |
| 2026-06-12 | [FAQ-307](#faq-307--diagrama-de-clases-de-planificacion): diagrama de clases Planificacion en docs/entidades |
| 2026-06-12 | [FAQ-308](#faq-308--orden-fisico-de-tablas-cluster-frente-a-pk-tabla_id): orden fisico cluster (item, fechas) vs PK id |
| 2026-06-12 | [FAQ-309](#faq-309--tablas-satelite-pk-y-orden-fisico): satelites PK planificacion_id; ocurrencias (planificacion_id, fecha_original, hora, ocurrencia_id) |
| 2026-06-12 | [FAQ-310](#faq-310--convencion-de-nombres-pk-tabla_id): PK {tabla}_id; excepcion PlanificacionPeriodo |
| 2026-06-12 | [FAQ-311](#faq-311--bloqueos-en-borrado-masivo-de-ocurrenciasmaterializadas-re-4): bloqueos borrado masivo OcurrenciasMaterializadas; RE-4 acotado a una planificacion |
| 2026-06-12 | Ticket 000 — Paso 11 cerrado: [FAQ-100](#faq-100--motor-de-base-de-datos), [FAQ-101](#faq-101--stack-de-aplicacion), [FAQ-102](#faq-102--n4-implementacion-al-cambiar-de-tecnologia-en-un-componente); stack PostgreSQL + NestJS/React/TS; desambiguacion e implementacion |
| 2026-06-12 | [FAQ-102](#faq-102--n4-implementacion-al-cambiar-de-tecnologia-en-un-componente) actualizada: N4 por componente/tecnologia; politica desacoplamiento-componentes-contratos |
| 2026-06-12 | Ticket 000 — Paso 12a cerrado: N4 implementacion por componente (ZC-1 a ZC-6) |
| 2026-06-12 | [vista-general.md](../../docs/planificacion/vista-general.md): capas, contratos externo/interno, bootstrap, checklist pre-implementacion |
| 2026-06-12 | **Renumeracion FAQ por grupos FAQ-Gnn** (0 dominio, 1 stack, 2 C4, 3 ER). Pasos 12→12a/12b; trazabilidad paso↔FAQ en [Ticket 000 README](README.md) |
| 2026-06-12 | Ticket 000 — Paso 12b cerrado: guias agnosticas por componente en docs/implementacion/ |
| 2026-06-12 | Ticket 000 — Paso 13 re-validado: historial FAQ con IDs vigentes; N4 shared/typescript/; informe actualizado |
