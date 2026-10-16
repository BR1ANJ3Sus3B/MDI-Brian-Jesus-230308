# 28. Dockerfile

Un Dockerfile expresa la construcción de una imagen en capas. Cambiar código puede reutilizar la capa de dependencias si se copiaron primero sus manifiestos.

| Instrucción | Función |
| --- | --- |
| FROM | Imagen base |
| WORKDIR | Directorio de trabajo |
| COPY | Copiar archivos desde el contexto |
| RUN | Ejecutar una acción durante construcción |
| EXPOSE | Documentar puerto; no lo publica por sí solo |
| CMD | Comando predeterminado al iniciar |

## FastAPI: `backend/Dockerfile`

Utiliza Python 3.13 slim, instala `requirements.txt`, copia `app`, crea un usuario sin privilegios y ejecuta Uvicorn en `0.0.0.0:8000`. Revisa el archivo real: es el usado por Compose.

## Express: `backend-node/Dockerfile`

Utiliza Node 24 slim, instala con `npm ci --omit=dev`, copia `src` y el contrato OpenAPI, selecciona el usuario `node` y ejecuta `node src/server.js`.

Construye desde la raíz:

```powershell
docker build -t mobile-fastapi ./backend
```

```powershell
docker build -t mobile-express ./backend-node
```

Los archivos `.dockerignore` excluyen entornos locales, caches y secretos. Las variables de ejecución se entregan al contenedor; no copies `.env` a una imagen. El servidor escucha en todas las interfaces del contenedor, mientras Compose limita los puertos publicados al equipo local.

**E22:** construcción de la alternativa elegida y explicación de sus capas. Un build correcto comprueba la imagen, no la conectividad completa con las bases. [Referencia Dockerfile](https://docs.docker.com/reference/dockerfile/).
