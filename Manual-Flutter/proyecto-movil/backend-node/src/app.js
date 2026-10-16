import express from 'express';
import cors from 'cors';
import swaggerUi from 'swagger-ui-express';
import {readFileSync} from 'node:fs';
import {router} from './routes/api.js';
import {settings} from './config/settings.js';

const contract = JSON.parse(readFileSync(new URL('../openapi.json', import.meta.url)));
export const app = express();
app.disable('x-powered-by');
app.use(cors({origin: settings.origins, allowedHeaders: ['Authorization', 'Content-Type']}));
app.use(express.json({limit: '32kb'}));
app.get('/openapi.json', (req, res) => res.json(contract));
app.use('/docs', swaggerUi.serve, swaggerUi.setup(contract));
app.use(router);
app.use((req, res) => res.status(404).json({detail: 'Ruta no encontrada'}));
app.use((error, req, res, next) => {
  let status = error.status ?? 500;
  let detail = status < 500 ? error.message : 'Error interno del servidor';
  if (error.type === 'entity.parse.failed') { status = 400; detail = 'JSON inválido'; }
  if (error.code === '23505') { status = 409; detail = 'El correo ya existe'; }
  if (error.code === '23503') { status = 400; detail = 'Categoría inexistente'; }
  if (['ECONNREFUSED', '28P01', '57P01'].includes(error.code) || error.name?.startsWith('Mongo')) {
    status = 503; detail = 'Base de datos temporalmente no disponible';
  }
  res.status(status).json({detail});
});
