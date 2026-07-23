import '../model/invoice.dart';
import '../model/day_expense.dart';

class HomeController {

  static List<DayExpense> groupByDay(List<Invoice> invoices) {
    final Map<DateTime, List<Invoice>> buckets = {};

    for (final invoice in invoices) {
      final day =
          DateTime(invoice.date.year, invoice.date.month, invoice.date.day);
      buckets.putIfAbsent(day, () => []).add(invoice);
    }

    final days = buckets.entries
        .map((entry) => DayExpense(date: entry.key, invoices: entry.value))
        .toList();

    days.sort((a, b) => b.date.compareTo(a.date));
    return days;
  }

  static double grandTotal(List<Invoice> invoices) {
    return invoices.fold(0.0, (sum, invoice) => sum + invoice.amount);
  }

  static String formatDay(DateTime date) {
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
    ];
    return "${date.day} ${months[date.month - 1]}";
  }
}
