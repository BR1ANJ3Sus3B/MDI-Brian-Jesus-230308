import pg from 'pg';
import {MongoClient} from 'mongodb';
import {settings} from './settings.js';

// pg reads the standard PGHOST, PGUSER, PGPASSWORD and PGDATABASE variables.
export const pool = new pg.Pool({connectionTimeoutMillis: 5000, max: 10});
pool.on('error', () => console.error('PostgreSQL idle connection unavailable'));
export const mongoClient = new MongoClient(settings.mongoUrl, {
  auth: {username: settings.mongoUser, password: settings.mongoPassword},
  authSource: settings.mongoDb,
  serverSelectionTimeoutMS: 3000,
  connectTimeoutMS: 3000,
  socketTimeoutMS: 3000,
});
export const mongoDb = mongoClient.db(settings.mongoDb);

export async function closeConnections() {
  await Promise.all([pool.end(), mongoClient.close()]);
}
