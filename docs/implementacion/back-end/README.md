# Back-End — Guía de implementación

**Componente:** Back-End (API REST + dominio + aplicación)  
**Código:** [`implementacion/back-end/nestjs-typescript/`](../../../implementacion/back-end/nestjs-typescript/)

> **Desambiguación:** [`desambiguacion-implementacion.md`](../../politicas-transversales/desambiguacion-implementacion.md)

---

## Propósito del componente

Punto de entrada HTTP/JSON, orquestación de casos de uso (ZC-4) y lógica de negocio en cuatro módulos: Proyecto → Item → Planificación → Ocurrencia. Consume **puertos** de persistencia; no ejecuta SQL directo en el dominio.

---

## Contenido esperado en esta carpeta

| Tema | Ejemplos |
|------|----------|
| Capas | `api/` (controllers), `application/` (orquestadores), `domain/` (entidades, servicios, puertos) |
| Módulos de negocio | Un módulo por agregado; dependencias unidireccionales |
| Regla de aislamiento | El dominio no importa framework ni infraestructura |
| ZC-1 a ZC-3 | Servicios de ocurrencias, materialización, definición temporal |
| ZC-4 | Transacciones multi-agregado (wizard, creación automática, cascadas) |
| Errores | Propagación de `codigo` estable hacia la API |
| Pruebas | Unitarias de dominio; integración de API con persistencia mockeada |

---

## Referencias

- Arquitectura: [`docs/arquitectura/`](../../arquitectura/)
- Granularidad: [`granularidad-modulos-negocio.md`](../../arquitectura/granularidad-modulos-negocio.md)
- Transacciones: [`transacciones-consistencia.md`](../../arquitectura/transacciones-consistencia.md)
- Pseudocódigo: [`docs/diagramas-c4/c4-nivel-4/pseudocodigo/`](../../diagramas-c4/c4-nivel-4/pseudocodigo/)
