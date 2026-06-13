# Plan de Documentación Inicial - Planificacion 2.0

**Fecha:** 2026-06-10  
**Vista general (capas, contratos, bootstrap):** [vista-general.md](vista-general.md) — lectura recomendada antes de implementar código.

**Objetivo:** Crear la estructura de documentación completa para el proyecto Planificacion 2.0

## Resumen Ejecutivo

Crear la documentacion fundamental del proyecto Planificacion 2.0, incluyendo README principal, casos de uso, modelos funcionales, diagramas C4, arquitectura logica, modelo entidad-relacion y, como cierre de arquitectura, seleccion de stack tecnologico. El proyecto gestiona planificaciones de proyectos con definiciones de tiempo puntuales, periodicas (diarias, semanales, mensuales) y de tipo "Sin planificar".

## Arquitectura de Componentes

### Jerarquía del Sistema
- **Proyecto**: Contenedor principal identificado por nombre
  - **Item**: Subdivisión de proyecto
    - **Planificación**: Tarea con tipo temporal, estado y observaciones
      - **Puntual** o **Periódica** (Diario / Semanal / Mensual) o **Sin planificar**
      - **Ocurrencia**: Instancia calculada o materializada (planificaciones con fecha)

### Estados de Planificación
- **Pendiente**: No completada y dentro de plazo
- **Completada**: Marcada como finalizada
- **Expirada**: Fecha/hora pasada sin completar

### Tipos de Definición Temporal

#### 1. Puntual
- Fecha y hora específica única

#### 2. Periódica
Con fecha inicio, fecha fin y periodo de repetición:
- **Diaria**: 
  - Todos los días
  - De Lunes a Viernes
  - Fin de semana
- **Semanal**: Lista de uno o más días de la semana (p. ej. martes y jueves)
- **Mensual**: Mismo día cada mes

#### 3. Sin planificar
- Sin fecha asignada (backlog)

## Plan de Implementación

### Fase 1: Estructura Base
**Step 1: Crear README.md principal**
- Documento raíz que define el proyecto, sus objetivos, arquitectura de datos, y componentes principales (Proyecto → Items → Planificaciones)
- Incluir sección de arquitectura con descripción de componentes
- Documentar tipos de planificación (Puntual, Periódica con subtipos, Sin planificar)
- Añadir estado de planificaciones (Completada, Pendiente, Expirada)
- Incluir referencia a la carpeta docs/

