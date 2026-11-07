import 'package:intl/intl.dart';

class HumanFormats {
  static String rating(double rating, [String locale = 'en']) =>
      NumberFormat('0.#', locale).format(rating);

  static String certification(String? certification, String regionCode,
      {required String unavailable}) {
    if (certification == null || certification.trim().isEmpty) {
      return unavailable;
    }
    return regionCode == 'DE' && !certification.trim().startsWith('FSK')
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
