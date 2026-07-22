import 'package:flutter/material.dart';

class DaySectionCard extends StatelessWidget {
  final String date;
  final double dayTotal;
  final List<dynamic> invoices;

  const DaySectionCard({
    super.key,
    required this.date,
    required this.dayTotal,
    required this.invoices,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(date),
            Text("- ${dayTotal.toInt()}"),
          ],
        ),
        const SizedBox(height: 8),

        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: (invoices as List<Map<String, dynamic>>).map((invoice) {
              return ListTile(
                leading: Icon(invoice["icon"], color: invoice["color"]),
                title: Text(invoice["title"]),
                trailing: Text(
                  invoice["amount"],
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
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
