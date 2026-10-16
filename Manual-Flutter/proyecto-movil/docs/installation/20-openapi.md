# 20. Swagger y OpenAPI

## ¿Qué son y para qué sirven?

**OpenAPI** es un formato de contrato que describe rutas, entradas, respuestas y autenticación. **Swagger UI** es una interfaz que interpreta ese contrato y permite probar operaciones. Resuelven la falta de una referencia compartida entre frontend, backend y pruebas.

## Papel, requisitos e instalación

Son parte de la documentación del backend. FastAPI genera OpenAPI automáticamente y publica Swagger y ReDoc. Express utiliza el contrato compartido en `docs/openapi.json` y el paquete `swagger-ui-express`; no genera documentación automáticamente a partir de cualquier ruta.

## Configuración y comandos principales

Con la API activa, abre:

- `http://localhost:8000/docs`: Swagger UI en ambas alternativas.
- `http://localhost:8000/openapi.json`: contrato JSON.
- `http://localhost:8000/redoc`: ReDoc, disponible en FastAPI.

```powershell
Invoke-RestMethod http://localhost:8000/openapi.json
```

## Ejemplo práctico

En Swagger selecciona GET `/`, pulsa **Try it out** y **Execute**. Para `/tasks`, usa **Authorize** y pega el access token, sin el prefijo `Bearer` cuando la interfaz usa el esquema HTTP bearer. Ejecuta una creación con título válido y otra con título vacío.

## Verificación, errores comunes y soluciones

Compara el contrato con la respuesta real. Si aparece 401, renueva el token; la documentación no evita autenticación. Si una ruta Express cambia, actualiza el contrato compartido y las pruebas. Un ejemplo documentado no demuestra que el endpoint funcione.

## Evidencia y conclusión

**E06:** endpoint, esquema, solicitud y respuesta. Explica por qué OpenAPI y Swagger no son sinónimos. [OpenAPI](https://spec.openapis.org/oas/latest.html), [documentación FastAPI](https://fastapi.tiangolo.com/tutorial/first-steps/).
