import os

import jwt
from fastapi import Depends, HTTPException
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from jwt import PyJWKClient
from jwt.exceptions import PyJWKClientConnectionError

bearer = HTTPBearer(auto_error=False)
issuer = os.getenv("KEYCLOAK_ISSUER", "http://localhost:8080/realms/app-mobile")
audience = os.getenv("JWT_AUDIENCE", "mobile-api")
jwks = PyJWKClient(
    os.getenv("KEYCLOAK_JWKS_URL", issuer + "/protocol/openid-connect/certs"),
    timeout=5,
)


def decode_token(token, key):
    return jwt.decode(
        token, key, algorithms=["RS256"], audience=audience, issuer=issuer,
        options={"require": ["exp", "iat", "sub", "iss", "aud"]},
    )


def current_user(credentials: HTTPAuthorizationCredentials | None = Depends(bearer)):
    if credentials is None:
        raise HTTPException(401, "Se requiere access token", headers={"WWW-Authenticate": "Bearer"})
    try:
        key = jwks.get_signing_key_from_jwt(credentials.credentials).key
        return decode_token(credentials.credentials, key)
    except PyJWKClientConnectionError as error:
        raise HTTPException(503, "Identidad temporalmente no disponible") from error
    except jwt.PyJWTError as error:
        raise HTTPException(401, "Token inválido o vencido", headers={"WWW-Authenticate": "Bearer"}) from error


def roles(user):
    return user.get("realm_access", {}).get("roles", [])


def task_user(user=Depends(current_user)):
    if not {"usuario", "administrador"}.intersection(roles(user)):
        raise HTTPException(403, "Se requiere rol usuario o administrador")
    return user


def admin_user(user=Depends(current_user)):
    if "administrador" not in roles(user):
        raise HTTPException(403, "Se requiere rol administrador")
    return user
