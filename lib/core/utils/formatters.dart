import 'package:intl/intl.dart';

String formatAmount(double amount) {
  final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA', decimalDigits: 0);
  final isNegative = amount < 0;
  final formatted = formatter.format(amount.abs());
  return isNegative ? '- $formatted' : formatted;
}

String formatDate(DateTime date) {
  return DateFormat('dd/MM/yyyy HH:mm').format(date);
}
