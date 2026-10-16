"""Export the shared contract from FastAPI without contacting databases."""
import json
from pathlib import Path
import sys

root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / 'backend'))
from app.main import app
from app.database.connections import mongo_client

content = json.dumps(app.openapi(), indent=2, ensure_ascii=False) + '\n'
for target in [root / 'docs/openapi.json', root / 'backend-node/openapi.json']:
    target.write_text(content, encoding='utf-8')
mongo_client.close()
print('Contrato OpenAPI exportado para documentación y Express.')
