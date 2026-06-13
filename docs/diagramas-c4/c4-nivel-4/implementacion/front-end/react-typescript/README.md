# N4 — Front-End (React 18 + TypeScript + Vite)

**Componente:** Front-End (SPA)  
**Tecnología:** React 18, TypeScript 5, Vite  
**Código:** [`implementacion/front-end/react-typescript/`](../../../../../../implementacion/front-end/react-typescript/)  
**Canónico:** [zc-6-presentacion.md](../../pseudocodigo/zc-6-presentacion.md)

---

## Compatibilidad

| Campo | Valor |
|-------|-------|
| Estado | **activa** |
| Contratos | API v1, errores v1, DTOs shared v1 |

Registro: [historial-stack.md](../../../../../stack-tecnologico/historial-stack.md).

---

## Mapeo lógico → artefactos

| Canónico (ZC-6) | Artefacto React | Ruta prevista |
|-----------------|-----------------|---------------|
| `ModuloCapturaPlanificacion` | `PlanificacionCaptureFeature` | `src/features/planificacion-capture/` |
| `ModuloVistaCalendario` | `CalendarFeature` | `src/features/calendar/` |
| `ClienteAPI` | `apiClient` + hooks | `src/api/` |
| `ResolucionMensajes` | i18n + `ErrorDisplay` | `src/i18n/`, `src/components/errors/` |
| Wizard UC-01.1 | `WizardCreateProjectPage` | `src/pages/wizard/` |
| RE-5 bloqueos | `EliminationBlockedDialog` | `src/components/errors/elimination-blocked-dialog.tsx` |

DTOs y códigos de error: paquete `implementacion/shared/typescript/` (contrato; no lógica de negocio).

---

## Documentos N4

| ZC | Fichero |
|----|---------|
| ZC-6 | [zc-6-presentacion.md](zc-6-presentacion.md) |

---

## Referencias

- Guía agnóstica: [docs/implementacion/front-end/](../../../../../implementacion/front-end/)
- i18n: [internacionalizacion.md](../../../../../politicas-transversales/internacionalizacion.md)
- N3 componentes UI: [c4-nivel-3-componentes-frontend.mmd](../../../c4-nivel-3/c4-nivel-3-componentes-frontend.mmd)
