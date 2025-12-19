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

String initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) {
    final s = parts.first;
    return (s.length >= 2 ? s.substring(0, 2) : s.substring(0, 1)).toUpperCase();
  }
  final a = parts.first;
  final b = parts[1];
  final ai = a.isNotEmpty ? a.substring(0, 1) : '?';
  final bi = b.isNotEmpty ? b.substring(0, 1) : '?';
  return '$ai$bi'.toUpperCase();
}