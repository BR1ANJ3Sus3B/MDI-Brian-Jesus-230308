import time
from types import SimpleNamespace

import jwt
import pytest
from cryptography.hazmat.primitives.asymmetric import rsa
from fastapi.testclient import TestClient

from app.main import app
from app.services import auth
from app.routes import api

client = TestClient(app)


@pytest.fixture(autouse=True)
def clean_overrides():
    app.dependency_overrides.clear()
    yield
    app.dependency_overrides.clear()


@pytest.fixture
def keys(monkeypatch):
    private = rsa.generate_private_key(public_exponent=65537, key_size=2048)
    monkeypatch.setattr(auth.jwks, "get_signing_key_from_jwt", lambda token: SimpleNamespace(key=private.public_key()))
    return private


def token(key, **overrides):
    now = int(time.time())
    claims = {"sub": "student-a", "iss": auth.issuer, "aud": auth.audience,
              "iat": now, "exp": now + 300, "realm_access": {"roles": ["usuario"]}}
    claims.update(overrides)
    return jwt.encode(claims, key, algorithm="RS256")


def test_public_and_missing_token():
    assert client.get("/").status_code == 200
    assert client.get("/tasks").status_code == 401


@pytest.mark.parametrize("overrides", [{"exp": 1}, {"iss": "https://wrong.invalid"}, {"aud": "another-api"}])
def test_rejects_bad_claims(keys, overrides):
    response = client.get("/me", headers={"Authorization": "Bearer " + token(keys, **overrides)})
    assert response.status_code == 401


def test_rejects_wrong_signature(keys):
    other = rsa.generate_private_key(public_exponent=65537, key_size=2048)
    assert client.get("/me", headers={"Authorization": "Bearer " + token(other)}).status_code == 401


def test_valid_identity_and_forbidden_role(keys):
    headers = {"Authorization": "Bearer " + token(keys)}
    assert client.get("/me", headers=headers).json()["sub"] == "student-a"
    assert client.get("/usuarios", headers=headers).status_code == 403


def test_account_without_application_role(keys):
    headers = {"Authorization": "Bearer " + token(keys, realm_access={"roles": []})}
    assert client.get("/tasks", headers=headers).status_code == 403


@pytest.mark.parametrize("body", [{"title": "   "}, {"title": "Study", "completed": "false"}, {"title": "Study", "category_id": -1}, {"title": "Study", "user_id": 2}])
def test_input_validation_before_database(body):
    app.dependency_overrides[auth.current_user] = lambda: {"sub": "a", "realm_access": {"roles": ["usuario"]}}
    assert client.post("/tasks", json=body).status_code == 400


def test_not_found_cannot_mutate_other_owners_task(monkeypatch):
    app.dependency_overrides[auth.current_user] = lambda: {"sub": "a", "realm_access": {"roles": ["usuario"]}}
    calls = []

    def database(sql, params=(), *, one=False):
        calls.append((sql, params))
        return {"id": 7} if sql.startswith("INSERT INTO users") else None

    monkeypatch.setattr(api, "query", database)
    assert client.put("/tasks/9", json={"title": "Changed"}).status_code == 404
    assert "AND user_id=%s" in calls[-1][0]
    assert calls[-1][1][-1] == 7


def test_audit_failure_is_visible_after_saved_task(monkeypatch):
    app.dependency_overrides[auth.current_user] = lambda: {"sub": "a", "realm_access": {"roles": ["usuario"]}}
    monkeypatch.setattr(api, "owner", lambda user: 1)
    monkeypatch.setattr(api, "query", lambda *args, **kwargs: {"id": 9, "title": "Study", "completed": False})
    monkeypatch.setattr(api, "record_activity", lambda *args: False)
    response = client.post("/tasks", json={"title": "Study"})
    assert response.status_code == 201
    assert response.json()["audit_recorded"] is False
