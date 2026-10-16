export const settings = {
  issuer: process.env.KEYCLOAK_ISSUER ?? 'http://localhost:8080/realms/app-mobile',
  jwks: process.env.KEYCLOAK_JWKS_URL ?? 'http://localhost:8080/realms/app-mobile/protocol/openid-connect/certs',
  audience: process.env.JWT_AUDIENCE ?? 'mobile-api',
  mongoUrl: process.env.MONGO_URL ?? 'mongodb://localhost:27017/app_mobile',
  mongoDb: process.env.MONGO_DB ?? 'app_mobile',
  mongoUser: process.env.MONGO_USER ?? 'developer',
  mongoPassword: process.env.MONGO_PASSWORD ?? '',
  origins: (process.env.CORS_ORIGINS ?? 'http://localhost:3000').split(','),
};
