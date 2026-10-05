/// Datos crudos que simulan la respuesta de una API.
///
/// Cada publicacion apunta a un clip distinto de `assets/videos/`
/// (`1.mp4` ... `8.mp4`).
///
/// Los `.mp4` NO estan versionados en git: pesan decenas de MB cada uno, asi
/// que `.gitignore` los excluye del repositorio. Copia los videos en
/// `assets/videos/` antes de ejecutar la app; si falta alguno, el reproductor
/// muestra un mensaje de error en lugar de fallar.
const List<Map<String, dynamic>> videoPosts = [
  {
    'name': 'Subiendo escaleras automaticas',
    'videoUrl': 'assets/videos/1.mp4',
    'likes': 23230,
    'views': 1523,
  },
  {
    'name': 'Planta apreciada por peatones',
    'videoUrl': 'assets/videos/2.mp4',
    'likes': 24230,
    'views': 1343,
  },
  {
    'name': 'Que borroso veo todo!',
    'videoUrl': 'assets/videos/3.mp4',
    'likes': 21564320,
    'views': 123563,
  },
  {
    'name': 'Esto es trigo? que interesante',
    'videoUrl': 'assets/videos/4.mp4',
    'likes': 320,
    'views': 2300,
  },
  {
    'name': 'El COVID no me afecta',
    'videoUrl': 'assets/videos/5.mp4',
    'likes': 3230,
    'views': 31030,
  },
  {
    'name': 'No quiero ir a trabajar hoy senor Stark',
    'videoUrl': 'assets/videos/6.mp4',
    'likes': 10,
    'views': 330,
  },
  {
    'name': 'Limpiar nunca fue tan divertido',
    'videoUrl': 'assets/videos/7.mp4',
    'likes': 1320,
    'views': 33032,
  },
  {
    'name': 'Ya llegamos a la India?... umm si',
    'videoUrl': 'assets/videos/8.mp4',
    'likes': 342,
    'views': 3332,
  },
];