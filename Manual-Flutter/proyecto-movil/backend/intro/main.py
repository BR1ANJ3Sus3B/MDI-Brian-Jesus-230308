"""Ejercicio inicial en memoria. No utilizar como API autenticada del integrador."""
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field

app = FastAPI(title="Primera API")
usuarios = []


class Usuario(BaseModel):
    nombre: str = Field(min_length=1, max_length=100)
    correo: str = Field(pattern=r"^[^\s@]+@[^\s@]+\.[^\s@]+$")


@app.get("/")
def inicio():
    return {"mensaje": "API funcionando"}


@app.get("/usuarios")
def listar():
    return usuarios


@app.post("/usuarios", status_code=201)
def crear(usuario: Usuario):
    if any(u["correo"] == usuario.correo for u in usuarios):
        raise HTTPException(409, "Correo repetido")
    nuevo = {"id": len(usuarios) + 1, **usuario.model_dump()}
    usuarios.append(nuevo)
    return nuevo
