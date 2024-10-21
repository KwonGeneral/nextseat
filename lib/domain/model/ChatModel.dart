
// MARK: - 채팅 모델
class ChatModel {
  String id;  // 채팅 고유 아이디
  String roomId;  // 채팅이 속한 채팅방 아이디
  String userId;  // 채팅을 보낸 유저 아이디
  String message;  // 채팅 메시지
  bool isSendSuccess = false;  // 채팅 전송 성공 여부
  DateTime createdAt;  // 채팅 생성 시간

  ChatModel({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.message,
    required this.createdAt,
    required this.isSendSuccess,
  });

  // Empty
  factory ChatModel.empty({
    String? roomId,
    String? userId,
    String? message,
    DateTime? createdAt,
  }) {
    return ChatModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      roomId: roomId ?? '',
      userId: userId ?? '',
      message: message ?? '',
      isSendSuccess: false,
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'userId': userId,
      'message': message,
      'isSendSuccess': isSendSuccess,
      'createdAt': createdAt.millisecondsSinceEpoch.toString(),
    };
  }

  ChatModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        roomId = json['roomId'],
        userId = json['userId'],
        message = json['message'],
        isSendSuccess = json['isSendSuccess'] ?? false,
        createdAt = DateTime.fromMillisecondsSinceEpoch(int.tryParse(json['createdAt'] ?? '0') ?? 0);

  @override
  String toString() {
    return toJson().toString();
  }
}