# 04. Introducción

El desarrollo móvil multiplataforma busca compartir una parte importante del código entre sistemas. Una aplicación nativa suele usar las herramientas propias de cada plataforma, por ejemplo Kotlin para Android y Swift para iOS. Una solución multiplataforma reduce duplicación, aunque todavía debe configurar permisos, compilación y funciones particulares de cada sistema.

Flutter construye interfaces mediante widgets y utiliza Dart. Un widget representa una parte de la pantalla o su comportamiento: un texto, un botón, una lista o una composición de ellos. Compartir código no garantiza que todos los paquetes funcionen en todas las plataformas.

En una arquitectura **cliente-servidor**, Flutter es el cliente: muestra datos y solicita operaciones. El **backend** procesa esas solicitudes, aplica reglas y consulta bases de datos. Una **API REST** organiza esas operaciones alrededor de recursos y métodos HTTP, como consultar tareas con GET o crearlas con POST.

Una **base de datos** conserva información más allá del cierre de la aplicación. PostgreSQL organiza datos relacionados en tablas; MongoDB guarda documentos. En este proyecto las tareas van a PostgreSQL y los eventos de actividad a MongoDB.

La **autenticación** comprueba quién es el usuario; la **autorización** decide qué puede hacer. Keycloak gestiona el inicio de sesión. La API valida el token recibido antes de acceder a los datos y comprueba además la propiedad de cada tarea.

La **contenerización** empaqueta procesos y dependencias para ejecutarlos de forma consistente. Docker ejecuta contenedores y Compose describe cómo colaborar entre ellos. El **control de versiones** conserva el historial de cambios; Git lo administra localmente y GitHub facilita compartirlo y revisarlo.

Ejemplo: Alex inicia sesión, crea una tarea y ve su nueva lista. Flutter gestiona la pantalla; Keycloak identifica a Alex; la API valida la solicitud; PostgreSQL conserva la tarea; MongoDB registra la actividad.
