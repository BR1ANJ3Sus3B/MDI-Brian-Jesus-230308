# TOKTIK · Arquitectura de software propuesta

Abrir **toktik-arquitectura.html** en un navegador. Funciona sin servidor ni dependencias externas. Es un documento interactivo, no una implementación de las APIs.

## Uso

- Seleccionar un componente para consultar responsabilidades, contratos, campos y autenticación.
- Cambiar entre **Solicitudes** y **Retorno** para seguir las flechas.
- Consultar **Error Handling**, **Environment Configuration** y **Alcance y referencias**.
- Simular un fallo de TikTok para observar la continuidad de las otras fuentes.
- Exportar la vista activa como SVG o usar Imprimir / PDF. El PDF incluye el detalle seleccionado.
- Abrir **toktik-overview.html** para el visor Archify complementario, con zoom, búsqueda y exportaciones. Sus controles fijos e idioma HTML son inglés; el contenido del diagrama es español.

## Alcance técnico

El código inspeccionado utiliza fuentes locales, NASA, Internet Archive y Wikimedia. TikTok, Instagram y Facebook son la arquitectura objetivo solicitada. Los nombres de assets son ejemplos. No se alteró el código Flutter.

El retorno pasa por Repository → Normalizer → Repository → Provider → Feed. El enlace visual Normalizer → Feed resume esos pasos, indicados también en el texto del explorador. El Repository elimina duplicados por fuente e identificador y puede comparar URLs cuando corresponda. Los errores se aíslan por fuente y la cache es opcional.

TikTok devuelve metadatos y un enlace de inserción, que requiere reproducción incrustada. El modelo propuesto añade `playbackType` y `embedUrl`; no trata ese enlace como un MP4. La documentación oficial de [List Videos](https://developers.tiktok.com/doc/tiktok-api-v2-video-list/) confirma POST, Bearer Token y scope `video.list` (consulta: 16/10/2026).

Los campos de [Instagram Media](https://developers.facebook.com/docs/instagram-platform/reference/instagram-media) y [Facebook Video](https://developers.facebook.com/docs/graph-api/reference/video/) son referencias de diseño pendientes de validar contra la versión, permisos y cuenta autorizada. Las páginas oficiales de Meta devolvieron HTTP 429 durante esta consulta. No se afirma acceso a contenido arbitrario de las plataformas.

Solo se documentan nombres de variables. `--dart-define` es configuración de compilación, no almacenamiento seguro de secretos.

## Validación y evidencias

- Tipo: architecture.
- Archify: 9/9 comprobaciones, perfil showcase, cero errores y cero advertencias de composición.
- Evidencia de navegador Archify: passed, en `toktik-overview.visual-check.json`.
- Explorador: selección de TikTok y endpoint, cambio de dirección y simulación de fallo comprobados en Edge mediante CDP.
- Vista inicial sin desbordamiento en 1440×900, 1600×1000, 1920×1080 y 2048×1320. Los paneles de detalle largos pueden desplazar la página.
- Capturas y mediciones: `explorer-browser-check.json`, `toktik-preview.png`, `toktik-preview-light.png`, `toktik-return.png`.
- Revisión visual: capturas revisadas en temas oscuro y claro. La validación geométrica de Archify corresponde al visor general, no al HTML personalizado.
- No se hicieron llamadas autenticadas a redes sociales ni pruebas de reproducción real; la simulación es didáctica.

Recibo de entrega Archify:

| Archivo | Bytes | SHA-256 |
|---|---:|---|
| toktik.architecture.json | 4718 | f11cc3111725a77c3ef7ce2bce6c4874fd103a2e56d0905207f5b2aa37b8ab9e |
| toktik-overview.html | 812507 | 2b7740132949b2498b16ad3f664fa32aaae032f782a8ef8cbd88b8902415001c |

## Fuentes editables

`build-explorer.py` contiene la composición y los textos del explorador. Regenerar con `python docs/architecture/build-explorer.py` desde la raíz del proyecto. `toktik.architecture.json` es la especificación del visor Archify.
