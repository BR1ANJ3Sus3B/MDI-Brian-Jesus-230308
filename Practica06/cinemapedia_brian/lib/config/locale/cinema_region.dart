import 'package:flutter/widgets.dart';
import 'package:cinemapedia/l10n/l10n.dart';

class CinemaRegion {
  const CinemaRegion({
    required this.code,
    required this.languageCode,
    required this.countryName,
    required this.languageName,
    required this.flag,
  });

  final String code;
  final String languageCode;
  final String countryName;
  final String languageName;
  final String flag;

  String get label => '$flag $countryName ($languageName)';
  Locale get locale => Locale(languageCode.split('-').first, code);
  String localizedCountry(AppLocalizations l10n) => switch (code) {
        'US' => l10n.countryUS,
        'DE' => l10n.countryDE,
        'JP' => l10n.countryJP,
        'CN' => l10n.countryCN,
        'RU' => l10n.countryRU,
        'BR' => l10n.countryBR,
        _ => l10n.countryMX,
      };

  static const mexico = CinemaRegion(
    code: 'MX',
    languageCode: 'es-MX',
    countryName: 'México',
    languageName: 'Español',
    flag: '🇲🇽',
  );

  static const all = <CinemaRegion>[
    CinemaRegion(
      code: 'US',
      languageCode: 'en-US',
      countryName: 'Estados Unidos',
      languageName: 'English',
      flag: '🇺🇸',
    ),
    mexico,
    CinemaRegion(
      code: 'DE',
      languageCode: 'de-DE',
      countryName: 'Deutschland',
      languageName: 'Deutsch',
      flag: '🇩🇪',
    ),
    CinemaRegion(
      code: 'JP',
      languageCode: 'ja-JP',
      countryName: '日本',
      languageName: '日本語',
      flag: '🇯🇵',
    ),
    CinemaRegion(
      code: 'CN',
      languageCode: 'zh-CN',
      countryName: '中国',
      languageName: '简体中文',
      flag: '🇨🇳',
    ),
    CinemaRegion(
      code: 'RU',
      languageCode: 'ru-RU',
      countryName: 'Россия',
      languageName: 'Русский',
      flag: '🇷🇺',
    ),
    CinemaRegion(
      code: 'BR',
      languageCode: 'pt-BR',
      countryName: 'Brasil',
      languageName: 'Português',
      flag: '🇧🇷',
    ),
  ];

  static CinemaRegion fromCode(String? code) => all.firstWhere(
        (region) => region.code == code,
        orElse: () => mexico,
      );
}
