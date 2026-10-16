# 30. Variables de entorno y secretos

`.env` contiene configuración local de Compose. `.env.example` documenta los nombres y valores iniciales sin secretos reales. `.gitignore` excluye el archivo real; no elimina secretos que ya se hayan publicado.

Desde `proyecto-movil`:

```powershell
Copy-Item .env.example .env
```

Antes de iniciar sustituye cada valor `cambiar_...` por una contraseña propia. Para este laboratorio puedes generar cadenas hexadecimales con tu gestor de contraseñas; así evitas problemas de caracteres reservados en URLs y scripts.

| Variable | Significado |
| --- | --- |
| POSTGRES_DB | Base de aplicación: `app_mobile` |
| POSTGRES_USER | Usuario limitado del backend: `developer` |
| POSTGRES_PASSWORD | Contraseña de ese usuario |
| POSTGRES_ADMIN_PASSWORD | Administración del contenedor PostgreSQL |
| MONGO_URL | Dirección interna: `mongodb://mongo:27017/app_mobile` |
| MONGO_USER / MONGO_PASSWORD | Autenticación de la aplicación MongoDB |
| KEYCLOAK_URL | Dirección interna de identidad: `http://keycloak:8080` |
| KEYCLOAK_PUBLIC_URL | Dirección del navegador: `http://localhost:8080` |
| BACKEND_CONTEXT | `../backend` o `../backend-node` |

Los drivers reciben usuario/contraseña Mongo por separado; `MONGO_URL` sin contraseña no desactiva la autenticación. El backend recibe las variables expresamente enumeradas en Compose. Una variable en `.env` no entra automáticamente a todos los contenedores.

```powershell
git check-ignore .env
```

Debe mostrar `.env`. No compartas la salida completa de `docker compose config`, pues puede incluir secretos. Si publicaste uno, rótalo aunque borres el archivo.

**E23:** nombres de variables y prueba de exclusión, con valores ocultos. [Variables en Compose](https://docs.docker.com/compose/how-tos/environment-variables/variable-interpolation/).
