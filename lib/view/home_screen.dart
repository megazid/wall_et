import 'package:flutter/material.dart';
import 'package:wall_et/controller/home_controller.dart';
import '../model/invoice.dart';
import 'widgets/day_section_card.dart';
import 'widgets/add_expense_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Invoice> _invoices = [];

  Future<void> _openAddSheet() async {
    final invoice = await showModalBottomSheet<Invoice>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const AddExpenseSheet(),
    );

    if (invoice != null) {
      setState(() => _invoices.add(invoice));
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = HomeController.groupByDay(_invoices);
    final grandTotal = HomeController.grandTotal(_invoices);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("wall_et",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "- ${grandTotal.toInt()}",
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            if (days.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 80),
                child: Center(
                  child: Text(
                    "No expenses yet.\nTap + to add your first one.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              )
            else
              ...days.map((day) => DaySectionCard(day: day)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[700],
        onPressed: _openAddSheet,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
