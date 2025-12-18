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
      total: (data['total'] as num).toDouble(),
      spent: (data['spent'] as num).toDouble(),
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
  final List<BudgetCategory> subCategories;

  BudgetCategory({
    required this.name,
    required this.allocated,
    required this.spent,
    required this.subCategories,
  });

  factory BudgetCategory.fromJson(Map<String, dynamic> data) {
    return BudgetCategory(
      name: data['name'],
      allocated: (data['allocated'] as num).toDouble(),
      spent: (data['spent'] as num).toDouble(),
      subCategories: data['subCategories'] == null ? [] :
          (data['subCategories'] as List)
          .map((e) => BudgetCategory.fromJson(e))
          .toList(),
    );
  }
}