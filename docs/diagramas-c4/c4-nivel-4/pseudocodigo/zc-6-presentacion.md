# ZC-6: Presentacion — captura y calendario

**Componente N3:** `Front-End`  
**Prioridad:** Media (opcional en primera iteracion)  
**Casos de uso:** UC-01.1, UC-01.4 (via UC-01.5), UC-02.1

---

## Estructura logica

```mermaid
flowchart TD
  App["AplicacionFrontEnd"]
  Captura["ModuloCapturaPlanificacion"]
  Calendario["ModuloVistaCalendario"]
  ApiClient["ClienteAPI"]
  Mensajes["ResolucionMensajes"]

  App --> Captura
  App --> Calendario
  Captura --> ApiClient
  Calendario --> ApiClient
  Captura --> Mensajes
  Calendario --> Mensajes
```

| Subcomponente | Responsabilidad |
|---------------|-----------------|
| `ModuloCapturaPlanificacion` | UC-01.5: formulario reutilizable por tipo/subtipo |
| `ModuloVistaCalendario` | UC-02.1: rango, listado, acceso a gestion individual |
| `ClienteAPI` | Invoca endpoints del Back-End |
| `ResolucionMensajes` | Traduce `codigo` de error a texto para el usuario |

---

## Pseudocodigo — captura de planificacion (UC-01.5)

```
ESTADO CapturaPlanificacion:
  paso: SELECCION_TIPO | CONFIGURACION | VALIDACION
  tipo_seleccionado: TipoPlanificacion | NULL
  datos_formulario: Mapa<Campo, Valor>
  datos_previos: Configuracion | NULL   // modo edicion

FUNCION iniciar(datos_previos = NULL):
  estado = nuevo CapturaPlanificacion(datos_previos = datos_previos)
  SI datos_previos:
    estado.tipo_seleccionado = datos_previos.tipo
    estado.datos_formulario = prellenar(datos_previos)
  RETORNAR estado

FUNCION seleccionarTipo(estado, tipo):
  estado.tipo_seleccionado = tipo
  estado.datos_formulario = camposPorTipo(tipo)   // catálogo ZC-3
  estado.paso = CONFIGURACION

FUNCION confirmar(estado):
  config = construirConfiguracion(estado.tipo_seleccionado, estado.datos_formulario)
  // Validacion local previa (UX); validacion definitiva en Back-End ZC-3
  errores = validarLocal(config)
  SI errores.noEstaVacio():
    estado.paso = VALIDACION
    RETORNAR ResultadoError(errores)

  RETORNAR ResultadoOk(config)   // invocador persiste o acumula en wizard

FUNCION cancelar(estado):
  RETORNAR ResultadoCancelacion()
```

```
FUNCION camposPorTipo(tipo):
  SEGUN tipo:
    PUNTUAL:     RETORNAR [fecha, hora, observaciones]
    PERIODICA:   RETORNAR [fecha_inicio, fecha_fin, hora, subtipo, campos_subtipo, observaciones]
    NO_PLANIFICADO: RETORNAR [observaciones]
```

```
FUNCION validarLocal(config):
  // Espejo simplificado de RC-2, RC-3 para feedback inmediato
  errores = LISTA_VACIA
  SI config.tipo == PERIODICA Y config.fecha_fin <= config.fecha_inicio:
    errores.agregar(codigo = "RANGO_TEMPORAL_INVALIDO")
  RETORNAR errores
```

---

## Pseudocodigo — vista calendario (UC-02.1)

```
ESTADO VistaCalendario:
  fecha_desde: Fecha
  fecha_hasta: Fecha
  ocurrencias: Lista<OcurrenciaVista>
  cargando: Booleano

FUNCION establecerRango(estado, desde, hasta):
  SI NOT validarRango(desde, hasta):
    mostrarError("RANGO_FECHAS_INVALIDO")
    RETORNAR

  estado.cargando = VERDADERO
  estado.fecha_desde = desde
  estado.fecha_hasta = hasta
  estado.ocurrencias = cliente_api.obtenerOcurrenciasEnRango(desde, hasta)
  estado.cargando = FALSO

FUNCION seleccionarOcurrencia(estado, ocurrencia):
  planificacion = cliente_api.obtenerPlanificacion(ocurrencia.planificacion_id)
  SEGUN planificacion.tipo:
    PUNTUAL:
      navegarA(gestionPuntual, ocurrencia)      // UC-02.2
    PERIODICA:
      navegarA(gestionPeriodica, ocurrencia)   // UC-02.3
```

```
FUNCION renderizarOcurrencia(ocurrencia):
  estado_mostrado = ocurrencia.estado_efectivo   // incluye EXPIRADO_CALCULADO
  estilo = estiloPorEstado(estado_mostrado)
  RETORNAR componenteVisual(ocurrencia, estilo)
```

---

## Resolucion de mensajes

```
FUNCION mostrarError(codigo, parametros = {}):
  texto = mensajes.resolver(codigo, parametros, idioma_actual)
  // mensajes: catalogo clave codigo -> plantilla (i18n en implementacion)
  ui.mostrarNotificacion(texto)

FUNCION manejarRespuestaApi(respuesta):
  SI respuesta.es_error_funcional:
    mostrarError(respuesta.codigo, respuesta.parametros)
  SI respuesta.es_error_tecnico:
    mostrarError("ERROR_GENERICO")
```

---

## Integracion con invocadores

| Invocador | Uso de captura | Persistencia |
|-----------|----------------|--------------|
| UC-01.1 Wizard | Acumula config; confirma al final | Orquestador ZC-4 |
| UC-01.4 Gestion | Devuelve config al caso de uso | Agregado ZC-3 |

La captura **no persiste**; solo devuelve `ResultadoOk`, `ResultadoError` o `ResultadoCancelacion`.

---

## Notas para N4-implementacion

Al definir el stack de Front-End, esta zona documentara:

- Framework UI y componentes concretos
- Catalogo i18n de mensajes
- Cliente HTTP y modelos de vista tipados

Deriva de este documento; ver [implementacion/](../implementacion/).
