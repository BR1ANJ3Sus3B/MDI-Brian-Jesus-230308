# Integración de videos: Facebook + TikTok + Instagram

La aplicación fue adaptada para mostrar **solo videos**.

## Dependencias necesarias en pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: any
  intl: any
  video_player: any
  http: any
  webview_flutter: any
```

Ejecuta después:

```bash
flutter pub get
```

## Credenciales de desarrollo

Ejecuta Flutter con los valores entregados por cada plataforma:

```bash
flutter run \
  --dart-define=FACEBOOK_PAGE_ID=TU_PAGE_ID \
  --dart-define=FACEBOOK_ACCESS_TOKEN=TU_PAGE_TOKEN \
  --dart-define=INSTAGRAM_USER_ID=TU_IG_USER_ID \
  --dart-define=INSTAGRAM_ACCESS_TOKEN=TU_IG_TOKEN \
  --dart-define=TIKTOK_ACCESS_TOKEN=TU_TIKTOK_TOKEN
```

En PowerShell usa una sola línea o el carácter de continuación `` ` ``.

## Permisos / productos

- TikTok: Login Kit + Display API y scope `video.list`.
- Instagram: cuenta profesional compatible, token válido y permisos de lectura necesarios para la cuenta autorizada.
- Facebook: Page ID, Page Access Token y permisos de lectura de contenido/engagement según el caso.

## Importante para producción

No publiques tokens dentro del APK. Para producción, mueve las llamadas y tokens a un backend propio y devuelve a Flutter un JSON normalizado.

## Comportamiento

- Instagram: reproduce el `media_url` de publicaciones `VIDEO`.
- TikTok: usa `embed_link`, porque Display API no entrega un MP4 directo.
- Facebook: Graph API v26 ya no permite leer `/{page_id}/videos`; se lee el feed de la Page, se filtran attachments de tipo video y se abre el permalink oficial dentro de un WebView.
