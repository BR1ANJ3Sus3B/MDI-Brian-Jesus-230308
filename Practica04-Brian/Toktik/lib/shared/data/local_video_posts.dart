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
    'userName': 'brain.dev',
    'songName': 'sonido original - brain.dev',
    'videoUrl': 'assets/videos/1.mp4',
    'likes': 23230,
    'views': 1523,
  },
  {
    'name': 'Planta apreciada por peatones',
    'userName': 'maria.jp',
    'songName': 'Green Leaves - lofi beats',
    'videoUrl': 'assets/videos/2.mp4',
    'likes': 24230,
    'views': 1343,
  },
  {
    'name': 'Que borroso veo todo!',
    'userName': 'juan.pov',
    'songName': 'Sunset Drive - chill mix',
    'videoUrl': 'assets/videos/3.mp4',
    'likes': 21564320,
    'views': 123563,
  },
  {
    'name': 'Esto es trigo? que interesante',
    'userName': 'agri.tips',
    'songName': 'Campo abierto - folk',
    'videoUrl': 'assets/videos/4.mp4',
    'likes': 320,
    'views': 2300,
  },
  {
    'name': 'El COVID no me afecta',
    'userName': 'carlos.mtz',
    'songName': 'No-touch - 2020 edit',
    'videoUrl': 'assets/videos/5.mp4',
    'likes': 3230,
    'views': 31030,
  },
  {
    'name': 'No quiero ir a trabajar hoy senor Stark',
    'userName': 'stark.fan',
    'songName': 'Arc Reactor - synthwave',
    'videoUrl': 'assets/videos/6.mp4',
    'likes': 10,
    'views': 330,
  },
  {
    'name': 'Limpiar nunca fue tan divertido',
    'userName': 'limpieza.pro',
    'songName': 'Fondo musical - CFR 2023',
    'videoUrl': 'assets/videos/7.mp4',
    'likes': 1320,
    'views': 33032,
  },
  {
    'name': 'Ya llegamos a la India?... umm si',
    'userName': 'viajera',
    'songName': 'Bollywood Nights - remix',
    'videoUrl': 'assets/videos/8.mp4',
    'likes': 342,
    'views': 3332,
  },
];