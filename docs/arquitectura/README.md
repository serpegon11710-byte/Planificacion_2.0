# Punto de partida para el analisis de arquitectura

## Estado actual

- Stack tecnologico **definido** (Step 11, 2026-06-12): NestJS + React + TypeScript + PostgreSQL. Ver [analisis-inicial.md](../stack-tecnologico/analisis-inicial.md) y FAQ-100/102 en [dudas-y-resoluciones.md](../planificacion/dudas-y-resoluciones.md).
- Vista general (capas, contratos, bootstrap): [vista-general.md](../planificacion/vista-general.md).
- Desambiguacion de rutas «implementacion»: [desambiguacion-implementacion.md](../politicas-transversales/desambiguacion-implementacion.md).
- Desacoplamiento por contratos: [desacoplamiento-componentes-contratos.md](../politicas-transversales/desacoplamiento-componentes-contratos.md).

## Objetivo de esta fase

Definir una arquitectura generica, independiente del stack, para alinear decisiones de diseno antes de elegir tecnologias.

## Principios acordados

- Arquitectura web por capas logicas: Front-End, Back-End y Persistencia.
- El motor de BBDD es externo al Back-End.
- La capa de persistencia debe estar desacoplada del motor SQL concreto.
- El Back-End consume contratos (puertos), no implementaciones concretas.
- En negocio se modela la jerarquia funcional principal:
  - Item depende de Proyecto
  - Planificacion depende de Item
  - Ocurrencia depende de Planificacion
- "Sin planificar" se trata como tipo de Planificacion, no como modulo independiente.

## Fronteras logicas a analizar

- Capa de Presentacion: interaccion de usuario y llamadas a API.
- Capa de Aplicacion/API: orquestacion de casos de uso.
- Capa de Negocio: entidades, reglas y dependencias del dominio.
- Puerto de Persistencia: contrato que consume negocio.
- Capa de Persistencia: adaptadores y repositorios que implementan contratos.
- Puerto de Conexion a BBDD: contrato tecnico hacia el motor externo.

## Reglas de dependencia propuestas

- Presentacion puede depender de API.
- API puede depender de Aplicacion/Negocio.
- Negocio no depende de infraestructura.
- Persistencia implementa puertos definidos por Negocio/Aplicacion.
- Ninguna capa de dominio conoce detalles del motor de BBDD.

## Checklist arquitectura logica

[x] Definir contratos minimos de puertos e interfaces.
[x] Definir granularidad final de modulos de negocio.
[x] Definir transacciones y limites de consistencia.
[x] Definir politicas de errores y validaciones por capa.
[x] Step 12a: N4 implementacion por componente (FAQ-102).

## Siguientes pasos (implementacion)

| Step | Descripcion | Estado |
|------|-------------|--------|
| 12a | N4 por componente | **Cerrado** — [implementacion/](../diagramas-c4/c4-nivel-4/implementacion/) |
| 12b | Practicas en `docs/implementacion/{componente}/` | **Cerrado** |
| 13 | Validacion documental | **Cerrado** — [validacion-documental-step13.md](../planificacion/validacion-documental-step13.md) |
| 14 | Bootstrap codigo en `implementacion/` | Pendiente |

Ver [planificacion-inicial.md](../planificacion/planificacion-inicial.md).

## Documentos de soporte de arquitectura

- Contratos minimos: `docs/arquitectura/contratos-minimos.md`
- Granularidad de modulos de negocio: `docs/arquitectura/granularidad-modulos-negocio.md`
- Transacciones y consistencia: `docs/arquitectura/transacciones-consistencia.md`
- Errores y validaciones por capa: `docs/arquitectura/errores-validaciones-capas.md`

## Diagramas C4 (Step 8)

Visualizacion documentada en Step 8 del plan. Indice: `docs/diagramas-c4/README.md`

| Nivel | Estado | Contenido |
|-------|--------|-----------|
| N1–N3 | Cerrado | Contexto, contenedores y componentes Back-End + Front-End (`.mmd`) |
| N4 canonico | Cerrado | Pseudocodigo por zona critica (`c4-nivel-4/pseudocodigo/`) |
| N4 implementacion | Cerrado (Step 12a) | Proyeccion por componente (`c4-nivel-4/implementacion/{componente}/{tecnologia}/`) |

Los diagramas C4 (Step 8) complementan los documentos de arquitectura (Step 9a); el N4 canonico es independiente del stack. La proyeccion N4 por componente es Step 12a.

## Politicas transversales

- Indice: `docs/politicas-transversales/README.md`
- Revision SOLID global: `docs/politicas-transversales/revision-principios-solid.md`
- Internacionalizacion (i18n): `docs/politicas-transversales/internacionalizacion.md`
- Desacoplamiento por contratos: `docs/politicas-transversales/desacoplamiento-componentes-contratos.md`
