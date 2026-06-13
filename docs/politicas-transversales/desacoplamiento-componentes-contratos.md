# Desacoplamiento entre componentes por contratos

**Última actualización:** 2026-06-12

Política transversal para que **cambiar la tecnología de un componente** (React, NestJS, PostgreSQL, etc.) afecte **solo a ese componente**, salvo cuando se modifique de forma consciente un **contrato** compartido.

> **Marco conceptual:** [vista-general.md](../planificacion/vista-general.md) (§3 contratos externos vs internos).  
> **Relacionado:** [desambiguacion-implementacion.md](desambiguacion-implementacion.md) (tres rutas «implementación»), [contratos-minimos.md](../arquitectura/contratos-minimos.md), [errores-validaciones-capas.md](../arquitectura/errores-validaciones-capas.md).

---

## Objetivo

Maximizar la independencia evolutiva de cada contenedor C4 (Front-End, Back-End, Persistencia, Shared, BBDD) **mediante contratos explícitos y estables**, de modo que:

- un cambio de framework, librería o motor **no obligue** a reescribir otro componente;
- el acoplamiento por stack (mismo lenguaje, mismo monorepo, mismo paquete compartido) quede **limitado y documentado**;
- las reglas de negocio sigan viviendo en `docs/entidades/` y en el pseudocódigo N4 canónico, **no** en detalles tecnológicos cruzados.

---

## Principio rector

| Tipo de cambio | Impacto esperado en otros componentes |
|----------------|----------------------------------------|
| Cambio **interno** de tecnología (mismos contratos en las fronteras) | **Ninguno** en código ni documentación del vecino |
| Cambio de **contrato** (API, puerto, esquema, código de error, semántica transaccional) | **Solo** en consumidores de ese contrato, con versionado explícito |
| Cambio de **regla de negocio** | Según trazabilidad UC/ZC; no es un cambio de stack |

La colaboración entre componentes **siempre** pasa por un contrato. El desacoplamiento no elimina fronteras; las **fija** fuera de la implementación.

---

## Fronteras y contratos

Cada par de componentes adyacentes tiene **un único tipo de contrato** como fuente de verdad lógica:

| Frontera | Contrato | Documentación de referencia | Implementa | Consume |
|----------|----------|----------------------------|------------|---------|
| Front-End ↔ Back-End | API REST (HTTP/JSON), DTOs, paginación, códigos de error | [contratos-minimos.md](../arquitectura/contratos-minimos.md), [errores-validaciones-capas.md](../arquitectura/errores-validaciones-capas.md) | Back-End | Front-End |
| Back-End ↔ Persistencia | Puertos de repositorio y conexión (`*RepositoryPort`, `DatabaseConnectionPort`) | [contratos-minimos.md](../arquitectura/contratos-minimos.md), pseudocódigo [zc-5-persistencia.md](../diagramas-c4/c4-nivel-4/pseudocodigo/zc-5-persistencia.md) | Persistencia | Back-End (dominio/aplicación) |
| Persistencia ↔ BBDD | Esquema relacional, migraciones, restricciones, políticas SQL | [modelo-entidad-relacion.md](../entidades/modelo-entidad-relacion.md), guía [bbdd/](../implementacion/bbdd/) | BBDD (+ SQL en Persistencia) | Persistencia |
| Front-End ↔ Back-End (tipos) | Catálogo estable de `codigo`, shapes de DTO | Shared **o** esquema/OpenAPI generado por contrato | Shared (artefacto) | Front-End, Back-End |
| Presentación ↔ usuario | i18n por `codigo` | [internacionalizacion.md](internacionalizacion.md) | Front-End | — |

**Regla:** la documentación agnóstica de un componente (`docs/implementacion/{componente}/`) **no** debe nombrar el stack del vecino como dependencia obligatoria. Solo referencia **contratos**.

---

## Restricciones transversales (obligatorias)

1. **Una tecnología por carpeta de código.** Cada componente vive en `implementacion/{componente}/{tecnologia}/`. Cambiar tecnología = nueva subcarpeta `{tecnologia}`; no mezclar frameworks en la misma ruta.

