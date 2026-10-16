# 36. Seguridad

- No publiques contraseñas, access tokens, refresh tokens ni archivos `.env` reales. Si se filtran, rótalos.
- Utiliza HTTPS en producción; el HTTP y `start-dev` de este laboratorio están limitados al desarrollo.
- Valida entradas en el backend aunque Flutter ya las revise.
- Utiliza consultas SQL parametrizadas; nunca formes SQL concatenando texto del usuario.
- Verifica firma, algoritmo permitido, emisor, audiencia y expiración de JWT.
- Asigna roles mínimos y comprueba el propietario en cada operación de tareas.
- Mantén corta la duración de access tokens; trata refresh tokens como credenciales sensibles.
- No coloques secretos de cliente en Flutter. Un binario distribuido puede inspeccionarse.
- Separa la base de identidad de la base de negocio y usa usuarios de aplicación con permisos limitados.
- Conserva puertos de desarrollo en loopback; no publiques bases de datos a Internet.
- Actualiza dependencias, revisa cambios y vuelve a ejecutar pruebas antes de promover versiones.
- Excluye tokens de capturas, logs, colecciones exportadas y ejemplos de soporte.

El laboratorio no incluye recuperación de cuenta, correo, TLS, proxy, protección contra fuerza bruta configurable para producción ni un sistema de auditoría transaccional. Antes de un despliegue real deben diseñarse y probarse estos aspectos; no basta con reutilizar `.env`.

**Prueba de permisos:** una cuenta `usuario` no puede acceder a `/admin/activity`; una cuenta `administrador` sí. Ambas gestionan solo sus propias tareas. La API nunca recibe roles confiables desde el cuerpo de una solicitud.
