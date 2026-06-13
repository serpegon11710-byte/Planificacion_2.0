# Front-End — Guía de implementación

**Componente:** Front-End (SPA)  
**Código:** [`implementacion/front-end/react-typescript/`](../../../implementacion/front-end/react-typescript/)

> **Desambiguación:** [`desambiguacion-implementacion.md`](../../politicas-transversales/desambiguacion-implementacion.md)  
> **Desacoplamiento por contratos:** [`desacoplamiento-componentes-contratos.md`](../../politicas-transversales/desacoplamiento-componentes-contratos.md) (restricciones transversales y de este componente)

---

## Propósito del componente

Interfaz web en navegador: wizard y mantenimiento (UC-01), calendario y gestión de ocurrencias (UC-02), listado Sin planificar (UC-03). Consume la API REST del Back-End; no accede a la BBDD.

---

## Contenido esperado en esta carpeta

Documentación **sin atar a React** en la redacción de reglas (aunque el código use React + TypeScript):

| Tema | Ejemplos |
|------|----------|
| Estructura lógica | `pages/`, `features/`, `components/`, rutas por caso de uso |
| Capa de API | Cliente HTTP, mapeo DTO ↔ vista, manejo de errores por `codigo` |
| Presentación (ZC-6) | Calendario, captura UC-01.5, formularios dinámicos según `TipoPeriodo` |
| i18n | Política de claves, locale vs UTC en pantalla |
| Estado y navegación | Flujos wizard, confirmaciones, avisos RE-5 |
| Pruebas | Componentes, integración con API mock |

---

## Referencias

- Casos de uso: [`docs/casos-uso/`](../../casos-uso/)
- i18n global: [`internacionalizacion.md`](../../politicas-transversales/internacionalizacion.md)
- Contratos API: [`contratos-minimos.md`](../../arquitectura/contratos-minimos.md)
- N4 presentación: [`zc-6-presentacion.md`](../../diagramas-c4/c4-nivel-4/pseudocodigo/zc-6-presentacion.md)
