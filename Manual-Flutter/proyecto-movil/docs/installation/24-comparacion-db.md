# 24. PostgreSQL frente a MongoDB

| Aspecto | PostgreSQL | MongoDB |
| --- | --- | --- |
| Modelo | Relacional, tablas | Documentos y colecciones |
| Relaciones | Claves foráneas y joins | Referencias o documentos embebidos |
| Estructura | Esquema explícito | Flexible, con validación opcional |
| Escalabilidad | Réplicas, partición y soluciones distribuidas | Réplicas y sharding |
| Casos de uso | Datos con integridad y relaciones | Documentos y eventos de estructura variable |
| Flexibilidad | Tipos, tablas y también JSON | Campos variables por documento |
| Consultas | SQL | Filtros y pipelines de agregación |

Ninguna opción es automáticamente más rápida. El diseño de índices, volumen, consultas y consistencia determina el resultado. Ambas admiten funciones más amplias que esta comparación inicial.

En el integrador `users`, `tasks` y `categories` requieren relaciones claras. Los eventos en MongoDB contienen actor, acción, tarea y fecha. Usar dos bases añade operaciones y mantenimiento: se justifica aquí para practicar necesidades distintas, no como requisito de toda aplicación.

**Actividad:** justifica en cinco líneas dónde guardarías pagos y dónde eventos de navegación. No uses “NoSQL es mejor” como argumento; describe consultas y garantías necesarias.
