
// MARK: - 유저 모델
class UserModel {
  String id;  // 유저 고유 아이디
  String name;  // 유저 이름
  String number;  // 유저 번호
  DateTime createdAt;  // 유저 생성 시간
  DateTime updatedAt;  // 유저 업데이트 시간

  UserModel({
    required this.id,
    required this.name,
    required this.number,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        number = json['number'],
        createdAt = DateTime.parse(json['createdAt']),
        updatedAt = DateTime.parse(json['updatedAt']);

  @override
  String toString() {
    return toJson().toString();
  }
}