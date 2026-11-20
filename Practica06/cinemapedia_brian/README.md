# Cinemapedia — Práctica 06

<p align="center">
  <img src="Assets/icon/cinemapedia.png" alt="Icono de Cinemapedia" width="180">
</p>

Aplicación desarrollada con **Flutter y Dart** para explorar películas de **The Movie Database (TMDB)**. Combina un diseño cinematográfico oscuro con catálogos regionales, búsqueda, favoritos persistentes y un carrusel interactivo.

## Funcionalidades

- **Inicio:** carrusel de películas destacadas y listas horizontales con acceso a las colecciones completas.
- **Categorías:** películas en cines, próximos estrenos, populares y mejor calificadas, con carga paginada.
- **Búsqueda:** consulta de películas por título y acceso a su ficha.
- **Detalles:** título, imágenes, sinopsis, calificación, información de estreno y reparto, según los datos disponibles en TMDB.
- **Favoritos:** permite agregar y quitar películas desde los controles de corazón; la selección se guarda localmente con `SharedPreferences`.
- **Navegación:** menú lateral, barra inferior y navegación lateral para pantallas amplias.
- **Configuración regional e idioma:** selección persistente que actualiza toda la interfaz y el catálogo, con transición cinematográfica y soporte de movimiento reducido.
- **Presentación:** fondos oscuros, acentos cian y violeta, tarjetas con pósteres y estados de carga.

### Controles del carrusel

| Acción | Resultado |
| --- | --- |
| Un toque en la zona izquierda de navegación | Retrocede una película. |
| Un toque en la zona derecha de navegación | Avanza una película. |
| Dos toques rápidos en el área de navegación | Regresa a la primera película sin ejecutar antes el toque simple. |
| Deslizamiento horizontal | Cambia de película manualmente. |
| Botón de corazón | Agrega o quita la película de favoritos. |
| Ver detalles | Abre la ficha de la película. |

El widget `MoviesSlideshow` utiliza un `PageView` con un único `PageController`. Las transiciones por toque duran **380 ms** y los indicadores se sincronizan mediante `onPageChanged`. Las flechas son circulares, semitransparentes y tienen un área de 48 × 48 píxeles lógicos.

Los botones respetan los extremos de la lista: retroceder desde la primera película o avanzar desde la última mantiene la posición. Se evitan animaciones programáticas simultáneas y se conserva el soporte de deslizamiento táctil, mouse y trackpad. Los controles informativos y de acción tienen sus propios espacios de interacción.

### Países disponibles

| País | Idioma de consulta | Código |
| --- | --- | --- |
| México (predeterminado) | Español | `es-MX` |
| Estados Unidos | Inglés | `en-US` |
| Alemania | Alemán | `de-DE` |
| Japón | Japonés | `ja-JP` |
| China | Chino simplificado | `zh-CN` |
| Rusia | Ruso | `ru-RU` |
| Brasil | Portugués | `pt-BR` |

La región determina tanto el idioma de la interfaz como los parámetros de consulta y la clasificación por edad solicitada. Los títulos, traducciones, imágenes y fechas dependen de TMDB; si no hay una clasificación regional, se muestra **«Sin clasificación disponible»** en el idioma seleccionado.

### Internacionalización y transición regional

La interfaz utiliza el sistema oficial de Flutter: `flutter_localizations`, `intl` y `gen_l10n`. Las traducciones están en `lib/l10n/app_{en,es,de,ja,zh,ru,pt}.arb`, con configuración en `l10n.yaml` y código generado en `lib/l10n/generated/`.

- Menús, botones, búsqueda, categorías, favoritos, detalles, configuración, errores y estados vacíos se traducen mediante `context.l10n`.
- Los mensajes admiten variables y plurales, incluidas las formas del ruso. Las fechas y calificaciones usan formatos locales.
- `MaterialApp.router` obtiene su `locale` del país guardado. México (`es-MX`) es la opción predeterminada.
- La selección destaca con borde cian, escala y marca de verificación. Una superposición con bandera, globo y mensaje en el nuevo idioma dura 700 ms, con fundidos de 200 ms.
- La navegación permanece montada; la transición no espera al catálogo. Si la API sigue pendiente, se muestran los estados de carga. La preferencia de reducir movimiento elimina la espera visual y los fundidos.
- Se impiden selecciones simultáneas durante la transición. Los proveedores regionales descartan respuestas tardías del país anterior y el carrusel reinicia su posición.
- Los favoritos conservan sus IDs y almacenamiento. Se consultan sus fichas en el idioma actual; sin conexión, se mantiene la copia local.

