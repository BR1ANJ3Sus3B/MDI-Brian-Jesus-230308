# 35. Flujo de ramas Git

```text
main
└── develop
    ├── feature/flutter
    ├── feature/api
    ├── feature/database
    ├── feature/keycloak
    └── feature/docker
```

| Rama | Propósito |
| --- | --- |
| main | Entregas estables verificadas |
| develop | Integración de trabajo del equipo |
| feature/flutter | UI y consumo de API |
| feature/api | Backend y contrato |
| feature/database | Esquemas y consultas |
| feature/keycloak | Identidad y roles |
| feature/docker | Imágenes y Compose |

Ejemplo desde un repositorio de práctica con `main`:

```powershell
git switch main
```

```powershell
git switch -c develop
```

```powershell
git switch -c feature/api
```

Registra cambios y publica la rama. Crea un PR hacia `develop`, exige pruebas y revisión; luego crea un PR de `develop` hacia `main` para la entrega.

```powershell
git push -u origin feature/api
```

No recrees una rama que ya existe: usa `git switch NOMBRE`. En este repositorio el material se elabora en `Manual-Flutter`; el árbol anterior es una propuesta para organizar el proyecto académico, no una afirmación de ramas ya creadas.
