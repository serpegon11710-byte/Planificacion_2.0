# N4 — Pseudocodigo (canonico)

Especificacion logica del detalle interno de cada [zona critica](../zonas-criticas-n4.md). Independiente del stack tecnologico.

## Politica

| Capa | Carpeta | Proposito | Cuando cambia |
|------|---------|-----------|---------------|
| **N4 canonico** | `pseudocodigo/` | Estructura logica + algoritmos + contratos de puertos | Cuando cambia la logica de negocio o el diseno interno |
| **N4 implementacion** | [implementacion/](../implementacion/) | Proyeccion por componente y tecnologia (Step 12a) | Al cambiar tecnologia en un componente |

El pseudocodigo es la **fuente de verdad funcional** (contrato de **diseño interno** lógico). Cada documento de implementacion debe referenciar el canonico del que deriva y traducir nombres logicos a artefactos reales, sin redefinir reglas. Marco: [vista-general.md](../../../backlog/vista-general.md).

## Convenciones

- **Nombres logicos** en PascalCase o snake_case segun contexto; sin librerias ni sintaxis de lenguaje concreto.
- **Pseudocodigo** con `FUNCION`, `SI`, `PARA`, `RETORNAR`, tipos abstractos (`Fecha`, `Planificacion`, `OcurrenciaVista`).
- **Errores funcionales** por `codigo` (p. ej. `PLANIFICACION_TIPO_NO_PERMITIDO`); los mensajes al usuario pertenecen a presentacion/i18n.
- **Referencias:** reglas en `docs/entidades/`; casos de uso en `docs/casos-uso/`.

## Documentos por zona

| Zona | Fichero | Componente N3 |
|------|---------|---------------|
| ZC-1 | [zc-1-consulta-ocurrencias.md](zc-1-consulta-ocurrencias.md) | `Ocurrencia`, `Planificacion` (lectura) |
| ZC-2 | [zc-2-materializacion-ocurrencias.md](zc-2-materializacion-ocurrencias.md) | `Ocurrencia` |
| ZC-3 | [zc-3-planificacion-temporal.md](zc-3-planificacion-temporal.md) | `Planificacion` |
| ZC-4 | [zc-4-orquestacion-aplicacion.md](zc-4-orquestacion-aplicacion.md) | `API REST` + coordinadores |
| ZC-5 | [zc-5-persistencia.md](zc-5-persistencia.md) | Puertos y adaptadores |
| ZC-6 | [zc-6-presentacion.md](zc-6-presentacion.md) | `Front-End` |

## Dependencias entre zonas

```
ZC-3 ──► ZC-1 ──► ZC-2
  │         │
  └────► ZC-4 ◄── ZC-5
ZC-6 (independiente; consume API)
```