2. **Sin imports cruzados de implementación.** Un componente **no** importa código fuente de otro componente salvo **Shared** como artefacto de contrato (DTOs/códigos). En particular:
   - Front-End **no** importa Back-End, Persistencia ni BBDD.
   - Back-End **no** importa Persistencia concreta en dominio; solo **interfaces** de puerto.
   - Persistencia **no** importa NestJS, React ni controllers HTTP.

3. **Contratos antes que conveniencia del stack.** Preferir contrato explícito (OpenAPI, JSON Schema, interfaces de puerto documentadas) frente a acoplar dos componentes porque comparten TypeScript en monorepo. El monorepo es **organización**, no frontera arquitectónica.

4. **Errores por `codigo`, no por mensaje.** Back-End emite `codigo` estable; Front-End resuelve texto vía i18n. Cambiar librería de UI **no** exige cambiar textos en API.

5. **Serialización neutral en contrato.** Fechas, horas, enums y `null` vs campo omitido se definen en el contrato API/Shared; no dependen de convenciones implícitas de un framework.

6. **Negocio fuera de infraestructura.** Reglas RT-*, RO-*, RC-* permanecen en dominio y pseudocódigo canónico. SQL, componentes React y módulos Nest son **proyecciones**, no fuente de verdad funcional.

7. **Versionado de contratos breaking.** Si un DTO, puerto o columna cambia de forma incompatible, incrementar versión documentada del contrato y actualizar **solo** productores/consumidores de ese contrato. No propagar el cambio a componentes no afectados.

8. **Documentación N4 de implementación por componente.** La proyección técnica de cada ZC se documenta bajo la carpeta del **componente y tecnología** que la materializa (no bajo un pack indivisible del stack). Ver [desambiguacion-implementacion.md](desambiguacion-implementacion.md).

9. **Tests en la frontera.** Al cambiar tecnología en un componente, ejecutar pruebas de **contrato** (API, puertos, migraciones) en la frontera afectada; no re-ejecutar toda la suite del vecino salvo rotura de contrato.

---

## Restricciones por componente

### Front-End

- Consume **solo** API HTTP documentada; prohibido acceso directo a BBDD o puertos de persistencia.
- Cliente HTTP y mapeo vista ↔ DTO son responsabilidad interna; **no** filtrar lógica de negocio que pertenece a Back-End (unicidad, RT-*, materialización).
- Validación local: formato y RC-1/RC-2/RC-3 de interfaz; el resto delegado vía API.
- Cambiar SPA (p. ej. React → otro framework) **no** debe exigir cambios en Back-End si el contrato API se mantiene.

### Back-End

- Dominio y aplicación dependen de **puertos**, no de adaptadores concretos.
- Controllers/API traducen HTTP ↔ DTO; **no** exponen entidades de persistencia ni SQL.
- Orquestación transaccional (ZC-4) usa `DatabaseConnectionPort`; **no** APIs del driver SQL en aplicación.
- Cambiar framework HTTP (p. ej. NestJS → otro) **no** debe exigir cambios en Front-End ni en Persistencia si puertos y JSON se mantienen.

### Persistencia

- Implementa puertos definidos por Back-End; **no** redefine reglas de negocio.
- SQL y mappers son internos; errores técnicos se traducen a códigos acordados hacia aplicación, sin filtrar stack traces al exterior.
- **No** acoplar nombres de tablas/columnas al dominio más allá del mapper (el dominio usa lenguaje ubiquo, la BBDD el ER).
- Cambiar ORM/driver/librería SQL **no** debe exigir cambios en Front-End; en Back-End solo wiring/DI si los **puertos** no cambian.

### Shared

- **Solo** artefactos de contrato: DTOs, códigos de error, tipos de identificadores, constantes de API.
- **Prohibido:** lógica de negocio, SQL, componentes UI, imports de framework (Nest, React).
- Tratar Shared como **contrato materializado**, no como capa de dominio. Si Back-End deja de ser TypeScript, los DTOs deben poder **regenerarse** desde el mismo contrato lógico (OpenAPI/Schema) sin arrastrar al Front-End a reescribir negocio.
- Cambios en Shared que alteren shape o semántica de DTO = **cambio de contrato** → coordinar Front-End y Back-End.

### BBDD

