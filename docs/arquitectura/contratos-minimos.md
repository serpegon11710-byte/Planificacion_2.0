# Contratos minimos de arquitectura (sin stack)

Este documento define la especificacion minima de **contratos de interfaz externa** acordada para el Step 9a de arquitectura (puertos, servicios de aplicacion, DTOs hacia API/UI).

> **Contexto:** [vista-general.md](../planificacion/vista-general.md) distingue contratos **externos** (este documento, API, ER) y **internos** (capas, ZC, mapeo N4, carpetas de codigo). Ambos deben estar cerrados antes de implementar negocio (Step 13–14).

## 1) Puerto de persistencia (por agregado)

Contrato consumido por Aplicacion/Negocio para CRUD y consultas de agregados sin exponer detalles SQL.

- `ProyectoRepositoryPort`
  - `create(proyecto)`
  - `update(proyecto)`
  - `delete(proyectoId)`
  - `findById(proyectoId)`
  - `findAll(filtro, paginacion)`
- `ItemRepositoryPort`
  - `create(item)`
  - `update(item)`
  - `delete(itemId)`
  - `findById(itemId)`
  - `findByProyectoId(proyectoId, filtro, paginacion)`
- `PlanificacionRepositoryPort`
  - `create(planificacion)`
  - `update(planificacion)`
  - `delete(planificacionId)`
  - `findById(planificacionId)`
  - `findByItemId(itemId, filtro, paginacion)`
  - `findSinPlanificar(filtro, paginacion)`
- `OcurrenciaRepositoryPort`
  - `markCompletada(ocurrenciaId, metadata)`
  - `markPendiente(ocurrenciaId)`
  - `findByPlanificacion(planificacionId, rango, filtros)`
- `OcurrenciaQueryPort` (lectura; segregado por ISP)
  - `findEnRango(rango, filtros)` — combina ocurrencias calculadas y materializadas (UC-02.1)

## 2) Puerto de conexion a BBDD (tecnico)

Contrato tecnico interno a Persistencia para desacoplar el motor SQL concreto.

- `DatabaseConnectionPort`
  - `open()`
  - `close()`
  - `query(statement, params)`
  - `execute(statement, params)`
  - `beginTransaction()`
  - `commit()`
  - `rollback()`
  - `isHealthy()`

## 3) Servicios de aplicacion (entradas/salidas)

Orquestan casos de uso y exponen contratos de entrada/salida estables para API/UI.

- `ProyectoApplicationService`
  - Entradas: `CrearProyectoInput`, `ActualizarProyectoInput`, `EliminarProyectoInput`, `ListarProyectosInput`
  - Salidas: `ProyectoOutput`, `ListaProyectoOutput`
- `ItemApplicationService`
  - Entradas: `CrearItemInput`, `ActualizarItemInput`, `EliminarItemInput`, `ListarItemsInput`
  - Salidas: `ItemOutput`, `ListaItemOutput`
- `PlanificacionApplicationService`
  - Entradas: `CrearPlanificacionInput`, `ActualizarPlanificacionInput`, `EliminarPlanificacionInput`, `ListarSinPlanificarInput`, `ListarOcurrenciasInput`
  - Salidas: `PlanificacionOutput`, `ListaPlanificacionOutput`, `ListaOcurrenciaOutput`
- `OcurrenciaApplicationService`
  - Entradas: `CompletarOcurrenciaInput`, `ReabrirOcurrenciaInput`
  - Salidas: `OcurrenciaOutput`

## Criterios transversales

- Sin dependencia de framework ni libreria.
- Inputs y outputs explicitamente tipados (DTOs), sin exponer entidades internas completas.
- Errores funcionales estandarizados por `codigo` estable; el `mensaje` al usuario se resuelve via i18n en Presentacion (ver `docs/politicas-transversales/internacionalizacion.md`).
- Paginacion y filtrado declarados en contratos de lectura para evitar acoplamientos a consultas ad-hoc.
