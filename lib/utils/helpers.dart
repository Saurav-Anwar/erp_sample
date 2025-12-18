import 'package:erp_sample/models/timeline.dart';

import '../models/project.dart';

double projectBudgetUtilization(Project project) {
  return project.budget.spent / project.budget.total;
}

double milestonesProgress(Timeline timeline) {
  return timeline.milestones.where((milestone) => milestone.status == "Completed").length / timeline.milestones.length;
}