# Cambio de tecnología en un componente

**Última actualización:** 2026-06-12

Instrucciones para **sustituir** la tecnología de un contenedor (Front-End, Back-End, Persistencia, Shared, BBDD) **sin arrastrar** al resto, salvo cambio de contrato compartido.

> **Historial y stack activo:** [historial-stack.md](historial-stack.md)  
> **Desacoplamiento por contratos:** [desacoplamiento-componentes-contratos.md](../politicas-transversales/desacoplamiento-componentes-contratos.md)

---

## Alcance

Aplica a **código** y **documentación N4 de implementación** (Step 12a+):

| Ámbito | Patrón de ruta |
|--------|----------------|
| Código | `implementacion/{componente}/{tecnologia}/` |
| N4 implementación | `docs/diagramas-c4/c4-nivel-4/implementacion/{componente}/{tecnologia}/` |

Las guías agnósticas en `docs/implementacion/{componente}/` **no** llevan subcarpeta por tecnología; actualizarlas solo si cambian prácticas transversales del componente.

---

## Convención `(obsoleto)` — regla general

Al **sustituir** una tecnología por otra en el mismo componente (caso habitual: React → Vue):

1. **Renombrar** todas las carpetas de la tecnología saliente añadiendo el sufijo **` (obsoleto)`** (espacio + paréntesis, minúsculas, sin tilde en el slug).
2. **Crear** la carpeta de la tecnología entrante con el slug acordado **sin** `(obsoleto)`.
3. **No borrar** carpetas obsoletas salvo decisión explícita del equipo (referencia histórica y trazabilidad de documentación).

### Ejemplo (Front-End)

| Antes | Después (sustitución) |
|-------|------------------------|
| `implementacion/front-end/react-typescript/` | `implementacion/front-end/react-typescript (obsoleto)/` |
| — | `implementacion/front-end/vue-typescript/` *(nueva activa)* |

Mismo renombrado en N4:

| Antes | Después |
|-------|---------|
| `docs/.../implementacion/front-end/react-typescript/` | `docs/.../implementacion/front-end/react-typescript (obsoleto)/` |
| — | `docs/.../implementacion/front-end/vue-typescript/` |

El sufijo identifica **a qué tecnología se refiere** el contenido histórico (código, ZC traducidas, README de mapeo).

### Nomenclatura del slug

- Mantener el slug existente del proyecto (`react-typescript`, `nestjs-typescript`, `postgresql`, …).
- El sufijo `(obsoleto)` se **añade al final del nombre de carpeta completo**, no se traduce el framework al español en la ruta (p. ej. **`react-typescript (obsoleto)`**, no `React (obsoleto)` como nombre de carpeta raíz).

### Qué renombrar

En **ambos** árboles (código y N4 del componente):

- Toda la carpeta `{tecnologia}` saliente → `{tecnologia} (obsoleto)`.
- No mezclar archivos activos y obsoletos en la misma carpeta.

---

## Procedimiento paso a paso (sustitución)

1. **Decidir alcance:** ¿solo cambio interno de tecnología o también cambio de contrato? Si hay breaking change, versionar contrato (API v2, ER v2, …) y actualizar consumidores afectados.
2. **Registrar intención** en [historial-stack.md](historial-stack.md) (fila planificada o PR).
3. **Renombrar** carpetas salientes a `{tecnologia} (obsoleto)` en código y N4 (si ya existen).
4. **Crear** `{nueva-tecnologia}/` e implementar o documentar proyección N4 enlazando al [pseudocódigo canónico](../diagramas-c4/c4-nivel-4/pseudocodigo/).
5. **Actualizar** [historial-stack.md](historial-stack.md): stack activo + fila en historial de cambios.
6. **Actualizar** README del componente (matriz de compatibilidad: tecnología activa + versión de contratos).
7. **Ejecutar** pruebas de contrato en fronteras del componente (API, puertos, migraciones).
8. **No modificar** carpetas de otros componentes salvo rotura de contrato documentada.

---

## Excepciones: coexistencia de dos tecnologías activas

En algunos componentes puede ser **deseado** mantener **dos tecnologías activas a la vez**, sin marcar ninguna como `(obsoleto)`.

### Caso de uso principal: BBDD

Compatibilizar **PostgreSQL y MySQL** (u otros motores) con el **mismo ER lógico** pero dialectos o migraciones distintas:

```
implementacion/bbdd/
├── postgresql/          # activa
└── mysql/               # activa (paralela)
```

```
docs/.../implementacion/bbdd/
├── postgresql/
└── mysql/
```

**Requisitos:**

| Requisito | Detalle |
|-----------|---------|
| Registro explícito | Tabla **Coexistencia paralela** en [historial-stack.md](historial-stack.md) |
| Contrato ER | Mismo modelo lógico; documentar divergencias de dialecto (tipos, índices, FAQ-311, etc.) |
| Persistencia | Adaptadores por motor; Back-End sigue usando **puertos**, no SQL directo |
| Sin `(obsoleto)` | Ninguna de las carpetas paralelas lleva sufijo `(obsoleto)` mientras sigan activas |
| Despliegue | Documentar qué motor usa cada entorno (dev/staging/prod) |

Al **retirar** uno de los motores paralelos, **entonces** sí aplicar el procedimiento de sustitución: renombrar la carpeta del motor retirado a `{motor} (obsoleto)`.

### Otros componentes

Por defecto **una sola tecnología activa** por componente. Coexistencia paralela en Front-End, Back-End, Persistencia o Shared requiere:

- Entrada explícita en **Coexistencia paralela** de [historial-stack.md](historial-stack.md).
- Justificación (p. ej. migración gradual, A/B, soporte legacy acotado).
- Contratos versionados o perfiles de despliegue claramente separados.

Sin registro en historial, **no** se considera válida la coexistencia de dos carpetas activas sin `(obsoleto)`.

---

## Resumen de reglas

| Situación | Carpetas | `(obsoleto)` |
|-----------|----------|--------------|
| Sustitución (Vue reemplaza a React) | Una activa + una o más obsoletas | Sí, en la tecnología **saliente** |
| Coexistencia paralela (PG + MySQL) | Varias activas | **No** entre paralelas |
| Retirar una de dos paralelas | Una activa + una obsoleta | Sí, en la **retirada** |
| Cambio solo de versión menor (React 18 → 19) | Misma carpeta o política de equipo | Opcional: renombrar carpeta solo si el slug cambia (`react-typescript` → nuevo slug) |

---

## Referencias

| Tema | Ubicación |
|------|-----------|
| FAQ-102 | [dudas-y-resoluciones.md](../planificacion/dudas-y-resoluciones.md) |
| Desambiguación rutas | [desambiguacion-implementacion.md](../politicas-transversales/desambiguacion-implementacion.md) |
| N4 por componente | [c4-nivel-4/implementacion/README.md](../diagramas-c4/c4-nivel-4/implementacion/README.md) |
