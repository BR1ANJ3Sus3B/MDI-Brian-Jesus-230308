# Videos públicos y locales

El feed usa tres APIs reales sin claves ni cuentas:

- NASA Image and Video Library: búsqueda `/search` y archivos MP4 con `/asset/{id}`. [Documentación](https://images.nasa.gov/docs/images.nasa.gov_api_docs.pdf).
- Internet Archive: `/advancedsearch.php` busca películas de Prelinger y `/metadata/{id}` obtiene sus MP4. [Documentación](https://archive.org/developers/md-read.html).
- Wikimedia Commons: `/w/api.php` consulta `videoinfo` y sus variantes WebM/MP4. [Documentación](https://www.mediawiki.org/wiki/Extension:TimedMediaHandler/API).

Se retiraron las instrucciones de credenciales y el reproductor externo de las integraciones anteriores. No se necesitan tokens.

Los MP4 de `assets/videos/` se descubren desde AssetManifest. Después de agregar archivos, reinicia la aplicación para regenerar el manifiesto. Los archivos están ignorados por Git: otra computadora deberá copiarlos a esa carpeta.

La primera página local no espera a Internet. Después se intercalan videos locales y públicos. Cada API tiene un límite de espera independiente; una fuente fallida no impide cargar las otras. La sesión consulta hasta ocho páginas remotas (dos resultados por fuente y página), además de todos los archivos locales. Reiniciar el feed permite consultar nuevamente las fuentes.

Los videos empiezan silenciados para permitir autoplay web. El botón de altavoz activa o desactiva el sonido y conserva la selección al deslizar. Tocar el video pausa o reanuda. Solo el video visible se reproduce; al poner la app en segundo plano se pausa. Un archivo que no carga ofrece Reintentar y permite seguir deslizando.

## Ejecutar y comprobar

```sh
flutter pub get
flutter run -d chrome
flutter analyze
flutter test
flutter test test/infrastructure/public_video_api_live_test.dart --dart-define=LIVE_VIDEO_APIS=true
flutter build web
```

Las pruebas normales usan respuestas controladas. La prueba LIVE consulta realmente las tres APIs y comprueba una descarga parcial de cada fuente; requiere Internet.

La disponibilidad, CORS y codecs dependen del servidor y del dispositivo. Wikimedia usa principalmente WebM (Chrome/Android); algunos dispositivos Apple antiguos no lo reproducen. `video_player` no ofrece implementación Windows/Linux de escritorio en esta práctica: en Windows ejecuta Chrome o un emulador Android. La ausencia de errores en las pruebas no garantiza disponibilidad permanente de terceros ni compatibilidad de todos los archivos.

## Likes locales

El corazón se guarda con Localstore en `video_likes`. Al regresar al video o
reiniciar la app se restaura la selección; quitarlo guarda `liked: false`.
El contador suma únicamente un like propio sobre el valor original del video.
Las claves usan plataforma e ID; para archivos locales, su ruta.
En web los datos pertenecen al mismo navegador y origen (host y puerto).
Borrar los datos del sitio elimina estos likes. Para desarrollo web usa un
puerto fijo, por ejemplo `flutter run -d chrome --web-port=8080`.
La copia de Localstore en `packages/localstore` incluye una corrección para
esperar la escritura antes de confirmarla en pantalla.

## Modos visuales

El botón de paleta en la cabecera permite cambiar entre TokTik clásico,
Navidad, Día de Muertos y Día de Reyes. El modo elegido se guarda en Localstore
(`settings/theme`) y se restaura al abrir la aplicación. El selector funciona
desde cualquier video y cambia colores de botones, superficies, indicadores y
acentos sin afectar los videos ni los likes.
