"""Check local Markdown links, code fences and structured JSON artifacts."""
import json
from pathlib import Path
import re

root = Path(__file__).resolve().parents[1]
files = [root / 'README.md', *root.joinpath('docs').rglob('*.md'), root / 'mobile/flutter_app/README.md']
errors = []
for file in files:
    text = file.read_text(encoding='utf-8')
    if len(re.findall(r'^```', text, re.M)) % 2:
        errors.append(f'{file.relative_to(root)}: bloque de código sin cerrar')
    for target in re.findall(r'\]\(([^)]+)\)', text):
        if target.startswith(('http:', 'https:', 'mailto:', '#')):
            continue
        path = target.split('#', 1)[0]
        if not (file.parent / path).exists():
            errors.append(f'{file.relative_to(root)}: enlace inexistente {target}')
for file in [*root.joinpath('postman').glob('*.json'), *root.joinpath('infrastructure/keycloak').glob('*.json'), root/'docs/openapi.json', root/'backend-node/openapi.json']:
    json.loads(file.read_text(encoding='utf-8'))
assert len(list(root.joinpath('docs/installation').glob('*.md'))) == 41
assert len(list(root.joinpath('docs/evidence').glob('E*.md'))) == 24
if errors:
    raise SystemExit('\n'.join(errors))
print(f'OK: {len(files)} documentos, enlaces locales, bloques, 41 capítulos, 24 evidencias y JSON.')
