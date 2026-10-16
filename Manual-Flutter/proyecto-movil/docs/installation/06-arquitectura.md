# 06. Arquitectura del entorno

```mermaid
flowchart TD
  Flutter[Flutter / Dart] -->|HTTP / HTTPS: API REST| Backend
  subgraph Compose[Docker Compose: entorno backend]
    Backend[Backend: FastAPI O Express] --> PG[(PostgreSQL: users, tasks, categories)]
    Backend --> MG[(MongoDB: logs, activity)]
    KC[Keycloak] --> KDB[(PostgreSQL separado: identidad)]
  end
  Flutter -->|Authorization Code + PKCE| KC
  KC -->|Access token JWT| Flutter
  Flutter -->|Authorization: Bearer JWT| Backend
  Backend -->|Claves públicas JWKS| KC
  Git[Git local] --> GitHub[GitHub remoto / Pull Requests]
  Git -. versiona código y configuración .-> Compose
  Git -. versiona .-> Flutter
```

![Arquitectura DevOps para una aplicación Flutter](../../Assets/arquitectura-devops-flutter.png)

*Vista general de la arquitectura DevOps: Flutter, backend, PostgreSQL, MongoDB, Keycloak, Docker y Git.*

FastAPI y Express implementan el mismo contrato; elige una alternativa. Keycloak mantiene su propia base de identidad y credenciales, separada de las tablas de aplicación. No se conectan PostgreSQL o MongoDB directamente desde Flutter.

En el laboratorio HTTP facilita la configuración local; en producción se utiliza HTTPS. El backend usa nombres de servicio (`postgres`, `mongo`, `keycloak`) dentro de Docker. Un teléfono necesita una dirección accesible desde su red o el puente USB descrito en el capítulo 32.

La escritura de tareas y la auditoría en MongoDB no forman una transacción distribuida. Si falla MongoDB después de guardar una tarea, la respuesta indica `audit_recorded: false`; el capítulo 39 explica esta limitación deliberada.
