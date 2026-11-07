// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get home => 'Startseite';

  @override
  String get inTheaters => 'Im Kino';

  @override
  String get comingSoon => 'Demnächst';

  @override
  String get categories => 'Kategorien';

  @override
  String get favorites => 'Favoriten';

  @override
  String get settings => 'Einstellungen';

  @override
  String get viewDetails => 'Details ansehen';

  @override
  String get popular => 'Beliebt';

  @override
  String get topRated => 'Bestbewertet';

  @override
  String get movies => 'Filme';

  @override
  String get openMenu => 'Menü öffnen';

  @override
  String get back => 'Zurück';

  @override
  String get backHome => 'Zur Startseite';

  @override
  String get backCategories => 'Zurück zu den Kategorien';

  @override
  String get searchMovies => 'Filme suchen';

  @override
  String get clearSearch => 'Suche löschen';

  @override
  String get searchHint => 'Suche nach einem Filmtitel.';

  @override
  String noResults(String query) {
    return 'Keine Ergebnisse für „$query“.';
  }

  @override
  String get connectionError =>
      'Keine Verbindung. Prüfe deine Internetverbindung und versuche es erneut.';

  @override
  String get collectionError =>
      'Diese Sammlung konnte nicht geladen werden. Prüfe deine Verbindung.';

  @override
  String get movieError => 'Der Film konnte nicht geladen werden.';

  @override
  String get collectionsUnavailable =>
      'Einige Sammlungen sind nicht verfügbar.';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get loading => 'Wird geladen…';

  @override
  String loadingCollection(String title) {
    return '$title wird geladen…';
  }

  @override
  String get emptyMovies => 'Für diese Region sind keine Filme verfügbar.';

  @override
  String get addFavorite => 'Zu Favoriten hinzufügen';

  @override
  String get removeFavorite => 'Aus Favoriten entfernen';

  @override
  String get favoriteError =>
      'Favoriten konnten auf diesem Gerät nicht gespeichert werden.';

  @override
  String get stories => 'Geschichten, die dich begeistern';

  @override
  String get tagline => 'Deine nächste Geschichte beginnt hier';

  @override
  String get drawerTagline => 'Entdecke Geschichten für jeden Moment';

  @override
  String get nowPlayingDescription => 'Filme, die gerade im Kino laufen';

  @override
  String get upcomingDescription => 'Kommende Filmstarts';

  @override
  String get popularDescription => 'Die beliebtesten Filme der Community';

  @override
  String get topRatedDescription => 'Publikumslieblinge';

  @override
  String get seeAll => 'Alle ansehen';

  @override
  String get exploreCategories => 'Kategorien entdecken';

  @override
  String get categoriesDescription =>
      'Aktuelle Sammlungen mit Daten von TheMovieDB.';

  @override
  String get myList => 'Meine Liste';

  @override
  String savedTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gespeicherte Titel',
      one: '1 gespeicherter Titel',
      zero: 'Keine gespeicherten Titel',
    );
    return '$_temp0';
  }

  @override
  String get emptyFavorites => 'Deine Liste beginnt hier';

  @override
  String get emptyFavoritesDescription =>
      'Speichere Filme, die du sehen möchtest, und finde sie hier wieder.';

  @override
  String get exploreMovies => 'Filme entdecken';

  @override
  String get nowPlayingBadge => 'JETZT IM KINO';

  @override
  String get unrated => 'Nicht bewertet';

  @override
  String get noCertification => 'Keine Altersfreigabe verfügbar';

  @override
  String get loadingCertification => 'Altersfreigabe wird geladen…';

  @override
  String get originalTitleNotice =>
      'Kein übersetzter Titel verfügbar; der Originaltitel wird angezeigt.';

  @override
  String get previousMovie => 'Vorheriger Film';

  @override
  String get nextMovie => 'Nächster Film';

  @override
  String get carouselHint =>
      'Tippe zweimal auf das Bild, um zum ersten Film zurückzukehren';

  @override
  String get synopsis => 'Handlung';

  @override
  String get noSynopsis =>
      'Für diesen Film ist keine Zusammenfassung verfügbar.';

  @override
  String get cast => 'Besetzung';

  @override
  String runtime(int minutes) {
    return '$minutes Min.';
  }

  @override
  String get countryLanguage => 'Land und Sprache';

  @override
  String get regionDescription =>
      'Wähle die App-Sprache und die Region für Filmstarts.';

  @override
  String currentRegion(String country) {
    return 'Aktuelle Auswahl: $country';
  }

  @override
  String regionUpdated(String country) {
    return 'Region aktualisiert: $country';
  }

  @override
  String get regionSaveError =>
      'Die Region konnte auf diesem Gerät nicht gespeichert werden.';

  @override
  String configuringRegion(String country) {
    return 'Cinemapedia wird für $country eingerichtet…';
  }

  @override
  String get countryUS => 'Vereinigte Staaten';

  @override
  String get countryMX => 'Mexiko';

  @override
  String get countryDE => 'Deutschland';

  @override
  String get countryJP => 'Japan';

  @override
  String get countryCN => 'China';

  @override
  String get countryRU => 'Russland';

  @override
  String get countryBR => 'Brasilien';
}
