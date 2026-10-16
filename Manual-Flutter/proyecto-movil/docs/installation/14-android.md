# 14. Android Studio y Android SDK

## Android Studio: qué es, utilidad y arquitectura

IDE oficial para Android. En este laboratorio administra herramientas y dispositivos; VS Code puede seguir siendo tu editor. Requiere Windows compatible, espacio libre y acceso a Internet.

## Instalación y configuración

Instala desde [Android Studio](https://developer.android.com/studio/install), completa el asistente y abre **More Actions → SDK Manager** o **Tools → SDK Manager**. Anota **Android SDK Location**.

## Android SDK: qué es y qué problema resuelve

Conjunto de herramientas que permite compilar, instalar y depurar en Android. Se utiliza entre Flutter y el dispositivo durante el desarrollo.

| Componente | Función |
| --- | --- |
| SDK Platform | API de una versión Android usada al compilar |
| Build Tools | Construcción del paquete Android |
| Platform Tools | ADB y otras herramientas de comunicación |
| Command-line Tools | Administración por terminal, incluido sdkmanager |
| Android Emulator | Ejecución de dispositivos virtuales |
| NDK y CMake | Compilación de dependencias nativas cuando el proyecto las requiere |

### Instalación y configuración del SDK

En **SDK Platforms** instala la plataforma que solicita Flutter; la guía oficial consultada indica API 36. En **SDK Tools** instala Build-Tools, Platform-Tools, Command-line Tools, Emulator, NDK y CMake. Acepta cambios y espera las descargas. [Configuración oficial de Flutter para Android](https://docs.flutter.dev/platform-integration/android/setup).

## Comandos principales y ejemplo práctico

```powershell
flutter doctor --android-licenses
```

Lee y acepta las licencias necesarias. Después:

```powershell
flutter doctor -v
```

Si usa otra carpeta del SDK:

```powershell
flutter config --android-sdk "$env:LOCALAPPDATA\Android\Sdk"
```

## Error especial: Android sdkmanager not found

**Causas:** falta Command-line Tools, instalación interrumpida o Flutter apunta a otro SDK. **Solución:** abre SDK Manager, instala **Android SDK Command-line Tools**, confirma la ubicación y verifica el ejecutable:

```powershell
Test-Path "$env:LOCALAPPDATA\Android\Sdk\cmdline-tools\latest\bin\sdkmanager.bat"
```

Si tienes herramientas en un directorio versionado, usa esa ubicación real. Repite las licencias y el diagnóstico. No copies manualmente archivos entre SDK sin comprobar primero las rutas. [Referencia sdkmanager](https://developer.android.com/tools/sdkmanager).

## Verificación, evidencia y conclusión

**E18:** SDK Manager, herramientas instaladas y licencias aceptadas. Android Studio y Android SDK son componentes distintos; instalar el IDE no demuestra por sí solo que las herramientas estén completas.
