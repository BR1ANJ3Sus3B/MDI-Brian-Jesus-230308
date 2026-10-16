import {Router} from 'express';
import * as api from '../controllers/api.js';
import {authenticate, requireRoles} from '../services/auth.js';

export const router = Router();
router.get('/', (req, res) => res.json({message: 'API de gestión de tareas', backend: 'express'}));
router.get('/health', api.health);
router.use(authenticate);
router.get('/me', api.me);
router.get('/usuarios', requireRoles('administrador'), api.listUsers);
router.post('/usuarios', requireRoles('administrador'), api.createUser);
router.get('/admin/activity', requireRoles('administrador'), api.activity);
router.use(requireRoles('usuario', 'administrador'));
router.get('/categories', api.categories);
router.get('/tasks', api.listTasks);
router.post('/tasks', api.createTask);
router.put('/tasks/:id', api.updateTask);
router.delete('/tasks/:id', api.deleteTask);
