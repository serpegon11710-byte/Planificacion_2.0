# UC-02: Visualizar Calendario

**ID:** UC-02  
**Nombre:** Visualizar Calendario de Planificaciones  
**Prioridad:** Alta  
**Última actualización:** 2026-06-10

---

## Descripción

Permite al usuario visualizar todas las planificaciones en formato calendario, con filtros por proyecto, item, tipo y estado. Las planificaciones periódicas se expanden dinámicamente mostrando todas sus ocurrencias calculadas.

---

## Actores

- **Usuario:** Persona que visualiza y gestiona planificaciones en el calendario

---

## Precondiciones

- Usuario autenticado en el sistema
- Existen proyectos con planificaciones en el sistema

---

## Características

- **Vista mensual y semanal:** Permite cambiar entre diferentes vistas
- **Cálculo dinámico de ocurrencias:** Las planificaciones periódicas se expanden en el calendario
- **Filtros múltiples:** Por proyecto, item, tipo de planificación, estado
- **Diferenciación visual:** Estados se muestran con colores (pendiente, completada, expirada)
- **Gestión de ocurrencias individuales:** Permite modificar ocurrencias específicas de planificaciones periódicas

---

## Flujo Principal

1. Usuario accede a "Calendario"
2. Sistema calcula todas las ocurrencias de planificaciones periódicas
3. Sistema aplica modificaciones de tabla `OcurrenciaModificada`
4. Sistema muestra calendario del mes actual con todas las planificaciones:
   - **Azul:** Planificaciones pendientes
   - **Verde:** Planificaciones completadas
   - **Rojo:** Planificaciones expiradas
5. Usuario puede navegar entre meses (anterior/siguiente)
6. Usuario puede cambiar vista (mensual/semanal)
7. Usuario puede aplicar filtros
8. Usuario puede hacer clic en una planificación para ver detalles
9. Usuario puede modificar ocurrencias individuales

---

## Filtros Disponibles

### Por Proyecto
- Mostrar solo planificaciones de un proyecto específico
- Opción "Todos los proyectos"

### Por Item
- Mostrar solo planificaciones de un item específico
- Opción "Todos los items"

### Por Tipo de Planificación
- Puntual
- Periódica
- No planificado
- Opción "Todos los tipos"

### Por Estado
- Pendiente
- Completada
- Expirada
- Opción "Todos los estados"

---

## Gestión de Ocurrencias Periódicas

**Importante:** Las ocurrencias NO se crean físicamente en la BD. Se calculan dinámicamente al visualizar el calendario.

### Algoritmo de Cálculo y Visualización

1. Sistema recupera todas las planificaciones periódicas
2. Para cada planificación:
   - Calcula todas las fechas naturales según el patrón (diario/semanal/mensual)
   - Consulta tabla `OcurrenciaModificada` para esa planificación
   - Aplica modificaciones (cambios de fecha, hora, estado, observaciones)
   - Filtra ocurrencias marcadas como eliminadas
3. Sistema combina ocurrencias calculadas + modificadas
4. Sistema ordena todas las ocurrencias por fecha
5. Sistema aplica filtros del usuario
6. Sistema muestra resultado en el calendario

### Operaciones sobre Ocurrencias Individuales

#### 1. **Modificar Estado de Ocurrencia**
**Contexto:** Usuario hace clic en una ocurrencia en el calendario

**Proceso:**
1. Sistema muestra opciones:
   - [ ] Marcar como "Completada"
   - [ ] Marcar como "Pendiente"
2. Usuario selecciona nuevo estado
3. Sistema crea/actualiza registro en tabla `OcurrenciaModificada`:
   - planificacion_id
   - fecha_original
   - estado (nuevo)
4. Sistema actualiza visualmente el calendario
5. La ocurrencia se muestra con el nuevo estado

#### 2. **Modificar Fecha de Ocurrencia**
**Contexto:** Usuario arrastra una ocurrencia a otra fecha en el calendario

**Proceso:**
1. Usuario arrastra ocurrencia desde fecha original a nueva fecha
2. Sistema solicita confirmación: "¿Mover planificación del DD/MM/YYYY al DD/MM/YYYY?"
3. Usuario confirma
4. Sistema crea/actualiza registro en `OcurrenciaModificada`:
   - fecha_original: fecha donde estaba
   - fecha_modificada: nueva fecha
   - es_eliminada: false (prevalece sobre eliminaciones previas)
5. Sistema recalcula calendario
6. Ocurrencia se muestra en la nueva fecha

**Regla especial:** Si la fecha original estaba marcada como eliminada, el cambio de fecha anula la eliminación.

