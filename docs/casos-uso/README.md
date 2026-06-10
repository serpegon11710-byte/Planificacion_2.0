# Casos de Uso - Planificacion 2.0

Este documento contiene el índice de todos los casos de uso del sistema Planificacion 2.0.

## Índice de Casos de Uso

| ID | Nombre | Descripción | Prioridad |
|----|--------|-------------|-----------|
| UC-01 | [Mantenimiento de Proyecto](UC-01-mantenimiento-proyecto.md) | Gestión completa del ciclo de vida de proyectos, items y planificaciones | Alta |
| UC-02 | [Visualizar Calendario de Planificaciones](UC-02-visualizar-calendario.md) | Permite al usuario consultar un calendario visual con todas sus planificaciones organizadas | Alta |
| UC-03 | [Listar Planificaciones de tipo "No planificado"](UC-03-listar-no-planificado.md) | Permite al usuario obtener un listado de todas las planificaciones marcadas como "No planificado" | Media |

### Sub-Casos de Uso UC-01

| ID | Nombre | Descripción | Tipo |
|----|--------|-------------|------|
| UC-01.1 | [Wizard Creación de Proyecto](UC-01.1-wizard-creacion-proyecto.md) | Flujo guiado para crear proyecto completo en una sesión | Wizard |
| UC-01.2 | [Creación/Configuración Proyecto](UC-01.2-gestion-proyecto.md) | Gestión manual de proyectos (crear, editar, eliminar) | Manual |
| UC-01.3 | [Creación/Configuración Item](UC-01.3-gestion-item.md) | Gestión manual de items dentro de proyectos | Manual |
| UC-01.4 | [Gestión Planificación](UC-01.4-gestion-planificacion.md) | Gestión completa de planificaciones (persistencia en BD) | Manual |
| UC-01.5 | [Captura Datos de Planificación](UC-01.5-captura-datos-planificacion.md) | Componente reutilizable para capturar/validar datos (NO persiste) | Componente |

## Casos de Uso por Prioridad

### Alta Prioridad
- **UC-01**: Mantenimiento de Proyecto
  - **UC-01.1**: Wizard Creación de Proyecto
  - **UC-01.2**: Creación/Configuración Proyecto
  - **UC-01.3**: Creación/Configuración Item
  - **UC-01.4**: Gestión Planificación
  - **UC-01.5**: Captura Datos de Planificación
- **UC-02**: Visualizar Calendario de Planificaciones

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

### UC-02: Visualizar Calendario de Planificaciones
Permite al usuario visualizar todas sus planificaciones en un formato de calendario. El sistema expande las planificaciones periódicas para mostrar cada ocurrencia y diferencia visualmente los estados (pendiente, completada, expirada).

### UC-03: Listar Planificaciones de tipo "No planificado"
Proporciona al usuario una vista de todas las planificaciones que no tienen fecha asignada, facilitando la gestión del backlog y la posterior programación de tareas.

---

**Última actualización:** 2026-06-10
