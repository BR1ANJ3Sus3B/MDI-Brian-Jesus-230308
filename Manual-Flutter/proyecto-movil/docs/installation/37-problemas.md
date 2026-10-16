# 37. Resolución de problemas

Antes de modificar código anota: comando, directorio, versión, mensaje completo y resultado esperado. Repite una comprobación pequeña para aislar la capa que falla.

| Síntoma | Causa posible | Solución y comprobación |
| --- | --- | --- |
| flutter command not found | PATH incompleto o terminal antigua | Añadir `flutter/bin`, abrir terminal nueva, `where.exe flutter` |
| Android sdkmanager not found | Falta Command-line Tools o SDK equivocado | SDK Manager, instalar herramientas, revisar ruta, repetir doctor |
| Android licenses not accepted | Licencias pendientes | `flutter doctor --android-licenses`; leer y aceptar las necesarias |
| No devices found | Emulador apagado, cable o controlador | Iniciar AVD o revisar USB; repetir `flutter devices` |
| ADB device unauthorized | Autorización RSA pendiente | Desbloquear celular y aceptar la computadora; reconectar |
| INSTALL_FAILED_USER_RESTRICTED | Instalación USB restringida | Atender aviso, configuración del fabricante o política del dispositivo |
| Puerto Docker ocupado | Otro proceso publica el mismo puerto | Identificarlo y detener solo el proceso conocido o cambiar el puerto |
| Docker Desktop no inicia | WSL/virtualización/compatibilidad | Revisar virtualización, `wsl --status` y diagnóstico Desktop |
| PostgreSQL connection refused | Host o puerto equivocado, proceso caído | `docker compose ps`; interno `postgres:5432`, externo `localhost:5432` |
| MongoDB connection refused | Servicio inaccesible | Logs y puerto; interno `mongo`, externo `localhost` |
| Error de contraseña en DB | `.env` distinto del volumen existente | Usar credencial inicial o rotarla dentro de la DB; no borrar datos por impulso |
| Keycloak no inicia | DB no disponible, configuración o memoria | Logs de `keycloak` y `keycloak-db`; comprobar disponibilidad y recursos |
| Realm sin cambios tras editar JSON | Importación solo inicial | Aplicar cambios desde consola o importar en un entorno nuevo de prueba |
| 401 Unauthorized | Token ausente, vencido o claims inválidos | Renovar; comparar issuer/audience; usar access token y reloj correcto |
| 403 Forbidden | Rol insuficiente | Asignar rol y obtener un token nuevo |
| CORS en navegador | Origen no permitido | Añadir origen exacto a CORS_ORIGINS y reiniciar backend |
| Flutter no conecta a localhost | localhost apunta al teléfono | Configurar ADB reverse o red LAN consistente; capítulo 32 |
| Login no vuelve a Flutter | Redirect/manifest no coincide | Revisar esquema, URI exacta y recompilar Android |
| HTTP bloqueado en Android | Se ejecuta release con URLs HTTP | Usar debug local o configurar HTTPS para distribución |
| Git push rejected | Remoto avanzó o faltan permisos | Fetch, revisar historial, integrar cambios y reintentar |
| Git branch no encontrada | Nombre incorrecto, mayúsculas o rama solo remota | `git branch -a`, fetch y crear seguimiento si corresponde |

## Comandos de diagnóstico

```powershell
Get-NetTCPConnection -LocalPort 8000 -ErrorAction SilentlyContinue
```

```powershell
docker compose logs --tail 80 keycloak
```

```powershell
docker compose logs --tail 80 backend
```

```powershell
wsl --status
```

```powershell
git fetch origin
```

```powershell
git branch -a
```

Si tu rama existe solo en remoto:

```powershell
git switch --track origin/feature/api
```

Si un push falla por cambios ajenos, revisa `git status` y el historial. Con trabajo guardado, integra conscientemente mediante merge o rebase según el acuerdo del equipo. No uses `push --force` para ocultar un conflicto.

CORS protege llamadas desde navegadores; no es un firewall ni explica por sí solo una conexión rechazada en Android nativo. Un 401 demuestra que hubo comunicación HTTP; una conexión rechazada indica que no se llegó al servicio.

## Certificados TLS de una red administrada

Si npm, pip o Gradle muestran `UNABLE_TO_VERIFY_LEAF_SIGNATURE`, `CERTIFICATE_VERIFY_FAILED` o `PKIX path building failed`, puede existir una CA de la red que Windows reconoce pero el runtime no. Confirma con el administrador qué certificado debe confiarse. No desactives TLS ni uses registros HTTP.

Para Node moderno en Windows, en la sesión actual:

```powershell
$env:NODE_USE_SYSTEM_CA = '1'
```

Para el build Docker se incluye una ruta opcional: exporta únicamente los certificados públicos ya confiados por Windows y pásalos al build como un montaje temporal:

```powershell
powershell -File scripts/export_windows_ca.ps1
```

```powershell
docker compose --env-file .env -f infrastructure/docker-compose.yml -f infrastructure/docker-compose.ca.yml up -d --build
```

El archivo `.local/windows-ca.pem` está excluido de Git y no se copia a la imagen. En una red normal basta con el Compose principal. Para Gradle/JDK en Windows puedes probar el almacén del sistema en esa terminal:

```powershell
$env:JAVA_TOOL_OPTIONS = '-Djavax.net.ssl.trustStoreType=Windows-ROOT -Djavax.net.ssl.trustStore=NONE'
```

Después repite la compilación. Si tu JDK no admite ese almacén, solicita una CA verificada y configura un truststore específico para ese proceso. Cierra la terminal para descartar estas variables temporales.

Referencias: [CA en Docker](https://docs.docker.com/engine/network/ca-certs/), [certificados pip](https://pip.pypa.io/en/stable/topics/https-certificates/), [Node y certificados del sistema](https://nodejs.org/api/cli.html), [truststores Java](https://docs.oracle.com/en/java/javase/24/security/java-secure-socket-extension-jsse-reference-guide.html).
