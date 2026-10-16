# Entorno de desarrollo móvil multiplataforma

Proyecto académico para pasar de la instalación de herramientas a una aplicación Flutter de gestión de tareas con autenticación y persistencia.

**Empieza por el [índice del manual](docs/README.md).** Sigue los capítulos en orden. El entorno principal es Windows + PowerShell + Android. Los servicios del backend se ejecutan en contenedores Linux.

## Qué contiene

- Flutter: login con OpenID Connect y PKCE, perfil y CRUD de tareas.
- **Alternativa A:** Python + FastAPI, documentación OpenAPI, Swagger y ReDoc.
- **Alternativa B:** Node.js + Express, el mismo contrato HTTP y Swagger UI.
- PostgreSQL: usuarios, categorías y tareas. MongoDB: eventos de actividad y registros.
- Keycloak: usuarios, roles y emisión de JWT. Cada API verifica firma, emisor, audiencia y expiración.
- Docker Compose: infraestructura compartida y una alternativa de backend a la vez.
- Ejemplos de Postman, pruebas y plantillas de evidencias.

## Estructura

```text
proyecto-movil/
├── mobile/flutter_app/       Aplicación Android en Flutter
├── backend/                 Alternativa A: FastAPI
├── backend-node/            Alternativa B: Express
├── database/
│   ├── postgres/            Esquema e inicialización
│   └── mongodb/             Ejercicios CRUD
├── infrastructure/
│   ├── keycloak/            Realm importable sin contraseñas de usuarios
│   └── docker-compose.yml   Servicios comunes + FastAPI por defecto
├── docs/
│   ├── installation/        Capítulos del manual
│   ├── diagrams/            Diagramas Mermaid
│   └── evidence/            Plantillas y registro de verificación
├── postman/                 Colección y entorno local
├── scripts/                 Comprobaciones del proyecto
├── .env.example             Configuración de desarrollo
└── .gitignore
```

## Arranque rápido después de instalar las herramientas

Ejecuta desde esta carpeta, `proyecto-movil`:

```powershell
Copy-Item .env.example .env
```

Edita `.env` y sustituye las contraseñas de ejemplo antes de iniciar. El archivo real queda excluido de Git. La configuración es para un laboratorio local; Keycloak usa `start-dev` y HTTP.

```powershell
docker compose up -d --build
```

`.env` establece `COMPOSE_FILE=infrastructure/docker-compose.yml`. Por ello, los comandos cortos funcionan desde esta carpeta. Usa siempre este directorio para administrar el entorno.

```powershell
docker compose ps
```

| Servicio | Dirección desde Windows |
| --- | --- |
| API | http://localhost:8000 |
| Swagger | http://localhost:8000/docs |
| OpenAPI | http://localhost:8000/openapi.json |
| ReDoc, alternativa FastAPI | http://localhost:8000/redoc |
| Keycloak | http://localhost:8080 |
| PostgreSQL | localhost:5432 |
| MongoDB | localhost:27017 |

En Keycloak crea los usuarios y asigna roles según el [capítulo 25](docs/installation/25-keycloak.md). No se incluye una cuenta de alumno con contraseña predeterminada.

Para elegir Express, detén primero el backend actual:

```powershell
docker compose down
```

Cambia en `.env` `BACKEND_CONTEXT=../backend-node`, y después:

```powershell
docker compose up -d --build
```

Ambas alternativas ocupan el puerto 8000 y usan las mismas bases de datos. Se elige una, no se encadenan ni se ejecutan simultáneamente.

## Ejecutar Flutter

El [capítulo 32](docs/installation/32-integracion-keycloak.md) explica el cliente público y la red. Para un Android conectado por USB, configura los puertos inversos con ADB y ejecuta desde `mobile/flutter_app`:

```powershell
flutter pub get
```

```powershell
flutter run --dart-define=API_URL=http://localhost:8000 --dart-define=ISSUER=http://localhost:8080/realms/app-mobile
```

El teléfono debe tener navegador para el login. La API espera un access token de Keycloak con audiencia `mobile-api`; los endpoints de tareas requieren rol `usuario` o `administrador`.

## Validación y entrega

Consulta [pruebas](docs/installation/33-pruebas.md), [actividad integradora](docs/installation/39-actividad-final.md) y [estado de verificación](docs/evidence/VERIFICACION.md). Los resultados esperados no se presentan como capturas ni como pruebas ejecutadas. Cada alumno debe registrar sus propios resultados.

Para apagar conservando los datos:

```powershell
docker compose down
```

> **Advertencia:** agregar `-v` elimina los volúmenes y los datos del laboratorio. No se necesita para cambiar entre backends.
