# ZC-5 — Persistencia (TypeScript + `pg`)

**Canónico:** [zc-5-persistencia.md](../../../pseudocodigo/zc-5-persistencia.md)  
**Esquema:** [bbdd/postgresql/zc-5-persistencia-esquema.md](../../bbdd/postgresql/zc-5-persistencia-esquema.md)  
**Código:** `implementacion/persistencia/typescript/src/`

> No se redefinen reglas RE-*, RO-* ni RN-*; solo traducción a adaptadores SQL y transacciones.

---

## `PgConnectionAdapter` — `DatabaseConnectionPort`

Implementa el puerto técnico interno a persistencia:

| Método canónico | Implementación `pg` |
|-----------------|---------------------|
| `open()` | `Pool.connect()` / pool singleton |
| `close()` | `pool.end()` |
| `query(statement, params)` | `client.query(text, values)` |
| `execute(statement, params)` | Igual; DML sin retorno de filas |
| `beginTransaction()` | `BEGIN`; retorna `PgTransaction` con el mismo `Client` |
| `commit()` / `rollback()` | `COMMIT` / `ROLLBACK`; `client.release()` |
| `isHealthy()` | `SELECT 1` |

**NestJS:** provider `DATABASE_CONNECTION_PORT` → `PgConnectionAdapter`. Los repositorios reciben pool o factory de transacción.

---

## Patrón transaccional — `TransactionalAdapter`

Equivalente a `AdaptadorBase.ejecutarEnTransaccion`:

```typescript
async executeInTransaction<T>(
  block: (tx: PgTransaction) => Promise<T>,
  externalTx?: PgTransaction,
): Promise<T>
```

- Si `externalTx` es null → inicia TX, commit on success, rollback on error.
- Si `externalTx` viene del orquestador ZC-4 → participa en la misma TX (mismo `Client`).

Errores `pg` → `PgErrorMapper.desdeTecnico()` → `ErrorFuncional` o `ErrorTecnico` (nunca SQL crudo al dominio).

---

## Repositorios por agregado

### `ProyectoRepository`

| Operación canónica | SQL / notas |
|--------------------|-------------|
| `crear` | `INSERT INTO proyectos …` |
| `nombreDisponible` | `SELECT NOT EXISTS (… nombre …)` |
| `eliminarEnCascada` | Delega items vía `ItemRepository`; luego `DELETE proyectos` (FK cascade) |

### `ItemRepository`

| Operación canónica | SQL / notas |
|--------------------|-------------|
| `nombreDisponibleEnProyecto` | UNIQUE `(proyecto_id, nombre)` |
| `esUltimoDelProyecto` | `COUNT(*) = 1` |
| `eliminarEnCascada` | Planificaciones vía `PlanificacionRepository.eliminarEnCascada` por item |

### `PlanificacionRepository`

| Operación canónica | SQL / notas |
|--------------------|-------------|
| `crear` | `INSERT planificaciones`; si periodo → `INSERT planificacion_periodo` |
| `guardar` | UPSERT fila + periodo opcional |
| `buscarSinPlanificar` | `fecha_inicio IS NULL AND fecha_fin IS NULL` (UC-03) |
| `buscarPlanificadasEnRango` | Excluye Sin planificar; intersección de rangos para ZC-1 |
| `listarBloqueosEliminacion*` | Implementa `bloqueosDePlanificacion` del canónico |
| `eliminarDirecta` | `validarEliminacionPlanificacion` + DELETE (FAQ-116: un solo `planificacion_id` por TX) |
| `contarPorItem` | Para RN-4.2 |

### `OcurrenciaRepository` + `OcurrenciaQueryRepository`

| Operación canónica | SQL / notas |
|--------------------|-------------|
| `buscarPorPlanificacionEnRango` | Índice `(planificacion_id, fecha_original, hora, ocurrencia_id)`; filtros RO-9/RO-10 |
| `buscarPorFechaOriginal` | `WHERE planificacion_id = $1 AND fecha_original = $2` |
| `contarPorPlanificacion` | Solo si existe `planificacion_periodo` (RE-4) |
| `guardar` / `eliminar` | INSERT/UPDATE/DELETE por `ocurrencia_id` |

**FAQ-116:** en operaciones masivas RE-4, **no** usar `DELETE … WHERE planificacion_id IN (…)` en una transacción READ COMMITTED; borrar por un único `planificacion_id` por unidad de trabajo.

---

## `PgErrorMapper`

| Error PostgreSQL | `codigo` funcional |
|------------------|-------------------|
| `23505` + constraint `proyecto_nombre` | `PROYECTO_NOMBRE_DUPLICADO` |
| `23505` + constraint item/proyecto | `ITEM_NOMBRE_DUPLICADO_EN_PROYECTO` |
| Conexión / timeout | `PERSISTENCIA_NO_DISPONIBLE` |
| Otros | `ERROR_PERSISTENCIA_INTERNO` |

---

## Mappers (`src/mappers/`)

| Mapper | Responsabilidad |
|--------|-----------------|
| `PlanificacionRowMapper` | Fila(s) `planificaciones` + `planificacion_periodo` → entidad dominio; inferencia de clase vía datos (sin discriminador BD) |
| `OcurrenciaRowMapper` | `ocurrencias_materializadas` → `RegistroOcurrencia` |
| `BloqueoEliminacionMapper` | Construye payload RE-5 (`identificable_por_usuario`) |

---

## Soporte a otras ZC

| ZC | Uso de persistencia |
|----|---------------------|
| ZC-1 | `OcurrenciaQueryRepository.buscarPorPlanificacionEnRango`; lecturas planificación |
| ZC-2 | `OcurrenciaRepository.guardar/eliminar/buscarPorFechaOriginal` |
| ZC-3 | `PlanificacionRepository` CRUD + Sin planificar |
| ZC-4 | TX compartida vía `executeInTransaction(..., externalTx)` en cascadas |

---

## Tests

- Integración con PostgreSQL (Testcontainers recomendado en Step 14).
- Fixtures alineados a seeds `implementacion/bbdd/postgresql/seeds/`.
