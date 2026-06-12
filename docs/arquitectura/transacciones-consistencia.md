# Transacciones y limites de consistencia

Este documento define los limites transaccionales y de consistencia de Planificacion 2.0, alineado con la granularidad de modulos y los casos de uso existentes.

## Objetivo

Establecer cuando una operacion debe ser atomica, que datos deben mantenerse consistentes entre modulos y que comportamiento se espera ante fallos parciales.

## Principios generales

- Una unidad de trabajo (transaccion) agrupa operaciones que deben persistir juntas o no persistir ninguna.
- Cada modulo es responsable de la consistencia interna de su agregado.
- La consistencia entre agregados de distintos modulos se garantiza mediante orquestacion en la capa de Aplicacion dentro de una transaccion compartida.
- Las consultas de ocurrencias calculadas son de solo lectura y no requieren transaccion de escritura.
- La capa de Negocio no gestiona transacciones; delega en Aplicacion/Persistencia via `DatabaseConnectionPort`.

## Unidades transaccionales por operacion

### Escritura atomica multi-modulo

| Operacion | Modulos involucrados | Alcance transaccional |
|-----------|---------------------|----------------------|
| UC-01.1 Confirmar wizard | Proyecto + Item + Planificacion | Crear los tres agregados o ninguno |
| UC-01.2 Crear proyecto | Proyecto + Item + Planificacion | Crear proyecto, item automatico y planificacion "Sin planificar" |
| UC-01.2 Eliminar proyecto | Proyecto + Item + Planificacion + Ocurrencia | Eliminar en cascada todo el arbol del proyecto |
| UC-01.3 Crear item | Item + Planificacion | Crear item y planificacion "Sin planificar" automatica |
| UC-01.3 Eliminar item | Item + Planificacion + Ocurrencia | Eliminar item, sus planificaciones y ocurrencias materializadas |
| UC-01.4 Crear/editar planificacion | Planificacion | Una planificacion y su definicion temporal |
| UC-01.4 Eliminar planificacion | Planificacion + Ocurrencia | Eliminar planificacion y ocurrencias materializadas asociadas |
| UC-02.2 Gestion puntual individual | Planificacion | Actualizar planificacion (la ocurrencia puntual es la planificacion) |
| UC-02.3 Materializar ocurrencia periodica | Ocurrencia (+ Planificacion lectura) | Registrar modificacion individual de una ocurrencia |
| UC-02.4 Operacion sobre ocurrencias fisicas | Ocurrencia | Crear, modificar o marcar eliminada una ocurrencia materializada |

### Operaciones de solo lectura (sin transaccion de escritura)

- UC-02.1 Visualizacion de ocurrencias en rango.
- UC-03 Listado de planificaciones "Sin planificar".
- Consultas de listado y detalle de Proyecto, Item y Planificacion.

## Reglas de consistencia entre agregados

### RC-T1: Integridad referencial jerarquica

- Todo Item referencia un Proyecto existente.
- Toda Planificacion referencia un Item existente.
- Toda Ocurrencia materializada referencia una Planificacion existente.

Validacion: en operaciones de escritura, el modulo propietario verifica la existencia de la referencia antes de persistir.

### RC-T2: Minimos obligatorios

- Un Proyecto debe tener al menos un Item (RN-3.3).
- Un Item debe tener al menos una Planificacion (RN-3.4).

Implicacion transaccional: no se permite eliminar el ultimo Item de un Proyecto ni la ultima Planificacion de un Item. Estas validaciones ocurren antes de iniciar la eliminacion.

### RC-T3: Eliminacion en cascada

| Eliminacion origen | Efecto en cascada |
|--------------------|-------------------|
| Proyecto | Items del proyecto, planificaciones de esos items, ocurrencias materializadas |
| Item | Planificaciones del item, ocurrencias materializadas de esas planificaciones |
| Planificacion | Ocurrencias materializadas de esa planificacion |

Toda cascada se ejecuta dentro de una unica transaccion.

### RC-T4: Creacion automatica acoplada

Al crear Proyecto (UC-01.2) o Item (UC-01.3), la planificacion "Sin planificar" automatica se crea en la misma transaccion. No puede quedar un Proyecto/Item sin su planificacion inicial.

### RC-T5: Ocurrencias calculadas vs materializadas

- Las ocurrencias naturales se calculan en lectura a partir de la Planificacion; no se persisten.
- Solo las modificaciones individuales (estado, fecha, hora, observaciones, eliminacion) se materializan en el agregado Ocurrencia.
- Una lectura de ocurrencias combina el calculo dinamico con las materializaciones registradas (precedencia de modificaciones, RO-3).

Consistencia: no se requiere transaccion entre el calculo y la lectura de materializaciones; la consistencia eventual de lectura es aceptable siempre que la planificacion base no cambie durante la consulta.

### RC-T6: Cambio de tipo de planificacion

Los cambios de tipo (reglas RT-1 a RT-5 en `docs/entidades/planificaciones.md`) se aplican dentro de una unica transaccion sobre el agregado Planificacion. Si el cambio implica invalidar ocurrencias materializadas (por ejemplo, pasar a "Sin planificar" con ocurrencias explicitas), la validacion falla antes de persistir.

## Limites de consistencia por capa

| Capa | Responsabilidad de consistencia |
|------|--------------------------------|
| Presentacion (UC-01.5) | Validacion de formulario y formato; sin efecto en persistencia |
| Aplicacion | Delimitar unidad transaccional, orquestar modulos, propagar rollback |
| Negocio | Reglas intra-agregado e invariantes de dominio |
| Persistencia | Implementar transaccion via `DatabaseConnectionPort`, ejecutar cascadas |

## Gestion de fallos y rollback

- Si cualquier paso de una operacion multi-modulo falla, se ejecuta rollback completo de la transaccion.
- Si UC-01.5 devuelve cancelacion, no se inicia transaccion de escritura.
- Errores de validacion de negocio (ultimo item, ultima planificacion, cambio de tipo no permitido) abortan la operacion sin efectos parciales.
- Errores tecnicos de persistencia provocan rollback y se propagan como error de infraestructura hacia Aplicacion.

## Resultado

Los limites transaccionales quedan definidos para:

- operaciones atomicas multi-modulo (wizard, creacion automatica, cascadas),
- invariantes de minimo obligatorio,
- separacion entre ocurrencias calculadas y materializadas,
- y reparto de responsabilidades por capa.

Este documento es base para el siguiente paso de arquitectura: politicas de errores y validaciones por capa (ver `docs/arquitectura/errores-validaciones-capas.md`).
