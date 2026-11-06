import 'package:intl/intl.dart';

class HumanFormats {
  static String rating(double rating) =>
      rating.toStringAsFixed(1).replaceFirst(RegExp(r'\.0$'), '');

  static String certification(String? certification, String regionCode) {
    if (certification == null || certification.trim().isEmpty) {
      return 'Sin clasificación disponible';
    }
    return regionCode == 'DE'
        ? 'FSK ${certification.trim()}'
        : certification.trim();
  }

  static String number(double number, [int decimals = 0]) {
    final formattedNumber = NumberFormat.compactCurrency(
            decimalDigits: decimals, symbol: '', locale: 'en')
        .format(number);

    return formattedNumber;
  }
}
