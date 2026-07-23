import 'package:flutter/material.dart';
import '../../model/invoice.dart';

// A preset "category" = a label + an icon + a color, bundled together.
// This is a v1 stand-in. In v2 this becomes a real Category model stored in Hive.
// Colors are stored as ints (0xAARRGGBB) so they drop straight into Invoice.colorValue.
final _categories = <({String label, IconData icon, int colorValue})>[
  (label: 'Food', icon: Icons.restaurant, colorValue: 0xFFE53935),
  (label: 'Rent', icon: Icons.home, colorValue: 0xFF1E88E5),
  (label: 'Transport', icon: Icons.directions_bus, colorValue: 0xFF43A047),
  (label: 'Shopping', icon: Icons.shopping_bag, colorValue: 0xFF8E24AA),
  (label: 'Bills', icon: Icons.receipt_long, colorValue: 0xFFFB8C00),
  (label: 'Health', icon: Icons.local_hospital, colorValue: 0xFF00897B),
  (label: 'Fun', icon: Icons.sports_esports, colorValue: 0xFF3949AB),
  (label: 'Other', icon: Icons.category, colorValue: 0xFF757575),
];

class AddExpenseSheet extends StatefulWidget {
  const AddExpenseSheet({super.key});

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  int _selectedCategory = 0;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(), // no logging future expenses
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submit() {
    final amount = double.tryParse(_amountController.text.trim());

    // v1 validation: only the amount is required.
    if (amount == null || amount <= 0) return;

    final category = _categories[_selectedCategory];
    final typed = _titleController.text.trim();

    final invoice = Invoice(
      // If the user didn't type a title, fall back to the category label.
      title: typed.isEmpty ? category.label : typed,
      amount: amount,
      date: _selectedDate,
      iconCode: category.icon.codePoint,
      colorValue: category.colorValue,
    );

    Navigator.of(context).pop(invoice);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "New expense",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: "Title (optional)"),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: "Amount"),
          ),
          const SizedBox(height: 16),

          // ---- Date row ----
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 18),
              const SizedBox(width: 8),
              Text(
                "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                style: const TextStyle(fontSize: 16),
              ),
              const Spacer(),
              TextButton(
                onPressed: _pickDate,
                child: const Text("Change"),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ---- Category picker ----
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Category", style: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: List.generate(_categories.length, (i) {
              final c = _categories[i];
              final selected = i == _selectedCategory;
              final color = Color(c.colorValue);
              return ChoiceChip(
                avatar: Icon(
                  c.icon,
                  size: 18,
                  color: selected ? Colors.white : color,
                ),
                label: Text(c.label),
                selected: selected,
                selectedColor: color,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : null,
                ),
                onSelected: (_) => setState(() => _selectedCategory = i),
              );
            }),
          ),
          const SizedBox(height: 20),

          FilledButton(
            onPressed: _submit,
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
