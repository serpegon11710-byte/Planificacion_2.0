# Planificacion 2.0

Sistema de gestión y seguimiento de planificaciones para proyectos con soporte para tareas puntuales, periódicas y sin planificar.

## ¿Qué es Planificacion 2.0?

Planificacion 2.0 te permite organizar y dar seguimiento a las tareas de tus proyectos mediante un sistema flexible de planificación temporal. Puedes crear proyectos, dividirlos en items y asignar planificaciones que pueden ejecutarse una sola vez, repetirse periódicamente, o mantenerse sin fecha definida hasta que decidas cuándo realizarlas.

## Componentes del Sistema

### 🗂️ Proyecto

Un **Proyecto** es el contenedor principal que agrupa todas las tareas relacionadas con una iniciativa, objetivo o área de trabajo.

**Características:**
- Se identifica por un nombre único
- Contiene múltiples items
- Permite organizar el trabajo por contexto o alcance

**Ejemplo:** "Desarrollo Web 2026", "Marketing Q2", "Infraestructura IT"

---

### 📦 Item

Un **Item** representa una tarea, componente o área específica dentro de un proyecto.

**Características:**
- Pertenece a un único proyecto
- Puede tener múltiples planificaciones asociadas
- Agrupa planificaciones relacionadas bajo un mismo concepto

**Ejemplo:** 
- Proyecto: "Desarrollo Web 2026"
  - Item: "Diseño de interfaz"
  - Item: "Implementación backend"
  - Item: "Testing y QA"

---

### 📅 Planificación

Una **Planificación** define cuándo y cómo se debe ejecutar una tarea asociada a un item.

**Características:**
- **Observaciones**: Descripción detallada de qué debe hacerse
- **Estado**: Indica si está pendiente, completada o ha expirado
- **Definición Temporal**: Especifica cuándo debe realizarse

**Estados posibles:**
- ✅ **Completada**: La tarea ha sido finalizada
- ⏳ **Pendiente**: Aún no se ha completado pero está dentro de plazo
- ⏰ **Expirada**: La fecha/hora ya pasó y no se completó

---

## Tipos de Planificación

### 📍 Puntual

Planificación que ocurre una sola vez en una fecha y hora específica.

**Cuándo usarla:**
- Reuniones únicas
- Entregas con fecha límite específica
- Eventos que no se repiten

**Ejemplo:**
- "Presentación de resultados Q1 - 15/06/2026 15:00"
- "Entrega final del proyecto - 30/12/2026 18:00"

---

### 🔄 Periódica

Planificación que se repite automáticamente según un patrón temporal definido.

**Características:**
- Fecha de inicio: Cuándo comienza la repetición
- Fecha de fin: Cuándo termina la repetición
- Hora específica: A qué hora ocurre cada repetición

#### Tipos de Periodicidad

##### 📆 Diaria
La planificación se repite cada día según el patrón elegido:

- **Todos los días**: Se repite 7 días a la semana
  - Ejemplo: "Backup diario de base de datos - 02:00"
  
- **De Lunes a Viernes**: Se repite solo en días laborables
  - Ejemplo: "Daily standup meeting - 09:00"
  
- **Fin de semana**: Se repite solo sábados y domingos
  - Ejemplo: "Revisión de métricas semanales - 10:00"

##### 📅 Semanal
La planificación se repite el mismo día de cada semana.

**Ejemplo:**
- "Sprint planning - Todos los lunes a las 10:00"
- "Retrospectiva de equipo - Todos los viernes a las 16:00"

##### 📊 Mensual
La planificación se repite el mismo día de cada mes.

**Ejemplo:**
- "Cierre contable - Día 1 de cada mes a las 08:00"
- "Revisión de objetivos - Día 15 de cada mes a las 14:00"

---

### ❓ No Planificado

Planificación sin fecha ni hora asignada. Útil para gestionar un backlog de tareas pendientes de programar.

**Cuándo usarla:**
- Tareas en backlog
- Ideas o mejoras futuras sin fecha definida
- Tareas que dependen de otros eventos

**Ejemplo:**
- "Investigar nueva herramienta de testing"
- "Optimización de rendimiento (cuando sea necesario)"
- "Documentar API interna"

---

## Flujos de Trabajo

### Crear un nuevo proyecto con planificaciones

1. Crea un **Proyecto** con un nombre descriptivo
2. Añade **Items** para organizar las tareas del proyecto
3. Para cada item, crea **Planificaciones** con su definición temporal:
   - Puntual para tareas únicas con fecha específica
   - Periódica para tareas recurrentes
   - No Planificado para backlog

### Visualizar el calendario

Consulta el calendario para ver todas tus planificaciones organizadas por fecha. El sistema muestra:
- Planificaciones puntuales en su fecha específica
- Cada ocurrencia de las planificaciones periódicas
- Estado visual (pendiente, completada, expirada)

### Gestionar tareas sin planificar

Accede al listado de planificaciones "No Planificado" para:
- Revisar tu backlog de tareas
- Convertirlas en planificaciones con fecha
- Priorizar qué tareas programar

---

## Preguntas frecuentes

Consulta [FAQ.md](FAQ.md) si tienes dudas sobre cómo usar el sistema.

---

## Documentación Técnica

Para información sobre arquitectura, diseño e implementación, consulta la [carpeta docs/](docs/). Punto de entrada recomendado: [vista general (capas, contratos, bootstrap)](backlog/vista-general.md).

---

**Versión:** 2.0  
**Última actualización:** 2026-06-12