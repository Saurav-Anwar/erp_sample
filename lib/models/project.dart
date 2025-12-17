import 'budget.dart';
import 'payment.dart';
import 'risk.dart';
import 'task.dart';
import 'team.dart';
import 'timeline.dart';
import 'manager.dart';

class Project {
  final String projectId;
  final String name;
  final String status;
  final Timeline timeline;
  final Manager manager;
  final List<Team> teams;
  final Budget budget;
  final List<Task> tasks;
  final List<Payment> payments;
  final List<Risk> risks;

  Project({
    required this.projectId,
    required this.name,
    required this.status,
    required this.timeline,
    required this.manager,
    required this.teams,
    required this.budget,
    required this.tasks,
    required this.payments,
    required this.risks
  });

  factory Project.fromJson(Map<String, dynamic> data) {
    return Project(
      projectId: data['projectId'],
      name: data['name'],
      status: data['status'],
      timeline: Timeline.fromJson(data['timeline']),
      manager: Manager.fromJson(data['manager']),
      teams: (data['teams'] as List).map((e) => Team.fromJson(e)).toList(),
      budget: Budget.fromJson(data['budget']),
      tasks: (data['tasks'] as List).map((e) => Task.fromJson(e)).toList(),
      payments: (data['payments'] as List).map((e) => Payment.fromJson(e)).toList(),
      risks: (data['risks'] as List).map((e) => Risk.fromJson(e)).toList(),
    );
  }
}
