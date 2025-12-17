class Manager {
  final String employeeId;
  final String name;
  final String designation;
  final String email;

  Manager({
    required this.employeeId,
    required this.name,
    required this.designation,
    required this.email,
  });

  factory Manager.fromJson(Map<String, dynamic> data) {
    return Manager(
      employeeId: data['employeeId'],
      name: data['name'],
      designation: data['designation'],
      email: data['email'],
    );
  }
}
