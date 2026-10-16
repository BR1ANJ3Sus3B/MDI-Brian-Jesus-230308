# 15. Emulador Android y dispositivo físico

Un **AVD** describe un dispositivo Android virtual: modelo, versión del sistema y recursos. El emulador lo ejecuta y permite probar sin un teléfono, a costa de más memoria y CPU.

## Crear y verificar un AVD

1. Android Studio → **Device Manager → Create Virtual Device**.
2. Selecciona un teléfono y una imagen Android compatible con la arquitectura de tu CPU.
3. Descarga la imagen y asigna recursos razonables; para un equipo de 16 GB comienza con 2–4 GB de RAM para el emulador.
4. Finaliza y pulsa iniciar. Espera a que termine de arrancar Android.

```powershell
flutter devices
```

Si no inicia, revisa virtualización y aceleración. La versión Android del teléfono emulado no tiene por qué ser idéntica al SDK usado para compilar, pero debe cumplir el mínimo de la aplicación. [Administrar AVD](https://developer.android.com/studio/run/managing-avds).

## Teléfono por USB

Activa opciones de desarrollador tocando repetidamente el número de compilación; habilita depuración USB, conecta un cable de datos y acepta la huella RSA de la computadora. Instala el controlador del fabricante si Windows lo necesita.

```powershell
adb devices
```

`unauthorized` exige aceptar la autorización en el teléfono. `INSTALL_FAILED_USER_RESTRICTED` suele requerir permitir la instalación por USB o atender una restricción del dispositivo; no se resuelve modificando Dart. [Dispositivos físicos](https://developer.android.com/studio/run/device).

**E03:** AVD o teléfono listado, pantalla Android y versión. Indica cuál usarás para la integración final.
