# Casos de Uso - Planificacion 2.0

Este documento contiene el índice de todos los casos de uso del sistema Planificacion 2.0.

## Índice de Casos de Uso

| ID | Nombre | Descripción | Prioridad |
|----|--------|-------------|-----------|
| UC-01 | [Mantenimiento de Proyecto](UC-01-mantenimiento-proyecto.md) | Gestión completa del ciclo de vida de proyectos, items y planificaciones | Alta |
| UC-02 | [Gestión de Ocurrencias](UC-02-gestion-ocurrencias.md) | Gestión funcional de ocurrencias planificadas, con operaciones individuales puntuales/periódicas y gestión por planificación | Alta |
| UC-03 | [Visualización de Planificaciones de Tipo "Sin planificar"](UC-03-listar-sin-planificar.md) | Recupera y lista planificaciones de tipo "Sin planificar" | Media |

### Sub-Casos de Uso UC-01

| ID | Nombre | Descripción | Tipo |
|----|--------|-------------|------|
| UC-01.1 | [Wizard Creación de Proyecto](UC-01.1-wizard-creacion-proyecto.md) | Flujo guiado para crear proyecto completo en una sesión | Wizard |
| UC-01.2 | [Creación/Configuración Proyecto](UC-01.2-gestion-proyecto.md) | Gestión manual de proyectos (crear, editar, eliminar) | Manual |
| UC-01.3 | [Creación/Configuración Item](UC-01.3-gestion-item.md) | Gestión manual de items dentro de proyectos | Manual |
| UC-01.4 | [Gestión Planificación](UC-01.4-gestion-planificacion.md) | Gestión completa de planificaciones (persistencia en BD) | Manual |
| UC-01.5 | [Captura Datos de Planificación](UC-01.5-captura-datos-planificacion.md) | Componente reutilizable para capturar/validar datos (NO persiste) | Componente |

### Sub-Casos de Uso UC-02

| ID | Nombre | Descripción | Tipo |
|----|--------|-------------|------|
| UC-02.1 | [Visualización de Ocurrencias Planificadas](UC-02.1-visualizacion-ocurrencias.md) | Consulta por rango de ocurrencias de planificaciones planificadas | Consulta |
| UC-02.2 | [Gestión Individual de Planificación Puntual](UC-02.2-gestion-individual-planificacion-puntual.md) | Modificación individual para tipo puntual, con actualización directa de la planificación | Operación |
| UC-02.3 | [Gestión Individual de Ocurrencias Periódicas](UC-02.3-gestion-individual-ocurrencias-periodicas.md) | Modificación de ocurrencias periódicas, con materialización física cuando aplique | Operación |
| UC-02.4 | [Gestión de Ocurrencias por Planificación](UC-02.4-gestion-ocurrencias-por-planificacion.md) | Gestión de ocurrencias físicas de una planificación (modificadas y eliminadas) | Operación |

## Casos de Uso por Prioridad

### Alta Prioridad
- **UC-01**: Mantenimiento de Proyecto
  - **UC-01.1**: Wizard Creación de Proyecto
  - **UC-01.2**: Creación/Configuración Proyecto
  - **UC-01.3**: Creación/Configuración Item
  - **UC-01.4**: Gestión Planificación
  - **UC-01.5**: Captura Datos de Planificación
- **UC-02**: Gestión de Ocurrencias
  - **UC-02.1**: Visualización de Ocurrencias Planificadas
  - **UC-02.2**: Gestión Individual de Planificación Puntual
  - **UC-02.3**: Gestión Individual de Ocurrencias Periódicas
  - **UC-02.4**: Gestión de Ocurrencias por Planificación

### Media Prioridad
## Descripción General

### UC-01: Mantenimiento de Proyecto
Caso de uso principal que engloba toda la gestión de proyectos, items y planificaciones. Se divide en dos modalidades:

**Modalidad Wizard (UC-01.1):** Flujo guiado para usuarios que desean crear un proyecto completo rápidamente. Invoca UC-01.5 para capturar configuración de planificación.

**Modalidad Manual (UC-01.2, UC-01.3, UC-01.4):** Gestión detallada por capas:
- **UC-01.2:** Gestión de proyectos (al crear proyecto → se crea item automático + planificación)
- **UC-01.3:** Gestión de items (al crear item → se crea planificación automática)
- **UC-01.4:** Gestión de planificaciones (invoca UC-01.5 para captura, luego persiste en BD)

**Componente Reutilizable (UC-01.5):** Captura y valida datos de planificación sin persistir. Usado por UC-01.1 y UC-01.4.

Este es el caso de uso más complejo del sistema. UC-01.5 concentra la definición de tipos/subtipos y la captura/validación de configuración, mientras UC-01.4 persiste la planificación base. UC-01.5 garantiza interfaz consistente para configuración.

### UC-02: Gestión de Ocurrencias
Define la gestión funcional mediante cuatro subcasos: visualización de ocurrencias planificadas, gestión individual puntual, gestión individual periódica y gestión de ocurrencias físicas por planificación.

### UC-03: Visualización de Planificaciones de Tipo "Sin planificar"
Proporciona al usuario una vista de todas las planificaciones que no tienen fecha asignada, facilitando la gestión del backlog y la posterior programación de tareas.

---

**Última actualización:** 2026-06-10
