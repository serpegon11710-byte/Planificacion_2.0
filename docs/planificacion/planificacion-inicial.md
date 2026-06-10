# Plan de Documentación Inicial - Planificacion 2.0

**Fecha:** 2026-06-10
**Objetivo:** Crear la estructura de documentación completa para el proyecto Planificacion 2.0

## Resumen Ejecutivo

Crear la documentación fundamental del proyecto Planificacion 2.0, incluyendo README principal, casos de uso con diagramas Mermaid, y diagrama entidad-relación. El proyecto gestiona planificaciones de proyectos con definiciones de tiempo puntuales, periódicas (diarias, semanales, mensuales) y de tipo "No planificado".

## Arquitectura de Componentes

### Jerarquía del Sistema
- **Proyecto**: Contenedor principal identificado por nombre
  - **Item**: Subdivisión de proyecto
    - **Planificación**: Tarea con definición temporal y estado
      - **Definición Fecha/Hora**: Especificación temporal (Puntual, Periódica, No planificado)

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

#### 3. No planificado
- Sin fecha asignada (backlog)

## Plan de Implementación

### Fase 1: Estructura Base
**Step 1: Crear README.md principal**
- Documento raíz que define el proyecto, sus objetivos, arquitectura de datos, y componentes principales (Proyecto → Items → Planificaciones)
- Incluir sección de arquitectura con descripción de componentes
- Documentar tipos de planificación (Puntual, Periódica con subtipos, No planificado)
- Añadir estado de planificaciones (Completada, Pendiente, Expirada)
- Incluir referencia a la carpeta docs/

**Step 2: Crear estructura docs/** (*parallel con step 1*)
- Carpeta `docs/` en la raíz del proyecto
- Subcarpeta `docs/casos-uso/` para organizar los casos de uso
- Subcarpeta `docs/planificacion/` para documentos de planificación

### Fase 2: Casos de Uso
**Step 3: Generar caso de uso: Crear proyecto, item y planificación** (*depends on 2*)
- Archivo: `docs/casos-uso/UC-01-mantenimiento-proyecto.md`
- Incluir: actores, precondiciones, flujo principal, flujos alternativos
- Diagrama Mermaid de secuencia mostrando interacción usuario → sistema
- Cubrir escenarios de los diferentes tipos de planificación (Puntual, Periódica diaria/semanal/mensual, No planificado)

**Step 4: Generar caso de uso: Gestión de ocurrencias** (*depends on 2*)
- Archivo: `docs/casos-uso/UC-02-gestion-ocurrencias.md`
- Incluir: actores, precondiciones, flujo principal (filtros, vista mensual/semanal)
- Diagrama Mermaid de flujo mostrando proceso de visualización
- Considerar cómo mostrar planificaciones periódicas expandidas en el calendario
- Incluir diferenciación visual de estados (pendiente, completada, expirada)

**Step 5: Generar caso de uso: Listar planificaciones de tipo "No planificado"** (*depends on 2*)
- Archivo: `docs/casos-uso/UC-03-listar-no-planificado.md`
- Incluir: actores, precondiciones, flujo principal
- Diagrama Mermaid de flujo mostrando filtrado de planificaciones tipo "No planificado"
- Considerar acciones disponibles desde el listado (editar, convertir a planificada)

**Step 6: Crear índice de casos de uso** (*depends on 3, 4, 5*)
- Archivo: `docs/casos-uso/README.md`
- Listar los 3 casos de uso con enlaces y descripción breve
- Tabla resumen con ID, nombre, y prioridad

### Fase 3: Modelo de Datos
**Step 7: Generar diagrama entidad-relación** (*parallel con steps 3-6*)
- Archivo: `docs/modelo-entidad-relacion.md`
- Diagrama Mermaid ERD mostrando entidades:
  - **Proyecto** (id, nombre, fecha_creacion)
  - **Item** (id, proyecto_id, nombre, descripcion)
  - **Planificacion** (id, item_id, observaciones, estado, fecha_completado)
  - **DefinicionFechaHora** (id, planificacion_id, tipo, fecha_hora, fecha_inicio, fecha_fin, periodo, dias_semana, hora)
- Relaciones: 
  - Proyecto 1:N Item
  - Item 1:N Planificacion
  - Planificacion 1:1 DefinicionFechaHora
- Incluir descripción de atributos clave y restricciones

## Archivos a Crear

| Archivo | Descripción |
|---------|-------------|
| `README.md` | Documentación principal del proyecto |
| `docs/casos-uso/UC-01-mantenimiento-proyecto.md` | Caso de uso #1 con diagrama de secuencia |
| `docs/casos-uso/UC-02-gestion-ocurrencias.md` | Caso de uso #2 con diagrama de casos y subcasos |
| `docs/casos-uso/UC-03-listar-no-planificado.md` | Caso de uso #3 con diagrama de flujo |
| `docs/casos-uso/README.md` | Índice de casos de uso |
| `docs/modelo-entidad-relacion.md` | Diagrama ERD con modelo de datos |

## Verificación

1. ✓ README.md contiene todas las secciones necesarias y es comprensible para nuevos desarrolladores
2. ✓ Los 3 casos de uso incluyen diagramas Mermaid que se renderizan correctamente
3. ✓ El diagrama entidad-relación representa todas las entidades y relaciones descritas
4. ✓ La estructura de carpetas docs/ facilita la organización y escalabilidad futura
5. ✓ Todos los tipos de planificación están cubiertos (Puntual, Diaria, Semanal, Mensual, No planificado)

## Decisiones Tomadas

### Idioma
Toda la documentación se creará en español para mantener consistencia con el contexto del proyecto.

### Formato de Casos de Uso
Se utilizará formato estándar con secciones: Actores, Precondiciones, Flujo Principal, Flujos Alternativos, Postcondiciones.

### Diagramas Mermaid
- Diagramas de secuencia para flujos de creación
- Diagramas de flujo para visualización/consultas

### Modelo de Datos
Se propone separar DefinicionFechaHora como entidad independiente para permitir flexibilidad en tipos de planificación.

### Estados de Planificación
Se consideran 3 estados (Pendiente, Completada, Expirada) donde "Expirada" se calcula dinámicamente según fecha actual vs. fecha planificada.

## Consideraciones Pendientes

### 1. Nivel de detalle en periodos diarios
**Pregunta:** ¿Los periodos "De Lunes a Viernes" y "Fin de semana" deben modelarse como atributos separados o como una lista de días de la semana?

**Recomendación:** Usar una lista flexible (días_semana: [1,2,3,4,5] para L-V) para mayor extensibilidad.

### 2. Gestión de zona horaria
**Pregunta:** ¿Las fechas/horas deben considerar zonas horarias o se asume una única zona horaria para todo el sistema?

**Recomendación:** Definir esto ahora para el modelo de datos.

### 3. Completado de planificaciones periódicas
**Pregunta:** ¿Se marca como completada una instancia específica de una planificación periódica o la planificación completa?

**Recomendación:** Aclarar si se necesita una entidad adicional "InstanciaPlanificacion" para trackear ocurrencias individuales.

## Próximos Pasos

[x] 1. Revisar y aprobar este plan
[x] 2. Ejecutar Fase 1: Crear estructura base y README
[ ] 3. Ejecutar Fase 2: Documentar casos de uso
[ ] 4. Ejecutar Fase 3: Crear modelo entidad-relación
[ ] 5. Validar toda la documentación
[ ] 6. Proceder con la implementación técnica

## Historial
2026-06-10 - Paso 1 Completado
2026-06-10 - Paso 2 Completado