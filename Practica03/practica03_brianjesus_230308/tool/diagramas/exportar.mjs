// Exporta el diagrama de docs/ a PNG en varias resoluciones y en los dos temas,
// reutilizando el navegador headless del skill Archify.
//
//   node tool/diagramas/exportar.mjs
//
// Variables de entorno opcionales:
//   ARCHIFY_CHROME     ruta a Chrome/Chromium/Edge (por defecto se busca solo)
//   ARCHIFY_SKILL_DIR  directorio del skill Archify
import fs from 'node:fs';
import path from 'node:path';
import process from 'node:process';
import { fileURLToPath, pathToFileURL } from 'node:url';

const raizProyecto = path.resolve(
  path.dirname(fileURLToPath(import.meta.url)),
  '..',
  '..',
);
const docsDir = path.join(raizProyecto, 'docs');
const salidaDir = path.join(docsDir, 'imagenes');

const skillDir = process.env.ARCHIFY_SKILL_DIR
  || path.join(process.env.USERPROFILE || process.env.HOME || '', '.agents', 'skills', 'archify');
const visualCheck = path.join(skillDir, 'bin', 'visual-check.mjs');

if (!fs.existsSync(visualCheck)) {
  throw new Error(
    `No se encontro el skill Archify en ${skillDir}. Define ARCHIFY_SKILL_DIR.`,
  );
}

const { ChromeVisualBrowser, findChrome } = await import(pathToFileURL(visualCheck).href);

const diagramas = [
  { archivo: 'arquitectura-practica03.html', nombre: 'arquitectura-practica03' },
  { archivo: 'hola-jarvis.html', nombre: 'hola-jarvis' },
];

const viewports = [
  { width: 1600, height: 1000 },
  { width: 1920, height: 1080 },
];
const temas = ['light', 'dark'];

const chrome = process.env.ARCHIFY_CHROME || findChrome();
if (!chrome) {
  throw new Error('No se encontro Chrome, Chromium ni Edge. Define ARCHIFY_CHROME.');
}
console.log(`Navegador: ${chrome}`);
console.log(`Skill:     ${skillDir}\n`);

fs.mkdirSync(salidaDir, { recursive: true });

const browser = new ChromeVisualBrowser(chrome);
const escritos = [];

try {
  for (const diagrama of diagramas) {
    const artifactPath = path.join(docsDir, diagrama.archivo);
    if (!fs.existsSync(artifactPath)) {
      console.warn(`omitido (no existe): ${diagrama.archivo}`);
      continue;
    }
    for (const { width, height } of viewports) {
      for (const theme of temas) {
        const destino = path.join(
          salidaDir,
          `diagrama-${diagrama.nombre}-${width}x${height}-${theme}.png`,
        );
        await browser.inspect({
          artifactPath,
          width,
          height,
          theme,
          screenshotPath: destino,
        });
        const kb = Math.round(fs.statSync(destino).size / 1024);
        escritos.push(path.relative(raizProyecto, destino));
        console.log(`  ${path.basename(destino)}  (${kb} KB)`);
      }
    }
  }
} finally {
  await browser.close();
}

console.log(`\n${escritos.length} PNG generados en docs/imagenes/`);