**Step 2: Crear estructura docs/** (*parallel con step 1*)
- Carpeta `docs/` en la raíz del proyecto
- Subcarpeta `docs/casos-uso/` para organizar los casos de uso
- Subcarpeta `docs/planificacion/` para documentos de planificación
- Subcarpeta `docs/politicas-transversales/` para politicas globales del proyecto

### Fase 2: Casos de Uso
**Step 3: Generar caso de uso: Crear proyecto, item y planificación** (*depends on 2*)
- Archivo: `docs/casos-uso/UC-01-mantenimiento-proyecto.md`
- Incluir: actores, precondiciones, flujo principal, flujos alternativos
- Diagrama Mermaid de secuencia mostrando interacción usuario → sistema
- Cubrir escenarios de los diferentes tipos de planificación (Puntual, Periódica diaria/semanal/mensual, Sin planificar)

**Step 4: Generar caso de uso: Gestión de ocurrencias** (*depends on 2*)
- Archivo: `docs/casos-uso/UC-02-gestion-ocurrencias.md`
- Incluir: actores, precondiciones, flujo principal (filtros, vista mensual/semanal)
- Diagrama Mermaid de flujo mostrando proceso de visualización
- Considerar cómo mostrar planificaciones periódicas expandidas en el calendario
- Incluir diferenciación visual de estados (pendiente, completada, expirada)

**Step 5: Generar caso de uso: Listar planificaciones de tipo "Sin planificar"** (*depends on 2*)
- Archivo: `docs/casos-uso/UC-03-listar-sin-planificar.md`
- Incluir: actores, precondiciones, flujo principal
- Diagrama Mermaid de flujo mostrando filtrado de planificaciones tipo "Sin planificar"
- Considerar acciones disponibles desde el listado (editar, convertir a planificada)

**Step 6: Crear índice de casos de uso** (*depends on 3, 4, 5*)
- Archivo: `docs/casos-uso/README.md`
- Listar los 3 casos de uso con enlaces y descripción breve
- Tabla resumen con ID, nombre, y prioridad

### Fase 3: Modelos funcionales del dominio
**Step 7: Documentar modelos funcionales** (*depends on 3-6*)
- Archivos:
  - `docs/entidades/planificaciones.md`
  - `docs/entidades/modelo-clases-planificacion.md` (jerarquía de clases; FAQ-112)
  - `docs/entidades/ocurrencias.md`
- Definir estructura funcional del dominio y trazabilidad con casos de uso.

**Step 7b: Documentar entidades Proyecto e Item** (*depends on 3-6*; FAQ-005)
- Archivos:
  - `docs/entidades/proyectos.md`
  - `docs/entidades/items.md`
- Alcance: reglas de unicidad, CRUD funcional, efectos automaticos (item/planificacion al crear proyecto o item).

### Fase 4: Diagramas C4
**Step 8: Documentar diagramas C4 (Niveles 1-4)** (*depends on 3-7*; integrado con arquitectura en Step 9a)
- Carpeta: `docs/diagramas-c4/`
- Archivo indice: `docs/diagramas-c4/README.md`
- Diagramas (Mermaid C4):
  - `docs/diagramas-c4/c4-nivel-1/c4-nivel-1-contexto.mmd` (N1 cerrado)
  - `docs/diagramas-c4/c4-nivel-2/c4-nivel-2-contenedores.mmd` (N2 cerrado)
  - `docs/diagramas-c4/c4-nivel-3/c4-nivel-3-componentes.mmd` (N3 cerrado)
  - N4 canonico: `docs/diagramas-c4/c4-nivel-4/pseudocodigo/` + `zonas-criticas-n4.md` (cerrado)
  - N4 implementacion por componente: `docs/diagramas-c4/c4-nivel-4/implementacion/{componente}/{tecnologia}/` (**cerrado** Step 12)
- Incorporar trazabilidad entre diagramas C4 y casos de uso UC-01, UC-02, UC-03 (ver FAQ-104 en [dudas-y-resoluciones.md](dudas-y-resoluciones.md))

**Step 8b: Diagrama C4 N3 — Front-End** (*depends on 8*; FAQ-103)
- Fichero: `docs/diagramas-c4/c4-nivel-3/c4-nivel-3-componentes-frontend.mmd`
- Zoom de componentes UI (complementa N4 ZC-6).

**Step 8c: Trazabilidad casos de uso ↔ C4** (*depends on 8*; FAQ-104)
- Trazabilidad **distribuida**: cada ZC N4 en `pseudocodigo/zc-*.md` documenta los UCs que la justifican; cada UC referencia las ZC afectadas.
- Sin fichero central.

### Fase 5: Definicion de arquitectura
**Step 9: Definir arquitectura** (*depends on 7, 8*)

**Step 9a: Arquitectura logica y contratos** (*depends on 7, 8*)
- Archivo principal: `docs/arquitectura/README.md`
- Archivos de soporte:
  - `docs/arquitectura/contratos-minimos.md`
  - `docs/arquitectura/granularidad-modulos-negocio.md`
  - `docs/arquitectura/transacciones-consistencia.md`
  - `docs/arquitectura/errores-validaciones-capas.md`
- Alcance:
  - Contratos minimos de puertos e interfaces
  - Granularidad final de modulos de negocio
  - Transacciones y limites de consistencia
  - Politicas de errores y validaciones por capa
  - Referencia cruzada con diagramas C4 (Step 8)

**Step 9b: Verificacion transversal pre-stack** (*depends on 9a*)
- Carpeta: `docs/politicas-transversales/`
- Archivos:
  - `docs/politicas-transversales/revision-principios-solid.md`
  - `docs/politicas-transversales/internacionalizacion.md`
- Alcance:
  - Revision SOLID en toda la documentacion del proyecto
  - Politica de i18n para la implementacion

### Fase 6: Modelo de Datos (ER)
**Step 10: Generar diagrama entidad-relacion** (*depends on 9a, 9b*)
- Archivo principal: `docs/entidades/modelo-entidad-relacion.md`
- Basarse en [dudas-y-resoluciones.md](dudas-y-resoluciones.md) y entidades en `docs/entidades/`.
- Entregables (FAQ):
  - **FAQ-105 / 106 / 108 / 110 / 111:** ERD con `Proyectos`, `Items`, `Planificaciones`, `PlanificacionPeriodo`, `TipoPeriodo` (visibilidad campos patrón), `OcurrenciasMaterializadas`; naturaleza inferida sin flags (sustituye borrador `DefinicionFechaHora`)
  - **FAQ-004:** tabla `OcurrenciasMaterializadas`; alinear seccion de persistencia en `ocurrencias.md`
  - **FAQ-002:** columnas fecha/hora en UTC en el ER; nota en `internacionalizacion.md` (almacenamiento UTC vs formateo en UI)
- Diagrama Mermaid ERD, atributos clave y restricciones (UNIQUE, FK, CHECK segun reglas RP-*, RI-*, RT-*)

### Fase 7: Stack e implementacion N4
**Step 11: Stack tecnologico (cierre de arquitectura)** (*depends on 9a, 9b, 10*) — **Cerrado (2026-06-12)**
- Resultado: criterios y seleccion tecnologica alineada con arquitectura, diagramas C4 y modelo ER.
- Entregables (FAQ):
  - **FAQ-101:** PostgreSQL 16 — [`docs/stack-tecnologico/analisis-inicial.md`](../stack-tecnologico/analisis-inicial.md)
  - **FAQ-102:** NestJS 10 + React 18 + TypeScript 5 + pnpm workspaces
  - **FAQ-007:** politica N4 por componente, desacoplamiento por contratos y desambiguacion de rutas «implementacion»
  - Esqueleto de codigo: [`implementacion/`](../../implementacion/) (por componente y tecnologia)
  - Guias agnosticas (plantillas): [`docs/implementacion/`](../implementacion/)
  - [`desambiguacion-implementacion.md`](../politicas-transversales/desambiguacion-implementacion.md)

**Step 12: N4 implementacion por componente — Opcion B** (*depends on 11*) — **Completado (2026-06-12)**
- Carpetas: `docs/diagramas-c4/c4-nivel-4/implementacion/{componente}/{tecnologia}/`
- Proyeccion ZC-1 a ZC-6; enlaces al pseudocodigo. Indice: [c4-nivel-4/implementacion/README.md](../diagramas-c4/c4-nivel-4/implementacion/README.md).
- Prioridad **1** entre pasos pendientes.

**Step 12b: Practicas de implementacion por componente — Opcion A** (*depends on 11; recomendado tras Step 12*) — **Pendiente**
- Redactar contenido en `docs/implementacion/{front-end,back-end,persistencia,shared,bbdd}/` (convenciones de capas, tests, errores, dependencias).
- Agnostico de tecnologia en la redaccion; enlaces al codigo en `implementacion/` y a N4 del Step 12.
- Prioridad **2** (antes del bootstrap de codigo).

### Fase 8: Cierre documental e implementacion
**Step 13: Validar toda la documentacion** (*depends on 10, 12, 12b*) — **Pendiente**
- Revision de coherencia entre entidades, ER, C4, arquitectura, stack, N4 e implementacion.
- Incluye checklist de [vista-general.md](vista-general.md) §6 (contratos externos e internos antes de codificar negocio).
- Prioridad **3**.

**Step 14: Bootstrap e implementacion tecnica — Opcion C** (*depends on 13*) — **Pendiente**
- Monorepo (pnpm), proyectos Nest/Vite, migraciones en `implementacion/bbdd/postgresql/`, paquete shared.
- Solo andamiaje ejecutable (arranque, DI, migraciones); **sin logica de negocio** hasta validar Step 13. Ver [vista-general.md](vista-general.md) §5.
- Prioridad **4**.

## Archivos a Crear

| Archivo | Descripción |
|---------|-------------|
| `README.md` | Documentación principal del proyecto |
| `docs/casos-uso/UC-01-mantenimiento-proyecto.md` | Caso de uso #1 con diagrama de secuencia |
| `docs/casos-uso/UC-02-gestion-ocurrencias.md` | Caso de uso #2 con diagrama de casos y subcasos |
| `docs/casos-uso/UC-03-listar-sin-planificar.md` | Caso de uso #3 con diagrama de flujo |
| `docs/casos-uso/README.md` | Índice de casos de uso |
| `docs/entidades/planificaciones.md` | Modelo funcional de planificaciones |
| `docs/entidades/ocurrencias.md` | Modelo funcional de ocurrencias |
| `docs/entidades/proyectos.md` | Modelo funcional de proyectos (Step 7b) |
| `docs/entidades/items.md` | Modelo funcional de items (Step 7b) |
| `docs/arquitectura/README.md` | Base de arquitectura logica |
| `docs/arquitectura/contratos-minimos.md` | Contratos logicos minimos de arquitectura |
| `docs/arquitectura/granularidad-modulos-negocio.md` | Granularidad final de modulos de negocio |
| `docs/arquitectura/transacciones-consistencia.md` | Transacciones y limites de consistencia |
| `docs/arquitectura/errores-validaciones-capas.md` | Politicas de errores y validaciones por capa |
| `docs/diagramas-c4/README.md` | Indice de diagramas C4 (N1–N4) |
| `docs/diagramas-c4/c4-nivel-3/c4-nivel-3-componentes.mmd` | C4 N3 componentes Back-End y persistencia |
| `docs/diagramas-c4/c4-nivel-3/c4-nivel-3-componentes-frontend.mmd` | C4 N3 componentes Front-End (Step 8b) |
| `docs/diagramas-c4/c4-nivel-4/zonas-criticas-n4.md` | Zonas criticas y alcance del N4 |
| `docs/diagramas-c4/c4-nivel-4/pseudocodigo/` | N4 canonico por zona critica (ZC-1 a ZC-6) |
| `docs/politicas-transversales/README.md` | Indice de politicas transversales |
| `docs/politicas-transversales/revision-principios-solid.md` | Revision global de cumplimiento SOLID |
| `docs/politicas-transversales/internacionalizacion.md` | Politica transversal de i18n |
| `docs/planificacion/planificacion-inicial.md` | Plan por fases y steps |
| `docs/planificacion/vista-general.md` | Capas, contratos (externo/interno), bootstrap, checklist pre-implementacion |
| `docs/planificacion/dudas-y-resoluciones.md` | FAQ centralizado de dudas, resoluciones y nomenclatura |
| `docs/entidades/modelo-entidad-relacion.md` | Diagrama ERD Mermaid (Step 10) |
| `docs/entidades/modelo-clases-planificacion.md` | Diagrama de clases dominio (FAQ-112) |
| `docs/stack-tecnologico/analisis-inicial.md` | Analisis y seleccion de stack (Step 11) |
| `docs/stack-tecnologico/historial-stack.md` | Stack activo e historial por componente |
| `docs/stack-tecnologico/cambio-tecnologia-componente.md` | Procedimiento `(obsoleto)` y coexistencia paralela |
| `docs/politicas-transversales/desambiguacion-implementacion.md` | Tres rutas «implementacion» (FAQ-007) |
| `docs/politicas-transversales/desacoplamiento-componentes-contratos.md` | Restricciones de desacoplamiento por contratos (FAQ-007) |
| `docs/diagramas-c4/c4-nivel-4/implementacion/` | N4 por componente y tecnologia (Step 12) |
| `docs/implementacion/` | Guias de implementacion por componente (plantillas Step 11; contenido Step 12b) |
| `implementacion/` | Esqueleto de codigo por componente y tecnologia (Step 11) |

## Verificación

1. ✓ README.md contiene todas las secciones necesarias y es comprensible para nuevos desarrolladores
2. ✓ Los 3 casos de uso incluyen diagramas Mermaid que se renderizan correctamente
3. ✓ Los casos de uso estan documentados y trazables
4. ✓ Los modelos funcionales del dominio estan documentados y trazables con casos de uso
5. ✓ Los diagramas C4 estan documentados (Step 8) e integrados con arquitectura (Step 9a)
6. ✓ La arquitectura logica se documenta en su README y archivos de soporte (Step 9a)
7. [x] El diagrama entidad-relacion representa todas las entidades y relaciones descritas (Step 10)
8. [x] El stack tecnologico se define al cierre de arquitectura (Step 11; FAQ-101, 102, 007)
9. ✓ La estructura de carpetas docs/ facilita la organizacion y escalabilidad futura
10. ✓ Todos los tipos de planificacion estan cubiertos (Puntual, Diaria, Semanal, Mensual, Sin planificar)

## Decisiones Tomadas

### Idioma
Toda la documentación se creará en español para mantener consistencia con el contexto del proyecto.

### Formato de Casos de Uso
Se utilizará formato estándar con secciones: Actores, Precondiciones, Flujo Principal, Flujos Alternativos, Postcondiciones.

### Diagramas Mermaid
- Diagramas de secuencia para flujos de creación
- Diagramas de flujo para visualización/consultas

### Modelo de Datos
Modelo ER unificado (`Planificaciones` + `PlanificacionPeriodo`, catálogo `TipoPeriodo`). Ver [dudas-y-resoluciones.md](dudas-y-resoluciones.md) (FAQ-105–116) y [modelo-entidad-relacion.md](../entidades/modelo-entidad-relacion.md).

### Estados de Planificación
Se consideran 3 estados (Pendiente, Completada, Expirada) donde "Expirada" se calcula dinámicamente según fecha actual vs. fecha planificada.

## Dudas y resoluciones

Las preguntas abiertas, decisiones tomadas y cambios de nomenclatura se centralizan en **[dudas-y-resoluciones.md](dudas-y-resoluciones.md)** (FAQ).

Resumen de estado (2026-06-12):

- **Resueltas:** FAQ-001 a FAQ-009, FAQ-103, FAQ-104, FAQ-105 a FAQ-116, **FAQ-007, FAQ-101, FAQ-102** (Step 11).
- **Steps cerrados:** 1–12 (documentacion + stack + N4 implementacion por componente).
- **Pendientes (orden de prioridad):** Step 12b (Opcion **A**), Step 13, Step 14 (Opcion **C**). Ver tabla en [dudas-y-resoluciones.md](dudas-y-resoluciones.md#pendientes-de-ejecutar).

## Próximos Pasos

[x] 1. Revisar y aprobar este plan
[x] 2. Ejecutar Fase 1: Crear estructura base y README
[x] 3. Ejecutar Fase 2: Documentar casos de uso
[x] 4. Ejecutar Fase 3: Documentar modelos funcionales del dominio (Step 7)
[x] 5. Ejecutar Step 7b: Documentar entidades Proyecto e Item (FAQ-005)
[x] 6. Ejecutar Fase 4 parcial: Diagramas C4 N1–N4 canonico (Step 8)
[x] 7. Ejecutar Step 8c: Trazabilidad UC ↔ C4 distribuida (FAQ-104)
[x] 8. Ejecutar Step 8b: Diagrama C4 N3 Front-End (FAQ-103)
[x] 9. Ejecutar Fase 5 : Arquitectura logica y verificacion transversal (Steps 9a, 9b)
[x] 10. Ejecutar Step 10: Crear modelo entidad-relacion (ER)
[x] 11. Ejecutar Step 11: Definir stack tecnologico (FAQ-101, FAQ-102, FAQ-007)
[x] 12. Ejecutar Step 12 — **Opcion B:** N4 implementacion por componente (`{componente}/{tecnologia}/`)
[ ] 12b. Ejecutar Step 12b — **Opcion A:** Practicas en `docs/implementacion/{componente}/`
[ ] 13. Ejecutar Step 13: Validar toda la documentacion
[ ] 14. Ejecutar Step 14 — **Opcion C:** Bootstrap monorepo y proyectos en `implementacion/`

## Historial
2026-06-10 - Paso 1 Completado
2026-06-10 - Paso 2 Completado
2026-06-10 - Paso 3 Completado
2026-06-11 - Plan reajustado: se agrega fase intermedia de modelos funcionales
2026-06-11 - Orden fijado: arquitectura -> modelo ER -> stack tecnologico
2026-06-11 - Arquitectura: granularidad final de modulos de negocio definida
2026-06-12 - Arquitectura: granularidad completada (agregados, sub-UCs, orquestacion) y transacciones definidas
2026-06-12 - Arquitectura: politicas de errores y validaciones por capa definidas
2026-06-12 - Verificacion transversal: revision SOLID global e i18n reubicados en docs/politicas-transversales/
2026-06-12 - Plan: Step 9 unificado con sub-pasos 9a y 9b; stack desacoplado como Step 11
2026-06-12 - Diagramas C4 (Step 8) e integracion con arquitectura (Step 9a); N4 canonico cerrado
2026-06-12 - Plan corregido: indices duplicados resueltos — Step 7 modelos funcionales, Step 8 diagramas C4 (ambos pasos conservados)
2026-06-12 - Revision SOLID actualizada incluyendo docs/diagramas-c4/
2026-06-12 - Limpieza plan y FAQ: entregables Step 10/11; verificacion 7-8 corregida
2026-06-12 - Step 10 completado: modelo ER en docs/entidades/modelo-entidad-relacion.md
2026-06-12 - Step 11 completado: stack NestJS+React+TS+PostgreSQL; FAQ-007/101/102; implementacion/ y docs/implementacion/
2026-06-12 - Step 12 completado: N4 implementacion por componente (react-typescript, nestjs-typescript, typescript, postgresql)
