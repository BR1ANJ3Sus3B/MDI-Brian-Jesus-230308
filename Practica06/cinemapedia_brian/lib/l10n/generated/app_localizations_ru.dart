// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get home => 'Главная';

  @override
  String get inTheaters => 'В кино';

  @override
  String get comingSoon => 'Скоро';

  @override
  String get categories => 'Категории';

  @override
  String get favorites => 'Избранное';

  @override
  String get settings => 'Настройки';

  @override
  String get viewDetails => 'Подробнее';

  @override
  String get popular => 'Популярные';

  @override
  String get topRated => 'Лучшие';

  @override
  String get movies => 'Фильмы';

  @override
  String get openMenu => 'Открыть меню';

  @override
  String get back => 'Назад';

  @override
  String get backHome => 'На главную';

  @override
  String get backCategories => 'К категориям';

  @override
  String get searchMovies => 'Поиск фильмов';

  @override
  String get clearSearch => 'Очистить поиск';

  @override
  String get searchHint => 'Найдите фильм по названию.';

  @override
  String noResults(String query) {
    return 'По запросу «$query» ничего не найдено.';
  }

  @override
  String get connectionError =>
      'Не удалось подключиться. Проверьте соединение и повторите попытку.';

  @override
  String get collectionError =>
      'Не удалось загрузить подборку. Проверьте соединение.';

  @override
  String get movieError => 'Не удалось загрузить фильм.';

  @override
  String get collectionsUnavailable => 'Некоторые подборки недоступны.';

  @override
  String get retry => 'Повторить';

  @override
  String get loading => 'Загрузка…';

  @override
  String loadingCollection(String title) {
    return 'Загрузка: $title…';
  }

  @override
  String get emptyMovies => 'Для этого региона нет доступных фильмов.';

  @override
  String get addFavorite => 'Добавить в избранное';

  @override
  String get removeFavorite => 'Удалить из избранного';

  @override
  String get favoriteError =>
      'Не удалось сохранить избранное на этом устройстве.';

  @override
  String get stories => 'Истории, которые вам понравятся';

  @override
  String get tagline => 'Ваша следующая история начинается здесь';

  @override
  String get drawerTagline => 'Находите истории для каждого мгновения';

  @override
  String get nowPlayingDescription => 'Фильмы, которые сейчас идут в кино';

  @override
  String get upcomingDescription => 'Ближайшие премьеры';

  @override
  String get popularDescription => 'Самые популярные фильмы сообщества';

  @override
  String get topRatedDescription => 'Любимые фильмы зрителей';

  @override
  String get seeAll => 'Смотреть все';

  @override
  String get exploreCategories => 'Обзор категорий';

  @override
  String get categoriesDescription =>
      'Подборки обновляются по данным TheMovieDB.';

  @override
  String get myList => 'Мой список';

  @override
  String savedTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сохранённого фильма',
      many: '$count сохранённых фильмов',
      few: '$count сохранённых фильма',
      one: '$count сохранённый фильм',
      zero: 'Нет сохранённых фильмов',
    );
    return '$_temp0';
  }

  @override
  String get emptyFavorites => 'Ваш список начинается здесь';

  @override
  String get emptyFavoritesDescription =>
      'Сохраняйте фильмы, которые хотите посмотреть, и находите их здесь.';

  @override
  String get exploreMovies => 'Найти фильмы';

  @override
  String get nowPlayingBadge => 'В КИНО';

  @override
  String get unrated => 'Нет оценки';

  @override
  String get noCertification => 'Возрастной рейтинг недоступен';

  @override
  String get loadingCertification => 'Проверка возрастного рейтинга…';

  @override
  String get originalTitleNotice =>
      'Перевод названия недоступен; показано оригинальное название.';

  @override
  String get previousMovie => 'Предыдущий фильм';

  @override
  String get nextMovie => 'Следующий фильм';

  @override
  String get carouselHint =>
      'Дважды коснитесь изображения, чтобы вернуться к первому фильму';

  @override
  String get synopsis => 'Описание';

  @override
  String get noSynopsis => 'Описание этого фильма недоступно.';

  @override
  String get cast => 'В ролях';

  @override
  String runtime(int minutes) {
    return '$minutes мин';
  }

  @override
  String get countryLanguage => 'Страна и язык';

  @override
  String get regionDescription =>
      'Выберите язык приложения и регион кинопроката.';

  @override
  String currentRegion(String country) {
    return 'Текущий выбор: $country';
  }

  @override
  String regionUpdated(String country) {
    return 'Регион обновлён: $country';
  }

  @override
  String get regionSaveError =>
      'Не удалось сохранить регион на этом устройстве.';

  @override
  String configuringRegion(String country) {
    return 'Настраиваем Cinemapedia для региона: $country…';
  }

  @override
  String get countryUS => 'США';

  @override
  String get countryMX => 'Мексика';

  @override
  String get countryDE => 'Германия';

  @override
  String get countryJP => 'Япония';

  @override
  String get countryCN => 'Китай';

  @override
  String get countryRU => 'Россия';

  @override
  String get countryBR => 'Бразилия';
}
