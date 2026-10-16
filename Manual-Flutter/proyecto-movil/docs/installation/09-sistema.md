# 09. Configuración del sistema

Una variable de entorno es un valor que un proceso recibe del sistema, como la ruta de un SDK. `PATH` enumera directorios donde la terminal busca ejecutables. `JAVA_HOME` identifica un JDK; `ANDROID_HOME`, el Android SDK.

PowerShell es un intérprete de comandos. La terminal es la ventana que lo aloja. Una variable `$env:NOMBRE` corresponde al entorno del proceso actual.

## Preparación en Windows

1. Actualiza Windows y confirma compatibilidad con Docker Desktop.
2. En Administrador de tareas → Rendimiento → CPU revisa **Virtualización**. Si está desactivada, consulta el procedimiento del fabricante para habilitar VT-x/AMD-V en UEFI.
3. Instala WSL 2 siguiendo el asistente de Docker Desktop. Reinicia cuando se solicite.
4. Abre PowerShell normal para trabajar; eleva permisos solo cuando un instalador del sistema lo requiera.

Ejemplo de configuración de la sesión después de instalar los SDK:

```powershell
$env:ANDROID_HOME = "$env:LOCALAPPDATA\Android\Sdk"
```

```powershell
$env:JAVA_HOME = 'C:\Program Files\Android\Android Studio\jbr'
```

```powershell
$env:Path = "$env:USERPROFILE\develop\flutter\bin;$env:ANDROID_HOME\platform-tools;$env:Path"
```

Comprueba las rutas antes de usarlas. Para persistirlas, abre **Variables de entorno de usuario** y añade entradas; no reemplaces todo el PATH. Abre una terminal nueva después.

```powershell
where.exe flutter
```

```powershell
flutter doctor -v
```

Flutter puede seleccionar el JDK de Android Studio aunque exista otro `JAVA_HOME`; el diagnóstico informa el Java realmente usado. Si hay incompatibilidad de Gradle, revisa esa ruta antes de instalar versiones al azar.

**E15:** registra rutas y diagnóstico. Error frecuente: cambiar una variable y continuar usando una terminal que aún conserva el valor anterior.

Fuentes: [PATH de Flutter](https://docs.flutter.dev/install/add-to-path), [variables Android](https://developer.android.com/tools/variables), [WSL](https://learn.microsoft.com/windows/wsl/install).
