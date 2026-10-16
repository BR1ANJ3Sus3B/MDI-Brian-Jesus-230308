import {pool, mongoDb} from '../config/database.js';
import {taskInput, userInput, positiveId, ApiError} from '../models/validation.js';
import {recordActivity} from '../services/activity.js';
import {roles} from '../services/auth.js';

async function owner(user) {
  const {rows} = await pool.query(
    'INSERT INTO users (keycloak_sub,username) VALUES ($1,$2) ON CONFLICT (keycloak_sub) DO UPDATE SET username=EXCLUDED.username RETURNING id',
    [user.sub, user.preferred_username ?? user.sub]);
  return rows[0].id;
}

export async function health(req, res) {
  await pool.query('SELECT 1');
  await mongoDb.command({ping: 1});
  res.json({status: 'ok', postgres: 'ok', mongo: 'ok'});
}

export function me(req, res) {
  res.json({sub: req.user.sub, username: req.user.preferred_username ?? '', roles: roles(req.user)});
}

export async function listUsers(req, res) {
  res.json((await pool.query('SELECT id,nombre,correo FROM usuarios ORDER BY id')).rows);
}

export async function createUser(req, res) {
  const {nombre, correo} = userInput(req.body);
  const {rows} = await pool.query('INSERT INTO usuarios (nombre,correo) VALUES ($1,$2) RETURNING id,nombre,correo', [nombre, correo]);
  res.status(201).json(rows[0]);
}

export async function categories(req, res) {
  res.json((await pool.query('SELECT id,name FROM categories ORDER BY id')).rows);
}

export async function listTasks(req, res) {
  const {rows} = await pool.query('SELECT id,title,completed,category_id,created_at FROM tasks WHERE user_id=$1 ORDER BY id', [await owner(req.user)]);
  res.json(rows);
}

export async function createTask(req, res) {
  const data = taskInput(req.body);
  const {rows} = await pool.query(
    'INSERT INTO tasks (user_id,title,completed,category_id) VALUES ($1,$2,$3,$4) RETURNING id,title,completed,category_id,created_at',
    [await owner(req.user), data.title, data.completed, data.category_id]);
  const task = rows[0];
  task.audit_recorded = await recordActivity(req.user.sub, 'create', task.id);
  res.status(201).json(task);
}

export async function updateTask(req, res) {
  const id = positiveId(req.params.id);
  const data = taskInput(req.body);
  const {rows} = await pool.query(
    'UPDATE tasks SET title=$1,completed=$2,category_id=$3 WHERE id=$4 AND user_id=$5 RETURNING id,title,completed,category_id,created_at',
    [data.title, data.completed, data.category_id, id, await owner(req.user)]);
  if (!rows.length) throw new ApiError(404, 'Tarea no encontrada');
  rows[0].audit_recorded = await recordActivity(req.user.sub, 'update', id);
  res.json(rows[0]);
}

export async function deleteTask(req, res) {
  const id = positiveId(req.params.id);
  const {rows} = await pool.query('DELETE FROM tasks WHERE id=$1 AND user_id=$2 RETURNING id', [id, await owner(req.user)]);
  if (!rows.length) throw new ApiError(404, 'Tarea no encontrada');
  res.json({deleted: id, audit_recorded: await recordActivity(req.user.sub, 'delete', id)});
}

export async function activity(req, res) {
  res.json(await mongoDb.collection('activity').find({}, {projection: {_id: 0}}).sort({at: -1}).limit(100).toArray());
}
