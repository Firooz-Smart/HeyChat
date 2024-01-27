class Message {
  const Message(
      {required this.id,
      required this.content,
      required this.profileId,
      required this.createdAt,
      required this.isMe});

  final String id;
  final String content;
  final String profileId;
  final DateTime createdAt;
  final bool isMe;

  Message.fromMap({required Map<String, dynamic> map, required String myUserId})
      : id = map['id'],
        content = map['content'],
        profileId = map['profile_id'],
        createdAt = map['created_at'],
        isMe = map['profile_id'] == myUserId;
}
