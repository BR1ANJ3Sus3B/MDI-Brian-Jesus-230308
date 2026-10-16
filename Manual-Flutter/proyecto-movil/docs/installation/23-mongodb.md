# 23. MongoDB

## ¿Qué es y para qué sirve?

Base NoSQL orientada a documentos. Una colección agrupa documentos con campos; BSON es la representación binaria que admite tipos adicionales a JSON. Resuelve el almacenamiento de eventos con atributos que pueden variar, sin eliminar la necesidad de validar.

## Papel, requisitos e instalación

Guarda `logs` y `activity`; PostgreSQL conserva las tareas. Se instala mediante `mongo:8.0` y un volumen. `database/mongodb/init.js` crea un usuario limitado a `app_mobile`. Instala [MongoDB Compass](https://www.mongodb.com/products/tools/compass) si deseas una interfaz gráfica.

## Configuración y comandos principales

Desde Windows, Compass conecta a `localhost:27017`, con el usuario de aplicación, su contraseña y base de autenticación `app_mobile`. Dentro de Docker, el host es `mongo`.

Si ya existe MongoDB local en 27017, añade `MONGO_PORT=27018` a `.env` y usa `localhost:27018` en Compass. El backend continúa usando `mongo:27017`; cambiar el puerto publicado no cambia el puerto interno.

```powershell
docker compose exec mongo mongosh --username developer --authenticationDatabase app_mobile app_mobile
```

Introduce la contraseña cuando la solicite. Si cambiaste el nombre de usuario, sustituye `developer`.

## Ejemplo práctico

```javascript
db.usuarios.insertOne({nombre: 'Alex', correo: 'alex@example.com', rol: 'usuario'})
```

```javascript
db.usuarios.find({correo: 'alex@example.com'})
```

```javascript
db.usuarios.updateOne({correo: 'alex@example.com'}, {$set: {nombre: 'Alex Rivera'}})
```

```javascript
db.usuarios.deleteOne({correo: 'alex@example.com'})
```

Son operaciones CRUD: crear, leer, actualizar y eliminar. La colección `usuarios` es un ejercicio independiente de los eventos del integrador.

## Verificación, errores comunes y soluciones

Después de crear una tarea consulta `db.activity.find()`. Si falla autenticación, revisa `authSource`, usuario y contraseña. Si aparece `connection refused`, comprueba el contenedor y el nombre de host. Las credenciales iniciales se aplican únicamente sobre un volumen vacío.

## Evidencia y conclusión

**E09:** CRUD educativo y un evento real. Explica por qué la flexibilidad documental no significa ausencia de reglas. [Instalación MongoDB](https://www.mongodb.com/docs/manual/installation/), [CRUD](https://www.mongodb.com/docs/manual/crud/).
