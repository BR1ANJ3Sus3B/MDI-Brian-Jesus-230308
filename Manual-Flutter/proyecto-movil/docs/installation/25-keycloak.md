# 25. Keycloak

## ¿Qué es, para qué sirve y papel arquitectónico?

Servicio de **IAM**, gestión de identidades y accesos. Centraliza cuentas, sesiones y roles para no implementar contraseñas en cada API. Autenticar identifica al usuario; autorizar limita sus acciones.

**OAuth 2.0** delega acceso a recursos. **OpenID Connect** añade identidad sobre OAuth. Un **JWT** es un token firmado con claims; no está necesariamente cifrado. La API debe validarlo, no solo decodificarlo.

| Concepto | Uso en este proyecto |
| --- | --- |
| Realm | Espacio de identidad `app-mobile` |
| Client | Aplicación registrada: `flutter-mobile`, `postman` |
| User | Cuenta de una persona |
| Role | `usuario` o `administrador` |
| Group | Agrupación opcional de personas y roles |
| Token | Credencial temporal emitida tras autenticación |

## Requisitos, instalación y configuración

Docker, base de identidad y `.env` configurado. Compose usa Keycloak 26.8.0 e importa `infrastructure/keycloak/app-mobile-realm.json`. Abre `http://localhost:8080`, entra con `KEYCLOAK_ADMIN` y `KEYCLOAK_ADMIN_PASSWORD` de tu `.env`.

1. Selecciona realm **app-mobile**.
2. En Realm roles comprueba `usuario` y `administrador`.
3. En Clients comprueba `flutter-mobile`: cliente público, Standard flow activo, Direct access grants desactivado, PKCE S256.
4. Comprueba redirect URI exacta `com.example.appmobile:/oauthredirect` y post logout URI `com.example.appmobile:/logout`.
5. En los mappers del cliente verifica audience `mobile-api` en access token.
6. En Users crea `alumno`, habilítalo y define contraseña en Credentials; desactiva **Temporary** para la práctica.
7. En Role mapping asigna `usuario`. Crea otra cuenta y asigna `administrador` para pruebas de administración.
8. Crea una tercera cuenta sin ninguno de esos roles para comprobar 403.

No confundas el administrador de la consola con un usuario de la aplicación. El realm se importa solo si no existe; editar el JSON no actualiza automáticamente un realm persistido.

## Comandos y ejemplo práctico

```powershell
docker compose logs keycloak
```

En Postman usa OAuth 2.0 → **Authorization Code (With PKCE)**, cliente `postman`, callback `https://oauth.pstmn.io/v1/callback`, sin client secret, scope `openid profile email` y challenge S256. URLs:

- Authorize: `http://localhost:8080/realms/app-mobile/protocol/openid-connect/auth`
- Token: `http://localhost:8080/realms/app-mobile/protocol/openid-connect/token`

Pulsa **Get New Access Token**, inicia sesión con el usuario y úsalo como Bearer. No uses password grant en Flutter ni copies contraseñas al código.

## Verificación, errores comunes y soluciones

Revisa que `iss` coincida con `KEYCLOAK_ISSUER` y `aud` incluya `mobile-api`. Consulta `/me` y luego `/tasks`. Si no vuelve a Flutter revisa el redirect exacto. Si hay 401, revisa firma, emisor, audiencia y expiración; si hay 403, roles. El host público del emisor debe ser el mismo para el móvil y la API.

## Evidencia y conclusión

**E10:** realm, clientes y roles; **E21:** login y acceso permitido/rechazado sin mostrar tokens. [Contenedor](https://www.keycloak.org/getting-started/getting-started-docker), [OIDC](https://www.keycloak.org/securing-apps/oidc-layers), [hostname](https://www.keycloak.org/server/hostname).
