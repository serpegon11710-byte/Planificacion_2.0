# Historial de stack por componente

**Última actualización:** 2026-06-12

Registro vivo de **qué tecnología está activa** en cada contenedor y **qué tecnologías anteriores** quedaron archivadas (carpetas `(obsoleto)`) o **coexisten en paralelo** (excepción documentada).

> **Procedimiento al cambiar tecnología:** [cambio-tecnologia-componente.md](cambio-tecnologia-componente.md)  
> **Decisión inicial y análisis:** [analisis-inicial.md](analisis-inicial.md)

---

## Stack activo (línea base v1)

Adoptado en **Step 11** (2026-06-12). Es la primera entrada del historial; aún no hay tecnologías sustituidas.

| Componente | Tecnología | Versión / detalle | Carpeta `{tecnologia}` | Estado |
|------------|------------|-------------------|------------------------|--------|
| Front-End | React + TypeScript + Vite | React 18, TS 5 | `react-typescript` | **activa** |
| Back-End | NestJS + TypeScript | NestJS 10, Node 22, TS 5 | `nestjs-typescript` | **activa** |
| Persistencia | TypeScript + `pg` | Adaptadores explícitos | `typescript` | **activa** |
| Shared | TypeScript | DTOs, códigos de error | `typescript` | **activa** |
| BBDD | PostgreSQL | 16 | `postgresql` | **activa** |

**Rutas de código:** `implementacion/{componente}/{tecnologia}/`  
**Rutas N4 implementación (Step 12a+):** `docs/diagramas-c4/c4-nivel-4/implementacion/{componente}/{tecnologia}/`

**Contratos de referencia (v1):** API v1, puertos v1, ER v1, catálogo de errores v1 — ver [contratos-minimos.md](../arquitectura/contratos-minimos.md).

**Monorepo:** pnpm workspaces recomendado (FAQ-101); ver [analisis-inicial.md](analisis-inicial.md).

---

## Leyenda de estados

| Estado | Significado |
|--------|-------------|
| **activa** | Tecnología en uso para desarrollo y despliegue; carpeta **sin** sufijo `(obsoleto)`. |
| **obsoleta** | Sustituida por otra tecnología en el mismo componente; carpeta renombrada a `{tecnologia} (obsoleto)`; solo referencia histórica. |
| **activa (paralela)** | Coexistencia **intencionada** de dos o más tecnologías activas en el mismo componente (excepción; ver [cambio-tecnologia-componente.md](cambio-tecnologia-componente.md)). |

En v1 solo hay filas **activa**. No hay carpetas `(obsoleto)` ni motores en paralelo.

---

## Historial de cambios por componente

Registrar **cada sustitución** o **cada alta de coexistencia paralela**. Una fila por evento.

| Fecha | Componente | Evento | Tecnología anterior | Tecnología nueva / adicional | Carpeta obsoleta | Motivo | Referencia |
|-------|------------|--------|---------------------|------------------------------|------------------|--------|------------|
| 2026-06-12 | *(todos)* | **Línea base v1** | — | Ver tabla «Stack activo» | — | Step 11; FAQ-100, FAQ-101 | [analisis-inicial.md](analisis-inicial.md) |

*(Sin entradas de sustitución hasta el primer cambio de tecnología.)*

---

## Snapshots históricos (opcional)

Cuando varios componentes cambien de forma coordinada (p. ej. migración mayor), puede añadirse un **snapshot** resumen:

| Id snapshot | Fecha fin | Descripción | Componentes afectados |
|-------------|-----------|-------------|------------------------|
| — | — | — | — |

En el modelo por componente **no es obligatorio** un snapshot global; el historial por filas es la fuente de verdad.

---

## Coexistencia paralela (excepciones registradas)

Tecnologías **activas a la vez** en un mismo componente (no aplicar `(obsoleto)` entre ellas).

| Componente | Tecnologías activas en paralelo | Desde | Motivo | Notas |
|------------|--------------------------------|-------|--------|-------|
| — | *(ninguna en v1)* | — | — | BBDD admite excepción futura (p. ej. PostgreSQL + MySQL); ver [cambio-tecnologia-componente.md § Excepciones](cambio-tecnologia-componente.md#excepciones-coexistencia-de-dos-tecnologias-activas) |

Al activar una excepción, actualizar esta tabla **y** la tabla «Stack activo» (varias filas activas para el mismo componente).

---

## Mantenimiento

Al completar un [cambio de tecnología](cambio-tecnologia-componente.md):

1. Añadir fila en **Historial de cambios por componente**.
2. Actualizar **Stack activo** (marcar obsoleta o añadir paralela).
3. Si aplica coexistencia, actualizar **Coexistencia paralela**.
4. Si el cambio afecta contratos, documentar nueva versión (API v2, ER v2, etc.).
