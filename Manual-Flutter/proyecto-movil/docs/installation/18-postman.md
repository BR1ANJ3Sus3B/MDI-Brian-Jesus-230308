# 18. Postman

## ¿Qué es, para qué sirve y papel arquitectónico?

Cliente HTTP para probar una API sin depender de la UI móvil. Ayuda a separar un fallo del backend de un problema de Flutter. No forma parte del servidor.

## Requisitos, instalación y configuración

Instala la aplicación de escritorio desde [Postman](https://www.postman.com/downloads/). Necesitas una API activa; retoma esta práctica después de levantar el backend.

Importa `postman/mobile.postman_collection.json` y `postman/local.postman_environment.json`. Una **Collection** agrupa solicitudes; un **Environment** guarda variables para un destino. Selecciona el entorno local; `{{base_url}}` representa `http://localhost:8000`.

## Comandos principales y ejemplo práctico

Postman se opera con **Send**. Prueba primero `GET http://localhost:8000/`. Luego configura Authorization → Bearer Token con el token obtenido en el capítulo 25. Los endpoints `/usuarios` requieren administrador.

```http
GET http://localhost:8000/usuarios
Authorization: Bearer TOKEN
```

```http
POST http://localhost:8000/usuarios
Content-Type: application/json
Authorization: Bearer TOKEN
```

En **Body → raw → JSON**:

```json
{"nombre":"Alex","correo":"alex@example.com"}
```

Headers describen la solicitud; Body contiene los datos. Un registro de `/usuarios` es un ejercicio de base de datos, no crea una cuenta Keycloak.

## Verificación, errores comunes y soluciones

GET debe responder 200 y POST 201; repetir correo da 409. Si hay 401 revisa el token; si hay 403 revisa el rol. Postman de escritorio no aplica CORS como un navegador. No confundas un error de conexión con una respuesta HTTP.

## Evidencia y conclusión

**E07:** método, URL, estado y JSON de respuesta, ocultando Authorization. Explica por qué probar primero la API reduce variables al depurar Flutter. [Primeros pasos oficiales](https://learning.postman.com/docs/getting-started/quick-start).
