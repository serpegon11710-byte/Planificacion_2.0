# Front-End — Guía de implementación

**Componente:** Front-End (SPA)  
**Código:** [`implementacion/front-end/react-typescript/`](../../../implementacion/front-end/react-typescript/)

> **Desambiguación:** [`desambiguacion-implementacion.md`](../../politicas-transversales/desambiguacion-implementacion.md)  
> **Desacoplamiento por contratos:** [`desacoplamiento-componentes-contratos.md`](../../politicas-transversales/desacoplamiento-componentes-contratos.md) (restricciones transversales y de este componente)

---

## Propósito del componente

Interfaz web en navegador: wizard y mantenimiento (UC-01), calendario y gestión de ocurrencias (UC-02), listado Sin planificar (UC-03). Consume la API REST del Back-End; no accede a la BBDD.

---

## Responsabilidades y límites

### Responsabilidades

- Renderizar la **interfaz web** (wizard, mantenimiento, calendario, listados).
- Invocar la **API REST** del Back-End mediante un cliente HTTP tipado.
- Validar **formato y completitud** de formularios antes de enviar datos (incl. UC-01.5).
- Resolver **i18n** a partir de `codigo` devuelto por la API ([`internacionalizacion.md`](../../politicas-transversales/internacionalizacion.md)).
- Mostrar fechas en **locale** del usuario manteniendo el modelo en UTC.

### Sí hace / No hace

| Sí hace | No hace |
|---------|---------|
| Navegación por flujos UC-01, UC-02, UC-03 | Acceder a BBDD ni ejecutar SQL |
| Mapear DTO ↔ estado de vista | Implementar reglas RT/RO/RP de negocio |
| Mostrar avisos RE-5 (bloqueos previos a borrado) | Reinterpretar errores de la API con lógica distinta |
| Formularios dinámicos según catálogo `TipoPeriodo` | Definir contratos API (viven en arquitectura/shared) |

### Frontera con vecinos

| Vecino | Contrato externo | Rol del Front-End |
|--------|------------------|-------------------|
| Back-End | API REST + DTOs | Cliente HTTP; solo consume endpoints documentados |
| Shared | Tipos y `codigo` de error | Importa shapes compartidos; no duplica DTOs |
| Usuario | i18n y UX | Presenta datos; no persiste directamente |

Ver contratos externos en [`vista-general.md`](../../planificacion/vista-general.md) §3.1.

---

## Referencias

- Casos de uso: [`docs/casos-uso/`](../../casos-uso/)
- i18n global: [`internacionalizacion.md`](../../politicas-transversales/internacionalizacion.md)
- Contratos API: [`contratos-minimos.md`](../../arquitectura/contratos-minimos.md)
- N4 presentación: [`zc-6-presentacion.md`](../../diagramas-c4/c4-nivel-4/pseudocodigo/zc-6-presentacion.md)
