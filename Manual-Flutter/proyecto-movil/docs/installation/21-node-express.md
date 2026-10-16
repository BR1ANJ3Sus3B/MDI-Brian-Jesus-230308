# 21. Alternativa B: Node.js y Express

## Node.js y npm

### ¿Qué son, para qué sirven y papel arquitectónico?

Node.js ejecuta JavaScript fuera del navegador. npm administra paquetes y scripts; `package.json` declara el proyecto y `package-lock.json` conserva la resolución de dependencias. Aquí ejecutan el backend alternativo a Python.

### Requisitos, instalación y configuración

Instala la versión LTS desde [Node.js](https://nodejs.org/en/download). El contenedor usa Node 24. Abre otra terminal:

```powershell
node --version
```

```powershell
npm.cmd --version
```

En Windows `npm.cmd` evita problemas con la política de ejecución del envoltorio PowerShell. En otras terminales usa `npm`.

### Comandos y ejemplo inicial

En una carpeta nueva de ejercicio:

```powershell
npm init -y
```

```powershell
npm install express
```

En el backend incluido, no regeneres el manifiesto: entra en `backend-node` y utiliza su archivo de bloqueo:

```powershell
npm.cmd ci
```

### Verificación, errores y soluciones

Si falta un paquete, instala desde la carpeta que contiene `package.json`. **E20:** versiones e instalación. Node es el runtime; npm es el administrador.

## Express

### ¿Qué es, para qué sirve y papel arquitectónico?

Framework de rutas HTTP para Node.js. Un **middleware** recibe la solicitud antes de la respuesta: puede leer JSON, verificar un token o registrar un error. Permite construir la misma API REST de la alternativa FastAPI.

### Requisitos, instalación y configuración

El proyecto usa Express 5, `pg`, el driver MongoDB, `jose` para JWT y Swagger UI. Las variables son las mismas que en FastAPI. Estructura:

```text
backend-node/
├── src/
│   ├── config/settings.js
│   ├── controllers/api.js
│   ├── routes/api.js
│   ├── services/auth.js
│   ├── models/validation.js
│   └── app.js
├── tests/
├── package.json
└── Dockerfile
```

### Comandos y ejemplo práctico

Desde `backend-node`, el ejemplo en memoria:

```powershell
node intro/app.js
```

Ofrece GET `/`, GET `/usuarios` y POST `/usuarios`. Para el integrador, cambia `BACKEND_CONTEXT=../backend-node` en `.env` y reconstruye Compose tras detener el backend anterior. No debe existir otro proceso usando 8000.

```powershell
npm.cmd test
```

### Verificación, errores comunes y soluciones

Repite E05 y E06 para esta alternativa. `EADDRINUSE` indica puerto ocupado. Un error de JSON se responde 400; un correo repetido, 409. La validación no debe confiar en la UI.

### Evidencia y conclusión

**E20:** endpoints y pruebas de Express. Compara la implementación con FastAPI: mismas responsabilidades y contrato, distintos lenguajes. [Express 5](https://expressjs.com/en/5x/api.html).
