import 'package:erp_sample/models/timeline.dart';
import 'package:intl/intl.dart';

import '../models/project.dart';

double projectBudgetUtilization(Project project) {
  return project.budget.spent / project.budget.total;
}

double milestonesProgress(Timeline timeline) {
  return timeline.milestones.where((milestone) => milestone.status == "Completed").length / timeline.milestones.length;
}

String formatMoneyShorthand(String currency, double amount) {
  final symbol = currency == 'BDT' ? '৳ ' : '$currency ';
  return NumberFormat.compactCurrency(symbol: symbol, decimalDigits: 2).format(amount);
}