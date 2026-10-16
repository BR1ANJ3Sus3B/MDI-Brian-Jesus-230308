# 39. Actividad final: gestión de tareas

## Producto esperado

Una aplicación Android en Flutter con login, lista, creación, edición, eliminación, perfil y cierre de sesión. El backend elegido ofrece:

| Método | Ruta | Acceso |
| --- | --- | --- |
| GET | `/` | Público, información básica |
| GET | `/health` | Público, salud de bases |
| GET | `/me` | Token válido |
| GET | `/tasks` | Usuario/administrador, tareas propias |
| POST | `/tasks` | Usuario/administrador |
| PUT | `/tasks/{id}` | Propietario |
| DELETE | `/tasks/{id}` | Propietario |
| GET | `/categories` | Usuario/administrador |
| GET / POST | `/usuarios` | Administrador, ejercicio de usuarios |
| GET | `/admin/activity` | Administrador |

PostgreSQL contiene `users`, `tasks` y `categories`; `usuarios` es una tabla educativa independiente. MongoDB contiene `activity` y `logs`. Keycloak contiene cuentas y roles, sin guardar contraseñas en la tabla `users` de aplicación.

## Procedimiento de entrega

1. Configura `.env` y levanta la alternativa elegida con Compose.
2. Crea dos cuentas `usuario`, una `administrador` y una sin roles de aplicación.
3. Prepara ADB reverse y ejecuta Flutter.
4. Inicia sesión como alumno, crea “Preparar exposición”, edítala, márcala completada y recarga.
5. Comprueba la fila en PostgreSQL y eventos en MongoDB.
6. Inicia sesión con otra cuenta y demuestra que no ve ni modifica la tarea anterior.
7. Prueba 401 sin token y 403 con la cuenta sin roles.
8. Reinicia el backend conservando volúmenes y verifica persistencia.
9. Elimina la tarea, comprueba el evento y cierra sesión.
10. Publica código y evidencias revisadas en GitHub mediante PR.

```powershell
docker compose up -d
```

Flutter se ejecuta en Android desde el SDK; Compose ejecuta **todo el backend**, no un emulador Android.

## Flujo que debe demostrarse

Usuario → Flutter → Keycloak → JWT → API → PostgreSQL/MongoDB → respuesta → Flutter.

## Límites explicados

La escritura de la tarea y la auditoría no son atómicas entre ambas bases. Si MongoDB falla después del commit SQL, se devuelve éxito con `audit_recorded: false` y Flutter avisa. Esto evita informar un fracaso de creación cuando la tarea sí existe. Una entrega que requiera auditoría garantizada deberá añadir y probar un patrón outbox o una cola con reintentos.

La lista es pequeña y no implementa paginación. La autenticación utiliza navegador y almacenamiento seguro; las pruebas unitarias no sustituyen la demostración en dispositivo. Las credenciales y capturas reales las aporta el estudiante.

## Evaluación propuesta

| Área | Puntos |
| --- | --- |
| Instalación y conceptos | 20 |
| API y persistencia | 25 |
| Autenticación y permisos | 20 |
| Flutter y manejo de errores | 20 |
| GitHub, evidencias y explicación | 15 |
