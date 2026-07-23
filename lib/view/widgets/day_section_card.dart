import 'package:flutter/material.dart';
import 'package:wall_et/controller/home_controller.dart';
import '../../model/day_expense.dart';

// Renders one day: a header (date + day total) and a card of its invoices.
// Takes a single DayExpense instead of loose Maps.
class DaySectionCard extends StatelessWidget {
  final DayExpense day;

  const DaySectionCard({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(HomeController.formatDay(day.date)),
            Text("- ${day.dayTotal.toInt()}"),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: day.invoices.map((invoice) {
              return ListTile(
                leading: Icon(
                  // Rebuild the IconData/Color from the stored codes.
                  IconData(invoice.iconCode, fontFamily: 'MaterialIcons'),
                  color: Color(invoice.colorValue),
                ),
                title: Text(invoice.title),
                trailing: Text(
                  "- ${invoice.amount.toInt()}",
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
