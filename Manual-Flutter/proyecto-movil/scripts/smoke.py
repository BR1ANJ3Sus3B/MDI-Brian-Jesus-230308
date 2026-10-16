"""Live smoke test. Prompts for a user access token without printing it."""
import getpass
import json
import urllib.error
import urllib.request
import uuid


def request(method, path, token=None, data=None):
    headers = {"Content-Type": "application/json"}
    if token:
        headers["Authorization"] = "Bearer " + token
    req = urllib.request.Request("http://localhost:8000" + path, method=method,
        headers=headers, data=None if data is None else json.dumps(data).encode())
    try:
        with urllib.request.urlopen(req, timeout=20) as response:
            return response.status, json.load(response)
    except urllib.error.HTTPError as error:
        return error.code, json.load(error)


def main():
    token = getpass.getpass("Access token de usuario (oculto): ").strip()
    if not token:
        raise SystemExit("Se necesita un token válido; no se ejecutaron mutaciones.")
    assert request("GET", "/health")[0] == 200
    assert request("GET", "/tasks")[0] == 401
    assert request("GET", "/tasks", "invalid-token")[0] == 401
    assert request("POST", "/tasks", token, {"title": " "})[0] == 400
    status, task = request("POST", "/tasks", token, {"title": "Prueba " + uuid.uuid4().hex[:8]})
    assert status == 201, (status, task)
    task_id = task["id"]
    try:
        assert task["audit_recorded"] is True, "La tarea se guardó pero MongoDB no registró el evento"
        status, tasks = request("GET", "/tasks", token)
        assert status == 200 and any(item["id"] == task_id for item in tasks)
        status, edited = request("PUT", f"/tasks/{task_id}", token, {"title": "Prueba completada", "completed": True})
        assert status == 200 and edited["completed"] is True and edited["audit_recorded"] is True
    finally:
        status, deleted = request("DELETE", f"/tasks/{task_id}", token)
        assert status == 200 and deleted["audit_recorded"] is True, "Revisa manualmente la tarea de prueba"
    assert request("DELETE", f"/tasks/{task_id}", token)[0] == 404
    print("OK: salud, autenticación, validación, CRUD y auditoría reportada por la API.")


if __name__ == "__main__":
    main()
