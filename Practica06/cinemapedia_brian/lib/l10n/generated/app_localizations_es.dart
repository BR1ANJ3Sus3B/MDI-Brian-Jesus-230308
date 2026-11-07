// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get home => 'Inicio';

  @override
  String get inTheaters => 'En cines';

  @override
  String get comingSoon => 'Próximamente';

  @override
  String get categories => 'Categorías';

  @override
  String get favorites => 'Favoritos';

  @override
  String get settings => 'Configuración';

  @override
  String get viewDetails => 'Ver detalles';

  @override
  String get popular => 'Populares';

  @override
  String get topRated => 'Mejor calificadas';

  @override
  String get movies => 'Películas';

  @override
  String get openMenu => 'Abrir menú';

  @override
  String get back => 'Volver';

  @override
  String get backHome => 'Volver al inicio';

  @override
  String get backCategories => 'Volver a categorías';

  @override
  String get searchMovies => 'Buscar películas';

  @override
  String get clearSearch => 'Limpiar búsqueda';

  @override
  String get searchHint => 'Busca una película por título.';

  @override
  String noResults(String query) {
    return 'No encontramos resultados para “$query”.';
  }

  @override
  String get connectionError =>
      'No se pudo conectar. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get collectionError =>
      'No se pudo cargar esta colección. Comprueba tu conexión.';

  @override
  String get movieError => 'No se pudo cargar la película.';

  @override
  String get collectionsUnavailable =>
      'Algunas colecciones no están disponibles.';

  @override
  String get retry => 'Reintentar';

  @override
  String get loading => 'Cargando…';

  @override
  String loadingCollection(String title) {
    return 'Cargando $title…';
  }

  @override
  String get emptyMovies => 'No hay películas disponibles para esta región.';

  @override
  String get addFavorite => 'Agregar a favoritos';

  @override
  String get removeFavorite => 'Quitar de favoritos';

  @override
  String get favoriteError =>
      'No se pudieron guardar los favoritos en este dispositivo.';

  @override
  String get stories => 'Historias que te van a encantar';

  @override
  String get tagline => 'Tu próxima historia empieza aquí';

  @override
  String get drawerTagline => 'Descubre historias para cada momento';

  @override
  String get nowPlayingDescription => 'Películas que están ahora en cartelera';

  @override
  String get upcomingDescription => 'Próximos estrenos';

  @override
  String get popularDescription => 'Lo más visto por la comunidad';

  @override
  String get topRatedDescription => 'Favoritas de la audiencia';

  @override
  String get seeAll => 'Ver todas';

  @override
  String get exploreCategories => 'Explora por categorías';

  @override
  String get categoriesDescription =>
      'Colecciones actualizadas con los datos de TheMovieDB.';

  @override
  String get myList => 'Mi lista';

  @override
  String savedTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count títulos guardados',
      one: '1 título guardado',
      zero: 'Sin títulos guardados',
    );
    return '$_temp0';
  }

  @override
  String get emptyFavorites => 'Tu lista empieza aquí';

  @override
  String get emptyFavoritesDescription =>
      'Guarda las películas que quieras ver y las encontrarás aquí.';

  @override
  String get exploreMovies => 'Explorar películas';

  @override
  String get nowPlayingBadge => 'EN CARTELERA';

  @override
  String get unrated => 'Sin calificación';

  @override
  String get noCertification => 'Sin clasificación disponible';

  @override
  String get loadingCertification => 'Consultando clasificación…';

  @override
  String get originalTitleNotice =>
      'La API no devolvió título localizado; se muestra el original.';

  @override
  String get previousMovie => 'Película anterior';

  @override
  String get nextMovie => 'Película siguiente';

  @override
  String get carouselHint =>
      'Doble toque en la imagen para volver a la primera película';

  @override
  String get synopsis => 'Sinopsis';

  @override
  String get noSynopsis => 'No hay una sinopsis disponible para esta película.';

  @override
  String get cast => 'Reparto';

  @override
  String runtime(int minutes) {
    return '$minutes min';
  }

  @override
  String get countryLanguage => 'País e idioma';

  @override
  String get regionDescription =>
      'Elige el idioma de la aplicación y la región para consultar estrenos.';

  @override
  String currentRegion(String country) {
    return 'Selección actual: $country';
  }

  @override
  String regionUpdated(String country) {
    return 'Región actualizada: $country';
  }

  @override
  String get regionSaveError =>
      'No se pudo guardar la región en este dispositivo.';

  @override
  String configuringRegion(String country) {
    return 'Configurando Cinemapedia para $country…';
  }

  @override
  String get countryUS => 'Estados Unidos';

  @override
  String get countryMX => 'México';

  @override
  String get countryDE => 'Alemania';

  @override
  String get countryJP => 'Japón';

  @override
  String get countryCN => 'China';

  @override
  String get countryRU => 'Rusia';

  @override
  String get countryBR => 'Brasil';
}
