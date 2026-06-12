# FAQ — Dudas y resoluciones

Registro centralizado de preguntas abiertas, decisiones tomadas y cambios de nomenclatura del proyecto Planificacion 2.0.

**Ultima actualizacion:** 2026-06-12

Los documentos funcionales (`entidades/`, `arquitectura/`, etc.) deben **referenciar este FAQ** en lugar de mantener dudas duplicadas. Las resoluciones aqui prevalecen sobre borradores antiguos del plan (p. ej. `DefinicionFechaHora`, `InstanciaPlanificacion`).

---

## Leyenda

| Estado | Significado |
|--------|-------------|
| **Resuelta** | Decision acordada; pendiente de reflejar en todos los artefactos si aun no lo esta |
| **Abierta** | Requiere decision antes o durante Step 9c / Step 10 |
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

**Pendiente de reflejar en:** `planificaciones.md`, pseudocodigo ZC-3 (semanal ya admite conjunto de dias; diaria debe usar enum, no lista generica).

**Nota:** El plan original recomendaba lista flexible para diarios; queda **supersedida**.

---

### FAQ-002 — Zona horaria

**Origen:** `planificacion-inicial.md` (consideracion 2).

**Pregunta:** ¿Una sola zona horaria o multi-zona?

**Resolucion (2026-06-12):** Persistir y comparar fechas/horas en **UTC**. Evita ambiguedades al cerrar el modelo (Step 10) sin disenar multi-zona de usuario todavia.

**Pendiente de reflejar en:** Step 10 (ER), politica i18n (formateo a locale en presentacion; almacenamiento UTC).

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

**Pendiente de reflejar en:** Step 10, `ocurrencias.md` si hace falta detalle de persistencia.

---

### FAQ-005 — Entidades Proyecto e Item

**Origen:** `revision-principios-solid.md` (deuda documental).

**Pregunta:** ¿Documentar Proyecto e Item en `docs/entidades/`?

**Resolucion:** **Si**, crear `proyectos.md` e `items.md` **antes** del Step 10 (ER).

**Estado de ejecucion:** **Pendiente** — registrado en el plan como Step 7b (ver `planificacion-inicial.md`).

---

### FAQ-006 — Idiomas (i18n)

**Origen:** Step 9b / `internacionalizacion.md`.

**Pregunta:** ¿Que locales en la primera implementacion?

**Resolucion (2026-06-12):** **Espanol** en la UI. **Infraestructura i18n** preparada para cualquier idioma. **Sin literales en la capa de negocio** (solo `codigo`; mensajes en presentacion).

---

### FAQ-007 — N4 implementacion al cambiar de stack

**Origen:** `c4-nivel-4/implementacion/README.md`.

**Pregunta:** ¿Que hacer con el N4 de un stack anterior?

**Resolucion (2026-06-12):** **Conservar** carpetas `{stack}/` como historico. Detalle de politica de archivo pendiente de conversacion futura.

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

**Resolucion (2026-06-12):** **Dos tablas:**

- `PlanificacionesPeriodicas`
- `PlanificacionesPuntuales` (incluye Puntual y Sin planificar)

**Sin planificar** no tiene tabla propia: flag booleano `sin_planificar` en `PlanificacionesPuntuales`.

**Cambios de tipo:**

| Transicion | Operacion |
|------------|-----------|
| Sin planificar ↔ Puntual | Misma tabla; mutar flag y fecha/hora |
| Sin planificar → Periodica | Anular puntual; crear periodica. Sin impacto en ocurrencias |
| Periodica → Sin planificar | Anular periodica; crear puntual con `sin_planificar = true`. Precondicion: sin ocurrencias materializadas (RT-3) |

Detalle en `docs/entidades/planificaciones.md`.

---

### FAQ-106 — Tabla catalogo de tipos de planificacion

**Origen:** Step 10 (alternativa a `DefinicionFechaHora` del plan).

**Resolucion (2026-06-12):** Tabla `TipoPlanificacion` con columna `periodica`:

| Tipo | `periodica` |
|------|-------------|
| Puntual | `false` |
| SinPlanificar | `NULL` |
| Diario | `true` |
| Semanal | `true` |
| Mensual | `true` |

Subtipos diarios (`TODOS`, `LUN_VIE`, `FIN_SEMANA`) son configuracion de filas `Diario`, no filas de catalogo.

---

### FAQ-107 — Nomenclatura «Sin planificar»

**Origen:** FAQ-105 / modelo ER.

**Resolucion (2026-06-12):** Usar **«Sin planificar»** en toda la documentacion y **`SinPlanificar`** como codigo de tipo. Clase de dominio: `PlanificacionSinPlanificar`. Sustituye la nomenclatura anterior «No planificado» / `NoPlanificado`.

---

### FAQ-108 — Borrador ER del plan: `DefinicionFechaHora`

**Origen:** `planificacion-inicial.md` (Step 10 y «Decisiones tomadas»).

**Resolucion (2026-06-12):** Sustituir `DefinicionFechaHora` por el modelo FAQ-105 / FAQ-106: tablas `PlanificacionesPuntuales`, `PlanificacionesPeriodicas` y catalogo `TipoPlanificacion`. Aplicar en Step 10.

---

## Abiertas

### FAQ-101 — Motor de base de datos

**Origen:** Step 9c.

**Estado:** **Postergada** — no abordar aun. Se retomara en Step 9c cuando proceda.

---

### FAQ-102 — Stack de aplicacion

**Origen:** Step 9c.

**Estado:** **Postergada** — no abordar aun. Se retomara en Step 9c cuando proceda.

---

### FAQ-103 — Diagrama C4 N3 para Front-End

**Origen:** Step 8.

**Resolucion (2026-06-12):** **Si**, crear un **segundo diagrama N3** de componentes Front-End (ademas del N3 Back-End/Persistencia existente).

**Estado de ejecucion:** **Pendiente** — registrado en el plan como Step 8b (ver `planificacion-inicial.md`).

---

## Pendientes de ejecutar

| ID | Accion | Registro en plan |
|----|--------|------------------|
| FAQ-005 | `docs/entidades/proyectos.md`, `items.md` | Step 7b |
| FAQ-103 | `c4-nivel-3/c4-nivel-3-componentes-frontend.mmd` | Step 8b |

---

## Indice rapido por documento origen

| Documento | IDs FAQ |
|-----------|---------|
| `planificacion-inicial.md` | FAQ-001, 002, 003, 108 |
| `entidades/ocurrencias.md` | FAQ-003, 004 |
| `entidades/planificaciones.md` | FAQ-001, 105, 106, 107 |
| `revision-principios-solid.md` | FAQ-005, 009 |
| `diagramas-c4/` | FAQ-103, 104, 007, 008 |
| Step 9c | FAQ-101, 102 |

---

## Historial del FAQ

| Fecha | Cambio |
|-------|--------|
| 2026-06-12 | Creacion del documento; migracion de consideraciones del plan y respuestas del cuestionario |
| 2026-06-12 | Anadidas FAQ-105 a FAQ-108 (modelo ER, tablas por tipo, nomenclatura Sin planificar) |
| 2026-06-12 | FAQ-004: aclarada semantica herencia (NULL en BD, valor visible heredado, persistencia al interactuar) |
| 2026-06-12 | FAQ-104 a FAQ-108 resueltas; trazabilidad distribuida; modelo dos tablas; Sin planificar |
