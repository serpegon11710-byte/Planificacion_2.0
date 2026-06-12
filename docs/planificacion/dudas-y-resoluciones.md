# FAQ — Dudas y resoluciones

Registro centralizado de preguntas abiertas, decisiones tomadas y cambios de nomenclatura del proyecto Planificacion 2.0.

**Ultima actualizacion:** 2026-06-12

Los documentos funcionales (`entidades/`, `arquitectura/`, etc.) deben **referenciar este FAQ** en lugar de mantener dudas duplicadas. Las resoluciones aqui prevalecen sobre borradores antiguos del plan (p. ej. `DefinicionFechaHora`, `InstanciaPlanificacion`).

**FAQ de uso del producto** (por qué no puedo borrar, cómo preparar planificaciones antes de eliminar): [FAQ.md](../../FAQ.md) en la raíz del repositorio. Este archivo (`dudas-y-resoluciones.md`) es solo para decisiones de diseño.

---

## Leyenda

| Estado | Significado |
|--------|-------------|
| **Resuelta** | Decision acordada; el detalle documental puede quedar como entregable del Step indicado en cada FAQ |
| **Abierta** | Requiere decision; ver Step 11 o Step 10 segun el FAQ |
| **Supersedida** | Duda historica; ver resolucion y nota de nomenclatura |

---

## Resueltas

### FAQ-001 — Periodos diarios y semanales

**Origen:** `planificacion-inicial.md` (consideracion 1).

**Pregunta:** ¿Atributos fijos o lista flexible de dias de la semana?

**Resolucion (2026-06-12):**

- **Periodica diaria:** subtipo **prefijado / enum** (`TODOS`, `LUN_VIE`, `FIN_SEMANA`). No es lista libre.
- **Periodica semanal:** **lista de dias de la semana** (p. ej. martes y jueves en la misma planificacion). Puede haber varios dias seleccionados.
- **Periodica mensual:** sin cambio respecto al catalogo funcional (`planificaciones.md`).

**Reflejado en:** `planificaciones.md`, `zc-3-planificacion-temporal.md`.

**Nota:** El plan original recomendaba lista flexible para diarios; queda **supersedida**.

---

### FAQ-002 — Zona horaria

**Origen:** `planificacion-inicial.md` (consideracion 2).

**Pregunta:** ¿Una sola zona horaria o multi-zona?

**Resolucion (2026-06-12):** Persistir y comparar fechas/horas en **UTC**. Formateo a locale del usuario en presentacion (i18n).

**Entregable Step 10:** tipos UTC en el ER (`docs/entidades/modelo-entidad-relacion.md`) y nota en `internacionalizacion.md` (almacenamiento vs visualizacion). **Completado (2026-06-12).**

---

### FAQ-003 — Completado en planificaciones periodicas

**Origen:** `planificacion-inicial.md` (consideracion 3).

**Pregunta:** ¿Se completa la ocurrencia concreta o la planificacion entera?

**Nota de nomenclatura:** La duda inicial mencionaba una entidad `InstanciaPlanificacion`. Ese nombre quedo **sustituido por Ocurrencia** (`docs/entidades/ocurrencias.md`).

**Resolucion (2026-06-12):**

- Se completa la **ocurrencia individual**.
- Toda ocurrencia tiene **estado propio**; puede quedar **NULL** en persistencia (= hereda el estado de la planificacion; el usuario lo ve reflejado hasta que interactue).
- Modificar el completado de la **planificacion** no arrastra ocurrencias ya materializadas.
- No se requiere entidad aparte de **Ocurrencia**.

---

### FAQ-004 — Ocurrencias materializadas en el ER

**Origen:** Step 10 / modelo de datos.

**Pregunta:** ¿Incluir tabla de ocurrencias materializadas en el diagrama ER?

**Resolucion (2026-06-12):** **Si**, en Step 10.

**Semantica de herencia** (observaciones, estado / completada):

- En **persistencia**, **NULL** significa que la ocurrencia no tiene valor propio para ese campo; el valor **efectivo** se resuelve desde la planificacion.
- En **presentacion**, el usuario **ve** el valor heredado (el mismo que muestra la planificacion para ese campo).
- Al **interactuar** con el dato (editar observaciones, marcar completada, etc.), se **registra** en la ocurrencia materializada lo que el usuario indico; ese campo deja de heredar.

Relacionado con FAQ-003 (estado vacio = hereda).

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

