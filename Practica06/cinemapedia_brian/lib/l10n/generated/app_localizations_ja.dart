// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get home => 'ホーム';

  @override
  String get inTheaters => '上映中';

  @override
  String get comingSoon => '公開予定';

  @override
  String get categories => 'カテゴリー';

  @override
  String get favorites => 'お気に入り';

  @override
  String get settings => '設定';

  @override
  String get viewDetails => '詳細を見る';

  @override
  String get popular => '人気作品';

  @override
  String get topRated => '高評価作品';

  @override
  String get movies => '映画';

  @override
  String get openMenu => 'メニューを開く';

  @override
  String get back => '戻る';

  @override
  String get backHome => 'ホームに戻る';

  @override
  String get backCategories => 'カテゴリーに戻る';

  @override
  String get searchMovies => '映画を検索';

  @override
  String get clearSearch => '検索をクリア';

  @override
  String get searchHint => '映画のタイトルで検索できます。';

  @override
  String noResults(String query) {
    return '「$query」に一致する作品はありません。';
  }

  @override
  String get connectionError => '接続できませんでした。通信環境を確認して、もう一度お試しください。';

  @override
  String get collectionError => '作品一覧を読み込めませんでした。通信環境を確認してください。';

  @override
  String get movieError => '映画を読み込めませんでした。';

  @override
  String get collectionsUnavailable => '一部の作品一覧を表示できません。';

  @override
  String get retry => '再試行';

  @override
  String get loading => '読み込み中…';

  @override
  String loadingCollection(String title) {
    return '$titleを読み込み中…';
  }

  @override
  String get emptyMovies => 'この地域で表示できる映画はありません。';

  @override
  String get addFavorite => 'お気に入りに追加';

  @override
  String get removeFavorite => 'お気に入りから削除';

  @override
  String get favoriteError => 'この端末にお気に入りを保存できませんでした。';

  @override
  String get stories => '心に残る物語を見つけよう';

  @override
  String get tagline => '次の物語はここから';

  @override
  String get drawerTagline => 'どんなひとときにも、ぴったりの物語を';

  @override
  String get nowPlayingDescription => '現在映画館で上映中の作品';

  @override
  String get upcomingDescription => 'これから公開される作品';

  @override
  String get popularDescription => 'みんなに人気の作品';

  @override
  String get topRatedDescription => '観客から高く評価された作品';

  @override
  String get seeAll => 'すべて見る';

  @override
  String get exploreCategories => 'カテゴリーから探す';

  @override
  String get categoriesDescription => 'TheMovieDBのデータで更新される作品一覧。';

  @override
  String get myList => 'マイリスト';

  @override
  String savedTitles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count作品を保存済み',
      zero: '保存した作品はありません',
    );
    return '$_temp0';
  }

  @override
  String get emptyFavorites => 'ここからマイリストを作ろう';

  @override
  String get emptyFavoritesDescription => '観たい映画を保存すると、ここに表示されます。';

  @override
  String get exploreMovies => '映画を探す';

  @override
  String get nowPlayingBadge => '上映中';

  @override
  String get unrated => '評価なし';

  @override
  String get noCertification => '年齢区分の情報なし';

  @override
  String get loadingCertification => '年齢区分を確認中…';

  @override
  String get originalTitleNotice => '翻訳されたタイトルがないため、原題を表示しています。';

  @override
  String get previousMovie => '前の映画';

  @override
  String get nextMovie => '次の映画';

  @override
  String get carouselHint => '画像をダブルタップすると最初の映画に戻ります';

  @override
  String get synopsis => 'あらすじ';

  @override
  String get noSynopsis => 'この映画のあらすじはありません。';

  @override
  String get cast => 'キャスト';

  @override
  String runtime(int minutes) {
    return '$minutes分';
  }

  @override
  String get countryLanguage => '国と言語';

  @override
  String get regionDescription => 'アプリの言語と映画の公開情報を取得する地域を選んでください。';

  @override
  String currentRegion(String country) {
    return '現在の選択：$country';
  }

  @override
  String regionUpdated(String country) {
    return '地域を更新しました：$country';
  }

  @override
  String get regionSaveError => 'この端末に地域設定を保存できませんでした。';

  @override
  String configuringRegion(String country) {
    return '$country向けにCinemapediaを設定しています…';
  }

  @override
  String get countryUS => 'アメリカ合衆国';

  @override
  String get countryMX => 'メキシコ';

  @override
  String get countryDE => 'ドイツ';

  @override
  String get countryJP => '日本';

  @override
  String get countryCN => '中国';

  @override
  String get countryRU => 'ロシア';

  @override
  String get countryBR => 'ブラジル';
}
