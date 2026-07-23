import 'package:flutter/material.dart';

class Invoice {
  final String title;
  final double amount;
  final DateTime date;
  final int iconCode;
  final int colorValue;

  Invoice({
    required this.title,
    required this.amount,
    required this.date,
    required this.iconCode,
    required this.colorValue,
  });


  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      title: json["title"],
      amount: (json["amount"] as num).toDouble(),
      date: DateTime.parse(json["date"]),
      iconCode: json["iconCode"],
      colorValue: json["colorValue"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "amount": amount,
      "date": date.toIso8601String(),
      "iconCode": iconCode,
      "colorValue": colorValue,
    };
  }

  @override
  String toString() {
    return 'Invoice{title: $title, amount: $amount, date: $date, iconCode: $iconCode, colorValue: $colorValue}';
  }
}


