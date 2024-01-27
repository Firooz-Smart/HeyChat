class Profile {
  const Profile(
      {required this.id, required this.username, required this.createdAt});
  final String id;
  final String username;
  final DateTime createdAt;

  Profile.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        createdAt = DateTime.parse(json['created_at']);
}
