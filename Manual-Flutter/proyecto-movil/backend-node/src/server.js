import {app} from './app.js';
import {closeConnections} from './config/database.js';

const server = app.listen(8000, '0.0.0.0', () => console.log('API listening on port 8000'));
for (const signal of ['SIGTERM', 'SIGINT']) {
  process.on(signal, () => {
    server.close(async () => { await closeConnections(); process.exit(0); });
  });
}
