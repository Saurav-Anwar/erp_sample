import 'package:flutter/cupertino.dart';

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
      teams: (data['teams'] as List).map((e) {
        try {
          return Team.fromJson(e);
        } catch (e) {
          debugPrint("error parsing teams");
          return Team(teamId: '', name: '', members: []);
        }
      }).toList(),
      budget: Budget.fromJson(data['budget']),
      tasks: (data['tasks'] as List).map((e) {
        try {
          return Task.fromJson(e);
        } catch (e) {
          debugPrint("error parsing tasks");
          return Task(taskId: '', title: '', assignedTeam: '', priority: '', progress: 0, subTasks: [], activityLogs: []);
        }
      }).toList(),
      payments: (data['payments'] as List).map((e) {
        try {
          return Payment.fromJson(e);
        } catch (e) {
          debugPrint("error parsing payments");
          return Payment(paymentId: '', amount: 0, requestedBy: '', requestDate: '', invoices: [], approvalFlow: ApprovalFlow(approvedBy: '', approvedDate: '', status: ''));
        }
      }).toList(),
      risks: (data['risks'] as List).map((e) {
        try {
          return Risk.fromJson(e);
        } catch (e) {
          debugPrint("error parsing risks");
          return Risk(riskId: '', description: '', severity: '', mitigation: '');
        }
      }).toList(),
    );
  }
}
