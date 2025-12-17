import 'package:flutter/foundation.dart';

class Budget {
  final double total;
  final double spent;
  final List<BudgetCategory> categories;

  Budget({
    required this.total,
    required this.spent,
    required this.categories,
  });

  factory Budget.fromJson(Map<String, dynamic> data) {
    return Budget(
      total: data['total'],
      spent: data['spent'],
      categories: (data['categories'] as List)
          .map((e) => BudgetCategory.fromJson(e))
          .toList(),
    );
  }
}

class BudgetCategory {
  final String name;
  final double allocated;
  final double spent;
  List<BudgetCategory> subCategories = [];

  BudgetCategory({
    required this.name,
    required this.allocated,
    required this.spent,
    required this.subCategories,
  });

  factory BudgetCategory.fromJson(Map<String, dynamic> data) {
    return BudgetCategory(
      name: data['name'],
      allocated: data['allocated'],
      spent: data['spent'],
      subCategories: data['subCategories'] == null ? [] :
          (data['subCategories'] as List)
          .map((e) => BudgetCategory.fromJson(e))
          .toList(),
    );
  }
}