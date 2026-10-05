import 'package:flutter_test/flutter_test.dart';
import 'package:practica04_brian/config/helpers/human_formats.dart';

void main() {
  group('HumanFormats.humanReadableNumber', () {
    test('usa notacion compacta para miles', () {
      expect(HumanFormats.humanReadableNumber(1523), '1.52K');
      expect(HumanFormats.humanReadableNumber(23230), '23.2K');
    });

    test('usa notacion compacta para millones', () {
      expect(HumanFormats.humanReadableNumber(21564320), '21.6M');
    });

    test('deja intactos los numeros de tres digitos', () {
      expect(HumanFormats.humanReadableNumber(320), '320');
    });

    test('formatea el cero', () {
      expect(HumanFormats.humanReadableNumber(0), '0');
    });
  });
}