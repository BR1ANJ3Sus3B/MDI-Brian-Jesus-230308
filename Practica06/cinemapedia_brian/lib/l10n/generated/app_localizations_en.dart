// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get inTheaters => 'In Theaters';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get categories => 'Categories';

  @override
  String get favorites => 'Favorites';

  @override
  String get settings => 'Settings';

  @override
  String get viewDetails => 'View Details';

  @override
  String get popular => 'Popular';

  @override
  String get topRated => 'Top Rated';

  @override
  String get movies => 'Movies';

  @override
  String get openMenu => 'Open menu';

  @override
  String get back => 'Back';

  @override
  String get backHome => 'Back to home';

  @override
  String get backCategories => 'Back to categories';

  @override
  String get searchMovies => 'Search movies';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get searchHint => 'Search for a movie by title.';

  @override
  String noResults(String query) {
    return 'No results for “$query”.';
  }

  @override
  String get connectionError =>
      'Unable to connect. Check your connection and try again.';

  @override
  String get collectionError =>
      'Unable to load this collection. Check your connection.';

  @override
  String get movieError => 'Unable to load this movie.';

  @override
  String get collectionsUnavailable => 'Some collections are unavailable.';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading…';

  @override
  String loadingCollection(String title) {
    return 'Loading $title…';
  }

  @override
  String get emptyMovies => 'No movies available for this region.';

  @override
  String get addFavorite => 'Add to favorites';

  @override
  String get removeFavorite => 'Remove from favorites';

  @override
  String get favoriteError => 'Unable to save favorites on this device.';

  @override
  String get stories => 'Stories you will love';

  @override
  String get tagline => 'Your next story starts here';

  @override
  String get drawerTagline => 'Discover stories for every moment';

  @override
  String get nowPlayingDescription => 'Movies currently in theaters';

  @override
  String get upcomingDescription => 'Upcoming releases';

  @override
  String get popularDescription => 'Most watched by the community';

  @override
  String get topRatedDescription => 'Audience favorites';

  @override
  String get seeAll => 'See all';

  @override
  String get exploreCategories => 'Explore by category';

  @override
  String get categoriesDescription =>
      'Collections updated with data from TheMovieDB.';

  @override
  String get myList => 'My list';

  @override
  String savedTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saved titles',
      one: '1 saved title',
      zero: 'No saved titles',
    );
    return '$_temp0';
  }

  @override
  String get emptyFavorites => 'Your list starts here';

  @override
  String get emptyFavoritesDescription =>
      'Save movies you want to watch and find them here.';

  @override
  String get exploreMovies => 'Explore movies';

  @override
  String get nowPlayingBadge => 'IN THEATERS';

  @override
  String get unrated => 'Not rated';

  @override
  String get noCertification => 'No classification available';

  @override
  String get loadingCertification => 'Checking classification…';

  @override
  String get originalTitleNotice =>
      'No localized title was provided; showing the original.';

  @override
  String get previousMovie => 'Previous movie';

  @override
  String get nextMovie => 'Next movie';

  @override
  String get carouselHint =>
      'Double tap the image to return to the first movie';

  @override
  String get synopsis => 'Synopsis';

  @override
  String get noSynopsis => 'No synopsis is available for this movie.';

  @override
  String get cast => 'Cast';

  @override
  String runtime(int minutes) {
    return '$minutes min';
  }

  @override
  String get countryLanguage => 'Country and language';

  @override
  String get regionDescription =>
      'Choose the language of the app and the region for movie releases.';

  @override
  String currentRegion(String country) {
    return 'Current selection: $country';
  }

  @override
  String regionUpdated(String country) {
    return 'Region updated: $country';
  }

  @override
  String get regionSaveError => 'Unable to save the region on this device.';

  @override
  String configuringRegion(String country) {
    return 'Setting up Cinemapedia for $country…';
  }

  @override
  String get countryUS => 'United States';

  @override
  String get countryMX => 'Mexico';

  @override
  String get countryDE => 'Germany';

  @override
  String get countryJP => 'Japan';

  @override
  String get countryCN => 'China';

  @override
  String get countryRU => 'Russia';

  @override
  String get countryBR => 'Brazil';
}
