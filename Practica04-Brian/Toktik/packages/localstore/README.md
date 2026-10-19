# Localstore 1.4.0 (copia local)

Origen: https://pub.dev/packages/localstore/versions/1.4.0
Licencia original en LICENSE.

Cambio en DocumentRef.set: esperar la escritura y actualizar la caché solo al
terminar. La versión publicada no esperaba el Future del almacenamiento; esto
impedía confirmar el guardado y capturar fallos de escritura en la aplicación.
El resto del código conserva su comportamiento original.
