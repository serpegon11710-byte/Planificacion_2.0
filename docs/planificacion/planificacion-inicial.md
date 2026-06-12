# Plan de Documentación Inicial - Planificacion 2.0

**Fecha:** 2026-06-10
**Objetivo:** Crear la estructura de documentación completa para el proyecto Planificacion 2.0

## Resumen Ejecutivo

Crear la documentacion fundamental del proyecto Planificacion 2.0, incluyendo README principal, casos de uso, modelos funcionales, diagramas C4, arquitectura logica y, como cierre de arquitectura, seleccion de stack tecnologico antes de definir el modelo entidad-relacion. El proyecto gestiona planificaciones de proyectos con definiciones de tiempo puntuales, periodicas (diarias, semanales, mensuales) y de tipo "Sin planificar".

## Arquitectura de Componentes

### Jerarquía del Sistema
- **Proyecto**: Contenedor principal identificado por nombre
  - **Item**: Subdivisión de proyecto
    - **Planificación**: Tarea con definición temporal y estado
      - **Definición Fecha/Hora**: Especificación temporal (Puntual, Periódica, Sin planificar)

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
- **Semanal**: Mismo día cada semana
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
  - N4 implementacion por stack: `docs/diagramas-c4/c4-nivel-4/implementacion/` (pendiente hasta Step 9c)
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

**Step 9c: Stack tecnologico (cierre de arquitectura)** (*depends on 9a, 9b*)
- Resultado: criterios y seleccion tecnologica alineada con arquitectura y diagramas C4.

### Fase 6: Modelo de Datos (ER)
**Step 10: Generar diagrama entidad-relación** (*depends on 9*)
- Archivo: `docs/modelo-entidad-relacion.md`
- Basarse en [dudas-y-resoluciones.md](dudas-y-resoluciones.md) (FAQ-004 a FAQ-108) y [planificaciones.md](../entidades/planificaciones.md).
- Entidades principales (orientativo; detalle en FAQ-105/106/108):
  - **Proyecto**, **Item**
  - **TipoPlanificacion** (catalogo: Puntual, SinPlanificar, Diario, Semanal, Mensual)
  - **PlanificacionesPuntuales** (`sin_planificar`, fecha, hora)
  - **PlanificacionesPeriodicas** (fecha_inicio, fecha_fin, hora, patron)
  - **Ocurrencias** materializadas (FAQ-004)

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
| `docs/planificacion/dudas-y-resoluciones.md` | FAQ centralizado de dudas, resoluciones y nomenclatura |
| `docs/modelo-entidad-relacion.md` | Diagrama ERD con modelo de datos |

## Verificación

1. ✓ README.md contiene todas las secciones necesarias y es comprensible para nuevos desarrolladores
2. ✓ Los 3 casos de uso incluyen diagramas Mermaid que se renderizan correctamente
3. ✓ Los casos de uso estan documentados y trazables
4. ✓ Los modelos funcionales del dominio estan documentados y trazables con casos de uso
5. ✓ Los diagramas C4 estan documentados (Step 8) e integrados con arquitectura (Step 9a)
6. ✓ La arquitectura logica se documenta en su README y archivos de soporte (Step 9a)
7. ✓ El stack tecnologico se define al cierre de arquitectura (Step 9c)
8. ✓ El diagrama entidad-relacion representa todas las entidades y relaciones descritas
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
Modelo ER segun FAQ-105/106/108: dos tablas de planificacion + catalogo de tipos. Ver [dudas-y-resoluciones.md](dudas-y-resoluciones.md) y [planificaciones.md](../entidades/planificaciones.md).

### Estados de Planificación
Se consideran 3 estados (Pendiente, Completada, Expirada) donde "Expirada" se calcula dinámicamente según fecha actual vs. fecha planificada.

## Dudas y resoluciones

Las preguntas abiertas, decisiones tomadas y cambios de nomenclatura se centralizan en **[dudas-y-resoluciones.md](dudas-y-resoluciones.md)** (FAQ).

Resumen de estado (2026-06-12):

- **Resueltas:** FAQ-001 a FAQ-009, FAQ-104 a FAQ-108 (ver FAQ).
- **Pendientes de ejecutar:** ninguno en diagramas C4 (Step 8b cerrado).
- **Postergadas:** FAQ-101, FAQ-102 (Step 9c).

## Próximos Pasos

[x] 1. Revisar y aprobar este plan
[x] 2. Ejecutar Fase 1: Crear estructura base y README
[x] 3. Ejecutar Fase 2: Documentar casos de uso
[x] 4. Ejecutar Fase 3: Documentar modelos funcionales del dominio (Step 7)
[x] 5. Ejecutar Step 7b: Documentar entidades Proyecto e Item (FAQ-005)
[x] 6. Ejecutar Fase 4 parcial: Diagramas C4 N1–N4 canonico (Step 8)
[x] 7. Ejecutar Step 8c: Trazabilidad UC ↔ C4 distribuida (FAQ-104)
[x] 8. Ejecutar Step 8b: Diagrama C4 N3 Front-End (FAQ-103)
[x] 9. Ejecutar Fase 5 parcial: Arquitectura logica y verificacion transversal (Steps 9a, 9b)
[ ] 10. Ejecutar Step 9c: Definir stack tecnologico (FAQ-101, FAQ-102)
[ ] 11. Completar N4 implementacion por stack (depende de 9c)
[ ] 12. Ejecutar Fase 6: Crear modelo entidad-relacion (Step 10)
[ ] 13. Validar toda la documentacion
[ ] 14. Proceder con la implementacion tecnica

## Historial
2026-06-10 - Paso 1 Completado
2026-06-10 - Paso 2 Completado
2026-06-10 - Paso 3 Completado
2026-06-11 - Plan reajustado: se agrega fase intermedia de modelos funcionales
2026-06-11 - Orden fijado: arquitectura -> stack tecnologico -> modelo ER
2026-06-11 - Arquitectura: granularidad final de modulos de negocio definida
2026-06-12 - Arquitectura: granularidad completada (agregados, sub-UCs, orquestacion) y transacciones definidas
2026-06-12 - Arquitectura: politicas de errores y validaciones por capa definidas
2026-06-12 - Verificacion transversal: revision SOLID global e i18n reubicados en docs/politicas-transversales/
2026-06-12 - Plan: Step 9 unificado con sub-pasos 9a, 9b y 9c; Step 10 renumerado (ER)
2026-06-12 - Diagramas C4 (Step 8) e integracion con arquitectura (Step 9a); N4 canonico cerrado
2026-06-12 - Plan corregido: indices duplicados resueltos — Step 7 modelos funcionales, Step 8 diagramas C4 (ambos pasos conservados)
2026-06-12 - Revision SOLID actualizada incluyendo docs/diagramas-c4/
2026-06-12 - Step 8b completado: diagrama N3 Front-End (FAQ-103)
