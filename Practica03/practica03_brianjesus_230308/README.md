# Hola Jarvis - Práctica 03

Aplicación móvil de chat desarrollada en **Flutter**. El usuario conversa con
"Jarvis", un asistente simulado que responde con textos aleatorios y siempre
acompaña su mensaje con un GIF o imagen de reacción.

## Características

- Envía mensajes desde el campo de texto (botón de enviar o tecla *listo*).
- Cada mensaje muestra la **hora** en que fue enviado (formato `HH:mm`).
- Jarvis responde tras 1.5 segundos con un indicador de "escribiendo...".
- **Respuestas variadas**: un texto aleatorio de una lista de 18 mensajes,
  sin repetir hasta agotarla.
- **Imágenes de reacción variadas**: cada respuesta incluye un GIF aleatorio de
  un repertorio de 4 assets, sin repetir el último usado.
- Tema `Material 3` con paleta configurable (`AppTheme`).


## Capturas de la aplicación

### 1. Pantalla principal del chat
<img src="/Practica03/practica03_brianjesus_230308/assets/1.jpeg" width="250">

### 2. Envío de mensaje
<img src="/Practica03/practica03_brianjesus_230308/assets/2.jpeg" width="250">

### 3. Respuesta de Jarvis
<img src="/Practica03/practica03_brianjesus_230308/assets/3.jpeg" width="250">

### 4. GIF de reacción
<img src="/Practica03/practica03_brianjesus_230308/assets/5.jpeg" width="250">

### 5. Conversación completa
<img src="/Practica03/practica03_brianjesus_230308/assets/WhatsApp%20Image%202026-09-29%20at%209.04.08%20AM.jpeg" width="250">

## Assets incluidos

| Archivo | Tipo | Uso |
| --- | --- | --- |
| `assets/jarvis.jpg` | Imagen | Avatar del asistente en la barra superior |
| `assets/Homero.gif` | GIF | Reacción de Jarvis |
| `assets/her.gif` | GIF | Reacción de Jarvis |
| `assets/comer.gif` | GIF | Reacción de Jarvis |
| `assets/hola.gif` | GIF | Reacción de Jarvis |

## Estructura del proyecto

```
lib/
├── main.dart                                   # Punto de entrada y MaterialApp
├── config/theme/app_theme.dart                 # Tema (Material 3) configurable
└── Presentencion/
    ├── chat/chat_screen.dart                   # Pantalla principal del chat
    ├── Models/chat_message.dart                # Modelo ChatMessage + formato de hora
    └── Widgets/
        ├── Chat/my_message_bubble.dart         # Burbuja de mensaje del usuario
        ├── Chat/her_message_bubble.dart        # Burbuja de mensaje de Jarvis
        └── shared/message_field_box.dart       # Campo de escritura de mensajes
tool/
└── diagramas/exportar.mjs                      # Exporta los diagramas a PNG
docs/                                           # Diagramas y documentación (este sitio)
```

## Documentación

En [`docs/`](docs/) están los diagramas de arquitectura y la página de la
práctica: la arquitectura **propuesta** por capas
([`arquitectura-practica03.html`](docs/arquitectura-practica03.html)) y la
arquitectura del **chat implementado**
([`hola-jarvis.html`](docs/hola-jarvis.html)). La portada es
[`docs/index.html`](docs/index.html) y la especificación en
[`docs/arquitectura-practica03.md`](docs/arquitectura-practica03.md).

Se publica con GitHub Pages desde la rama `Practica03`:
<https://br1anj3sus3b.github.io/MDI-Brian-Jesus-230308/Practica03/practica03_brianjesus_230308/docs/>

## Cómo ejecutar

```bash
flutter pub get
flutter run
```

## Cómo probar

```bash
flutter test
```

Los tests cubren el arranque de la app y el flujo de enviar un mensaje y
recibir la respuesta de Jarvis.