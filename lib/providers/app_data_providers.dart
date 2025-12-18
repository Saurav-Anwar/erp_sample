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
  int get activeProjects => company.projects.where((project) => project.status != 'Completed').length;
  int get completedProjects => company.projects.where((project) => project.status == 'Completed').length;
  List<Project> get recentProjects {
    final sortedProjects = [...company.projects];

    sortedProjects.sort(
          (a, b) => DateTime.parse(b.timeline.startDate)
          .compareTo(DateTime.parse(a.timeline.startDate)),
    );

    return sortedProjects.take(2).toList();
  }

  int get totalTasks =>
      company.projects.fold(0, (sum, project) => sum + project.tasks.length);

  double get totalBudget =>
      company.projects.fold(0, (sum, project) => sum + project.budget.total);

  double get totalSpent =>
      company.projects.fold(0, (sum, project) => sum + project.budget.spent);

  double get totalBudgetUtilization =>
      totalBudget == 0 ? 0 : totalSpent / totalBudget;

  // project list

  List<Project> get projects => company.projects;

  // task and team

  List<Task> get allTasks =>
      company.projects.expand((project) => project.tasks).toList();

  List<Task> get completedTasks =>
      allTasks.where((task) => task.progress == 100).toList();

  List<Task> get inProgressTasks =>
      allTasks.where((task) => task.progress < 100).toList();

  // payments and approvals

  List<Payment> get allPayments =>
      company.projects.expand((project) => project.payments).toList();

  List<Payment> get approvedPayments =>
      allPayments
          .where((project) => project.approvalFlow.status == 'Approved')
          .toList();

  int get totalApprovals => approvedPayments.length;

  List<Payment> get pendingPayments =>
      allPayments
          .where((project) => project.approvalFlow.status != 'Approved')
          .toList();

  int get pendingApprovals =>
      company.projects
          .expand((project) => project.payments)
          .where((project) => project.approvalFlow.status != 'Approved')
          .length;
}