- Esquema y migraciones alineados al ER; motor concreto solo en `implementacion/bbdd/{motor}/`.
- Políticas SQL (FAQ-116, UTC, cascadas) documentadas aquí; Persistencia las consume, **no** las redefine en Back-End.
- Cambiar motor (p. ej. PostgreSQL → otro) impacta **BBDD + Persistencia**; Front-End intacto; Back-End intacto si puertos y semántica transaccional equivalentes.

---

## Procedimiento: cambio de tecnología en un componente

Procedimiento detallado, sufijo `(obsoleto)` y excepciones de coexistencia: [cambio-tecnologia-componente.md](../stack-tecnologico/cambio-tecnologia-componente.md). Historial y stack activo: [historial-stack.md](../stack-tecnologico/historial-stack.md).

1. Confirmar que **no** se alteran contratos en frontera (API, puertos, ER) o planificar **nueva versión** de contrato.
2. **Renombrar** la carpeta de la tecnología saliente a `{tecnologia} (obsoleto)` en código y N4 (si existen).
3. **Crear** `implementacion/{componente}/{nueva-tecnologia}/` y, si aplica, proyección N4 en la ruta homóloga bajo `docs/diagramas-c4/.../implementacion/`.
4. Actualizar **solo** la documentación del componente afectado y [historial-stack.md](../stack-tecnologico/historial-stack.md).
5. **No** actualizar documentación de implementación de otros componentes salvo rotura de contrato.
6. Ejecutar pruebas de contrato en fronteras tocadas.

---

## Acoplamientos prohibidos

| Patrón | Por qué rompe el desacoplamiento |
|--------|----------------------------------|
| Front-End importa tipos/clases del Back-End | Acopla SPA al framework y despliegue del servidor |
| Dominio importa `pg`, TypeORM, Nest, React | Mezcla negocio con infraestructura |
| Persistencia expone SQL o filas crudas a la API | Salta capas y fija el motor en la frontera externa |
| Shared con servicios, validadores de negocio o hooks UI | Convierte contrato en dominio compartido |
| Documentar «el stack» como unidad indivisible en guías de un solo componente | Obliga a cambiar docs/código de vecinos al migrar una capa |
| Mensajes de error traducidos generados en Back-End para la UI | Acopla API al locale del cliente |

---

## Matriz de compatibilidad

Fuente de verdad central: [historial-stack.md](../stack-tecnologico/historial-stack.md) (stack activo + historial de cambios + coexistencia paralela).

Cada README de componente puede resumir la fila local (tecnología activa + versión de contratos). Ejemplo v1:

| Componente | Tecnología activa | Contratos |
|------------|-------------------|-----------|
| Front-End | `react-typescript` | API v1, errores v1 |
| Back-End | `nestjs-typescript` | API v1, puertos v1 |
| Persistencia | `typescript` | puertos v1, ER v1 |
| BBDD | `postgresql` | ER v1 |

Al cambiar solo Front-End, se actualiza su fila; las demás permanecen si API v1 no cambia.

---

## Checklist rápido antes de merge

- [ ] ¿El cambio está confinado a un componente o a un contrato documentado?
- [ ] ¿Algún import cruza frontera de implementación sin pasar por contrato?
- [ ] ¿Shared sigue sin lógica de negocio ni dependencias de framework?
- [ ] ¿Los DTO/códigos de error siguen alineados con [contratos-minimos.md](../arquitectura/contratos-minimos.md)?
- [ ] ¿La guía del componente evita nombrar tecnologías del vecino como requisito?

---

## Referencias

| Tema | Ubicación |
|------|-----------|
| Capas y puertos | [docs/arquitectura/](../arquitectura/) |
| Guías por componente | [docs/implementacion/](../implementacion/) |
| Código por componente | [implementacion/](../../implementacion/) |
| Pseudocódigo N4 canónico | [pseudocodigo/](../diagramas-c4/c4-nivel-4/pseudocodigo/) |
| Desambiguación de rutas | [desambiguacion-implementacion.md](desambiguacion-implementacion.md) |
| Historial de stack | [historial-stack.md](../stack-tecnologico/historial-stack.md) |
| Cambio de tecnología | [cambio-tecnologia-componente.md](../stack-tecnologico/cambio-tecnologia-componente.md) |
