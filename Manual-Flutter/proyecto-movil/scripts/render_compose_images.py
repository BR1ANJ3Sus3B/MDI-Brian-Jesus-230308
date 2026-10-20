"""Render reproducible instructional plates for chapter 29 (requires Pillow)."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'Assets'
FONTS = Path('C:/Windows/Fonts')


def font(size, mono=False, bold=False):
    name = 'consola.ttf' if mono else ('segoeuib.ttf' if bold else 'segoeui.ttf')
    return ImageFont.truetype(str(FONTS / name), size)


def plate(number, title, subtitle, height):
    im = Image.new('RGB', (1600, height), '#f3f7fc')
    d = ImageDraw.Draw(im)
    d.rectangle((0, 0, 1600, 14), fill='#0284c7')
    d.text((64, 42), f'MANUAL FLUTTER  /  DOCKER COMPOSE  /  {number}', font=font(23, bold=True), fill='#0369a1')
    d.text((64, 88), title, font=font(49, bold=True), fill='#102c46')
    d.text((64, 160), subtitle, font=font(27), fill='#475569')
    d.line((64, height-76, 1536, height-76), fill='#cbd5e1', width=2)
    d.text((64, height-56), 'Guía ilustrada del proyecto · No es una captura de ejecución', font=font(23), fill='#475569')
    return im, d


im, d = plate('01', 'Los servicios de tu proyecto', 'Archivo: infrastructure/docker-compose.yml · Proyecto: manual_mobile', 1080)
rows = [
    ('backend', 'FastAPI · imagen construida desde ../backend', 'localhost:8000'),
    ('postgres', 'PostgreSQL 17 · datos de la aplicación', 'localhost:5432'),
    ('mongo', 'MongoDB 8.0 · eventos de actividad', 'localhost:27017*'),
    ('keycloak', 'Keycloak 26.8.0 · autenticación', 'localhost:8080'),
    ('keycloak-db', 'PostgreSQL 17 · datos de identidad', 'Solo red interna'),
]
for i, (name, desc, address) in enumerate(rows):
    y = 232 + i*118
    d.rounded_rectangle((64, y, 1536, y+100), radius=16, fill='white', outline='#d8e3ef', width=2)
    d.text((88, y+29), name, font=font(29, mono=True), fill='#0369a1')
    d.text((350, y+32), desc, font=font(26), fill='#102c46')
    d.text((1190, y+33), address, font=font(24, mono=True), fill='#475569')
d.text((64, 855), 'Red compartida: mobile · Flutter se ejecuta en Android fuera de Docker.', font=font(28), fill='#102c46')
d.text((64, 905), '* Puerto predeterminado; puede cambiarse con MONGO_PORT.', font=font(25), fill='#475569')
im.save(OUT / 'docker-compose-servicios.png')

im, d = plate('02', 'Prepara la configuración local', 'Desde Manual-Flutter/proyecto-movil · Conserva tu .env si ya existe', 1000)
d.rounded_rectangle((64, 225, 1536, 590), radius=18, fill='#102c46')
d.text((96, 250), '.env.example → .env', font=font(27, bold=True), fill='#7dd3fc')
keys = ('COMPOSE_FILE=', 'COMPOSE_PROJECT_NAME=', 'BACKEND_CONTEXT=', 'POSTGRES_DB=', 'POSTGRES_USER=', 'MONGO_PORT=')
lines = [line for line in (ROOT / '.env.example').read_text(encoding='utf-8').splitlines() if line.startswith(keys)]
for i, line in enumerate(lines):
    d.text((96, 312+i*42), line, font=font(29, mono=True), fill='#f0f9ff')
notes = [
    ('1', 'Copia .env.example a .env únicamente si aún no existe.'),
    ('2', 'Sustituye las contraseñas de ejemplo y guarda el archivo.'),
    ('3', 'Valida: docker compose config --quiet'),
]
for i, (number, label) in enumerate(notes):
    y = 640+i*80
    d.ellipse((64, y, 110, y+46), fill='#0284c7')
    d.text((78, y+3), number, font=font(27, bold=True), fill='white')
    d.text((132, y+3), label, font=font(29), fill='#102c46')
im.save(OUT / 'docker-compose-configuracion.png')

im, d = plate('03', 'Arranca y verifica el entorno', 'Ejecuta en PowerShell desde la carpeta proyecto-movil', 1140)
steps = [
    ('01 · VALIDAR', 'docker compose config --quiet', 'Continúa solo si termina sin errores.'),
    ('02 · CONSTRUIR E INICIAR', 'docker compose up -d --build', 'La primera ejecución descarga imágenes y construye el backend.'),
    ('03 · REVISAR LOS CINCO SERVICIOS', 'docker compose ps -a', 'Comprueba contenedores activos y bases de datos saludables.'),
    ('04 · COMPROBAR LA API', 'Invoke-RestMethod http://localhost:8000/health', 'Verifica las bases de la aplicación; prueba el login por separado.'),
]
for i, (label, command, note) in enumerate(steps):
    y = 224+i*188
    d.rounded_rectangle((64, y, 1536, y+168), radius=16, fill='white', outline='#d8e3ef', width=2)
    d.text((92, y+16), label, font=font(23, bold=True), fill='#0369a1')
    d.text((92, y+58), command, font=font(32, mono=True), fill='#102c46')
    d.text((92, y+112), note, font=font(26), fill='#475569')
d.text((64, 1000), 'Al terminar: docker compose down · Conserva los volúmenes de datos.', font=font(27), fill='#102c46')
im.save(OUT / 'docker-compose-arranque.png')
def cards(number, title, subtitle, filename, entries):
    im, d = plate(number, title, subtitle, 1120)
    for i, (label, command, note) in enumerate(entries):
        y = 228 + i * 198
        d.rounded_rectangle((64, y, 1536, y+176), radius=18, fill='white', outline='#d8e3ef', width=2)
        d.text((94, y+16), label, font=font(25, bold=True), fill='#0369a1')
        d.text((94, y+62), command, font=font(29, mono=True), fill='#102c46')
        d.text((94, y+117), note, font=font(25), fill='#475569')
    im.save(OUT / filename)


cards('04', 'Ubica los archivos del proyecto', 'Rutas relativas a Manual-Flutter/proyecto-movil', 'docker-compose-archivos.png', [
    ('ORQUESTACIÓN', 'infrastructure/docker-compose.yml', 'Define los cinco servicios, la red y los volúmenes.'),
    ('CONFIGURACIÓN LOCAL', '.env.example  →  .env', 'La plantilla contiene las variables que debes configurar.'),
    ('IMAGEN DE LA API', 'backend/Dockerfile', 'Construye FastAPI; backend-node/Dockerfile es la alternativa Express.'),
    ('INICIALIZACIÓN DE DATOS', 'database/postgres/  ·  database/mongodb/', 'Contienen los scripts que se aplican a bases vacías.'),
])
cards('05', 'Qué revisar después del arranque', 'Cada comprobación responde una pregunta distinta', 'docker-compose-comprobaciones.png', [
    ('CONTENEDORES · ¿SIGUEN ACTIVOS?', 'docker compose ps -a', 'Revisa los cinco servicios y la salud de las bases de datos.'),
    ('API · ¿RESPONDEN SUS BASES DE DATOS?', 'http://localhost:8000/health', 'Consulta esta dirección con Invoke-RestMethod desde PowerShell.'),
    ('CONTRATO · ¿ESTÁ DISPONIBLE SWAGGER?', 'http://localhost:8000/docs', 'Abre la documentación de FastAPI en el navegador de Windows.'),
    ('IDENTIDAD · ¿RESPONDE KEYCLOAK?', 'http://localhost:8080', 'Revisa el realm app-mobile y completa la prueba de login del capítulo 25.'),
])
cards('06', 'Los datos y el cierre del entorno', 'Volúmenes declarados: postgres_data, mongo_data y keycloak_data', 'docker-compose-volumenes.png', [
    ('PAUSA DEL TRABAJO · DETENER LOS SERVICIOS', 'docker compose stop', 'Detiene los contenedores; conserva contenedores y datos.'),
    ('RETOMAR EL TRABAJO', 'docker compose start', 'Inicia los contenedores existentes que se habían detenido.'),
    ('CIERRE HABITUAL', 'docker compose down', 'Elimina contenedores y red; conserva los volúmenes de las bases.'),
    ('BORRADO DE DATOS · NO ES EL CIERRE HABITUAL', 'docker compose down -v', 'También elimina los volúmenes: perderías los datos guardados.'),
])
cards('07', 'Diagnostica los errores comunes', 'Identifica el síntoma antes de cambiar la configuración', 'docker-compose-errores.png', [
    ('NO CONECTA CON DOCKER', 'docker version', 'Abre Docker Desktop y comprueba que aparece la sección Server.'),
    ('CONFIGURACIÓN INCOMPLETA', 'docker compose config --quiet', 'Ejecuta desde proyecto-movil y completa la variable indicada en .env.'),
    ('UN SERVICIO TERMINA O FALLA', 'docker compose logs --tail 100 backend', 'Lee el registro; sustituye backend por el servicio que necesites revisar.'),
    ('MONGODB TIENE EL PUERTO LOCAL OCUPADO', 'MONGO_PORT=27018', 'Ejemplo de puerto alternativo en .env; internamente sigue usando 27017.'),
])
print('Generadas 7 imágenes de Docker Compose.')
