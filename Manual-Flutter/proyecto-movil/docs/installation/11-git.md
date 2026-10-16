# 11. Git

## ¿Qué es y para qué sirve?

Sistema distribuido de control de versiones. Resuelve la pérdida del historial y permite comparar cambios, trabajar en paralelo y recuperar versiones.

| Concepto | Significado |
| --- | --- |
| Repositorio | Archivos y su historial |
| Commit | Registro de cambios con mensaje y autor |
| Branch | Línea de trabajo |
| Merge | Integración de líneas de trabajo |
| Clone | Copia de un repositorio y su historial |
| Push | Envío de commits al remoto |
| Pull | Obtención e integración de cambios remotos |
| Remote | Nombre y dirección de otro repositorio |

## Papel dentro de la arquitectura y requisitos

Herramienta externa al sistema ejecutándose. Requiere acceso de escritura a la carpeta; Internet solo para colaborar con remotos.

## Instalación y configuración

Instala [Git para Windows](https://git-scm.com/downloads/win), abre una terminal nueva y verifica:

```powershell
git --version
```

```powershell
git config --global user.name "Nombre"
```

```powershell
git config --global user.email "correo@ejemplo.com"
```

El correo queda en los commits; puedes usar el correo privado proporcionado por GitHub.

## Comandos principales y ejemplo práctico

En una carpeta nueva de ejercicio, fuera de un repositorio existente:

```powershell
git init
```

Después de crear un README y `.gitignore`, revisa los archivos antes de agregarlos:

```powershell
git status
```

```powershell
git add .
```

```powershell
git commit -m "Primer commit"
```

```powershell
git branch
```

```powershell
git switch -c feature/manual
```

`git switch main` vuelve a una rama existente; `-c` crea una nueva. Los comandos de remoto se practican en el capítulo siguiente.

## Verificación, errores comunes y soluciones

```powershell
git log --oneline -5
```

Si no conoce tu identidad, configura nombre y correo. Si `git add .` incluye secretos, retíralos del área de preparación antes del commit y corrige `.gitignore`. No inicialices otro `.git` dentro de este proyecto: ya pertenece al repositorio de prácticas.

## Evidencia y conclusión

**E01:** versión, estado y un commit. Explica la diferencia entre guardar un archivo y registrar un commit. [Referencia de Git](https://git-scm.com/docs).
