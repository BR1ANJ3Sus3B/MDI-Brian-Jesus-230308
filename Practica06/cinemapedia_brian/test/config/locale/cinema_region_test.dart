import 'package:cinemapedia/config/locale/cinema_region.dart';
import 'package:cinemapedia/presentation/providers/region/selected_region_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('CinemaRegion', () {
    test('contains all seven requested country and language pairs', () {
      expect(
        CinemaRegion.all
            .map((region) => '${region.code}:${region.languageCode}')
            .toList(),
        [
          'US:en-US',
          'MX:es-MX',
          'DE:de-DE',
          'JP:ja-JP',
          'CN:zh-CN',
          'RU:ru-RU',
          'BR:pt-BR',
        ],
      );
    });

    test('defaults to Mexico for a missing or unknown preference', () {
      expect(CinemaRegion.fromCode(null).code, 'MX');
      expect(CinemaRegion.fromCode('XX').code, 'MX');
    });
  });

  test('persists the selected region across notifier instances', () async {
    SharedPreferences.setMockInitialValues({});

    final firstSession = SelectedRegionNotifier();
    await firstSession.ready;
    expect(firstSession.current.code, 'MX');

    await firstSession.select(CinemaRegion.all[3]);
    firstSession.dispose();

    final nextSession = SelectedRegionNotifier();
    await nextSession.ready;
    expect(nextSession.current.code, 'JP');
    nextSession.dispose();
  });
}
