"""Create a local .env once, replacing example passwords with random values."""
from pathlib import Path
import re
import secrets

root = Path(__file__).resolve().parents[1]
target = root / ".env"
if target.exists():
    raise SystemExit(".env ya existe; se conservó sin cambios.")
content = (root / ".env.example").read_text(encoding="utf-8")
content = re.sub(r"cambiar_[a-z_]+", lambda match: secrets.token_hex(20), content)
target.write_text(content, encoding="utf-8")
print(".env creado con contraseñas aleatorias. Revísalo localmente; no lo publiques.")
