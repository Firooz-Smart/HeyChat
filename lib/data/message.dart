class Message {
  const Message(
      {required this.id,
      required this.content,
      required this.profileId,
      required this.createdAt,
      required this.isMine});

  final String id;
  final String content;
  final String profileId;
  final DateTime createdAt;
  final bool isMine;

  Message.fromMap({required Map<String, dynamic> map, required String myUserId})
      : id = map['id'],
        content = map['content'],
        profileId = map['profile_id'],
        createdAt = DateTime.parse(map['created_at']),
        isMine = map['profile_id'] == myUserId;
}
