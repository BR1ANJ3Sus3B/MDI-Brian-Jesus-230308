# 33. Plan de pruebas

| Prueba | Herramienta | Resultado esperado |
| --- | --- | --- |
| Entorno Flutter | `flutter doctor -v` | Sin pendientes que impidan Android |
| Dispositivo | `flutter devices` | Android disponible |
| API activa | GET `/` | 200 y nombre de backend |
| Dependencias | GET `/health` | PostgreSQL y MongoDB `ok` |
| Swagger | Navegador `/docs` | Contrato y ejecución |
| PostgreSQL | psql SELECT | Tarea persistida con propietario |
| MongoDB | mongosh find | Eventos create/update/delete |
| Keycloak | Discovery OIDC | Issuer y claves disponibles |
| Token válido | GET `/tasks` | 200 con rol adecuado |
| Token ausente/alterado/vencido | Postman | 401 |
| Rol insuficiente | Cuenta sin roles | 403 |
| Otro propietario | PUT tarea de otra cuenta | 404 y ningún cambio |
| Datos inválidos | POST título vacío | 400 |
| Correo duplicado | POST `/usuarios` dos veces | 409 en segundo intento |
| Docker | `docker version` | Client y Server |
| Compose | `docker compose ps` | Servicios activos |
| Flutter y API | Crear y recargar | Tarea visible |
| Persistencia | Reiniciar servicios | Tarea conservada |

## Pruebas automatizadas

Desde `backend`:

```powershell
.\.venv\Scripts\python.exe -m pytest -q
```

Desde `backend-node`:

```powershell
npm.cmd test
```

Desde `mobile/flutter_app`:

```powershell
flutter analyze
```

```powershell
flutter test
```

Estas pruebas comprueban validación, JWT y manejo de solicitudes con dependencias controladas. No reemplazan las pruebas con contenedores reales ni la interacción del navegador OAuth.

Desde `proyecto-movil` puedes ejecutar la prueba de integración después de obtener un token de usuario en Postman. El script solicita el token sin imprimirlo:

```powershell
python scripts/smoke.py
```

El script crea una tarea propia, la edita y la elimina; comprueba 401 y entrada inválida. No uses datos de producción. Para comprobar permisos entre usuarios, sigue la tabla manual con dos cuentas diferentes.

Consulta [VERIFICACION](../evidence/VERIFICACION.md) para distinguir resultados ejecutados de resultados todavía pendientes. **E24:** comando, resultado real y alcance de la prueba.
