# ZC-6 — Presentación (React + TypeScript)

**Canónico:** [zc-6-presentacion.md](../../../pseudocodigo/zc-6-presentacion.md)  
**Código:** `implementacion/front-end/react-typescript/src/`

> Validación definitiva en Back-End (ZC-3); la UI solo aplica RC-1/RC-2/RC-3 local para UX.

---

## Estructura de carpetas

```
src/
├── api/
│   ├── client.ts              # fetch/axios; base URL; interceptores error por codigo
│   ├── planificacion.api.ts
│   ├── ocurrencia.api.ts
│   └── proyecto.api.ts
├── features/
│   ├── planificacion-capture/ # UC-01.5
│   │   ├── CaptureWizard.tsx
│   │   ├── useCaptureState.ts
│   │   └── fields/            # campos dinamicos por TipoPeriodo
│   └── calendar/              # UC-02.1
│       ├── CalendarView.tsx
│       ├── useOccurrencesRange.ts
│       └── OccurrenceChip.tsx
├── pages/
│   ├── wizard/                # UC-01.1
│   └── sin-planificar/        # UC-03
├── i18n/
│   ├── es.json                # claves error.<CODIGO>
│   └── useTranslation.ts      # react-i18next
└── components/errors/
    ├── ApiErrorToast.tsx
    └── EliminationBlockedDialog.tsx  # RE-5
```

---

## `PlanificacionCaptureFeature` (UC-01.5)

Estado equivalente a `CapturaPlanificacion` del canónico — hook `useCaptureState`:

| Paso canónico | Componente |
|---------------|------------|
| `SELECCION_TIPO` | `NatureSelector` (Sin planificar / Puntual / Periódica) |
| `CONFIGURACION` | Formulario dinámico según `TipoPeriodo` (FAQ-111 visibilidades desde API catálogo) |
| `VALIDACION` | Lista errores locales + mensajes i18n |

**Resultados:** `ResultadoOk(config)` | `ResultadoError` | `ResultadoCancelacion` — sin llamada persistencia desde el feature.

Integración:

| Invocador | Comportamiento |
|-----------|----------------|
| Wizard UC-01.1 | Acumula `config` en estado de página; confirma vía `POST /wizard/confirm` |
| UC-01.4 | `onConfirm` → `PUT /planificaciones/:id` |

---

## `CalendarFeature` (UC-02.1)

| Canónico | Implementación |
|----------|----------------|
| `establecerRango` | `useOccurrencesRange(desde, hasta)` → `GET /ocurrencias?desde&hasta` |
| `renderizarOcurrencia` | `OccurrenceChip` con estilo por `estado_efectivo` (incl. expirado calculado) |
| `seleccionarOcurrencia` | Navegación a ruta UC-02.2 o UC-02.3 según naturaleza devuelta por API |

Vista mensual/semanal: librería calendario (p. ej. react-big-calendar) o componente propio; fechas en UTC en modelo, formato locale en UI (FAQ-002).

---

## Cliente API

```typescript
// Tipos desde shared
import type { ListaOcurrenciaOutput } from '@planificacion/shared';

async function obtenerOcurrenciasEnRango(desde: string, hasta: string): Promise<ListaOcurrenciaOutput>
```

- Serialización JSON: fechas ISO `YYYY-MM-DD`, hora `HH:mm:ss`.
- Errores: parsear `{ codigo, campo?, bloqueos? }` → `handleApiResponse` del canónico.

---

## i18n y RE-5

| `codigo` | Clave i18n |
|----------|------------|
| Genérico | `error.<CODIGO>` |
| `ELIMINACION_PROYECTO_BLOQUEADA` | `error.ELIMINACION_PROYECTO_BLOQUEADA.titulo` + líneas por bloqueo |
| `ELIMINACION_ITEM_BLOQUEADA` | Idem |

`formatearIdentificablePorUsuario`: helper en `src/i18n/format-planificacion-id.ts` usando plantillas de [planificaciones.md](../../../../../entidades/planificaciones.md).

---

## Dependencias permitidas

- `@planificacion/shared` (DTOs/códigos únicamente).
- **Prohibido:** importar código de Back-End o Persistencia ([desacoplamiento-componentes-contratos.md](../../../../../politicas-transversales/desacoplamiento-componentes-contratos.md)).

---

## Tests

- Componentes: React Testing Library + mocks de API.
- i18n: snapshot de claves `error.*` vs catálogo shared.
