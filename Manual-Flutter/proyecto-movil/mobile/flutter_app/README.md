# Aplicación Flutter de tareas

Cliente Android del laboratorio: login Keycloak con PKCE, almacenamiento seguro de sesión, renovación del token, perfil y CRUD de tareas. El frontend nunca conecta directamente con las bases de datos.

Configura Keycloak y ADB siguiendo [la integración](../../docs/installation/32-integracion-keycloak.md). Desde esta carpeta:

```powershell
flutter pub get
```

```powershell
flutter run --dart-define=API_URL=http://localhost:8000 --dart-define=ISSUER=http://localhost:8080/realms/app-mobile
```

El redirect está registrado como `com.example.appmobile:/oauthredirect`. El modo debug permite HTTP para el laboratorio; una distribución real requiere HTTPS y firma de publicación. El proyecto incluye Android; iOS y web requieren configuración adicional y no se presentan como plataformas verificadas.

`lib/services` realiza HTTP y OIDC; `lib/controllers` gestiona estado; `lib/models` convierte JSON; `lib/main.dart` construye las pantallas.
