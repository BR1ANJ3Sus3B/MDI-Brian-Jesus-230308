// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get home => '首页';

  @override
  String get inTheaters => '正在热映';

  @override
  String get comingSoon => '即将上映';

  @override
  String get categories => '分类';

  @override
  String get favorites => '收藏';

  @override
  String get settings => '设置';

  @override
  String get viewDetails => '查看详情';

  @override
  String get popular => '热门电影';

  @override
  String get topRated => '高分电影';

  @override
  String get movies => '电影';

  @override
  String get openMenu => '打开菜单';

  @override
  String get back => '返回';

  @override
  String get backHome => '返回首页';

  @override
  String get backCategories => '返回分类';

  @override
  String get searchMovies => '搜索电影';

  @override
  String get clearSearch => '清空搜索';

  @override
  String get searchHint => '按片名搜索电影。';

  @override
  String noResults(String query) {
    return '未找到与“$query”相关的结果。';
  }

  @override
  String get connectionError => '无法连接。请检查网络后重试。';

  @override
  String get collectionError => '无法加载此片单。请检查网络连接。';

  @override
  String get movieError => '无法加载此电影。';

  @override
  String get collectionsUnavailable => '部分片单暂不可用。';

  @override
  String get retry => '重试';

  @override
  String get loading => '加载中…';

  @override
  String loadingCollection(String title) {
    return '正在加载$title…';
  }

  @override
  String get emptyMovies => '此地区暂无可用电影。';

  @override
  String get addFavorite => '添加到收藏';

  @override
  String get removeFavorite => '取消收藏';

  @override
  String get favoriteError => '无法在此设备上保存收藏。';

  @override
  String get stories => '发现让你心动的故事';

  @override
  String get tagline => '下一段故事从这里开始';

  @override
  String get drawerTagline => '为每个时刻发现好故事';

  @override
  String get nowPlayingDescription => '目前在影院上映的电影';

  @override
  String get upcomingDescription => '即将上映的新片';

  @override
  String get popularDescription => '社区最受欢迎的电影';

  @override
  String get topRatedDescription => '观众喜爱的高分佳作';

  @override
  String get seeAll => '查看全部';

  @override
  String get exploreCategories => '按分类探索';

  @override
  String get categoriesDescription => '根据TheMovieDB数据更新片单。';

  @override
  String get myList => '我的片单';

  @override
  String savedTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已收藏$count部电影',
      zero: '尚未收藏电影',
    );
    return '$_temp0';
  }

  @override
  String get emptyFavorites => '从这里创建你的片单';

  @override
  String get emptyFavoritesDescription => '收藏想看的电影，即可在这里找到它们。';

  @override
  String get exploreMovies => '探索电影';

  @override
  String get nowPlayingBadge => '正在热映';

  @override
  String get unrated => '暂无评分';

  @override
  String get noCertification => '暂无分级信息';

  @override
  String get loadingCertification => '正在查询分级…';

  @override
  String get originalTitleNotice => '未提供本地化片名，现显示原片名。';

  @override
  String get previousMovie => '上一部电影';

  @override
  String get nextMovie => '下一部电影';

  @override
  String get carouselHint => '双击图片可返回第一部电影';

  @override
  String get synopsis => '剧情简介';

  @override
  String get noSynopsis => '暂无此电影的剧情简介。';

  @override
  String get cast => '演员阵容';

  @override
  String runtime(int minutes) {
    return '$minutes分钟';
  }

  @override
  String get countryLanguage => '国家和语言';

  @override
  String get regionDescription => '选择应用语言及电影上映信息对应的地区。';

  @override
  String currentRegion(String country) {
    return '当前选择：$country';
  }

  @override
  String regionUpdated(String country) {
    return '地区已更新：$country';
  }

  @override
  String get regionSaveError => '无法在此设备上保存地区设置。';

  @override
  String configuringRegion(String country) {
    return '正在为$country配置Cinemapedia…';
  }

  @override
  String get countryUS => '美国';

  @override
  String get countryMX => '墨西哥';

  @override
  String get countryDE => '德国';

  @override
  String get countryJP => '日本';

  @override
  String get countryCN => '中国';

  @override
  String get countryRU => '俄罗斯';

  @override
  String get countryBR => '巴西';
}
