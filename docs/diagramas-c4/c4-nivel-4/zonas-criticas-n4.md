# Zonas criticas para C4 Nivel 4

Define que componentes del [Nivel 3](../c4-nivel-3/c4-nivel-3-componentes.mmd) merecen un diagrama N4 (detalle interno) y con que alcance funcional.

## Politica N4

El N4 se documenta en dos capas:

| Capa | Ubicacion | Rol |
|------|-----------|-----|
| **Canonico** | [pseudocodigo/](pseudocodigo/) | Estructura logica + pseudocodigo; independiente del stack |
| **Implementacion** | [implementacion/](implementacion/) | Proyeccion por componente y tecnologia ([T-000#S-12a](../../../backlog/000-planificacion-inicial/planificacion-inicial.md)) |

El pseudocodigo es la fuente de verdad funcional. Si cambia la tecnologia de un componente, se actualiza solo su carpeta en [implementacion/](implementacion/) a partir del mismo canonico, sin redefinir las zonas criticas ni las reglas de negocio.

**Trazabilidad (FAQ-201):** cada ZC N4 documenta los casos de uso que la justifican; cada UC referencia las ZC afectadas. No hay fichero central de correspondencias.

## Criterios de seleccion

Una zona es critica para N4 si cumple al menos uno de estos criterios:

1. **Complejidad de negocio:** reglas no evidentes en el N3 (calculo dinamico, materializacion, cambios de tipo).
2. **Coordinacion multi-componente:** operacion atomica que cruza varios agregados del N3.
3. **Riesgo de acoplamiento:** frontera entre capas o entre calculo y persistencia poco clara en el N3.
4. **Trazabilidad densa:** varios sub-casos de uso convergen en el mismo componente.

No se diagraman en N4 los agregados con CRUD directo y reglas simples si el N3 ya es suficiente.

## Zonas criticas

### ZC-1: Consulta y calculo de ocurrencias

| Atributo | Valor |
|----------|-------|
| Componente N3 | `Ocurrencia`, `Planificacion` (lectura) |
| Contenedor | Back-End |
| Prioridad | Alta |

**Motivo:** las ocurrencias naturales se calculan en lectura (RO-1); la consulta en rango combina calculo dinamico con materializaciones y precedencia (RO-3). Es la logica mas compleja del sistema.

**Casos de uso:** UC-02.1, UC-02.3 (lectura previa), UC-02.4 (consulta de fisicas).

**Alcance N4:**

- Motor de calculo por tipo (puntual, periodica); generacion incremental excluyendo fechas ya materializadas.
- Composicion fisicas + naturales pendientes (RO-3), sin doble calculo previo.
- Resolucion de estado efectivo (RO-7) y estado expirado calculado.

**Fuente de reglas:** `docs/entidades/ocurrencias.md`  
**N4 canonico:** [pseudocodigo/zc-1-consulta-ocurrencias.md](pseudocodigo/zc-1-consulta-ocurrencias.md)

---

### ZC-2: Materializacion y mutacion de ocurrencias

| Atributo | Valor |
|----------|-------|
| Componente N3 | `Ocurrencia` |
| Contenedor | Back-End |
| Prioridad | Alta |

**Motivo:** escritura sobre ocurrencias con reglas distintas segun tipo puntual vs periodico; materializacion solo bajo modificacion individual (RO-2).

**Casos de uso:** UC-02.2 (puntual = actualiza planificacion), UC-02.3, UC-02.4.

**Alcance N4:**

- Transiciones de estado operativo (completar, reabrir).
- Registro de modificacion individual y eliminacion virtual (RO-4).
- Vinculo fecha original al cambiar fecha (RO-5).

**Fuente de reglas:** `docs/entidades/ocurrencias.md`  
**N4 canonico:** [pseudocodigo/zc-2-materializacion-ocurrencias.md](pseudocodigo/zc-2-materializacion-ocurrencias.md)

---

### ZC-3: Definicion temporal y ciclo de vida de planificaciones

| Atributo | Valor |
|----------|-------|
| Componente N3 | `Planificacion` |
| Contenedor | Back-End |
| Prioridad | Alta |

**Motivo:** multiples tipos y subtipos (puntual, periodica diaria/semanal/mensual, Sin planificar), reglas de configuracion (RC-*) y restricciones de cambio de tipo (RT-*).

**Casos de uso:** UC-01.4, UC-01.5 (validacion), UC-03 (lectura Sin planificar).

**Alcance N4:**

- Value objects de definicion temporal por variante.
- Validacion de catalogo comun (RC-1, RC-2, RC-3).
- Aplicacion de reglas de cambio de tipo (RT-1 a RT-5).

**Fuente de reglas:** `docs/entidades/planificaciones.md`  
**N4 canonico:** [pseudocodigo/zc-3-planificacion-temporal.md](pseudocodigo/zc-3-planificacion-temporal.md)

---

### ZC-4: Orquestacion multi-agregado (aplicacion)

| Atributo | Valor |
|----------|-------|
| Componente N3 | `API REST` + coordinadores (no explicitos en N3) |
| Contenedor | Back-End |
| Prioridad | Media-alta |

**Motivo:** flujos que cruzan Proyecto, Item y Planificacion en una unica transaccion; el N3 muestra agregados aislados pero no la orquestacion.

**Casos de uso:** UC-01.1 (wizard atomico), UC-01.2 (crear proyecto + item + planificacion automatica), UC-01.3 (crear item + planificacion automatica).

**Alcance N4:**

- Orquestador de wizard (confirmar o cancelar sin persistir).
- Coordinacion de creacion automatica acoplada.
- Delimitacion de unidad transaccional y rollback.

**Nota:** los agregados `Proyecto` e `Item` en N3 no requieren N4 propio; su complejidad es CRUD con reglas de unicidad y se cubre via esta zona.  
**N4 canonico:** [pseudocodigo/zc-4-orquestacion-aplicacion.md](pseudocodigo/zc-4-orquestacion-aplicacion.md)

---

### ZC-5: Persistencia y adaptadores

| Atributo | Valor |
|----------|-------|
| Componente N3 | `Puerto de Persistencia`, `Adaptador de Persistencia`, `Puerto de Conexion a BBDD` |
| Contenedor | Capa de Persistencia |
| Prioridad | Media-alta |

**Motivo:** desacoplamiento del motor SQL, repositorios por agregado, consultas de lectura complejas (ocurrencias en rango) y cascadas en eliminacion.

**Casos de uso:** todos los de escritura UC-01.* y UC-02.*; lecturas UC-02.1, UC-03.

**Alcance N4:**

- Adaptadores por agregado (Proyecto, Item, Planificacion, Ocurrencia).
- Adaptador de consulta de ocurrencias en rango (lectura ZC-1).
- Implementacion de transaccion via puerto de conexion.
- Mapeo de errores tecnicos hacia capa de aplicacion.

**N4 canonico:** [pseudocodigo/zc-5-persistencia.md](pseudocodigo/zc-5-persistencia.md)

---

### ZC-6: Presentacion — captura y calendario

| Atributo | Valor |
|----------|-------|
| Componente N3 | `Front-End` |
| Contenedor | Front-End |
| Prioridad | Media |

**Motivo:** componente reutilizable UC-01.5 y vista de calendario UC-02.1 concentran logica de UI y validacion local con alta reutilizacion.

**Casos de uso:** UC-01.1, UC-01.4 (via UC-01.5), UC-02.1.

**Alcance N4:**

- Componente de captura de planificacion (formulario por tipo/subtipo).
- Vista de calendario y filtros de rango.
- Resolucion de mensajes al usuario en cliente.

**Nota:** N4 de presentacion es opcional en una primera iteracion; las zonas ZC-1 a ZC-5 del Back-End tienen prioridad.  
**N3 Front-End:** [c4-nivel-3-componentes-frontend.mmd](../c4-nivel-3/c4-nivel-3-componentes-frontend.mmd) (zoom de componentes UI; [T-000#S-8b](../../../backlog/000-planificacion-inicial/planificacion-inicial.md)).  
**N4 canonico:** [pseudocodigo/zc-6-presentacion.md](pseudocodigo/zc-6-presentacion.md)

## Componentes N3 excluidos de N4

| Componente N3 | Motivo de exclusion |
|---------------|---------------------|
| `Proyecto` | CRUD y unicidad de nombre; sin logica interna compleja |
| `Item` | CRUD, unicidad por proyecto, reglas de minimo; cubierto por ZC-4 y ZC-5 |
| `Adaptador Motor SQL` | Detalle de driver concreto; pertenece a la implementacion de ZC-5 |

## Dependencias entre zonas

| Zona | Depende de |
|------|------------|
| ZC-1 | ZC-3 |
| ZC-2 | ZC-1 |
| ZC-3 | — |
| ZC-4 | ZC-3, ZC-5 |
| ZC-5 | — |
| ZC-6 | — |

## Resultado

Quedan definidas **6 zonas criticas** (5 Back-End/Persistencia prioritarias + 1 Presentacion opcional). Cada una tiene su **N4 canonico en pseudocodigo** en [pseudocodigo/](pseudocodigo/). La proyeccion por componente esta en [implementacion/](implementacion/) ([T-000#S-12a](../../../backlog/000-planificacion-inicial/planificacion-inicial.md)).
