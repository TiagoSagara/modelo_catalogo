import 'package:intl/intl.dart';

class PriceFormatter {
  static String toReal(double price) {
    return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(price);
  }
}
