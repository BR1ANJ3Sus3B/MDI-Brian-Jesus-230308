import {createRemoteJWKSet, jwtVerify} from 'jose';
import {settings} from '../config/settings.js';
import {ApiError} from '../models/validation.js';

const remoteKeys = createRemoteJWKSet(new URL(settings.jwks), {timeoutDuration: 5000});

export async function verifyToken(token, keys = remoteKeys) {
  const {payload} = await jwtVerify(token, keys, {
    issuer: settings.issuer,
    audience: settings.audience,
    algorithms: ['RS256'],
    requiredClaims: ['sub', 'exp', 'iat', 'iss', 'aud'],
  });
  return payload;
}

export async function authenticate(req, res, next) {
  const match = /^Bearer ([^\s]+)$/i.exec(req.headers.authorization ?? '');
  if (!match) {
    res.set('WWW-Authenticate', 'Bearer');
    throw new ApiError(401, 'Se requiere access token');
  }
  try {
    req.user = await verifyToken(match[1]);
  } catch (error) {
    if (error.code === 'ERR_JWKS_TIMEOUT' || error instanceof TypeError) {
      throw new ApiError(503, 'Identidad temporalmente no disponible');
    }
    res.set('WWW-Authenticate', 'Bearer');
    throw new ApiError(401, 'Token inválido o vencido');
  }
  next();
}

export const roles = user => user.realm_access?.roles ?? [];

export function requireRoles(...allowed) {
  return (req, res, next) => {
    if (!allowed.some(role => roles(req.user).includes(role))) throw new ApiError(403, 'Rol insuficiente');
    next();
  };
}
