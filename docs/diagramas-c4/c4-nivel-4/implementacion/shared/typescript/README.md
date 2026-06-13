# N4 — Shared (TypeScript)

**Componente:** Shared (tipos y contratos FE/BE)  
**Tecnología:** TypeScript 5  
**Código:** [`implementacion/shared/typescript/`](../../../../../../implementacion/shared/typescript/)  
**Canónico:** [contratos-minimos.md](../../../../../arquitectura/contratos-minimos.md) (contratos API/DTOs; **sin pseudocódigo ZC**)

> Shared **no implementa zonas críticas**. Materializa contratos externos estables consumidos por Front-End y Back-End.

---

## Compatibilidad

| Campo | Valor |
|-------|-------|
| Estado | **activa** |
| Contratos | API v1, errores v1, DTOs shared v1 |

Registro: [historial-stack.md](../../../../../stack-tecnologico/historial-stack.md).

---

## Mapeo lógico → artefactos

Rutas previstas bajo `implementacion/shared/typescript/src/`:

| Contrato lógico | Artefacto TS | Ruta prevista |
|-----------------|--------------|---------------|
| `CrearProyectoInput` | interface/type | `dto/proyecto/crear-proyecto.input.ts` |
| `ProyectoOutput` | interface/type | `dto/proyecto/proyecto.output.ts` |
| `ListaProyectoOutput` | interface/type | `dto/proyecto/lista-proyecto.output.ts` |
| `CrearItemInput` … `ListaItemOutput` | interfaces | `dto/item/*.ts` |
| DTOs planificación / ocurrencia | interfaces | `dto/planificacion/*.ts`, `dto/ocurrencia/*.ts` |
| `ListaOcurrenciaOutput` | interface/type | `dto/ocurrencia/lista-ocurrencia.output.ts` |
| Catálogo `ErrorCode` | const enum / union | `errors/error-codes.ts` |
| Payload RE-5 `bloqueos` | interfaces | `dto/common/eliminacion-bloqueada.payload.ts` |
| Paginación, rango fechas, IDs | tipos transversales | `dto/common/paginacion.ts`, `rango-fechas.ts`, `ids.ts` |

Detalle completo: [contratos-api-dtos.md](contratos-api-dtos.md).

---

## Documentos N4

| Ámbito | Fichero |
|--------|---------|
| Contratos API/DTOs y códigos | [contratos-api-dtos.md](contratos-api-dtos.md) |

*(Sin filas ZC: Shared no traduce pseudocódigo de zonas críticas.)*

---

## Referencias

- Canónico arquitectura: [contratos-minimos.md](../../../../../arquitectura/contratos-minimos.md)
- Códigos de error: [errores-validaciones-capas.md](../../../../../arquitectura/errores-validaciones-capas.md)
- Guía agnóstica: [docs/implementacion/shared/](../../../../../implementacion/shared/)
- i18n: [internacionalizacion.md](../../../../../politicas-transversales/internacionalizacion.md)
