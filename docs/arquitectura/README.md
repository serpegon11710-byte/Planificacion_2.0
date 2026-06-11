# Punto de partida para el analisis de arquitectura

## Estado actual

- Se acuerda no fijar stack tecnologico por ahora (Step 8c pendiente).

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
- "No Planificado" se trata como tipo de Planificacion, no como modulo independiente.

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

[x] Definir contratos minimos de puertos e interfaces.
[x] Definir granularidad final de modulos de negocio.
[x] Definir transacciones y limites de consistencia.
[x] Definir politicas de errores y validaciones por capa.
[ ] Step 8c: definir criterios para seleccion de stack tecnologico.

## Documentos de soporte de arquitectura

- Contratos minimos: `docs/arquitectura/contratos-minimos.md`
- Granularidad de modulos de negocio: `docs/arquitectura/granularidad-modulos-negocio.md`
- Transacciones y consistencia: `docs/arquitectura/transacciones-consistencia.md`
- Errores y validaciones por capa: `docs/arquitectura/errores-validaciones-capas.md`

## Politicas transversales

- Indice: `docs/politicas-transversales/README.md`
- Revision SOLID global: `docs/politicas-transversales/revision-principios-solid.md`
- Internacionalizacion (i18n): `docs/politicas-transversales/internacionalizacion.md`
