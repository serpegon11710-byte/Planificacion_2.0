# Entidad: Planificaciones

**Última actualización:** 2026-06-10

---

## Propósito

Este documento define el catálogo común de tipos de planificación y sus reglas de configuración. Cualquier caso de uso que necesite capturar, validar o persistir planificaciones debe referenciar este documento como fuente única.

---

## Catálogo de Tipos de Planificación

### 1. Puntual
Planificación que ocurre una única vez en una fecha y hora específica.

**Configuración requerida:**
- Fecha
- Hora
- Observaciones (opcional)

---

### 2. Periódica
Planificación que se repite según un patrón temporal.

**Configuración base requerida:**
- Fecha inicio
- Fecha fin
- Hora
- Observaciones (opcional)

#### Variantes de planificación periódica

**a) Diaria**
- Todos los días
- Lunes a Viernes
- Fin de semana

**b) Semanal**
- Uno o más días de la semana

**c) Mensual**
- Día del mes (1-31)
- Para días mayores a 28, debe definirse uno de estos comportamientos cuando el mes no tenga ese día:
	- Usar el último día del mes
	- Mover al día 1 del mes siguiente
	- Omitir la ocurrencia de ese mes

---

### 3. No planificado
Planificación sin fecha ni hora asignada.

**Configuración requerida:**
- Observaciones (opcional)

---

## Estado de Planificación

Las planificaciones tienen estado base de negocio:

- **Pendiente**
- **Completada**

Este estado puede ser utilizado por las ocurrencias cuando una ocurrencia no tenga estado propio registrado.

---

## Reglas Comunes de Configuración

### RC-1: Aplicación de reglas por tipo
Cada tipo y variante aplica únicamente sus propias reglas de configuración.

### RC-2: Validación de rango temporal
Cuando exista fecha inicio/fin, la fecha fin debe ser posterior a la fecha inicio.

### RC-3: Validación de consistencia
La configuración debe ser válida y permitir generar al menos una ocurrencia para los tipos que generan ocurrencias (Puntual y Periódica), según su configuración y rango cuando aplique.

### RC-4: Mantenimiento planificaciones
La creación/modificación de planificaciones no gestiona ocurrencias individuales; solo persiste la planificación base.

### RC-5: Evolución del catálogo
Nuevos tipos o variantes deben incorporarse en este documento y luego ser consumidos por los casos de uso, evitando duplicación de definiciones.

---

## Reglas de Cambio de Tipo de Planificación

### RT-1: No planificado hacia otros tipos
Una planificación de tipo **No planificado** puede cambiarse a **Puntual** o **Periódica**, siempre que se informen y validen todos los parámetros requeridos del tipo destino.

### RT-2: Puntual hacia No planificado
Una planificación **Puntual** solo puede cambiarse a **No planificado** si su estado es **Pendiente** (no completada).

### RT-3: Periódica hacia No planificado
Una planificación **Periódica** solo puede cambiarse a **No planificado** cuando se cumplan todas estas condiciones:
- Estado de la planificación: **Pendiente** (no completada).
- No existen ocurrencias explícitas de tipo modificación.
- No existen ocurrencias explícitas de tipo eliminación.

### RT-4: Cambios no permitidos entre Puntual y Periódica
No se permite cambiar el tipo de planificación entre **Puntual** y **Periódica** en ningún sentido.

### RT-5: Cambios no permitidos de subtipo periódico
No se permite modificar el subtipo de una planificación **Periódica** (Diaria, Semanal o Mensual) una vez creada.

---

## Uso por Casos de Uso

- UC-01.5 debe usar este documento para captura y validación, sin redefinir tipos internamente.
- UC-01.4 debe persistir la configuración resultante sin redefinir el catálogo.
- Cualquier otro caso de uso que opere con planificaciones debe referenciar este catálogo común.
