# Granularidad final de modulos de negocio

Este documento fija la granularidad de modulos de negocio para Planificacion 2.0, sin acoplarse a tecnologias concretas. Forma parte de los **contratos de diseño interno** del Back-End — ver [vista-general.md](../../backlog/vista-general.md) §3.2.

## Objetivo

Definir limites funcionales claros entre modulos de dominio para:

- reducir acoplamiento,
- facilitar evolucion independiente,
- mantener reglas de negocio cohesionadas,
- y alinear casos de uso con responsabilidades explicitas.

## Criterios de granularidad aplicados

- Cohesion alta por capacidad funcional (no por tipo tecnico).
- Acoplamiento bajo entre modulos (interaccion por contratos).
- Un agregado principal por modulo cuando sea posible.
- Reglas de negocio y validaciones en el modulo propietario.
- Dependencias unidireccionales y explicitas.

## Agregados y limites de modulo

| Modulo | Agregado principal | Contenido cohesivo |
|--------|-------------------|-------------------|
| Proyecto | Proyecto | Identidad, nombre, descripcion, estado habilitado |
| Item | Item | Identidad, nombre, descripcion, referencia a proyecto |
| Planificacion | Planificacion | Tipo, estado, observaciones, definicion temporal, IdentificablePorUsuario |
| Ocurrencia | Ocurrencia materializada | Estado operativo, fecha/hora efectiva, modificaciones individuales |

Notas de agregado:

- La definicion temporal (puntual, periodica, Sin planificar) forma parte del agregado Planificacion, no de un modulo independiente.
- Las ocurrencias naturales (calculadas) no pertenecen al agregado; solo las ocurrencias materializadas por modificacion individual.
- "Sin planificar" es un tipo de Planificacion, no un modulo de negocio.

## Elementos fuera de modulos de negocio

- **UC-01.5 (Captura de datos de planificacion):** componente de presentacion reutilizable. Captura y valida datos de usuario sin persistir. Vive en la capa de Presentacion y delega la persistencia a los servicios de aplicacion del modulo Planificacion.
- **Orquestadores de aplicacion:** coordinan operaciones que cruzan modulos (por ejemplo, el wizard UC-01.1). No contienen reglas de dominio; invocan servicios de aplicacion de cada modulo dentro de una unidad transaccional.

## Modulos finales de negocio

### 1. Modulo Proyecto

Responsabilidad:

- Gestion del ciclo de vida de Proyecto.
- Reglas de unicidad de nombre y estado habilitado/inhabilitado.

Incluye:

- Entidad Proyecto.
- Reglas de negocio de Proyecto.
- Casos de uso: crear, editar, eliminar, listar proyectos.

Expone:

- `ProyectoApplicationService`
- `ProyectoRepositoryPort`

### 2. Modulo Item

Responsabilidad:

- Gestion del ciclo de vida de Item dentro de un Proyecto.
- Reglas de pertenencia Item -> Proyecto.

Incluye:

- Entidad Item.
- Reglas de consistencia de jerarquia con Proyecto.
- Casos de uso: crear, editar, eliminar, listar items por proyecto.

Expone:

- `ItemApplicationService`
- `ItemRepositoryPort`

Depende de:

- Modulo Proyecto (solo por identificadores y reglas de referencia).

### 3. Modulo Planificacion

Responsabilidad:

- Gestion de planificaciones puntuales, periodicas y no planificadas.
- Reglas de cambio de estado de planificacion.
- Reglas de definicion temporal.

Incluye:

- Entidad Planificacion.
- Value objects de definicion temporal.
- Casos de uso: crear, editar, eliminar, listar Sin planificar, consultar por item.

Expone:

- `PlanificacionApplicationService`
- `PlanificacionRepositoryPort`

Depende de:

- Modulo Item (solo por identificadores y validaciones de pertenencia).

### 4. Modulo Ocurrencia

Responsabilidad:

- Materializacion y gestion del estado operativo de ocurrencias.
- Reglas de completado/reapertura y consulta por rango temporal.

Incluye:

- Entidad Ocurrencia.
- Reglas de transicion de estado operativo.
- Casos de uso: listar ocurrencias, completar ocurrencia, reabrir ocurrencia.

Expone:

- `OcurrenciaApplicationService`
- `OcurrenciaRepositoryPort`
- `OcurrenciaQueryPort` (lecturas de calendario; UC-02.1)

Depende de:

- Modulo Planificacion (solo por identificadores y reglas de origen).

## Grafo de dependencias de negocio

Direccion permitida de dependencia entre modulos:

- `Proyecto -> (sin dependencias de negocio)`
- `Item -> Proyecto`
- `Planificacion -> Item`
- `Ocurrencia -> Planificacion`

Regla:

- No se permiten dependencias inversas.
- La comunicacion entre modulos se realiza por contratos de aplicacion/repositorio y objetos de entrada/salida.

## Asignacion de casos de uso a modulos

| Caso de uso | Modulo propietario | Modulos consultados | Orquestacion |
|-------------|-------------------|---------------------|--------------|
| UC-01.1 Wizard creacion | Orquestador de aplicacion | Proyecto, Item, Planificacion | Transaccion unica al confirmar |
| UC-01.2 Gestion proyecto | Proyecto | Item, Planificacion (creacion automatica) | Transaccion unica en crear/eliminar |
| UC-01.3 Gestion item | Item | Planificacion (creacion automatica) | Transaccion unica en crear/eliminar |
| UC-01.4 Gestion planificacion | Planificacion | Item (validacion pertenencia) | Transaccion unica por operacion |
| UC-01.5 Captura datos | Presentacion (fuera de negocio) | Planificacion (reglas de validacion) | Sin persistencia |
| UC-02.1 Visualizacion ocurrencias | Ocurrencia | Planificacion | Solo lectura |
| UC-02.2 Gestion puntual individual | Planificacion | Ocurrencia | Transaccion unica (ocurrencia = planificacion) |
| UC-02.3 Gestion periodica individual | Ocurrencia | Planificacion | Transaccion unica al materializar |
| UC-02.4 Gestion por planificacion | Ocurrencia | Planificacion | Transaccion unica por operacion |
| UC-03 Listar Sin planificar | Planificacion | Item (filtro opcional) | Solo lectura |

## Flujos de creacion automatica

Reglas de negocio que cruzan modulos pero mantienen responsabilidad clara:

- **UC-01.2 crear proyecto:** Proyecto crea el agregado; Item y Planificacion se crean como efecto colateral obligatorio en la misma unidad transaccional.
- **UC-01.3 crear item:** Item crea el agregado; Planificacion "Sin planificar" se crea como efecto colateral obligatorio en la misma unidad transaccional.
- **UC-01.1 wizard:** el orquestador invoca Proyecto, Item y Planificacion al confirmar; si falla cualquier paso, no persiste nada.

## Resultado

La granularidad final queda definida en 4 modulos de negocio:

- Proyecto
- Item
- Planificacion
- Ocurrencia

Esta granularidad se considera base de referencia para los siguientes pasos de arquitectura:

- transacciones y limites de consistencia,
- politicas de errores y validaciones por capa,
- y Step 11 (seleccion de stack tecnologico).
