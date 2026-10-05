import 'package:intl/intl.dart';

/// Utilidades para presentar datos crudos (likes, vistas) de forma legible.
class HumanFormats {
  const HumanFormats._();

  /// Convierte un numero a notacion compacta: 1200 -> "1.2K", 21564320 -> "21.6M".
  static String humanReadableNumber(double number) {
    return NumberFormat.compact(locale: 'en_US').format(number);
  }
}