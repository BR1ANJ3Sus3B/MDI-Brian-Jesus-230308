# Arquitectura de Cinemapedia

`index.html` es la portada para GitHub Pages. Los cuatro HTML de Archify son artefactos independientes y navegables; sus fuentes se conservan como `*.archify.json`.

## Alcance y evidencia

- Se inspeccionaron todas las carpetas principales y `lib/` de forma recursiva.
- Las relaciones del diagrama de `lib/` proceden de imports, herencia y uso de providers observados.
- `.dart_tool/` y `build/` se muestran como resúmenes (305 y 1367 archivos respectivamente), sin expandir compilados.
- `.env` se representa como configuración privada. Su contenido no fue leído ni copiado.

## Abrir localmente

Abra `index.html` en un navegador, o sirva `docs/` con un servidor estático. Para GitHub Pages, seleccione la carpeta `docs/` y navegue a `/arquitectura/`.

## Limitación de estilo

La portada usa la paleta solicitada. Archify admite el preset `blueprint`, pero su formato no admite colores hex personalizados por diagrama; por ello sus HTML conservan la interfaz y tema soportados por Archify.