**Entregable Step 10:** tabla `OcurrenciasMaterializadas` en `modelo-entidad-relacion.md`; seccion de persistencia en `ocurrencias.md` alineada al ER. **Completado (2026-06-12).**

---

### FAQ-005 — Entidades Proyecto e Item

**Origen:** `revision-principios-solid.md` (deuda documental).

**Pregunta:** ¿Documentar Proyecto e Item en `docs/entidades/`?

**Resolucion:** **Si**, crear `proyectos.md` e `items.md` **antes** del Step 10 (ER).

**Estado de ejecucion:** **Completado** (2026-06-12) — `docs/entidades/proyectos.md`, `docs/entidades/items.md`.

---

### FAQ-006 — Idiomas (i18n)

**Origen:** Step 9b / `internacionalizacion.md`.

**Pregunta:** ¿Que locales en la primera implementacion?

**Resolucion (2026-06-12):** **Espanol** en la UI. **Infraestructura i18n** preparada para cualquier idioma. **Sin literales en la capa de negocio** (solo `codigo`; mensajes en presentacion).

---

### FAQ-008 — Composicion de ocurrencias en consulta (ZC-1)

**Origen:** Diseno N4 / optimizacion SQL.

**Pregunta:** ¿Calcular todas las naturales y fusionar con fisicas, o evitar doble trabajo?

**Resolucion (2026-06-12):** Algoritmo acordado y documentado en `zc-1-consulta-ocurrencias.md`.

---

### FAQ-009 — Mensajes de error en casos de uso

**Origen:** `revision-principios-solid.md`.

**Resolucion (2026-06-12):** Literales en UCs solo como **referencia UX** en documentacion. Implementacion: `codigo` + i18n; negocio sin literales (FAQ-006).

---

### FAQ-104 — Trazabilidad C4 ↔ casos de uso

**Origen:** Step 8 (`planificacion-inicial.md`).

**Resolucion (2026-06-12):** Trazabilidad **distribuida**, no fichero central:

- Cada **zona critica N4** (`docs/diagramas-c4/c4-nivel-4/pseudocodigo/zc-*.md`) documenta los casos de uso que la justifican y su rol al implementar.
- Cada **caso de uso** referencia las zonas criticas N4 que le afectan.

Asi quien implementa una ZC ve de inmediato el origen funcional; quien lee un UC sabe donde buscar el detalle arquitectonico.

**Estado de ejecucion:** Reflejado en ZC N4 y UCs (Step 8c).

---

### FAQ-105 — Modelo fisico de planificaciones: una tabla o varias

**Origen:** Step 10 / decision de modelo de datos.

**Estado:** Resolucion inicial (dos tablas puntuales/periodicas) **supersedida por FAQ-110** (tabla unica `Planificaciones` + `PlanificacionPeriodo` 1:1). Conservada como historial.

**Entregable vigente:** `docs/entidades/modelo-entidad-relacion.md` (FAQ-110).

---

### FAQ-106 — Tabla catalogo de tipos de planificacion

**Estado:** **Supersedida por FAQ-111** (`TipoPeriodo` con visibilidades de campos). Conservada como historial (modelo intermedio `TipoPlanificacion` + `periodica`).

---

### FAQ-111 — `TipoPeriodo`: catalogo de visibilidad de campos de patron

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

### FAQ-112 — Diagrama de clases de Planificacion

**Origen:** Alineacion dominio / persistencia / pseudocodigo.

**Resolucion (2026-06-12):**

Jerarquia canonica en `docs/entidades/modelo-clases-planificacion.md` (+ `.mmd`):

- `Planificacion` (abstracta) → `PlanificacionSinPlanificar`, `PlanificacionPuntual`, `PlanificacionPeriodica` (abstracta) → `PlanificacionDiaria`, `PlanificacionSemanal`, `PlanificacionMensual`.
- Factory `inferirClase` / `Planificacion.desdePersistencia` enlaza ER con clases concretas.
- Nombres `PlanificacionPeriodicaDiaria` etc. quedan **obsoletos**; usar subclases directas de `PlanificacionPeriodica`.

**Entregable:** trazabilidad en `planificaciones.md`, `ocurrencias.md`, ZC-1, ZC-3. **Completado (2026-06-12).**

---

### FAQ-113 — Orden fisico de tablas (cluster) frente a PK `id`

**Origen:** Refinamiento ER; la PK surrogate no basta como criterio de localidad de lectura.

**Resolucion (2026-06-12):**