**Respaldo de contenido:** si faltan título o sinopsis, se consulta la ficha del mismo ID en `en-US` y se completan únicamente los campos ausentes. Si esa consulta falla, se conserva la respuesta regional y se utiliza el título original cuando está disponible. No se sustituyen fechas ni clasificaciones con datos de otro país.

**API:** los listados y la búsqueda envían `language` y `region`; los detalles utilizan `language`. Las clasificaciones se extraen de `/movie/{id}/release_dates` filtrando `iso_3166_1`. Se conservan las etiquetas oficiales y se añade el prefijo FSK en Alemania. Para China no se inventan equivalencias.

Referencias de TMDB: [cartelera](https://developer.themoviedb.org/reference/movie-now-playing-list), [próximos estrenos](https://developer.themoviedb.org/reference/movie-upcoming-list) y [detalles](https://developer.themoviedb.org/reference/movie-details).

## Arquitectura

Consulta el diagrama interactivo de la aplicación: [Arquitectura de 230308 en GitHub Pages](https://br1anj3sus3b.github.io/MDI-Brian-Jesus-230308/).

El diagrama describe el recorrido desde la interfaz Flutter y Riverpod hasta los repositorios, TMDB, la configuración `.env` y la persistencia local con `SharedPreferences`.

## Tecnologías

| Herramienta | Uso |
| --- | --- |
| Flutter / Dart | Interfaz y lógica de la aplicación. |
| Flutter Riverpod | Estado, proveedores y actualización de datos. |
| Dio | Peticiones HTTP a TMDB. |
| GoRouter | Rutas y navegación entre pantallas. |
| SharedPreferences | Persistencia de favoritos y región. |
| Flutter Dotenv | Lectura de la configuración de entorno. |
| Intl | Formato de números. |
| Flutter Launcher Icons | Generación de iconos de la aplicación. |

## Arquitectura

Consulta el diagrama interactivo de la aplicación: [Arquitectura de Cinemapedia en GitHub Pages](https://br1anj3sus3b.github.io/MDI-Brian-Jesus-230308/Practica06/cinemapedia_brian/docs/architecture/).

El diagrama describe el recorrido desde la interfaz Flutter y Riverpod hasta los repositorios, TMDB, la configuración `.env` y la persistencia local con `SharedPreferences`.


## Estructura del proyecto

```text
cinemapedia_brian/
├── Assets/                  # Capturas e identidad visual
│   └── icon/                # Icono y capa de primer plano
├── lib/
│   ├── config/              # Entorno, formatos, regiones, rutas y tema
│   ├── domain/              # Entidades y contratos de datos/repositorios
│   ├── infrastructure/      # Acceso a TMDB, modelos, mapeadores y repositorios
│   ├── l10n/                # Siete catálogos ARB y localizaciones generadas
│   ├── presentation/
│   │   ├── delegates/       # Búsqueda de películas
│   │   ├── providers/       # Películas, actores, favoritos y región
│   │   ├── screens/         # Inicio, detalles, colecciones y configuración
│   │   └── widgets/         # Carrusel, tarjetas y componentes compartidos
│   └── main.dart            # Punto de entrada
├── test/                    # Pruebas de datos, región y carrusel
├── android/                 # Proyecto nativo Android
├── ios/                     # Proyecto nativo iOS
├── linux/                   # Configuración Linux
├── macos/                   # Configuración macOS
├── web/                     # Configuración web
├── windows/                 # Configuración Windows
├── .env.template            # Plantilla de configuración
└── pubspec.yaml             # Dependencias y recursos Flutter
```

El flujo de datos sigue la separación **presentación → repositorios → fuentes de datos**, utilizando las entidades y contratos definidos en `domain`.

## Instalación y ejecución

### Requisitos

- Flutter con Dart compatible con `pubspec.lock`: las dependencias resueltas requieren **Flutter 3.44.0 o superior y Dart 3.13.0 o superior**.
- Un dispositivo o emulador configurado para Flutter.
- Una clave API de [TMDB](https://www.themoviedb.org/settings/api) y conexión a Internet para consultar el catálogo.

### Pasos

1. Abre una terminal en `Practica06/cinemapedia_brian`.
2. Copia `.env.template` como `.env` y completa la variable:

   ```dotenv
   THE_MOVIEDB_KEY=tu_clave_api_de_tmdb
   ```

   Mantén la clave real en el archivo local `.env`, fuera del historial de Git.

3. Instala las dependencias:

   ```bash
   flutter pub get
   flutter gen-l10n
   ```

4. Consulta los dispositivos y ejecuta la aplicación:

   ```bash
   flutter devices
   flutter run
   ```

## Verificación

Desde la carpeta del proyecto:

```bash
dart format .
flutter analyze
flutter test
```

Las pruebas cubren la serialización de películas, el formato de calificaciones, la selección y persistencia regional, los parámetros enviados a TMDB y las clasificaciones por país. Las pruebas de widgets del carrusel comprueban toques simples, doble toque, límites, indicadores, arrastre táctil y con mouse, favoritos, lista vacía y reducción del número de películas.

La suite incluye **27 pruebas**: también verifica la integridad de los siete ARB, menús y pantallas secundarias en cada idioma, diseños de 390 px de ancho, transición regional, movimiento reducido, reinicio del carrusel, respaldo de traducciones, respuestas tardías y reintento tras errores. Las pruebas de API utilizan respuestas simuladas, sin credenciales reales.

Para ejecutar únicamente las pruebas del carrusel:

```bash
flutter test test/movies_slideshow_test.dart
```

## Galería de la aplicación

Capturas almacenadas en `Assets`, tomadas en Android. Muestran diferentes regiones y momentos del desarrollo; los catálogos y calificaciones corresponden al momento de la captura.

### Inicio y navegación del carrusel

| Inicio en español con flechas | Inicio en chino y favoritos | Catálogo en inglés |
| :---: | :---: | :---: |
| <img src="Assets/WhatsApp%20Image%202026-11-06%20at%2011.44.17%20AM%20%282%29.jpeg" alt="Carrusel en español con flechas y clasificación B" width="240"> | <img src="Assets/WhatsApp%20Image%202026-11-06%20at%2011.44.17%20AM.jpeg" alt="Carrusel en chino con una película marcada como favorita" width="240"> | <img src="Assets/WhatsApp%20Image%202026-11-06%20at%2011.44.17%20AM%20%281%29.jpeg" alt="Películas en inglés con clasificación PG-13" width="240"> |

### Categorías y colecciones

| Categorías | En cines | Populares |
| :---: | :---: | :---: |
| <img src="Assets/WhatsApp%20Image%202026-11-06%20at%2011.44.18%20AM%20%281%29.jpeg" alt="Pantalla de categorías de películas" width="240"> | <img src="Assets/WhatsApp%20Image%202026-11-06%20at%2011.44.19%20AM.jpeg" alt="Colección de películas en cines" width="240"> | <img src="Assets/WhatsApp%20Image%202026-11-06%20at%2011.44.19%20AM%20%281%29.jpeg" alt="Colección de películas populares y favoritos" width="240"> |

### Exploración horizontal del catálogo regional

| Cartelera regional | Desplazamiento de tarjetas | Más películas |
| :---: | :---: | :---: |
| <img src="Assets/WhatsApp%20Image%202026-11-06%20at%2011.44.15%20AM%20%282%29.jpeg" alt="Lista horizontal de cartelera en chino" width="240"> | <img src="Assets/WhatsApp%20Image%202026-11-06%20at%2011.44.15%20AM%20%281%29.jpeg" alt="Otra posición de la lista horizontal regional" width="240"> | <img src="Assets/WhatsApp%20Image%202026-11-06%20at%2011.44.16%20AM.jpeg" alt="Más títulos del catálogo regional al deslizar" width="240"> |

### Instalación y vista previa del diseño

| Icono instalado en Android | Inicio antes de incorporar las flechas |
| :---: | :---: |
| <img src="Assets/WhatsApp%20Image%202026-11-06%20at%2011.44.15%20AM.jpeg" alt="Cinemapedia instalada en el cajón de aplicaciones Android" width="240"> | <img src="Assets/WhatsApp%20Image%202026-11-06%20at%2011.44.18%20AM.jpeg" alt="Versión previa del carrusel con información en inglés" width="240"> |

### Recursos gráficos

| Diseño neón | Capa de primer plano del icono |
| :---: | :---: |
| <img src="Assets/%C3%8Dcono%20ne%C3%B3n%20de%20Cinemapedia.png" alt="Diseño neón de Cinemapedia" width="280"> | <img src="Assets/icon/cinemapedia_foreground.png" alt="Primer plano del icono adaptativo de Cinemapedia" width="180"> |

Las rutas de las imágenes son relativas a este README y respetan el nombre de la carpeta `Assets`, incluyendo su mayúscula inicial.