#### 3. **Modificar Hora de Ocurrencia**
**Contexto:** Usuario edita una ocurrencia en el calendario

**Proceso:**
1. Usuario hace clic en ocurrencia → "Editar hora"
2. Sistema muestra formulario con hora actual
3. Usuario modifica hora
4. Usuario presiona "Guardar"
5. Sistema crea/actualiza registro en `OcurrenciaModificada`:
   - fecha_original
   - hora_modificada: nueva hora
6. Sistema actualiza visualmente el calendario
7. La ocurrencia se muestra con la nueva hora

#### 4. **Modificar Observaciones de Ocurrencia**
**Contexto:** Usuario edita una ocurrencia en el calendario

**Proceso:**
1. Usuario hace clic en ocurrencia → "Editar observaciones"
2. Sistema muestra formulario con observaciones actuales (de la planificación base)
3. Usuario modifica observaciones
4. Usuario presiona "Guardar"
5. Sistema crea/actualiza registro en `OcurrenciaModificada`:
   - fecha_original
   - observaciones_modificadas: nuevo texto
6. Sistema actualiza visualmente el calendario
7. La ocurrencia muestra las observaciones específicas

**Nota:** Las observaciones de la planificación base NO se modifican. Solo esta ocurrencia tendrá observaciones diferentes.

#### 5. **Eliminar Ocurrencia Individual**
**Contexto:** Usuario hace clic derecho en una ocurrencia

**Proceso:**
1. Usuario selecciona "Eliminar esta ocurrencia"
2. Sistema muestra confirmación: "¿Eliminar solo esta ocurrencia del DD/MM/YYYY?"
3. Usuario confirma
4. Sistema crea/actualiza registro en `OcurrenciaModificada`:
   - fecha_original
   - es_eliminada: true
5. Sistema recalcula calendario
6. La ocurrencia desaparece del calendario
7. Resto de ocurrencias de la planificación NO se afectan

**Nota importante:** La planificación base NO se elimina. Solo se oculta esa fecha específica.

---

## Flujos Alternativos

### FA-1: No Hay Planificaciones
1. Sistema detecta que no hay planificaciones en el rango de fechas
2. Sistema muestra mensaje: "No hay planificaciones para mostrar"
3. Sistema muestra calendario vacío

### FA-2: Filtros Sin Resultados
1. Usuario aplica filtros
2. Sistema no encuentra planificaciones que cumplan los criterios
3. Sistema muestra mensaje: "No se encontraron planificaciones con los filtros aplicados"
4. Sistema permite modificar filtros

### FA-3: Usuario Cancela Modificación de Ocurrencia
1. Usuario inicia modificación de ocurrencia
2. Usuario presiona "Cancelar"
3. Sistema descarta cambios
4. Sistema retorna a la vista del calendario

---

## Reglas de Negocio

### RN-2.1: Cálculo Dinámico
Las ocurrencias de planificaciones periódicas se calculan en tiempo real cada vez que se visualiza el calendario. NO se almacenan físicamente.

### RN-2.2: Materialización de Modificaciones
Solo se crean registros físicos en `OcurrenciaModificada` cuando el usuario modifica una ocurrencia específica.

### RN-2.3: Precedencia de Modificaciones
Si existe registro en `OcurrenciaModificada` para una fecha, sus datos prevalecen sobre la planificación base.

### RN-2.4: Estado Expirado Calculado
El estado "Expirada" se calcula dinámicamente: planificación con fecha/hora pasada y estado "Pendiente".

### RN-2.5: Modificar Fecha Anula Eliminación
Si una ocurrencia estaba marcada como eliminada (es_eliminada=true) y el usuario mueve esa ocurrencia a otra fecha, el sistema crea un nuevo registro con fecha_modificada y es_eliminada=false.

---

## Postcondiciones

### Éxito - Visualización
- Usuario visualiza calendario con todas las planificaciones
- Ocurrencias periódicas expandidas correctamente
- Filtros aplicados
- Estados diferenciados visualmente

### Éxito - Modificación de Ocurrencia
- Registro creado/actualizado en `OcurrenciaModificada`
- Calendario actualizado visualmente
- Resto de ocurrencias no afectadas

---

## Documentación Técnica Detallada

Para información técnica completa sobre:
- Tabla `OcurrenciaModificada` (estructura, campos, índices)
- Algoritmo de cálculo de ocurrencias (pseudocódigo completo)
- Ejemplos de casos complejos (modificaciones múltiples, precedencias)

Ver documento: `(borrador) UC-01-crear-proyecto-item-planificacion.md` - Sección "Notas Técnicas"

---

**Última revisión:** 2026-06-10
