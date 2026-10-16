# 19. Alternativa A: Python y FastAPI

## Python

### ¿Qué es, para qué sirve y papel arquitectónico?

Lenguaje interpretado con bibliotecas para web y datos. Ejecuta la lógica del backend de esta alternativa. Resuelve el desarrollo de servicios con código legible y tipado opcional.

### Requisitos previos, instalación y configuración

Instala una versión compatible de [Python para Windows](https://www.python.org/downloads/windows/). El contenedor usa la familia 3.13. Verifica el ejecutable y crea un entorno virtual: una carpeta que aísla las dependencias del proyecto.

```powershell
python --version
```

Desde `backend`:

```powershell
python -m venv .venv
```

### Comandos y ejemplo práctico

```powershell
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
```

Usar explícitamente el Python del entorno evita cambiar la política de ejecución de PowerShell. En una terminal con el entorno activado, la instalación mínima de una API educativa sería:

```powershell
pip install fastapi uvicorn
```

### Verificación, errores y soluciones

```powershell
.\.venv\Scripts\python.exe -m pip --version
```

Si falta un módulo, comprueba que instalaste y ejecutas con el mismo intérprete. **E19:** versión, entorno y dependencias. Conclusión: el entorno virtual aísla paquetes, no es una máquina virtual. [Referencia venv](https://docs.python.org/3/library/venv.html).

## FastAPI

### ¿Qué es, para qué sirve y papel arquitectónico?

Framework de APIs en Python que aprovecha modelos tipados para validar y documentar entradas. **Uvicorn** es el servidor ASGI que recibe HTTP y ejecuta la aplicación. FastAPI es una alternativa completa a Express.

### Requisitos, instalación y configuración

Utiliza el entorno anterior. La API real está en `backend/app/main.py`, con rutas, modelos, servicios y acceso a datos separados. Sus dependencias están en `requirements.txt`; Docker instala el mismo archivo.

```text
backend/
├── app/
│   ├── main.py
│   ├── routes/api.py
│   ├── models/schemas.py
│   ├── services/auth.py
│   └── database/connections.py
├── tests/
├── requirements.txt
└── Dockerfile
```

### Ejemplo inicial independiente

`backend/intro/main.py` implementa GET `/`, GET `/usuarios` y POST `/usuarios` en memoria. Desde `backend/intro`, con el entorno creado un nivel arriba:

```powershell
..\.venv\Scripts\uvicorn.exe main:app --reload
```

Con Uvicorn en el PATH, el equivalente es:

```powershell
uvicorn main:app --reload
```

Aquí los datos desaparecen al reiniciar. Detén este ejemplo antes de arrancar Compose, porque ambos usan 8000. La API integradora usa PostgreSQL y protege `/usuarios` con rol administrador.

### Ejecutar la API integradora localmente

Levanta primero los servicios de datos y Keycloak con Compose. Desde `backend`, establece PGHOST, PGPORT, PGDATABASE, PGUSER, PGPASSWORD, MONGO_URL, MONGO_USER, MONGO_PASSWORD, KEYCLOAK_ISSUER y KEYCLOAK_JWKS_URL con valores de tu `.env`; cambia los hosts Docker por `localhost`. Los valores predeterminados no incluyen contraseñas.

```powershell
.\.venv\Scripts\uvicorn.exe app.main:app --reload
```

La ruta recomendada para evitar diferencias de configuración es `docker compose up -d --build` desde la raíz del proyecto.

### Verificación, errores comunes y soluciones

Abre `/docs`, consulta `/health` y prueba entradas inválidas. La API devuelve 400 en validación y 409 en duplicados. Si el módulo `app` no aparece, ejecuta desde `backend`; si falla una conexión, revisa el host interno o externo.

### Evidencia y conclusión

**E05:** respuestas de creación y consulta; **E19:** pruebas Python. Explica la diferencia entre memoria y persistencia. [Tutorial FastAPI](https://fastapi.tiangolo.com/tutorial/).
