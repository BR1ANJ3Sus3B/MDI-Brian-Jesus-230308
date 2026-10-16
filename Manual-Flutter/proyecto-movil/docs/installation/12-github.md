# 12. GitHub

## ¿Qué es y para qué sirve?

Plataforma que aloja repositorios Git y facilita revisión y coordinación. Git funciona localmente; GitHub agrega repositorios remotos, Pull Requests e Issues. Un PR propone integrar cambios; un Issue registra una tarea o problema.

## Papel dentro de la arquitectura y requisitos

Herramienta externa de colaboración. Necesitas Git, cuenta GitHub e Internet. Autentica Git mediante el navegador con Git Credential Manager o configura SSH; no uses la contraseña de tu cuenta como contraseña de Git por HTTPS.

## Instalación y configuración

No necesita instalar un servidor. Crea tu cuenta en [GitHub](https://github.com), activa autenticación en dos pasos y crea un repositorio de práctica con README. Copia su URL desde **Code**.

## Comandos principales y ejemplo práctico

Sustituye `TU_USUARIO` por tu cuenta y ejecuta fuera del repositorio actual:

```powershell
git clone https://github.com/TU_USUARIO/proyecto-movil.git
```

```powershell
Set-Location proyecto-movil
```

```powershell
git switch -c feature/documentacion
```

Edita README, guarda y registra:

```powershell
git add README.md
```

```powershell
git commit -m "Documenta instalación inicial"
```

```powershell
git push -u origin feature/documentacion
```

En GitHub, abre **Compare & pull request**, selecciona base `main`, describe cambios y pruebas y solicita revisión. Crea también un Issue con un resultado esperado concreto.

```powershell
git pull --ff-only
```

## Verificación, errores comunes y soluciones

Comprueba la rama y el commit en el sitio. Si rechaza el push, revisa permisos, remoto y cambios ajenos; no fuerces la sobrescritura. Para un historial divergente consulta el capítulo 37.

## Evidencia y conclusión

**E13:** URL del repositorio, PR e Issue. Explica qué revisaría un compañero antes de integrar. [Guía de PR](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request).
