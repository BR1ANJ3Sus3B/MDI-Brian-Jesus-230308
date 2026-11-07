import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('ja'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh')
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @inTheaters.
  ///
  /// In en, this message translates to:
  /// **'In Theaters'**
  String get inTheaters;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @topRated.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get topRated;

  /// No description provided for @movies.
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get movies;

  /// No description provided for @openMenu.
  ///
  /// In en, this message translates to:
  /// **'Open menu'**
  String get openMenu;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @backHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get backHome;

  /// No description provided for @backCategories.
  ///
  /// In en, this message translates to:
  /// **'Back to categories'**
  String get backCategories;

  /// No description provided for @searchMovies.
  ///
  /// In en, this message translates to:
  /// **'Search movies'**
  String get searchMovies;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a movie by title.'**
  String get searchHint;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results for “{query}”.'**
  String noResults(String query);

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect. Check your connection and try again.'**
  String get connectionError;

  /// No description provided for @collectionError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load this collection. Check your connection.'**
  String get collectionError;

  /// No description provided for @movieError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load this movie.'**
  String get movieError;

  /// No description provided for @collectionsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Some collections are unavailable.'**
  String get collectionsUnavailable;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @loadingCollection.
  ///
  /// In en, this message translates to:
  /// **'Loading {title}…'**
  String loadingCollection(String title);

  /// No description provided for @emptyMovies.
  ///
  /// In en, this message translates to:
  /// **'No movies available for this region.'**
  String get emptyMovies;

  /// No description provided for @addFavorite.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addFavorite;

  /// No description provided for @removeFavorite.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFavorite;

  /// No description provided for @favoriteError.
  ///
  /// In en, this message translates to:
  /// **'Unable to save favorites on this device.'**
  String get favoriteError;

  /// No description provided for @stories.
  ///
  /// In en, this message translates to:
  /// **'Stories you will love'**
  String get stories;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Your next story starts here'**
  String get tagline;

  /// No description provided for @drawerTagline.
  ///
  /// In en, this message translates to:
  /// **'Discover stories for every moment'**
  String get drawerTagline;

  /// No description provided for @nowPlayingDescription.
  ///
  /// In en, this message translates to:
  /// **'Movies currently in theaters'**
  String get nowPlayingDescription;

  /// No description provided for @upcomingDescription.
  ///
  /// In en, this message translates to:
  /// **'Upcoming releases'**
  String get upcomingDescription;

  /// No description provided for @popularDescription.
  ///
  /// In en, this message translates to:
  /// **'Most watched by the community'**
  String get popularDescription;

  /// No description provided for @topRatedDescription.
  ///
  /// In en, this message translates to:
  /// **'Audience favorites'**
  String get topRatedDescription;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @exploreCategories.
  ///
  /// In en, this message translates to:
  /// **'Explore by category'**
  String get exploreCategories;

  /// No description provided for @categoriesDescription.
  ///
  /// In en, this message translates to:
  /// **'Collections updated with data from TheMovieDB.'**
  String get categoriesDescription;

  /// No description provided for @myList.
  ///
  /// In en, this message translates to:
  /// **'My list'**
  String get myList;

  /// No description provided for @savedTitles.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No saved titles} one{1 saved title} other{{count} saved titles}}'**
  String savedTitles(int count);

  /// No description provided for @emptyFavorites.
  ///
  /// In en, this message translates to:
  /// **'Your list starts here'**
  String get emptyFavorites;

  /// No description provided for @emptyFavoritesDescription.
  ///
  /// In en, this message translates to:
  /// **'Save movies you want to watch and find them here.'**
  String get emptyFavoritesDescription;

  /// No description provided for @exploreMovies.
  ///
  /// In en, this message translates to:
  /// **'Explore movies'**
  String get exploreMovies;

  /// No description provided for @nowPlayingBadge.
  ///
  /// In en, this message translates to:
  /// **'IN THEATERS'**
  String get nowPlayingBadge;

  /// No description provided for @unrated.
  ///
  /// In en, this message translates to:
  /// **'Not rated'**
  String get unrated;

  /// No description provided for @noCertification.
  ///
  /// In en, this message translates to:
  /// **'No classification available'**
  String get noCertification;

  /// No description provided for @loadingCertification.
  ///
  /// In en, this message translates to:
  /// **'Checking classification…'**
  String get loadingCertification;

  /// No description provided for @originalTitleNotice.
  ///
  /// In en, this message translates to:
  /// **'No localized title was provided; showing the original.'**
  String get originalTitleNotice;

  /// No description provided for @previousMovie.
  ///
  /// In en, this message translates to:
  /// **'Previous movie'**
  String get previousMovie;

  /// No description provided for @nextMovie.
  ///
  /// In en, this message translates to:
  /// **'Next movie'**
  String get nextMovie;

  /// No description provided for @carouselHint.
  ///
  /// In en, this message translates to:
  /// **'Double tap the image to return to the first movie'**
  String get carouselHint;

  /// No description provided for @synopsis.
  ///
  /// In en, this message translates to:
  /// **'Synopsis'**
  String get synopsis;

  /// No description provided for @noSynopsis.
  ///
  /// In en, this message translates to:
  /// **'No synopsis is available for this movie.'**
  String get noSynopsis;

  /// No description provided for @cast.
  ///
  /// In en, this message translates to:
  /// **'Cast'**
  String get cast;

  /// No description provided for @runtime.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String runtime(int minutes);

  /// No description provided for @countryLanguage.
  ///
  /// In en, this message translates to:
  /// **'Country and language'**
  String get countryLanguage;

  /// No description provided for @regionDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the language of the app and the region for movie releases.'**
  String get regionDescription;

  /// No description provided for @currentRegion.
  ///
  /// In en, this message translates to:
  /// **'Current selection: {country}'**
  String currentRegion(String country);

  /// No description provided for @regionUpdated.
  ///
  /// In en, this message translates to:
  /// **'Region updated: {country}'**
  String regionUpdated(String country);

  /// No description provided for @regionSaveError.
  ///
  /// In en, this message translates to:
  /// **'Unable to save the region on this device.'**
  String get regionSaveError;

  /// No description provided for @configuringRegion.
  ///
  /// In en, this message translates to:
  /// **'Setting up Cinemapedia for {country}…'**
  String configuringRegion(String country);

  /// No description provided for @countryUS.
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get countryUS;

  /// No description provided for @countryMX.
  ///
  /// In en, this message translates to:
  /// **'Mexico'**
  String get countryMX;

  /// No description provided for @countryDE.
  ///
  /// In en, this message translates to:
  /// **'Germany'**
  String get countryDE;

  /// No description provided for @countryJP.
  ///
  /// In en, this message translates to:
  /// **'Japan'**
  String get countryJP;

  /// No description provided for @countryCN.
  ///
  /// In en, this message translates to:
  /// **'China'**
  String get countryCN;

  /// No description provided for @countryRU.
  ///
  /// In en, this message translates to:
  /// **'Russia'**
  String get countryRU;

  /// No description provided for @countryBR.
  ///
  /// In en, this message translates to:
  /// **'Brazil'**
  String get countryBR;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'ja',
        'pt',
        'ru',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
