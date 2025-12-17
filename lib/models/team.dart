class Team {
  final String teamId;
  final String name;
  final List<Member> members;

  Team({
    required this.teamId,
    required this.name,
    required this.members,
  });

  factory Team.fromJson(Map<String, dynamic> data) {
    return Team(
      teamId: data['teamId'],
      name: data['name'],
      members: (data['members'] as List)
          .map((e) => Member.fromJson(e))
          .toList(),
    );
  }
}

class Member {
  final String name;
  final String role;

  Member({
    required this.name,
    required this.role,
  });

  factory Member.fromJson(Map<String, dynamic> data) {
    return Member(
      name: data['name'],
      role: data['role'],
    );
  }
}
