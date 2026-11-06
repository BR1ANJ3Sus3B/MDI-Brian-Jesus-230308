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
      languageName: 'Inglés',
      flag: '🇺🇸',
    ),
    mexico,
    CinemaRegion(
      code: 'DE',
      languageCode: 'de-DE',
      countryName: 'Alemania',
      languageName: 'Alemán',
      flag: '🇩🇪',
    ),
    CinemaRegion(
      code: 'JP',
      languageCode: 'ja-JP',
      countryName: 'Japón',
      languageName: 'Japonés',
      flag: '🇯🇵',
    ),
    CinemaRegion(
      code: 'CN',
      languageCode: 'zh-CN',
      countryName: 'China',
      languageName: 'Chino simplificado',
      flag: '🇨🇳',
    ),
    CinemaRegion(
      code: 'RU',
      languageCode: 'ru-RU',
      countryName: 'Rusia',
      languageName: 'Ruso',
      flag: '🇷🇺',
    ),
    CinemaRegion(
      code: 'BR',
      languageCode: 'pt-BR',
      countryName: 'Brasil',
      languageName: 'Portugués',
      flag: '🇧🇷',
    ),
  ];

  static CinemaRegion fromCode(String? code) => all.firstWhere(
        (region) => region.code == code,
        orElse: () => mexico,
      );
}
