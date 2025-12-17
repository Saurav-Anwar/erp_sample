class Risk {
  final String riskId;
  final String description;
  final String severity;
  final String mitigation;

  Risk({
    required this.riskId,
    required this.description,
    required this.severity,
    required this.mitigation
  });

  factory Risk.fromJson(Map<String, dynamic> data) {
    return Risk(
      riskId: data['riskId'],
      description: data['description'],
      severity: data['severity'],
      mitigation: data['mitigation']
    );
  }
}