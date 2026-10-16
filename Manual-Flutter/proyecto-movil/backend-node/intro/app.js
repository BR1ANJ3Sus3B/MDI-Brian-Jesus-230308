// Introducción en memoria; no sustituye al backend autenticado.
import express from 'express';
import {userInput} from '../src/models/validation.js';

const app = express();
const usuarios = [];
app.use(express.json());
app.get('/', (req, res) => res.json({mensaje: 'API funcionando'}));
app.get('/usuarios', (req, res) => res.json(usuarios));
app.post('/usuarios', (req, res) => {
  const user = userInput(req.body);
  if (usuarios.some(item => item.correo === user.correo)) return res.status(409).json({detail: 'Correo repetido'});
  const nuevo = {id: usuarios.length + 1, ...user};
  usuarios.push(nuevo);
  res.status(201).json(nuevo);
});
app.use((error, req, res, next) => res.status(error.status ?? 500).json({detail: error.status ? error.message : 'Error interno'}));
app.listen(8000, '127.0.0.1', () => console.log('API inicial: http://localhost:8000'));
