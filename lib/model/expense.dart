// ignore_for_file: constant_identifier_names

import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum Category {
  FOOD,
  TRAVEL,
  LEISURE,
  WORK,
}

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;
}
