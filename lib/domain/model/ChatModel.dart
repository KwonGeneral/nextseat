
// MARK: - 채팅 모델
class ChatModel {
  String id;  // 채팅 고유 아이디
  String userId;  // 채팅을 보낸 유저 아이디
  String userName;  // 채팅을 보낸 유저 이름
  String message;  // 채팅 메시지
  bool isSendSuccess = false;  // 채팅 전송 성공 여부
  bool isMyChat = false;  // 내 채팅 여부
  DateTime createdAt;  // 채팅 생성 시간

  ChatModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.message,
    required this.createdAt,
    required this.isSendSuccess,
    required this.isMyChat,
  });

  // Empty
  factory ChatModel.empty({
    String? userId,
    String? userName,
    String? message,
    bool? isMyChat,
    DateTime? createdAt,
  }) {
    return ChatModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId ?? '',
      userName: userName ?? '',
      message: message ?? '',
      isSendSuccess: false,
      isMyChat: isMyChat ?? false,
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'message': message,
      'isSendSuccess': isSendSuccess,
      'isMyChat': isMyChat,
      'createdAt': createdAt.millisecondsSinceEpoch.toString(),
    };
  }

  ChatModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['userId'],
        userName = json['userName'],
        message = json['message'],
        isSendSuccess = json['isSendSuccess'] ?? false,
        isMyChat = json['isMyChat'] ?? false,
        createdAt = DateTime.fromMillisecondsSinceEpoch(int.tryParse(json['createdAt'] ?? '0') ?? 0);

  // MARK: - List<ChatModel> Copy
  static List<ChatModel> copyList(List<ChatModel> list) {
    return list.map((e) => ChatModel(
      id: e.id,
      userId: e.userId,
      userName: e.userName,
      message: e.message,
      createdAt: e.createdAt,
      isSendSuccess: e.isSendSuccess,
      isMyChat: e.isMyChat,
    )).toList();
  }

  // MARK: - List<ChatModel>를 Json으로 변환
  static List<Map<String, dynamic>> toJsonList(List<ChatModel> list) {
    return list.map((e) => e.toJson()).toList();
  }

  // MARK: - Json을 List<ChatModel>로 변환
  static List<ChatModel> fromJsonList(List<dynamic> json) {
    return json.map((e) => ChatModel.fromJson(e)).toList();
  }

  @override
  String toString() {
    return toJson().toString();
  }
}