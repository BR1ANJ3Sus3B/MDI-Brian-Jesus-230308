# brian_mdi_230308 — Documentación del proyecto

Aplicación móvil **Flutter** (Material 3, tema oscuro) con una pantalla de **contador interactivo** con estados visuales.

![Interfaz de la aplicación](imagenes/interfaz.png)

## Índice

1. [Descripción](#descripción)
2. [Estructura del proyecto](#estructura-del-proyecto)
3. [Arquitectura](#arquitectura)
4. [Pantalla principal y estados](#pantalla-principal-y-estados)
5. [Estados del contador](#estados-del-contador)
6. [Tecnologías y dependencias](#tecnologías-y-dependencias)
7. [Cómo ejecutar](#cómo-ejecutar)
8. [Pruebas](#pruebas)
9. [Publicación con GitHub Pages](#publicación-con-github-pages)

---

## Descripción

`brian_mdi_230308` es una app Flutter de ejemplo que implementa un contador con tres controles flotantes (sumar, restar y reiniciar). La interfaz cambia de color, anima el número y muestra un estado textual (`LOW`, `MEDIUM`, `HIGH`, `NEGATIVE`) según el valor del contador.

- Framework: [Flutter](https://flutter.dev) + Material 3
- Tipografía: Space Grotesk vía `google_fonts`

---

## Estructura del proyecto

Los archivos se organizan con el layout estándar de Flutter; los runners de plataforma y las carpetas de herramientas se generan automáticamente.

| Ruta | Propósito |
| --- | --- |
| `lib/` | Código fuente Dart de la aplicación |
| `lib/main.dart` | Punto de entrada, `MyApp` y tema global |
| `lib/Presentacion/Screens/counter_functions.dart` | Pantalla principal `CounterFunctionsScrens` |
| `lib/Presentacion/Screens/counter_screns.dart` | Pantalla simple alternativa `CounterScrens` |
| `test/` | Pruebas de widget (`widget_test.dart`) |
| `android/` | Runner Android (Kotlin + Gradle) |
| `ios/` | Runner iOS (Swift + Xcode) |
| `web/` | Runner web (HTML5 + manifest) |
| `windows/` | Runner Windows (C++ + CMake) |
| `linux/` | Runner Linux (C++ + CMake) |
| `macos/` | Runner macOS (Swift + Xcode) |
| `docs/` | Documentación y diagramas (este sitio) |
| `build/` | Artefactos compilados (generado) |
| `.dart_tool/` · `.idea/` · `pubspec.*` | Configuración de paquetes e IDE |

### Diagrama de estructura

![Estructura del proyecto](imagenes/estructura.png)

Versión interactiva: [estructura.html](estructura.html)

### Árbol de directorios completo

```text
brian_mdi_230308/
├── lib/
│   ├── main.dart
│   └── Presentacion/
│       └── Screens/
│           ├── counter_functions.dart
│           └── counter_screns.dart
├── test/
│   └── widget_test.dart
├── android/          # Runner Android
├── ios/              # Runner iOS
├── web/              # Runner web
├── windows/          # Runner Windows
├── linux/            # Runner Linux
├── macos/            # Runner macOS
├── docs/             # Documentación y diagramas
├── build/            # Salidas (generado)
├── .dart_tool/       # Config de paquetes (generado)
├── .idea/            # Config del IDE
├── pubspec.yaml      # Dependencias
├── analysis_options.yaml
├── .metadata
├── .gitignore
└── README.md
```

---

## Arquitectura

La app arranca en `lib/main.dart`, donde `MyApp` configura un `MaterialApp` Material 3 con tema oscuro y selecciona `CounterFunctionsScrens` como pantalla inicial. La pantalla es un widget con estado que posee el valor `clickCounter` y lo modifica a través de `setState`.

![Arquitectura de la aplicación](architecture.png)

Versión interactiva: [architecture.html](architecture.html)

### Flujo de interacción

El diagrama `interaccion.html` resume qué ocurre al pulsar cada botón:

1. El usuario toca `+`, `−` o `⟳`.
2. El handler correspondiente (`increaseCounter`, `decreaseCounter`, `resetCounter`) invoca `setState`.
3. `clickCounter` se actualiza.
4. Los *getters* `primaryColor`, `secondaryColor` y `counterStatus` derivan colores y estado.
5. El widget se reconstruye y anima el cambio.

![Flujo de interacción](imagenes/interaccion.png)

Versión interactiva: [interaccion.html](interaccion.html)

---

## Pantalla principal y estados

`CounterFunctionsScrens` (en `lib/Presentacion/Screens/counter_functions.dart`) dibuja:

- Un **AppBar** transparente con el título "Counter Functions" y un botón de reinicio.
- Un **círculo animado** (`AnimatedContainer`) que cambia de gradiente y sombra.
- El **valor actual** con la tipografía Space Grotesk (tamaño 110).
- El texto `click` / `clicks` y una insignia de estado animada (`AnimatedSwitcher`).
- Tres **botones flotantes circulares**: sumar (verde), restar (rojo) y reiniciar (azul).

| Control | Función | Icono |
| --- | --- | --- |
| Sumar | `increaseCounter()` — `clickCounter++` | `Icons.add` |
| Restar | `decreaseCounter()` — `clickCounter--` | `Icons.remove` |
| Reiniciar | `resetCounter()` — `clickCounter = 0` | `Icons.refresh_rounded` |

---

## Estados del contador

Los colores y el estado se derivan del rango de `clickCounter`:

| Rango | `counterStatus` | `primaryColor` | `secondaryColor` |
| --- | --- | --- | --- |
| `< 0` | `NEGATIVE` | `redAccent` | `red` |
| `0 – 9` | `LOW` | `cyanAccent` | `blueAccent` |
| `10 – 19` | `MEDIUM` | degradado `greenAccent → green` | degradado `green → #006400` |
| `≥ 20` | `HIGH` | `greenAccent` | `#006400` |

![Ciclo de vida del contador](imagenes/ciclo-vida.png)

Versión interactiva: [ciclo-vida.html](ciclo-vida.html)

---

## Tecnologías y dependencias

Definidas en `pubspec.yaml`:

| Paquete | Versión | Uso |
| --- | --- | --- |
| `flutter` | SDK ^3.13.3 | Framework |
| `cupertino_icons` | ^1.0.8 | Iconos Cupertino |
| `google_fonts` | ^8.2.1 | Tipografía Space Grotesk |
| `flutter_test` + `flutter_lints` | ^6.0.0 | Pruebas y lints (dev) |

---

## Cómo ejecutar

```bash
# Instalar dependencias
flutter pub get

# Ejecutar en un dispositivo / emulador
flutter run

# Ejecutar en navegador
flutter run -d chrome
```

## Pruebas

```bash
# Análisis estático (lints)
flutter analyze

# Pruebas de widget
flutter test
```

El test `test/widget_test.dart` comprueba que la pantalla arranca en `0`, que el botón de sumar incrementa a `1` y que la interfaz responde al toque.

---

## Publicación con GitHub Pages

1. Sube el contenido de `docs/` a tu repositorio (rama `main`).
2. En GitHub: **Settings → Pages**.
3. En **Build and deployment** eliges **Deploy from a branch**.
4. Selecciona la rama `main` y la carpeta `/docs`.
5. Guarda; GitHub publicará `index.html`.

El marcador `docs/.nojekyll` permite que GitHub Pages sirva los archivos estáticos sin procesamiento Jekyll.

---

## Diagramas disponibles

| Diagrama | Interactivo | Imagen PNG |
| --- | --- | --- |
| Arquitectura | [architecture.html](architecture.html) | [architecture.png](architecture.png) |
| Estructura del proyecto | [estructura.html](estructura.html) | [estructura.png](imagenes/estructura.png) |
| Interacción del contador | [interaccion.html](interaccion.html) | [interaccion.png](imagenes/interaccion.png) |
| Ciclo de vida de estados | [ciclo-vida.html](ciclo-vida.html) | [ciclo-vida.png](imagenes/ciclo-vida.png) |

Los diagramas son HTML autocontenidos (sin backend ni CDN) generados con **Archify**; sus fuentes editables son los `.archify.json` correspondientes.

---

*Documentación generada el 18 de septiembre de 2026.*