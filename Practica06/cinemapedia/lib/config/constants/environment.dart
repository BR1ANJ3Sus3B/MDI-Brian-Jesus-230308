import 'package:flutter_dotenv/flutter_dotenv.dart';


class Environment {

  static String get theMovieDbKey =>
      dotenv.isInitialized ? dotenv.env['THE_MOVIEDB_KEY'] ?? '' : '';


}
