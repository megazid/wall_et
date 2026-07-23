import 'invoice.dart';

// A DayExpense is a *derived* view object: the controller builds it by grouping
// invoices that share the same date. It is never saved to disk on its own —
// the flat List<Invoice> is the single source of truth. That's why there is no
// toJson/fromJson here.
class DayExpense {
  final DateTime date;
  final List<Invoice> invoices;

  DayExpense({
    required this.date,
    required this.invoices,
  });

  // Sum of this day's invoices, computed on the fly.
  double get dayTotal =>
      invoices.fold(0.0, (sum, invoice) => sum + invoice.amount);
}
