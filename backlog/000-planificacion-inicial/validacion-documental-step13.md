# Validación documental — Step 13

**Fecha inicial:** 2026-06-12  
**Re-validación:** 2026-06-12 (corrección FAQ legacy + N4 shared)  
**Alcance:** coherencia global entre entidades, ER, C4, arquitectura, stack, N4 (12a), guías de implementación (12b) y plan/FAQ.  
**Resultado:** **Aprobado** — documentación lista para **Ticket 001** (bootstrap técnico sin lógica de negocio).

Referencia de checklist: [vista-general.md](../vista-general.md) §6.

---

## 1. Checklist §6 — contratos externos

| Ítem | Estado | Evidencia |
|------|--------|-----------|
| API/DTOs alineados a contratos-minimos | OK | [`contratos-minimos.md`](../../docs/arquitectura/contratos-minimos.md); N4 shared [`contratos-api-dtos.md`](../../docs/diagramas-c4/c4-nivel-4/implementacion/shared/typescript/contratos-api-dtos.md); código Ticket 001 |
| Puertos definidos; dominio sin SQL | OK | [`granularidad-modulos-negocio.md`](../../docs/arquitectura/granularidad-modulos-negocio.md), [`back-end/README.md`](../../docs/implementacion/back-end/README.md) § dependencias, pseudocódigo ZC-5 |
| ER cerrado | OK | [`modelo-entidad-relacion.md`](../../docs/entidades/modelo-entidad-relacion.md) (Step 10); FAQ-300–311 |
| Códigos de error estables; i18n en FE | OK | [`errores-validaciones-capas.md`](../../docs/arquitectura/errores-validaciones-capas.md), N4 shared § catálogo; [`internacionalizacion.md`](../../docs/politicas-transversales/internacionalizacion.md) |
| Política desacoplamiento | OK | [`desacoplamiento-componentes-contratos.md`](../../docs/politicas-transversales/desacoplamiento-componentes-contratos.md) |

---

## 2. Checklist §6 — contratos internos

| Ítem | Estado | Evidencia |
|------|--------|-----------|
| ZC canónicas (pseudocódigo) | OK | ZC-1 … ZC-6 en [`pseudocodigo/`](../../docs/diagramas-c4/c4-nivel-4/pseudocodigo/) |
| N4 implementación por componente (12a) | OK | [`c4-nivel-4/implementacion/`](../../docs/diagramas-c4/c4-nivel-4/implementacion/README.md) — FE, BE, persistencia, **shared**, BBDD |
| Granularidad de módulos | OK | [`granularidad-modulos-negocio.md`](../../docs/arquitectura/granularidad-modulos-negocio.md) |
| Guías por componente (12b) | OK | [`docs/implementacion/`](../../docs/implementacion/README.md) — 5 README con 5 secciones cada uno |
| Árbol de código acordado | OK | [`implementacion/README.md`](../../implementacion/README.md) — estructura por componente/tecnología |

---

## 3. Checklist §6 — plan y stack

| Ítem | Estado | Evidencia |
|------|--------|-----------|
| Plan y FAQ al día | OK | [`planificacion-inicial.md`](planificacion-inicial.md), [`dudas-y-resoluciones.md`](dudas-y-resoluciones.md) (grupos FAQ-Gnn; historial con IDs vigentes) |
| Stack activo registrado | OK | [`historial-stack.md`](../../docs/stack-tecnologico/historial-stack.md), FAQ-100/101 |

---

## 4. Matriz de coherencia (muestra)

| Capa | Entidades / ER | C4 / ZC | N4 12a | Guía 12b |
|------|----------------|---------|--------|----------|
| Consulta ocurrencias | [`ocurrencias.md`](../../docs/entidades/ocurrencias.md), ER | ZC-1 | BE `zc-1-*` | BE, FE (calendario) |
| Materialización | FAQ-002/003 herencia | ZC-2 | BE `zc-2-*` | BE, persistencia |
| Planificación temporal | [`planificaciones.md`](../../docs/entidades/planificaciones.md) | ZC-3 | BE `zc-3-*` | BE, FE (formularios) |
| Orquestación / wizard | UC-01.* | ZC-4 | BE `zc-4-*` | BE |
| Persistencia | ER tablas | ZC-5 | persistencia + BBDD | persistencia, bbdd |
| Presentación | UC-01/02/03 | ZC-6 | FE `zc-6-*` | front-end |
| DTOs / errores | contratos-minimos | — | shared `contratos-api-dtos` | shared |

Trazabilidad UC ↔ ZC: distribuida en casos de uso y pseudocódigo (FAQ-201). Sin fichero central — coherente con decisión de diseño.

---

## 5. Cobertura N4 vs canónico

| ZC / ámbito | Pseudocódigo / canónico | N4 Step 12a |
|-------------|-------------------------|-------------|
| ZC-1 | ✓ | ✓ back-end |
| ZC-2 | ✓ | ✓ back-end |
| ZC-3 | ✓ | ✓ back-end |
| ZC-4 | ✓ | ✓ back-end |
| ZC-5 | ✓ | ✓ persistencia + bbdd (esquema) |
| ZC-6 | ✓ | ✓ front-end |
| Contratos API/DTOs | [`contratos-minimos.md`](../../docs/arquitectura/contratos-minimos.md) | ✓ shared (sin ZC) |

Cada fichero N4 de ZC enlaza al canónico en `pseudocodigo/` ([`implementacion/README`](../../docs/diagramas-c4/c4-nivel-4/implementacion/README.md) regla 1). Shared enlaza a contratos-minimos y errores-validaciones-capas.

---

## 6. Hallazgos y alcance fuera de Step 13

| ID | Tipo | Descripción | Acción |
|----|------|-------------|--------|
| H-1 | Esperado | Código ejecutable (Nest, Vite, migraciones, DTOs en TS) aún no bootstrap | **Ticket 001** |
| H-2 | Esperado | Tests automatizados de integración | Post-bootstrap / implementación UC |
| H-3 | ~~Menor~~ **Resuelto** | IDs FAQ legacy en historial | Historial reescrito con IDs vigentes + mapa legacy |
| H-4 | ~~Menor~~ **Resuelto** | `shared/` sin carpeta N4 documental | N4 en `shared/typescript/` (contratos-api-dtos) |

No se detectan **contradicciones** entre ER, entidades funcionales, pseudocódigo ZC, guías 12b y N4 shared en los ejes revisados.

---

## 7. Conclusión

La documentación cumple el checklist de [vista-general.md](../vista-general.md) §6 para **iniciar Ticket 001** (andamiaje monorepo, arranque, migraciones, wiring DI) **sin implementar reglas de negocio** hasta completar el bootstrap.

**Step 13:** cerrado (2026-06-12; re-validado tras corrección FAQ + N4 shared).  
**Siguiente:** [Ticket 001 — Bootstrap](../001-bootstrap/README.md) — bootstrap en `implementacion/`.
