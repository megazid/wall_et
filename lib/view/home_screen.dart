import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double parseAmount(String amountStr) {
      String clean = amountStr.replaceAll('-', '').replaceAll(',', '').trim();
      return double.tryParse(clean) ?? 0.0;
    }
    // 1. Data Structure: List of Days -> List of Invoices
    final List<Map<String, dynamic>> daysData = [
      {
        "date": "18 JUL",
        "invoices": [
          {
            "title": "Rent",
            "icon": Icons.home,
            "color": Colors.black,
            "amount": "- 65"
          },
          {
            "title": "Rent",
            "icon": Icons.home,
            "color": Colors.blue,
            "amount": "- 65"
          },
          {
            "title": "TT",
            "icon": Icons.food_bank,
            "color": Colors.green,
            "amount": "- 65"
          },
          {
            "title": "S",
            "icon": Icons.bed,
            "color": Colors.blueAccent,
            "amount": "- 65"
          },
          {
            "title": "D",
            "icon": Icons.woman,
            "color": Colors.red,
            "amount": "- 65"
          },
        ]
      },
      {
        "date": "17 JUL",
        "invoices": [
          {
            "title": "Rent",
            "icon": Icons.home,
            "color": Colors.blue,
            "amount": "- 65"
          },
        ]
      },
      {
        "date": "16 JUL",
        "invoices": [
          {
            "title": "Education",
            "icon": Icons.school,
            "color": Colors.indigo,
            "amount": "- 95"
          },
          {
            "title": "Utilities",
            "icon": Icons.bolt,
            "color": Colors.orange,
            "amount": "- 49"
          },
          {
            "title": "Rent",
            "icon": Icons.home,
            "color": Colors.blue,
            "amount": "- 1,000"
          },
        ]
      }
    ];
    double grandTotal = daysData.fold(0.0, (grandSum, day) {
      double daySum = (day["invoices"] as List<Map<String, dynamic>>)
          .fold(0.0, (sum, item) => sum + parseAmount(item["amount"]));
      return grandSum + daySum;
    });
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("wall_et", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Title
            Center(
              child: Text(
                "${grandTotal.toInt()}",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // 2. Outer Loop: Loop over Days
            ...daysData.map((day) {
              double dayTotal = (day["invoices"] as List<Map<String, dynamic>>)
                  .fold(0.0, (sum, item) => sum + parseAmount(item["amount"]));
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Day Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(day["date"]),
                      Text("- ${dayTotal.toInt()}"),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Card containing the list of invoices for this day
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      // 3. Inner Loop: Loop over Invoices inside the day
                      children: (day["invoices"] as List<Map<String, dynamic>>).map((invoice) {
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
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[700],
        onPressed: () => print("yes"),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}