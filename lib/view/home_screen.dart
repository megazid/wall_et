import 'package:flutter/material.dart';
import 'package:wall_et/controller/home_controller.dart';
import '../data/mock_data.dart';
import 'widgets/day_section_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final double grandTotal = HomeController.calculateGrandTotal(mockDaysData);


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


            ...mockDaysData.map((day) {
              final double dayTotal = HomeController.calculateDayTotal(day["invoices"]);

              return DaySectionCard(
                date: day["date"],
                dayTotal: dayTotal,
                invoices: day["invoices"],
              );
            }),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[700],
        onPressed: () => print("LOL"),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}