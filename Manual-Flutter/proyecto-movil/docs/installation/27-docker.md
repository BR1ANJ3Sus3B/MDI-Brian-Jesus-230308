# 27. Docker

## ¿Qué es y para qué sirve?

Ejecuta procesos aislados a partir de imágenes. Reduce diferencias entre computadoras al empaquetar dependencias. Una máquina virtual incluye su propio sistema/kernel; los contenedores Linux comparten el kernel del entorno Linux que Docker Desktop administra en Windows.

| Concepto | Explicación |
| --- | --- |
| Imagen | Plantilla de archivos y configuración |
| Contenedor | Instancia en ejecución o detenida |
| Dockerfile | Instrucciones para construir una imagen |
| Volumen | Datos persistentes fuera del ciclo de vida del contenedor |
| Puerto | Punto de escucha TCP/UDP |
| Network | Red que comunica contenedores |
| Registry | Servicio de distribución de imágenes |

## Papel, requisitos, instalación y configuración

Ejecuta el backend y sus dependencias. Requiere virtualización, WSL 2 y Windows compatible. Instala [Docker Desktop](https://docs.docker.com/desktop/setup/install/windows-install/), completa WSL si se solicita, reinicia e inicia Docker Desktop con contenedores Linux. Espera a que el motor esté disponible.

## Comandos principales y ejemplo práctico

```powershell
docker --version
```

```powershell
docker version
```

El segundo debe mostrar Client y Server.

```powershell
docker pull hello-world
```

```powershell
docker run --name prueba-docker hello-world
```

```powershell
docker ps
```

```powershell
docker ps -a
```

```powershell
docker images
```

```powershell
docker logs prueba-docker
```

`hello-world` termina inmediatamente. Para detener un contenedor de larga duración usa `docker stop NOMBRE`. Elimina solo el ejemplo detenido:

```powershell
docker rm prueba-docker
```

## Verificación, errores comunes y soluciones

Si solo aparece Client, inicia el motor. Si falla WSL, consulta su estado y virtualización. No borres todos los volúmenes para solucionar un puerto ocupado; identifica el proceso.

## Evidencia y conclusión

**E11:** Client/Server y hello-world. Explica por qué una imagen no equivale a un contenedor. [Conceptos Docker](https://docs.docker.com/get-started/docker-concepts/the-basics/what-is-a-container/).
