
// MARK: - 서버 브로드캐스트 모델
class ServerBroadcastModel {
  String id;  // 서버 고유 아이디
  String address;  // 서버 주소
  String name;  // 서버 이름
  int memberCount;  // 서버 인원
  bool isJoinable;  // 서버 참여 가능 여부
  DateTime timestamp;  // 서버 생성 시간

  ServerBroadcastModel({
    required this.id,
    required this.address,
    required this.name,
    required this.memberCount,
    required this.isJoinable,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'name': name,
      'memberCount': memberCount,
      'isJoinable': isJoinable,
      'timestamp': timestamp,
    };
  }

  ServerBroadcastModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        address = json['address'],
        name = json['name'],
        memberCount = json['memberCount'],
        isJoinable = json['isJoinable'],
        timestamp = DateTime.parse(json['timestamp']);

  @override
  String toString() {
    return toJson().toString();
  }
}