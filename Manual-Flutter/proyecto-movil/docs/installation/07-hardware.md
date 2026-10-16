# 07. Requisitos de hardware

Estas cifras son un presupuesto académico orientativo para este laboratorio, no sustituyen los requisitos oficiales de cada herramienta.

## Configuración mínima práctica

| Recurso | Propuesta |
| --- | --- |
| CPU | 64 bits, compatible con virtualización |
| RAM | 8 GB, usando celular físico y evitando cargas simultáneas |
| Disco | SSD; al menos 30 GB libres para comenzar, ampliables |
| Virtualización | Habilitada en firmware y disponible para WSL 2 |
| Red | Internet para SDK, imágenes y dependencias |

## Configuración recomendada

| Recurso | Propuesta |
| --- | --- |
| CPU | Core i5 / Ryzen 5 o superior, varios núcleos |
| RAM | 16 GB; 32 GB da mayor margen para emulador y servicios |
| Disco | SSD, 40–50 GB libres inicialmente |
| Virtualización | Activa; WSL 2 operativo |
| Dispositivo | Android físico por USB o AVD |

El emulador ejecuta un sistema Android completo. Docker Desktop necesita recursos para su entorno Linux; Keycloak ejecuta Java; ambas bases mantienen cachés. Además, Gradle compila Android y el editor indexa código. Con 8 GB usa un teléfono, cierra aplicaciones pesadas y mide consumo en el Administrador de tareas.

Si las versiones instaladas requieren más memoria o un Windows más reciente, prevalecen sus requisitos oficiales: [Android Studio](https://developer.android.com/studio/install) y [Docker Desktop para Windows](https://docs.docker.com/desktop/setup/install/windows-install/).

**Evidencia E15:** procesador, memoria, espacio disponible y virtualización; oculta identificadores personales del equipo.
