import 'dart:async';
import 'dart:convert';
import 'package:erp_sample/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/company.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../models/payment.dart';

class AppDataProvider extends ChangeNotifier {
  Company? _company;
  User? _user;
  bool _isLoading = false;
  String? _error;

  Company get company => _company!;
  User get user => _user!;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool get hasData => _company != null;

  // loading data

  Future<void> loadData() async {
    if (_company != null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final jsonString =
      await rootBundle.loadString('assets/data.json');
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

      _company = Company.fromJson(jsonMap['company']);
      await loadUser();
      _error = null;
    } catch (e) {
      _error = 'Failed to load data';
      debugPrint("$_error: ${e.toString()}");
    } finally {
      await Future.delayed(const Duration(milliseconds: 500));
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUser() async {
    try {
      _user = User.fromJson({
        'employeeId': '001',
        'name': 'Saurav Anwar',
        'designation': 'Manager',
        'email': 'syedsauravanwar@gmail.com',
        'phone': '+8801988099673',
      });
    } catch (e) {
      debugPrint("loadUser error: ${e.toString()}");
    }
  }

  // dashboard

  int get totalProjects => company.projects.length;

  int get totalTasks =>
      company.projects.fold(0, (sum, p) => sum + p.tasks.length);

  double get totalBudget =>
      company.projects.fold(0, (sum, p) => sum + p.budget.total);

  double get totalSpent =>
      company.projects.fold(0, (sum, p) => sum + p.budget.spent);

  double get totalBudgetUtilization =>
      totalBudget == 0 ? 0 : totalSpent / totalBudget;

  int get pendingApprovals =>
      company.projects
          .expand((p) => p.payments)
          .where((p) => p.approvalFlow.status != 'Approved')
          .length;

  // project list

  List<Project> get projects => company.projects;

  // task and team

  List<Task> get allTasks =>
      company.projects.expand((p) => p.tasks).toList();

  List<Task> get completedTasks =>
      allTasks.where((t) => t.progress == 100).toList();

  List<Task> get inProgressTasks =>
      allTasks.where((t) => t.progress < 100).toList();

  // payments and approvals

  List<Payment> get allPayments =>
      company.projects.expand((p) => p.payments).toList();

  List<Payment> get approvedPayments =>
      allPayments
          .where((p) => p.approvalFlow.status == 'Approved')
          .toList();

  List<Payment> get pendingPayments =>
      allPayments
          .where((p) => p.approvalFlow.status != 'Approved')
          .toList();
}
