# Registro de verificación

Este archivo diferencia las comprobaciones realizadas durante la elaboración del proyecto de las evidencias que debe producir el alumno. Las capturas y las credenciales reales no se incluyen en el repositorio.

## Entorno observado al iniciar

- Rama de trabajo: `Manual-Flutter`.
- Windows y PowerShell.
- Python 3.14.3, Node.js 24.13.0, npm 11.6.2.
- Docker CLI 29.7.2 disponible; el motor Docker Desktop no estaba iniciado.

## Resultados finales de validación

Ejecutados sobre la rama `Manual-Flutter` (Windows y PowerShell) el 2026-10-16.

| Comprobación | Comando | Resultado |
| --- | --- | --- |
| Documentación | `python scripts/validate_docs.py` | OK: 70 documentos, enlaces locales, bloques, 41 capítulos, 24 evidencias y JSON |
| Contrato OpenAPI | `backend\.venv\Scripts\python.exe scripts\export_openapi.py` | Exportado sin cambios; `docs/openapi.json` y `backend-node/openapi.json` idénticos al contrato de FastAPI |
| Alternativa A: FastAPI | `.\backend\.venv\Scripts\python.exe -m pytest -q` desde `backend` | 13 pruebas aprobadas |
| Alternativa B: Express | `npm test` desde `backend-node` | 5 pruebas aprobadas |
| Análisis Flutter | `flutter analyze` desde `mobile/flutter_app` | No issues found |
| Pruebas Flutter | `flutter test` desde `mobile/flutter_app` | 4 pruebas aprobadas |

Versiones observadas: Flutter 3.47.4 y Dart 3.13.3; Python 3.14.3; Node.js 24.13.0 y npm 11.6.2; Docker CLI y motor 29.7.2.

Estas pruebas usan dependencias controladas y no sustituyen las comprobaciones manuales con contenedores reales, el flujo OAuth en el navegador ni la ejecución de `scripts/smoke.py`, que requiere un token de usuario obtenido en Postman. Esos pasos quedan descritos en el capítulo 33 y en las plantillas de evidencia para que el alumno los complete y registre sus propios resultados.
