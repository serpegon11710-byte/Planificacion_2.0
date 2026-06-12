# Punto de partida para el analisis de arquitectura

## Estado actual

- Se acuerda no fijar stack tecnologico por ahora (Step 9c pendiente).

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

## Decisiones pendientes (sin stack)

Ver FAQ-101 y FAQ-102 en [docs/planificacion/dudas-y-resoluciones.md](../planificacion/dudas-y-resoluciones.md).

[x] Definir contratos minimos de puertos e interfaces.
[x] Definir granularidad final de modulos de negocio.
[x] Definir transacciones y limites de consistencia.
[x] Definir politicas de errores y validaciones por capa.
[ ] Step 9c: definir criterios para seleccion de stack tecnologico.

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
| N4 implementacion | Pendiente (Step 9c) | Proyeccion al stack (`c4-nivel-4/implementacion/`) |

Los diagramas C4 (Step 8) complementan los documentos de arquitectura (Step 9a); el N4 canonico es independiente del stack y la capa de implementacion se genera al cerrar Step 9c.

## Politicas transversales

- Indice: `docs/politicas-transversales/README.md`
- Revision SOLID global: `docs/politicas-transversales/revision-principios-solid.md`
- Internacionalizacion (i18n): `docs/politicas-transversales/internacionalizacion.md`