| Tabla | Orden fisico | Indice adicional de negocio |
|-------|--------------|----------------------------|
| `Proyectos` | `id` | `UNIQUE (nombre)` |
| `Items` | `(proyecto_id, id)` | `UNIQUE (proyecto_id, nombre)` |
| `Planificaciones` | `(item_id, fecha_inicio, hora, id)` | `UNIQUE (item_id, observaciones)` parcial Sin planificar |

En `Planificaciones`, `fecha_inicio NULL` agrupa Sin planificar por item; puntuales y periodicas se ordenan por fecha y hora, no por subtipo. Sintaxis en Step 11.

**Entregable:** seccion en `modelo-entidad-relacion.md`. **Completado (2026-06-12).**

---

### FAQ-114 — Tablas satelite: PK y orden fisico

**Origen:** Refinamiento ER; `PlanificacionPeriodo` y `OcurrenciasMaterializadas`.

**Resolucion (2026-06-12):**

1. **`PlanificacionPeriodo`:** sin `id` propio; **PK = `planificacion_id`** (1:1). Orden fisico por `planificacion_id`. No coincide con el orden de `Planificaciones` (por item/fecha).
2. **`OcurrenciasMaterializadas`:** PK fila **`ocurrencia_id`**; FK **`planificacion_id`** (semantica planificacion periodica, misma clave que el periodo). Orden fisico **`(planificacion_id, fecha_original, hora, ocurrencia_id)`**. Alineado con `PlanificacionPeriodo` por `planificacion_id`; no alineado con `Planificaciones`.

**Entregable:** ER + pseudocodigo ZC-1/2/5. **Completado (2026-06-12).**

---

### FAQ-107 — Nomenclatura «Sin planificar»

**Origen:** FAQ-105 / modelo ER.

**Resolucion (2026-06-12):** Usar **«Sin planificar»** en toda la documentacion y **`SinPlanificar`** como codigo de tipo. Clase de dominio: `PlanificacionSinPlanificar`. Sustituye la nomenclatura anterior «No planificado» / `NoPlanificado`.

**Reflejado en:** documentacion funcional y pseudocodigo (renombrado 2026-06-12).

---

### FAQ-108 — Borrador ER del plan: `DefinicionFechaHora`

**Origen:** `planificacion-inicial.md` (Step 10 y «Decisiones tomadas»).

**Resolucion (2026-06-12):** Sustituir `DefinicionFechaHora` por el modelo FAQ-105 / FAQ-106. **Entregable Step 10:** `docs/entidades/modelo-entidad-relacion.md`. **Completado (2026-06-12).**

---

### FAQ-109 — Vista unificada, dias semana y ocurrencias solo periódicas

**Estado:** **Supersedida por FAQ-110** (2026-06-12). Conservada como historial de la iteracion intermedia (dos tablas + vista).

---

### FAQ-110 — Tabla unica Planificaciones + PlanificacionPeriodo 1:1

**Origen:** Revision del ER; simplificar duplicacion de campos comunes y escalabilidad.

**Resolucion (2026-06-12):**

1. **Una tabla `Planificaciones`** con campos comunes: `item_id`, `fecha_inicio`, `fecha_fin`, `hora`, `observaciones`, `estado`. Sin flags: la naturaleza se infiere (Sin planificar = fechas NULL; Puntual = inicio = fin sin periodo; Periódica = existe `PlanificacionPeriodo` y fin > inicio).
2. **`PlanificacionPeriodo`** 1:1 opcional: solo periódicas. Valores de patron aqui; visibilidad por tipo en **`TipoPeriodo`** (FAQ-111).
3. **Ocurrencias:** Sin planificar → lista vacia; Puntual → una dinamica; Periódica → dinamicas + `OcurrenciasMaterializadas` (FK `planificacion_id`). Restricciones RO-8 a RO-10 (rango, visibilidad tras cambio de fechas).
4. Se eliminan `PlanificacionesPuntuales`, `PlanificacionesPeriodicas`, `V_Planificacion` y flags `sin_planificar`.

**Entregable Step 10:** `docs/entidades/modelo-entidad-relacion.md`, `planificaciones.md`, pseudocodigo ZC-1/3/5. **Completado (2026-06-12).**

---

### FAQ-103 — Diagrama C4 N3 para Front-End

**Origen:** Step 8.

**Resolucion (2026-06-12):** **Si**, crear un **segundo diagrama N3** de componentes Front-End (ademas del N3 Back-End/Persistencia existente).

