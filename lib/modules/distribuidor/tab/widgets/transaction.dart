import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Transaction {
  final int id;
  final String title;
  final double value;
  final String category;
  final IconData iconData;
  final Color color;

  Transaction(this.id, this.title, this.value, this.category, this.iconData,
      this.color);
}

class Transactions with ChangeNotifier {
  List<Transaction> _transaction = [
    Transaction(
      1,
      "Dinner",
      128.2,
      "Meals",
      Icons.fastfood,
      Color(0xffe8505b),
    ),
    Transaction(
      1,
      "Presents",
      128.2,
      "Gifts",
      Icons.fastfood,
      Color(0xFF723035),
    ),
  ];

  List<Transaction> get transactions {
    return _transaction;
  }
}
