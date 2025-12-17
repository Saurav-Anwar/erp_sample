class Timeline {
  final String startDate;
  final String endDate;
  final List<Milestone> milestones;

  Timeline({
    required this.startDate,
    required this.endDate,
    required this.milestones,
  });

  factory Timeline.fromJson(Map<String, dynamic> data) {
    return Timeline(
      startDate: data['startDate'],
      endDate: data['endDate'],
      milestones: (data['milestones'] as List)
          .map((e) => Milestone.fromJson(e))
          .toList(),
    );
  }
}

class Milestone {
  final String milestoneId;
  final String title;
  final String status;

  Milestone({
    required this.milestoneId,
    required this.title,
    required this.status,
  });

  factory Milestone.fromJson(Map<String, dynamic> data) {
    return Milestone(
      milestoneId: data['milestoneId'],
      title: data['title'],
      status: data['status'],
    );
  }
}
