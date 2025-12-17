class Task {
  final String taskId;
  final String title;
  final String assignedTeam;
  final String priority;
  final int progress;
  final List<SubTask> subTasks;
  final List<ActivityLog> activityLogs;

  Task({
    required this.taskId,
    required this.title,
    required this.assignedTeam,
    required this.priority,
    required this.progress,
    required this.subTasks,
    required this.activityLogs,
  });

  factory Task.fromJson(Map<String, dynamic> data) {
    return Task(
      taskId: data['taskId'],
      title: data['title'],
      assignedTeam: data['assignedTeam'],
      priority: data['priority'],
      progress: data['progress'],
      subTasks: data['subTasks'] == null ? [] :
          (data['subTasks'] as List)
          .map((e) => SubTask.fromJson(e))
          .toList(),
      activityLogs: data['activityLogs'] == null ? [] :
          (data['activityLogs'] as List)
          .map((e) => ActivityLog.fromJson(e))
          .toList(),
    );
  }
}

class SubTask {
  final String subTaskId;
  final String title;
  final String status;

  SubTask({
    required this.subTaskId,
    required this.title,
    required this.status
  });

  factory SubTask.fromJson(Map<String, dynamic> data) {
    return SubTask(
      subTaskId: data['subTaskId'],
      title: data['title'],
      status: data['status'],
    );
  }
}

class ActivityLog {
  final String date;
  final String updatedBy;
  final String remark;

  ActivityLog({
    required this.date,
    required this.updatedBy,
    required this.remark
  });

  factory ActivityLog.fromJson(Map<String, dynamic> data) {
    return ActivityLog(
      date: data['date'],
      updatedBy: data['updatedBy'],
      remark: data['remark'],
    );
  }
}