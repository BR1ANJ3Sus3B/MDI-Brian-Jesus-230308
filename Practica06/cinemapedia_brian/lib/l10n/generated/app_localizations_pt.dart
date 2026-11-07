// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get home => 'Início';

  @override
  String get inTheaters => 'Nos cinemas';

  @override
  String get comingSoon => 'Em breve';

  @override
  String get categories => 'Categorias';

  @override
  String get favorites => 'Favoritos';

  @override
  String get settings => 'Configurações';

  @override
  String get viewDetails => 'Ver detalhes';

  @override
  String get popular => 'Populares';

  @override
  String get topRated => 'Mais bem avaliados';

  @override
  String get movies => 'Filmes';

  @override
  String get openMenu => 'Abrir menu';

  @override
  String get back => 'Voltar';

  @override
  String get backHome => 'Voltar ao início';

  @override
  String get backCategories => 'Voltar às categorias';

  @override
  String get searchMovies => 'Buscar filmes';

  @override
  String get clearSearch => 'Limpar busca';

  @override
  String get searchHint => 'Busque um filme pelo título.';

  @override
  String noResults(String query) {
    return 'Nenhum resultado para “$query”.';
  }

  @override
  String get connectionError =>
      'Não foi possível conectar. Verifique sua conexão e tente novamente.';

  @override
  String get collectionError =>
      'Não foi possível carregar esta coleção. Verifique sua conexão.';

  @override
  String get movieError => 'Não foi possível carregar o filme.';

  @override
  String get collectionsUnavailable => 'Algumas coleções estão indisponíveis.';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get loading => 'Carregando…';

  @override
  String loadingCollection(String title) {
    return 'Carregando $title…';
  }

  @override
  String get emptyMovies => 'Não há filmes disponíveis para esta região.';

  @override
  String get addFavorite => 'Adicionar aos favoritos';

  @override
  String get removeFavorite => 'Remover dos favoritos';

  @override
  String get favoriteError =>
      'Não foi possível salvar os favoritos neste dispositivo.';

  @override
  String get stories => 'Histórias que você vai adorar';

  @override
  String get tagline => 'Sua próxima história começa aqui';

  @override
  String get drawerTagline => 'Descubra histórias para cada momento';

  @override
  String get nowPlayingDescription => 'Filmes em cartaz nos cinemas';

  @override
  String get upcomingDescription => 'Próximas estreias';

  @override
  String get popularDescription => 'Os mais assistidos pela comunidade';

  @override
  String get topRatedDescription => 'Favoritos do público';

  @override
  String get seeAll => 'Ver todos';

  @override
  String get exploreCategories => 'Explore por categorias';

  @override
  String get categoriesDescription =>
      'Coleções atualizadas com os dados do TheMovieDB.';

  @override
  String get myList => 'Minha lista';

  @override
  String savedTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count títulos salvos',
      one: '1 título salvo',
      zero: 'Nenhum título salvo',
    );
    return '$_temp0';
  }

  @override
  String get emptyFavorites => 'Sua lista começa aqui';

  @override
  String get emptyFavoritesDescription =>
      'Salve os filmes que quer assistir e encontre todos aqui.';

  @override
  String get exploreMovies => 'Explorar filmes';

  @override
  String get nowPlayingBadge => 'EM CARTAZ';

  @override
  String get unrated => 'Sem avaliação';

  @override
  String get noCertification => 'Classificação indisponível';

  @override
  String get loadingCertification => 'Consultando classificação…';

  @override
  String get originalTitleNotice =>
      'O título traduzido não está disponível; exibindo o original.';

  @override
  String get previousMovie => 'Filme anterior';

  @override
  String get nextMovie => 'Próximo filme';

  @override
  String get carouselHint =>
      'Toque duas vezes na imagem para voltar ao primeiro filme';

  @override
  String get synopsis => 'Sinopse';

  @override
  String get noSynopsis => 'Não há sinopse disponível para este filme.';

  @override
  String get cast => 'Elenco';

  @override
  String runtime(int minutes) {
    return '$minutes min';
  }

  @override
  String get countryLanguage => 'País e idioma';

  @override
  String get regionDescription =>
      'Escolha o idioma do aplicativo e a região para consultar estreias.';

  @override
  String currentRegion(String country) {
    return 'Seleção atual: $country';
  }

  @override
  String regionUpdated(String country) {
    return 'Região atualizada: $country';
  }

  @override
  String get regionSaveError =>
      'Não foi possível salvar a região neste dispositivo.';

  @override
  String configuringRegion(String country) {
    return 'Configurando o Cinemapedia para $country…';
  }

  @override
  String get countryUS => 'Estados Unidos';

  @override
  String get countryMX => 'México';

  @override
  String get countryDE => 'Alemanha';

  @override
  String get countryJP => 'Japão';

  @override
  String get countryCN => 'China';

  @override
  String get countryRU => 'Rússia';

  @override
  String get countryBR => 'Brasil';
}
