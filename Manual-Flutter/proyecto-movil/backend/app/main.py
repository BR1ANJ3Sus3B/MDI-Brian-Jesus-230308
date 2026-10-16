import os
from contextlib import asynccontextmanager

import psycopg
from fastapi import FastAPI, Request
from fastapi.exceptions import RequestValidationError
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from fastapi.openapi.utils import get_openapi
from pymongo.errors import PyMongoError

from app.database.connections import mongo_client
from app.routes.api import router


@asynccontextmanager
async def lifespan(app):
    yield
    mongo_client.close()


app = FastAPI(title="API móvil de tareas", version="1.0.0", lifespan=lifespan)
app.add_middleware(
    CORSMiddleware,
    allow_origins=os.getenv("CORS_ORIGINS", "http://localhost:3000").split(","),
    allow_methods=["GET", "POST", "PUT", "DELETE"],
    allow_headers=["Authorization", "Content-Type"],
)


@app.exception_handler(RequestValidationError)
async def validation_error(request: Request, error: RequestValidationError):
    return JSONResponse(status_code=400, content={"detail": "Entrada inválida: revisa campos y tipos"})


@app.exception_handler(psycopg.OperationalError)
@app.exception_handler(PyMongoError)
async def unavailable(request: Request, error: Exception):
    return JSONResponse(status_code=503, content={"detail": "Base de datos temporalmente no disponible"})


@app.exception_handler(Exception)
async def unexpected(request: Request, error: Exception):
    return JSONResponse(status_code=500, content={"detail": "Error interno del servidor"})


app.include_router(router)


def contract():
    if app.openapi_schema:
        return app.openapi_schema
    schema = get_openapi(title=app.title, version=app.version, routes=app.routes)
    for path in schema['paths'].values():
        for operation in path.values():
            responses = operation.setdefault('responses', {})
            responses.pop('422', None)
            responses['400'] = {'description': 'Entrada inválida'}
            responses['503'] = {'description': 'Dependencia no disponible'}
            if operation.get('security'):
                responses['401'] = {'description': 'Token ausente o inválido'}
                responses['403'] = {'description': 'Rol insuficiente'}
            responses['404'] = {'description': 'Recurso no encontrado'}
            responses['409'] = {'description': 'Conflicto de datos'}
    app.openapi_schema = schema
    return schema


app.openapi = contract
