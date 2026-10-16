# 22. PostgreSQL

## ¿Qué es y para qué sirve?

Motor relacional: organiza datos en tablas, cuyas filas representan registros y columnas atributos. Una clave primaria identifica una fila; una clave foránea conecta una fila con otra tabla. SQL permite definir y consultar esos datos.

## Papel y requisitos

Conserva usuarios de aplicación, tareas y categorías. Resuelve integridad y relaciones; Keycloak guarda sus credenciales en una base separada. Requiere Docker y variables del capítulo 30.

## Instalación y configuración

La ruta principal usa el contenedor `postgres:17`, una familia mantenida, y un volumen persistente. El script de inicialización crea un usuario de aplicación sin privilegios de superusuario y aplica `database/postgres/02-schema.sql`. No es necesario instalar otro servidor en Windows.

Para instalación nativa opcional utiliza el [instalador oficial](https://www.postgresql.org/download/windows/), selecciona puerto y contraseña, y evita ejecutarlo al mismo tiempo que el contenedor en 5432.

## Comandos principales y ejemplo práctico

Desde `proyecto-movil`, con el servicio activo:

```powershell
docker compose exec postgres psql -U postgres -d app_mobile
```

En un servidor nuevo sin la base, el comando de creación sería:

```sql
CREATE DATABASE app_mobile;
```

Compose ya la crea. En la sesión de `app_mobile`, practica con la tabla educativa `usuarios` (incluida en el esquema):

```sql
CREATE TABLE IF NOT EXISTS usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(150) UNIQUE NOT NULL
);
```

```sql
INSERT INTO usuarios (nombre, correo) VALUES ('Alex', 'alex@example.com');
```

```sql
SELECT * FROM usuarios;
```

```sql
UPDATE usuarios SET nombre = 'Alex Rivera' WHERE correo = 'alex@example.com';
```

```sql
DELETE FROM usuarios WHERE correo = 'alex@example.com';
```

El backend conecta mediante `psycopg` o `pg`, usando consultas parametrizadas. El esquema integrador une `tasks.user_id` con `users.id` y `tasks.category_id` con `categories.id`.

## Verificación, errores comunes y soluciones

Comprueba persistencia al reiniciar sin borrar volúmenes. `connection refused` exige revisar servicio, host y puerto; error de contraseña exige revisar credenciales. Cambiar `.env` no cambia usuarios de un volumen inicializado: modifica la contraseña con SQL o recrea un laboratorio descartable con autorización.

## Evidencia y conclusión

**E08:** SELECT y relación entre tarea y propietario. Explica por qué una restricción UNIQUE sigue siendo necesaria aunque Flutter valide. [Tutorial SQL](https://www.postgresql.org/docs/17/tutorial-sql.html).
