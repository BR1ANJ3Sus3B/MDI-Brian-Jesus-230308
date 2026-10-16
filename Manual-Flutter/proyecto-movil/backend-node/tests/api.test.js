import test from 'node:test';
import assert from 'node:assert/strict';
import request from 'supertest';
import {createLocalJWKSet, exportJWK, generateKeyPair, SignJWT} from 'jose';
import {app} from '../src/app.js';
import {verifyToken, requireRoles} from '../src/services/auth.js';
import {settings} from '../src/config/settings.js';
import {taskInput, userInput} from '../src/models/validation.js';
import {closeConnections} from '../src/config/database.js';

test.after(closeConnections);

test('public root and missing bearer', async () => {
  assert.equal((await request(app).get('/')).status, 200);
  assert.equal((await request(app).get('/tasks')).status, 401);
});

test('invalid JSON is 400', async () => {
  const response = await request(app).post('/tasks').set('Content-Type', 'application/json').send('{broken');
  assert.equal(response.status, 400);
});

test('input rejects blank, coercion and ownership injection', () => {
  for (const input of [{title: ' '}, {title: 'Study', completed: 'false'}, {title: 'Study', category_id: -1}, {title: 'Study', user_id: 3}]) {
    assert.throws(() => taskInput(input), error => error.status === 400);
  }
  assert.equal(userInput({nombre: ' Alex ', correo: 'ALEX@example.com'}).correo, 'alex@example.com');
});

test('valid signature and claims accepted; wrong issuer, audience, expiry rejected', async () => {
  const {privateKey, publicKey} = await generateKeyPair('RS256');
  const jwk = await exportJWK(publicKey);
  const keys = createLocalJWKSet({keys: [{...jwk, kid: 'test-key', alg: 'RS256'}]});
  const sign = overrides => new SignJWT({sub: 'a', iat: Math.floor(Date.now()/1000), exp: Math.floor(Date.now()/1000)+300,
    iss: settings.issuer, aud: settings.audience, ...overrides}).setProtectedHeader({alg: 'RS256', kid: 'test-key'}).sign(privateKey);
  assert.equal((await verifyToken(await sign({}), keys)).sub, 'a');
  for (const overrides of [{iss: 'wrong'}, {aud: 'wrong'}, {exp: 1}]) {
    await assert.rejects(verifyToken(await sign(overrides), keys));
  }
  const other = await generateKeyPair('RS256');
  const forged = await new SignJWT({sub:'a'}).setProtectedHeader({alg:'RS256',kid:'test-key'}).sign(other.privateKey);
  await assert.rejects(verifyToken(forged, keys));
});

test('role guard forbids authenticated account without role', () => {
  const guard = requireRoles('usuario', 'administrador');
  assert.throws(() => guard({user:{realm_access:{roles:[]}}}, {}, () => assert.fail()), error => error.status === 403);
  let allowed = false;
  guard({user:{realm_access:{roles:['usuario']}}}, {}, () => {allowed = true;});
  assert.equal(allowed, true);
});