**Estado de ejecucion:** **Completado** — `docs/diagramas-c4/c4-nivel-3/c4-nivel-3-componentes-frontend.mmd` (Step 8b).

---

## Abiertas (postergadas a Step 11)

### FAQ-007 — N4 implementacion al cambiar de stack

**Origen:** `c4-nivel-4/implementacion/README.md`.

**Principio acordado (2026-06-12):** **Conservar** carpetas `{stack}/` como historico al cambiar de stack; no mezclar implementaciones en la misma carpeta.

**Entregable Step 11:** politica de archivo detallada en `implementacion/README.md` (cuando se cierre la seleccion de stack).

---

### FAQ-101 — Motor de base de datos

**Origen:** Step 11.

**Estado:** **Postergada** — entregable Step 11.

---

### FAQ-102 — Stack de aplicacion

**Origen:** Step 11.

**Estado:** **Postergada** — entregable Step 11.

---

## Entregables por Step (resumen)

| Step | FAQ / contenido | Artefactos |
|------|-----------------|------------|
| **10** | FAQ-002, 004, 105, 106, 108 | `docs/entidades/modelo-entidad-relacion.md`; UTC en ER + `internacionalizacion.md`; ocurrencias materializadas |
| **11** | FAQ-007, 101, 102 | Stack, motor BBDD, politica N4 historico |
| **12** | — | N4 `implementacion/{stack}/` (proyeccion del canonico) |

Los Steps 7b, 8b y 8c ya estan cerrados. Las FAQ 001, 003, 006, 008, 009, 103, 104, 107 no tienen entregable pendiente fuera de lo ya documentado.

---

## Pendientes de ejecutar

_Ninguno fuera de Steps 11 y 12 (2026-06-12). Step 10 cerrado._

---

## Indice rapido por documento origen

| Documento | IDs FAQ |
|-----------|---------|
| `planificacion-inicial.md` | FAQ-001, 002, 003, 108 |
| `entidades/modelo-entidad-relacion.md` | FAQ-002, 004, 105, 106, 108, 113, 114 |
| `entidades/ocurrencias.md` | FAQ-003, 004 |
| `entidades/proyectos.md`, `items.md` | FAQ-005 |
| `entidades/planificaciones.md`, `modelo-clases-planificacion.md` | FAQ-001, 105, 106, 107, 110, 111, 112 |
| `revision-principios-solid.md` | FAQ-005, 009 |
| `diagramas-c4/` | FAQ-103, 104, 007, 008 |
| Step 11 | FAQ-007, 101, 102 |
| Step 12 | N4 implementacion por stack |
| Step 10 | FAQ-002, 004, 105, 106, 108, 110, 111, 112, 113, 114 |
---

## Historial del FAQ

| Fecha | Cambio |
|-------|--------|
| 2026-06-12 | Creacion del documento; migracion de consideraciones del plan y respuestas del cuestionario |
| 2026-06-12 | Anadidas FAQ-105 a FAQ-108 (modelo ER, tablas por tipo, nomenclatura Sin planificar) |
| 2026-06-12 | FAQ-004: aclarada semantica herencia (NULL en BD, valor visible heredado, persistencia al interactuar) |
| 2026-06-12 | FAQ-104 a FAQ-108 resueltas; trazabilidad distribuida; modelo dos tablas; Sin planificar |
| 2026-06-12 | Step 7b: entidades proyectos.md e items.md (FAQ-005) |
| 2026-06-12 | Step 8b: diagrama N3 Front-End (FAQ-103) |
| 2026-06-12 | Renumeracion plan: Step 11 -> Step 11; ER (10) antes que stack; Step 12 N4 implementacion |
| 2026-06-12 | FAQ-109: V_Planificacion, dias_semana LMXJVSD, ocurrencias solo periódicas |
| 2026-06-12 | FAQ-110: tabla unica Planificaciones + PlanificacionPeriodo; supersede FAQ-109 |
| 2026-06-12 | FAQ-111: TipoPeriodo (visibilidad campos patron); supersede FAQ-106 |
| 2026-06-12 | FAQ-112: diagrama de clases Planificacion en docs/entidades |
| 2026-06-12 | FAQ-113: orden fisico cluster (item, fechas) vs PK id |
| 2026-06-12 | FAQ-114: satelites PK planificacion_id; ocurrencias (planificacion_id, fecha_original, hora, ocurrencia_id) |
