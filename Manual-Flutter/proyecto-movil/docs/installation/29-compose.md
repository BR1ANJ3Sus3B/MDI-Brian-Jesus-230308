# 29. Docker Compose

## ¿Qué es, para qué sirve y papel arquitectónico?

Herramienta para describir varios contenedores como un sistema. Resuelve el arranque manual con numerosos comandos y redes inconsistentes.

## Requisitos e instalación

Docker Desktop incluye Compose v2. Comprueba:

```powershell
docker compose version
```

## Configuración

`infrastructure/docker-compose.yml` contiene backend, PostgreSQL, MongoDB, Keycloak y un PostgreSQL independiente para identidad. `services` define procesos; `volumes` preserva datos; `networks` permite comunicación por nombres; `environment` configura procesos; `ports` publica servicios al anfitrión.

Desde `proyecto-movil`, copia `.env.example` a `.env`, sustituye contraseñas y conserva `COMPOSE_FILE=infrastructure/docker-compose.yml`. Las rutas de montaje y build se resuelven respecto del archivo Compose; por eso usan `../backend` y `../database`.

## Comandos principales y ejemplo práctico

```powershell
docker compose config --quiet
```

Valida la configuración sin imprimir valores sensibles.

```powershell
docker compose up -d
```

```powershell
docker compose ps
```

```powershell
docker compose logs --tail 50 backend
```

```powershell
docker compose build
```

```powershell
docker compose down
```

Usa `up -d --build` después de cambiar código. Para Express modifica `BACKEND_CONTEXT` según README y reconstruye. Los healthchecks de las bases evitan iniciar el backend antes de que respondan; Keycloak puede tardar más. `/health` comprueba las dos bases, no sustituye la prueba del login.

## Verificación, errores comunes y soluciones

Si 8000 está ocupado, detén tu Uvicorn/Node local. Si hay un volumen antiguo, los scripts de inicialización no vuelven a correr. `down` conserva volúmenes; `down -v` borra datos y requiere asumir esa pérdida.

## Evidencia y conclusión

**E12:** servicios, health y arranque. Explica diferencia entre ordenar arranque y garantizar disponibilidad permanente. [Compose](https://docs.docker.com/compose/), [dependencias y salud](https://docs.docker.com/compose/how-tos/startup-order/).
