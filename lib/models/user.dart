class User {
  final String employeeId;
  final String name;
  final String designation;
  final String email;
  final String phone;
  final String? imageUrl;

  User({
    required this.employeeId,
    required this.name,
    required this.designation,
    required this.email,
    required this.phone,
    this.imageUrl
  });

  factory User.fromJson(Map<String, dynamic> data) {
    return User(
      employeeId: data['employeeId'],
      name: data['name'],
      designation: data['designation'],
      email: data['email'],
      phone: data['phone'],
      imageUrl: data['imageUrl'],
    );
  }
}
