# Practica 04 - TokTik

Clone de TikTok hecho en Flutter: un feed vertical de videos con scroll
infinito, likes, vistas y reproductor a pantalla completa con caption y
gradiente.

El feed combina los MP4 locales con NASA, Internet Archive y Wikimedia Commons.
Incluye un botón de altavoz para silenciar o activar el sonido. Consulta
[la integración actual](lib/INTEGRACION_APIS.md) para ejecutar y verificar las fuentes.
Desde la paleta de la cabecera también puedes elegir TokTik clásico, Navidad,
Día de Muertos o Día de Reyes; la selección queda guardada localmente.

Proyecto de la materia **MDI** (Desarrollo Movil) - Flutter.

---

## Tabla de contenidos

- [Objetivo](#objetivo)
- [Como ejecutar](#como-ejecutar)
- [Dependencias](#dependencias)
- [Arquitectura del proyecto](#arquitectura-del-proyecto)
- [Estructura de carpetas](#estructura-de-carpetas)
- [Diseno de la interfaz](#diseno-de-la-interfaz)
- [Componentes principales](#componentes-principales)
- [Recursos de video](#recursos-de-video)
- [Fuentes públicas y reproducción](#fuentes-públicas-y-reproducción)
- [Pruebas](#pruebas)
- [Problemas corregidos en esta practica](#problemas-corregidos-en-esta-practica)

---

## Objetivo

Practicar la organizacion de un proyecto Flutter en capas (**Clean
Architecture**), el uso de `provider` para la gestion de estado, la
paginacion de datos y el manejo del paquete `video_player`.

La app cumple con:

- Feed vertical con un video por pantalla (`PageView` vertical).
- Scroll infinito: al llegar cerca del final se carga la siguiente pagina.
- Botones de likes y vistas con formato compacto (`23.2K`, `21.6M`).
- Like interactivo que cambia de color y suma o resta 1.
- Reproduccion en loop y silenciada; un toque pausa o reanuda.
- Tema oscuro (Material 3) con la paleta de marca de TikTok.
- Estados de carga, de pagina vacia y de error con opcion de reintentar.
- Cabecera con pestanas, avatar con boton de seguir y overlay de autor.

---

## Como ejecutar

Requisitos: **Flutter 3.47+** (Dart **3.13.3+**), que es lo que pide el
`environment.sdk` del `pubspec.yaml`. Verificar la instalacion con:

```bash
flutter doctor
```

Luego, desde la raiz del proyecto:

```bash
# 1. Instalar dependencias
flutter pub get

# 2. Ejecutar en un dispositivo o emulador
flutter run

# 3. Generar una compilacion de release
flutter build apk      # Android
flutter build ipa      # iOS
flutter build web      # Web
```

> En iOS, `video_player` reproduce videos locales sin permisos de red, asi que
> no hace falta agregar nada al `Info.plist`.

---

## Dependencias

Declaradas en `pubspec.yaml`:

| Paquete | Version | Para que se usa |
| --- | --- | --- |
| [`http`](https://pub.dev/packages/http) | `^1.2.2` | Consultas a las tres APIs públicas. |
| [`provider`](https://pub.dev/packages/provider) | `^6.1.2` | Inyeccion de dependencias y `ChangeNotifier` para el estado del feed. |
| [`video_player`](https://pub.dev/packages/video_player) | `^2.9.2` | Reproduccion de videos locales y remotos a pantalla completa. |
| [`intl`](https://pub.dev/packages/intl) | `^0.20.2` | Formato compacto de numeros en los likes y las vistas. |
| [`animate_do`](https://pub.dev/packages/animate_do) | `^3.2.0` | Animacion `SpinPerfect` del boton de audio. |
| [`cupertino_icons`](https://pub.dev/packages/cupertino_icons) | `^1.0.8` | Iconos de estilo iOS. |
| [`flutter_lints`](https://pub.dev/packages/flutter_lints) | `^6.0.0` | Reglas de analisis estatico (solo desarrollo). |

Ademas, en `flutter:` se declara el recurso de video:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/videos/
```

---

## Arquitectura del proyecto

El proyecto sigue una arquitectura por capas, en la que las dependencias
apuntan **hacia adentro**:

```
┌──────────────────────────────────────────────────────────┐
│  presentation   DiscoverProvider (ChangeNotifier)         │
│                 DiscoverScreen, VideoScrollableView,      │
│                 VideoButtons, FullScreenPlayer            │
│                         ▲                                │
│                         │ depende de la interfaz         │
├──────────────────────────────────────────────────────────┤
│  domain         VideoPost (entidad)                      │
│                 VideoRepository, VideoDataSource          │
│                   (contratos abstractos)                  │
│                         ▲                                │
│                         │ implementan los contratos        │
├──────────────────────────────────────────────────────────┤
│  infrastructure LocalVideoModel (data model)              │
│                 LocalVideoRepository                      │
│                 LocalVideoDataSource                      │
└──────────────────────────────────────────────────────────┘

  shared/data     Datos crudos locales (simulan la respuesta de una API)
  config          Tema y utilidades de formato
```

Reglas que se respetan:

1. **`domain` no depende de nada.** Solo define la entidad `VideoPost` y las
   interfaces `VideoRepository` / `VideoDataSource`. No importa Flutter.
2. **`infrastructure` implementa los contratos de `domain`.** Aqui viven el
   *data model* (`LocalVideoModel`), la fuente de datos y el repositorio que
   transforma los mapas crudos en entidades.
3. **`presentation` solo conoce `domain`.** El `DiscoverProvider` recibe un
   `VideoRepository` por el constructor y nunca importa el modelo concreto.
4. **La inyeccion se decide en `main.dart`.** Cambiar la fuente de datos
   (local a API) es modificar una sola linea, sin tocar la interfaz de usuario.

### Flujo de datos de una pagina

```
DiscoverScreen (initState)
        │  loadNextPage()
        ▼
DiscoverProvider ──── _currentPage = 0
        │  getVideosByPage(0)
        ▼
LocalVideoRepository
        │
        ▼
LocalVideoDataSource  ──►  AssetManifest (archivos locales existentes)
        │  List<Map<String, dynamic>>
        ▼
LocalVideoModel.fromJson(...).toVideoPostEntity()
        │  List<VideoPost>
        ▼
DiscoverProvider._videos  ──►  notifyListeners()
        │
        ▼
VideoScrollableView  ──►  FullScreenPlayer + VideoButtons
```

---

## Estructura de carpetas

```
lib/
├── main.dart                                   # Composition root y providers
│
├── config/                                     # Configuracion transversal
│   ├── helpers/
│   │   └── human_formats.dart                  # 23230 -> "23.2K"
│   └── theme/
│       ├── app_colors.dart                       # Paleta de marca
│       └── app_theme.dart                        # Tema oscuro Material 3
│
├── domain/                                     # Reglas de negocio (sin Flutter)
│   ├── entities/
│   │   └── video_post.dart                     # Entidad VideoPost
│   └── repositories/
│       ├── video_repository.dart               # Contrato de negocio
│       └── video_data_source.dart              # Contrato de datos crudos
│
├── infrastructure/                             # Implementaciones tecnicas
│   ├── datasources/
│   │   └── local_video_data_source.dart        # Lee la lista local
│   ├── models/
│   │   └── local_video_model.dart              # Data model + fromJson
│   └── repositories/
│       └── local_video_repository.dart         # Implementa VideoRepository
│
├── presentation/                               # UI y estado
│   ├── providers/
│   │   └── discover_provider.dart              # ChangeNotifier del feed
│   ├── screens/
│   │   └── discover/
│   │       └── discover_screen.dart            # Pantalla principal
│   └── widgets/
│       ├── shared/
│       │   ├── video_buttons.dart              # Avatar, like, compartir, audio
│       │   ├── video_header.dart               # Pestanas + busqueda
│       │   └── video_scrollable_view.dart      # PageView + scroll infinito
│       └── video/
│           ├── fullscreen_player.dart          # Reproductor y overlay de autor
│           └── video_background.dart           # Degradados superior e inferior
│
└── shared/
    └── data/
        └── local_video_posts.dart              # Datos crudos de ejemplo

test/
├── helpers/human_formats_test.dart
├── infrastructure/local_video_model_test.dart
└── presentation/
    ├── discover_provider_test.dart
    ├── discover_screen_test.dart
    ├── video_buttons_test.dart
    ├── video_header_test.dart
    ├── video_scrollable_view_test.dart
    └── fullscreen_player_test.dart

assets/
└── videos/                                     # NO versionado en git
    ├── 1.mp4
    ├── 2.mp4
    ├── 3.mp4
    ├── 4.mp4
    ├── 5.mp4
    ├── 6.mp4
    ├── 7.mp4
    └── 8.mp4
```

---

## Diseno de la interfaz

### Paleta de marca

Todo el color vive en `lib/config/theme/app_colors.dart`. Evita "magas" como
`Colors.red` sueltos en los widgets y permite re-tematizar la app desde un solo
archivo.

| Color | Uso |
| --- | --- |
| `#FE2C55` | Rojo de marca: like activo, boton de seguir, boton primario. |
| `#25F4EE` | Cian de marca: acentos y confirmaciones. |
| `#000000` | Fondo de la app. |
| `#121212` | Superficies elevadas (iconos de estado, `snackbar`). |
| `FFFFFF` / `B3FFFFFF` / `80FFFFFF` | Texto en tres niveles de jerarquia. |

`AppTheme` engancha esa paleta al tema global de `MaterialApp` y define una
escala tipografica con pesos fuertes (`w600` / `w700`), porque el contenido se
lee rapido, en vertical y sobre un fondo cambiante.

### Composicion de cada pagina de video

```
┌─────────────────────────────────┐
│░░ degradado superior ░░░░░░░░░░│  <- VideoBackground.top()
│   Siguiendo  Para ti    🔍    │  <- VideoHeader
│      ━━━━                      │     (subrayado animado en la activa)
│                                 │
│         VIDEO A FULL           │  <- FullScreenPlayer
│      (Center + AspectRatio)    │
│                                 │
│░░ degradado inferior ░░░░░░░░░░│  <- VideoBackground.bottom()
│ @autor.1        ♪ un audio     │  <- _VideoInfo
│ Descripcion del video           │
│                          ◯  👤 │  <- VideoButtons
│                          👁     │     (avatar, like, comentarios,
│                          ⤴     │      compartir, guardar, disco)
│                          🔖     │
│                          💿     │
└─────────────────────────────────┘
```

Decisiones de diseño relevantes:

- **Doble degradado.** El superior oscurece para que la cabecera se lea sobre
  cualquier video; el inferior hace lo mismo con el autor y la descripcion. Se
  usan tres paradas cada uno para que la transicion sea gradual y no una banda
  plana de negro.
- **Sombra en el texto.** Iconos y textos sobre el video llevan
  `Shadow` para mantener contraste sin necesidad de un chip opaco.
- **Video sin deformar.** `Center` + `AspectRatio` centrados: el clip mantiene
  su proporcion y las bandas negras quedan a los lados.
- **Sin zona segura en la pantalla.** El video ocupa toda la pantalla y el
  `SafeArea` vive dentro de `VideoHeader`, para que solo la cabecera respete la
  muesca o la barra de gestos.
- **Indicador de pausa.** Al pausar con un toque aparece un icono con
  `AnimatedOpacity`, en lugar de detener el video de golpe.

### Interacciones

| Elemento | Comportamiento |
| --- | --- |
| Pestanas del header | Cambian la seleccionada y mueven el subrayado con `AnimatedContainer`. |
| Like | Alterna `favorite` / `favorite_border`, cambia a rojo, suma o resta 1 y se envuelve en un `Pulse` al activarse. |
| Toque sobre el video | Pausa o reanuda. |
| Seguir | Boton `+` superpuesto al avatar (decorativo). |
| Comentarios / compartir / guardar | Botones con ripple; la accion todavia no esta implementada. |
| Disco de audio | Gira en loop con `SpinPerfect`. |

### Accesibilidad

- Cada accion usa `Semantics(button: true, label: ...)` para que el lector de
  pantalla anuncie los botones con su contador.
- Los contadores tienen `overflow: TextOverflow.ellipsis`, igual que autor,
  descripcion y audio.
- Las acciones usan `InkResponse` con ripple y area tactile ampliada
  (`radius: 26`), no un `IconButton` pelado.

---

## Componentes principales

### `main.dart`

Es el *composition root*: decide que implementacion se inyecta y registra los
providers.

```dart
final VideoRepository _videoRepository = FeedVideoRepository();
```

### `DiscoverProvider` (`presentation/providers/discover_provider.dart`)

`ChangeNotifier` que expone el estado del feed:

| Propiedad | Descripcion |
| --- | --- |
| `videos` | Videos cargados (lista no modificable). |
| `initialLoading` | `true` durante la primera carga. |
| `isLoading` | `true` mientras se pide cualquier pagina. |
| `hasReachedEnd` | `true` cuando la ultima pagina vino vacia. |
| `errorMessage` | Mensaje de error, o `null`. |

- `loadNextPage()` ignora llamadas concurrentes y no vuelve a pedir paginas si
  ya se alcanzo el final.
- `reload()` reinicia el feed desde la primera pagina (boton **Reintentar**).

### `LocalVideoRepository` / `LocalVideoDataSource`

`LocalVideoDataSource` lee AssetManifest y devuelve páginas de cuatro MP4
existentes en `assets/videos/`. `LocalVideoRepository` convierte
cada mapa en un `VideoPost` usando `toVideoPostEntity()`.

### `FullScreenPlayer` (`presentation/widgets/video/fullscreen_player.dart`)

Inicializa un controlador local o de red y conserva la preferencia de sonido.
Pausa al perder visibilidad y permite reintentar archivos que fallen. Al tocar el video alterna entre pausa y
reproduccion. Si el asset no se puede cargar, muestra un mensaje de error en
lugar de dejar la pantalla en negro.

### `VideoScrollableView` (`presentation/widgets/shared/video_scrollable_view.dart`)

`PageView.builder` vertical con `BouncingScrollPhysics`. En `onPageChanged`
avisa al provider cuando la pagina actual esta a una de la ultima, disparando
la carga de la siguiente pagina.

---

## Recursos de video

> **Importante:** los videos **no estan versionados en git**. Cada `.mp4` pesa
> entre 5 y 112 MB (el set completo ronda los **350 MB**), por lo que
> `.gitignore` los excluye del repositorio para no inflar el historial.
>Ver [Videos no incluidos en el repo](#videos-no-incluidos-en-el-repo).

`lib/shared/data/local_video_posts.dart` define 8 publicaciones y cada una
apunta a un clip distinto:

| Publicacion | Archivo | Likes | Vistas |
| --- | --- | --- | --- |
| Subiendo escaleras automaticas | `assets/videos/1.mp4` | 23.230 | 1.523 |
| Planta apreciada por peatones | `assets/videos/2.mp4` | 24.230 | 1.343 |
| Que borroso veo todo! | `assets/videos/3.mp4` | 21.564.320 | 123.563 |
| Esto es trigo? que interesante | `assets/videos/4.mp4` | 320 | 2.300 |
| El COVID no me afecta | `assets/videos/5.mp4` | 3.230 | 31.030 |
| No quiero ir a trabajar hoy senor Stark | `assets/videos/6.mp4` | 10 | 330 |
| Limpiar nunca fue tan divertido | `assets/videos/7.mp4` | 1.320 | 33.032 |
| Ya llegamos a la India?... umm si | `assets/videos/8.mp4` | 342 | 3.332 |

### Videos no incluidos en el repo

Quien clone el proyecto **no recibira los `.mp4`**. Para que la app funcione:

1. Copia 8 videos `.mp4` a `assets/videos/`, nombrados `1.mp4` a `8.mp4`.
2. Ejecuta `flutter pub get` y `flutter run`.

Si falta algun archivo, `FullScreenPlayer` no se rompe: muestra un aviso
*"No se pudo cargar el video"* con el nombre de la publicacion.

Si necesitas compartir los videos por git, usa
[Git LFS](https://git-lfs.com/) en lugar de subirlos como blobs normales:

```bash
git lfs install
git lfs track "assets/videos/*.mp4"
git add .gitattributes
```

---

## Fuentes públicas y reproducción

Consulta [Integración de APIs](lib/INTEGRACION_APIS.md) para las tres fuentes activas, videos locales, sonido y pruebas.

## Pruebas

Se ejecutan con `flutter test` (**46 pruebas, todas en verde**):

```bash
flutter test
```

Cobertura actual:

| Archivo | Que se verifica |
| --- | --- |
| `test/helpers/human_formats_test.dart` | Formato compacto de miles, millones y cifras cortas. |
| `test/infrastructure/local_video_model_test.dart` | Mapeo del JSON a entidad, `int` y `double`, y valores por defecto. |
| `test/presentation/discover_provider_test.dart` | Carga inicial, acumulacion de paginas, fin de los datos, llamadas concurrentes, errores y `reload()`. |
| `test/presentation/discover_screen_test.dart` | Estados de la pantalla: spinner, vacio, error, reintento y tema. |
| `test/presentation/video_buttons_test.dart` | Like interactivo (suma y resta 1), contadores, avatar con inicial y acciones secundarias. |
| `test/presentation/video_header_test.dart` | Pestanas, boton de busqueda y notificacion del cambio de pestana. |
| `test/presentation/video_scrollable_view_test.dart` | El feed se monta sin desbordar el layout, avisos de carga y de fin de datos. |
| `test/presentation/fullscreen_player_test.dart` | Spinner de carga y estado de error cuando el video no se puede cargar. |

Las pruebas del provider usan repositorios falsos, por lo que corren sin
necesidad de los assets de video y sin timers.

### Probar widgets con animaciones infinitas

`VideoButtons` y `VideoScrollableView` usan `animate_do` con animaciones que
se repiten para siempre (`SpinPerfect`, `Pulse`). Eso deja un timer pendiente y
hace fallar el test con *"A Timer is still pending even after the widget tree
was disposed"*. El patron que hay que usar es:

```dart
await tester.pumpWidget(
  MaterialApp(
    home: TickerMode(
      enabled: false,          // 1. detiene los tickers infinitos
      child: MiWidget(),
    ),
  ),
);

// 2. animate_do arranca con Future.delayed: hay que avanzar el reloj para
//    que ese timer se dispare. Se hace dos veces porque al marcar un like se
//    monta la animacion Pulse en el frame siguiente al toque.
await tester.pump(const Duration(milliseconds: 1));
await tester.pump(const Duration(milliseconds: 1));
```

Calidad de codigo:

```bash
flutter analyze   # => No issues found!
```

---

## Problemas corregidos en esta practica

| # | Problema | Solucion |
| --- | --- | --- |
| 1 | Los 7 archivos de `lib/` importaban `package:toktik/...`, pero el paquete se llama `practica04_brian`: **el proyecto no compilaba**. | Imports corregidos en toda la carpeta `lib/`. |
| 2 | `pubspec.yaml` no declaraba `provider`, `video_player`, `intl` ni `animate_do`, aunque el codigo los usaba. | Dependencias agregadas con `flutter pub get`. |
| 3 | No existia la seccion `assets` ni la carpeta `assets/videos`, aunque los datos apuntan a `assets/videos/1.mp4` ... `8.mp4`. | Carpeta creada, seccion `assets` declarada en `pubspec.yaml` y los 8 clips agregados. |
| 4 | `controller.initialize()` se ejecutaba dentro de `build()`, por lo que se relanzaba en cada rebuild y el video parpadeaba. | Inicializacion unica en `initState` con estado `_initialized` + `setState`. |
| 5 | `HumanFormats.humanReadbleNumber` tenia un error de escritura y usaba `compactCurrency` (muestra simbolos) en vez de `NumberFormat.compact`. | Renombrado a `humanReadableNumber` y corregido el formateo. |
| 6 | `_CustomIconButton` declaraba `iconColor` **sin tipo**, cayendo en `dynamic`. | Parametro tipado como `Color?`. |
| 7 | El `TODO: Repository, DataSource` del provider estaba sin implementar. | Capa completa `domain/repositories` + `infrastructure/{models,repositories,datasources}`. |
| 8 | `loadNextPage()` no tenia control de concurrencia ni de fin de paginacion: duplicaba videos al hacer scroll. | Banderas `_isLoading` y `_hasReachedEnd`, mas `_currentPage`. |
| 9 | El `AspectRatio` del video se renderizaba estirado dentro de `SizedBox.expand`. | `Center` + `AspectRatio` para conservar la proporcion. |
| 10 | `test/widget_test.dart` era la prueba del contador por defecto de Flutter y fallaba al compilar. | Reemplazada por 46 pruebas organizadas por capa. |
| 11 | No habia forma de recuperar la app si la carga fallaba. | Estado de error con mensaje y boton **Reintentar** (`reload()`). |
| 12 | `VideoBackground` interceptaba los toques del video por ser un `DecoratedBox` a pantalla completa. | Envoltura con `IgnorePointer`. |
| 13 | Sin `dispose` en la `PageController` del feed. | `PageController` creado en el `State` y liberado en `dispose`. |
| 14 | Los 8 videos del feed pesan ~350 MB en total: subirlos a git habria inflado el historial de forma permanente. | `assets/videos/*.mp4` agregado a `.gitignore` y los archivos sacados del indice con `git rm --cached`. Siguen en disco y la app los reproduce; el repo solo guarda codigo. Alternativa documentada: Git LFS. |
| 15 | `_ActionButton` usaba `InkResponse` sin un `Material` ancestor, lo que lanzaba *"No Material widget found"* al superponerse sobre el video. | Cada boton envuelto en `Material(type: MaterialType.transparency)`: el ripple funciona sin tapar el video. |
| 16 | Sin capa de diseno: colores magos (`Colors.red`, `Colors.white`) repartidos por los widgets y tipografia por defecto. | Nueva `app_colors.dart` con la paleta de marca y `AppTheme` con escala tipografica, `colorScheme`, botones, `snackbar` e indicador de progreso. |
