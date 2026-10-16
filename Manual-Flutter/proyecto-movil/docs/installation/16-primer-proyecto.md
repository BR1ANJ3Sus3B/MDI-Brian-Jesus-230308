# 16. Primer proyecto Flutter

En una carpeta de ejercicios fuera del repositorio actual:

```powershell
flutter create app_demo
```

```powershell
Set-Location app_demo
```

| Ruta | Función |
| --- | --- |
| `lib/` | Código Dart de la aplicación |
| `lib/main.dart` | Entrada del programa |
| `android/` | Integración y compilación Android |
| `ios/` | Integración iOS; compilación en macOS |
| `web/` | Archivos de integración web |
| `test/` | Pruebas |
| `pubspec.yaml` | Dependencias, SDK y recursos |

Reemplaza `lib/main.dart` por este ejemplo completo:

```dart
import 'package:flutter/material.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Mi entorno móvil')),
        body: const Center(child: Text('Flutter está funcionando')),
      ),
    );
  }
}
```

`runApp` inicia la UI; `MaterialApp` configura la aplicación; `Scaffold` organiza una pantalla. `const` identifica objetos inmutables construidos con valores constantes.

```powershell
flutter run
```

Cambia el texto, guarda y pulsa `r`. Si ejecutas las pruebas generadas del contador, actualízalas para este nuevo diseño; su resultado esperado ya no es un contador.

**E04:** pantalla, código y recarga. El integrador completo está en `mobile/flutter_app`; este ejercicio introduce widgets antes de incorporar red y autenticación.
