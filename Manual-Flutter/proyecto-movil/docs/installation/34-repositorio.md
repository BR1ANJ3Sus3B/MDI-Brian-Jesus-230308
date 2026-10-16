# 34. Estructura del repositorio

```text
proyecto-movil/
├── mobile/
│   ├── ejemplos/saludo.dart
│   └── flutter_app/
│       ├── android/
│       ├── lib/
│       └── test/
├── backend/
│   ├── app/
│   ├── intro/
│   ├── tests/
│   └── Dockerfile
├── backend-node/
│   ├── src/
│   ├── intro/
│   ├── tests/
│   └── Dockerfile
├── database/
│   ├── postgres/
│   └── mongodb/
├── infrastructure/
│   ├── keycloak/
│   └── docker-compose.yml
├── docs/
│   ├── diagrams/
│   ├── installation/
│   └── evidence/
├── postman/
├── scripts/
├── .gitignore
├── .env.example
└── README.md
```

`backend` y `backend-node` no dependen entre sí en ejecución. `intro` contiene ejercicios en memoria; `app`/`src` contienen el integrador. Las bases se inicializan con scripts versionados y mantienen datos en volúmenes, nunca en archivos SQL con contraseñas reales.

Los tests viven junto al componente que validan. Los archivos de bloqueo de npm y Flutter deben viajar con el proyecto para repetir sus dependencias. Los diagramas Mermaid pueden abrirse desde los capítulos o reutilizarse en una presentación.

Este proyecto está dentro del repositorio de prácticas; no se crea un repositorio Git anidado. Si deseas distribuirlo de forma independiente, copia su carpeta fuera y sigue el flujo de GitHub del capítulo 12.
