# ZC-5 — Esquema y SQL (PostgreSQL 16)

**Canónico lógico:** [zc-5-persistencia.md](../../../pseudocodigo/zc-5-persistencia.md)  
**Adaptadores:** [persistencia/typescript/zc-5-persistencia.md](../../persistencia/typescript/zc-5-persistencia.md)  
**ER:** [modelo-entidad-relacion.md](../../../../../entidades/modelo-entidad-relacion.md)  
**Migraciones:** `implementacion/bbdd/postgresql/migrations/`

---

## Tablas

| Tabla | PK | Notas |
|-------|-----|-------|
| `proyectos` | `proyecto_id` | UNIQUE `nombre` |
| `items` | `item_id` | FK `proyecto_id`; UNIQUE `(proyecto_id, nombre)` |
| `planificaciones` | `planificacion_id` | Orden físico cluster: `(item_id, fecha_inicio, hora, planificacion_id)` (FAQ-308/309) |
| `tipo_periodo` | `tipo_periodo_id` | Catálogo; visibilidades FAQ-306 |
| `planificacion_periodo` | `planificacion_id` | PK = FK a `planificaciones`; 1:1 |
| `ocurrencias_materializadas` | `ocurrencia_id` | Orden: `(planificacion_id, fecha_original, hora, ocurrencia_id)` |

Sin columnas discriminadoras de subtipo: la clase de dominio se infiere (FAQ-305).

---

## Tipos PostgreSQL (FAQ-001, FAQ-100)

| Columna lógica | Tipo PG |
|----------------|---------|
| Fechas calendario | `date` |
| Hora | `time` |
| Instantes / auditoría | `timestamptz` |
| Estado, códigos cortos | `varchar` con CHECK o FK a catálogo |
| Texto libre | `text` |

---

## Restricciones destacadas

| Regla | Implementación SQL |
|-------|-------------------|
| Sin planificar | `fecha_inicio IS NULL AND fecha_fin IS NULL`; UNIQUE parcial observaciones por item (ER) |
| Puntual | CHECK `fecha_inicio = fecha_fin` cuando no hay periodo |
| Periódica | Fila en `planificacion_periodo`; FK `tipo_periodo_id` |
| Cascadas UC-01.2/01.3 | `ON DELETE CASCADE` proyecto → items → planificaciones → periodo → ocurrencias **solo** cuando RE-4 permite (validación en app antes de DELETE) |
| RE-4 borrado masivo | Política app FAQ-311; evitar DELETE multi-`planificacion_id` en una TX |

---

## Índices para ZC-1

```sql
-- Consulta materializadas en rango (RO-9, RO-10)
CREATE INDEX idx_ocurrencias_planificacion_fechas
  ON ocurrencias_materializadas (planificacion_id, fecha_original, hora, ocurrencia_id);

-- Planificaciones activas en rango de consulta
CREATE INDEX idx_planificaciones_item_fechas
  ON planificaciones (item_id, fecha_inicio, fecha_fin)
  WHERE fecha_inicio IS NOT NULL;
```

---

## Seeds

| Seed | Contenido |
|------|-----------|
| `tipo_periodo` | Filas Diario, Semanal, Mensual con flags de visibilidad (FAQ-306) |
| Desarrollo | Proyectos/items de prueba (opcional Ticket 001) |

---

## Migraciones

- Herramienta recomendada: node-pg-migrate o equivalente (ver [analisis-inicial.md](../../../../../stack-tecnologico/analisis-inicial.md)).
- Una migración por cambio de ER versionado; idempotencia en entornos CI.
- Al cambiar ER (contrato v2), nueva migración + actualizar adaptadores en persistencia **sin** tocar Front-End si API estable.
