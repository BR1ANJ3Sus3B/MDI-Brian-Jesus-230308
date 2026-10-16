const appDb = db.getSiblingDB('app_mobile');
appDb.createUser({
  user: process.env.APP_MONGO_USER,
  pwd: process.env.APP_MONGO_PASSWORD,
  roles: [{role: 'readWrite', db: 'app_mobile'}],
});
appDb.createCollection('activity');
appDb.createCollection('logs');
appDb.activity.createIndex({actor: 1, at: -1});
appDb.logs.createIndex({at: -1});
