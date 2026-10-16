# 17. Fundamentos de HTTP y REST

HTTP define intercambios entre cliente y servidor. HTTPS agrega cifrado TLS para protegerlos en tránsito. Una **request** contiene método, dirección, encabezados y opcionalmente cuerpo; una **response** contiene estado, encabezados y cuerpo.

JSON representa objetos, listas, números, booleanos y texto. Ejemplo de tarea: `{"title":"Preparar entorno","completed":false}`. No admite comentarios ni comas finales.

| Método | Intención | Ejemplo |
| --- | --- | --- |
| GET | Consultar | `/tasks` |
| POST | Crear | `/tasks` con JSON |
| PUT | Reemplazar campos del recurso según contrato | `/tasks/3` |
| PATCH | Modificar parcialmente | No implementado en este proyecto |
| DELETE | Eliminar | `/tasks/3` |

| Estado | Significado en el laboratorio |
| --- | --- |
| 200 | Operación o consulta correcta |
| 201 | Recurso creado |
| 400 | Entrada inválida |
| 401 | Token ausente, inválido o vencido |
| 403 | Identidad válida sin el rol requerido |
| 404 | Recurso inexistente o fuera del alcance del usuario |
| 409 | Conflicto, por ejemplo correo repetido |
| 500 | Error inesperado del servidor |
| 503 | Dependencia temporalmente no disponible |

REST es un estilo de diseño, no un formato de archivo. La API no confía en un `user_id` enviado por Flutter: obtiene el propietario del token validado. Los errores deben explicar el problema sin devolver contraseñas, trazas internas ni tokens.

**Práctica:** identifica método, URL, encabezados, cuerpo y estado en E07. [Referencia HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview).
