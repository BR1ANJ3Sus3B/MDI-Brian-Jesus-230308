from fastapi import APIRouter, Depends, HTTPException, Path
from psycopg.errors import ForeignKeyViolation, UniqueViolation

from app.database.connections import mongo_db, query
from app.models.schemas import TaskInput, UserInput
from app.services.activity import record_activity
from app.services.auth import admin_user, current_user, task_user, roles

router = APIRouter()


def owner(user):
    row = query(
        "INSERT INTO users (keycloak_sub, username) VALUES (%s,%s) "
        "ON CONFLICT (keycloak_sub) DO UPDATE SET username=EXCLUDED.username RETURNING id",
        (user["sub"], user.get("preferred_username", user["sub"])), one=True,
    )
    return row["id"]


@router.get("/")
def root():
    return {"message": "API de gestión de tareas", "backend": "fastapi"}


@router.get("/health")
def health():
    query("SELECT 1")
    mongo_db.command("ping")
    return {"status": "ok", "postgres": "ok", "mongo": "ok"}


@router.get("/me")
def me(user=Depends(current_user)):
    return {"sub": user["sub"], "username": user.get("preferred_username", ""), "roles": roles(user)}


@router.get("/usuarios", dependencies=[Depends(admin_user)])
def list_users():
    return query("SELECT id,nombre,correo FROM usuarios ORDER BY id")


@router.post("/usuarios", status_code=201, dependencies=[Depends(admin_user)])
def create_user(data: UserInput):
    try:
        return query("INSERT INTO usuarios (nombre,correo) VALUES (%s,%s) RETURNING id,nombre,correo",
                     (data.nombre, data.correo), one=True)
    except UniqueViolation as error:
        raise HTTPException(409, "El correo ya existe") from error


@router.get("/categories", dependencies=[Depends(task_user)])
def categories():
    return query("SELECT id,name FROM categories ORDER BY id")


@router.get("/tasks")
def list_tasks(user=Depends(task_user)):
    return query("SELECT id,title,completed,category_id,created_at FROM tasks WHERE user_id=%s ORDER BY id",
                 (owner(user),))


@router.post("/tasks", status_code=201)
def create_task(data: TaskInput, user=Depends(task_user)):
    try:
        row = query("INSERT INTO tasks (user_id,title,completed,category_id) VALUES (%s,%s,%s,%s) "
                    "RETURNING id,title,completed,category_id,created_at",
                    (owner(user), data.title, data.completed, data.category_id), one=True)
    except ForeignKeyViolation as error:
        raise HTTPException(400, "Categoría inexistente") from error
    row["audit_recorded"] = record_activity(user["sub"], "create", row["id"])
    return row


@router.put("/tasks/{task_id}")
def update_task(data: TaskInput, task_id: int = Path(gt=0), user=Depends(task_user)):
    try:
        row = query("UPDATE tasks SET title=%s,completed=%s,category_id=%s WHERE id=%s AND user_id=%s "
                    "RETURNING id,title,completed,category_id,created_at",
                    (data.title, data.completed, data.category_id, task_id, owner(user)), one=True)
    except ForeignKeyViolation as error:
        raise HTTPException(400, "Categoría inexistente") from error
    if row is None:
        raise HTTPException(404, "Tarea no encontrada")
    row["audit_recorded"] = record_activity(user["sub"], "update", row["id"])
    return row


@router.delete("/tasks/{task_id}")
def delete_task(task_id: int = Path(gt=0), user=Depends(task_user)):
    row = query("DELETE FROM tasks WHERE id=%s AND user_id=%s RETURNING id", (task_id, owner(user)), one=True)
    if row is None:
        raise HTTPException(404, "Tarea no encontrada")
    return {"deleted": task_id, "audit_recorded": record_activity(user["sub"], "delete", task_id)}


@router.get("/admin/activity", dependencies=[Depends(admin_user)])
def activity():
    return list(mongo_db.activity.find({}, {"_id": 0}).sort("at", -1).limit(100))
