# 32. Integración Flutter y Keycloak

## Secuencia implementada

1. Flutter abre el navegador mediante `flutter_appauth`.
2. Keycloak autentica; AppAuth canjea el código con PKCE.
3. `AuthService` guarda tokens en `flutter_secure_storage`, no en texto dentro del repositorio.
4. `ApiService` agrega el access token al encabezado Bearer.
5. La API valida RS256, firma JWKS, `iss`, `aud`, `exp` y presencia de `sub` e `iat`.
6. Los roles y el propietario determinan qué recurso puede utilizarse.

`401` indica autenticación no aceptada. `403` indica identidad aceptada sin permisos suficientes. La UI no puede concederse roles modificando JSON.

## Ruta recomendada: Android por USB o emulador con ADB

Con Compose iniciado, agrega Platform Tools al PATH y ejecuta:

```powershell
adb devices
```

```powershell
adb reverse tcp:8000 tcp:8000
```

```powershell
adb reverse tcp:8080 tcp:8080
```

```powershell
adb reverse --list
```

Si hay varios dispositivos, usa `adb -s ID_DEL_DISPOSITIVO reverse ...`. Este puente hace que `localhost:8000` y `localhost:8080` del Android lleguen a la computadora. Debes restablecerlo tras desconectar o reiniciar.

Conserva `KEYCLOAK_PUBLIC_URL=http://localhost:8080` en `.env`. Desde `mobile/flutter_app`:

```powershell
flutter run -d ID_DEL_DISPOSITIVO --dart-define=API_URL=http://localhost:8000 --dart-define=ISSUER=http://localhost:8080/realms/app-mobile
```

El emulador Android también puede acceder al anfitrión con `10.0.2.2`, pero no mezcles un issuer `localhost` con otro `10.0.2.2`: el emisor del token debe coincidir exactamente. La ruta ADB evita esa diferencia para esta práctica.

## Configuración Android incluida

- Permiso INTERNET en el manifest principal.
- `appAuthRedirectScheme=com.example.appmobile` en Gradle.
- Callback exacto registrado en Keycloak.
- HTTP permitido solo en el manifest **debug** y en AppAuth cuando `kDebugMode` es verdadero.
- Copias de seguridad deshabilitadas para evitar restaurar credenciales cifradas en otro contexto.

## Alternativa por Wi-Fi

El teléfono necesita la IP LAN de la computadora, puertos accesibles por firewall y un issuer público consistente. Compose publica por defecto en `127.0.0.1`; para una LAN de laboratorio debes cambiar esos enlaces conscientemente. No basta con cambiar la URL Flutter. Para despliegues reales utiliza DNS, HTTPS, proxies y un Keycloak configurado para producción.

## Verificación, errores y evidencia

Inicia sesión, abre perfil, crea una tarea y cierra sesión. Después de cinco minutos comprueba renovación o reautenticación. Cancelar el navegador debe volver a la pantalla sin bloquearla. **E21:** flujo sin mostrar credenciales; **E14:** respuesta en Flutter. El cierre local siempre borra la sesión; si no se puede cerrar el navegador, aparece un aviso.

Fuentes: [Flutter AppAuth](https://pub.dev/packages/flutter_appauth), [almacenamiento seguro](https://pub.dev/packages/flutter_secure_storage), [ADB](https://developer.android.com/tools/adb).
