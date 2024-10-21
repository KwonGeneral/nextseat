
// MARK: - 유저 모델
class UserModel {
  String id;  // 유저 고유 아이디
  String? name;  // 유저 이름
  String? number;  // 유저 번호
  DateTime createdAt;  // 유저 생성 시간
  DateTime updatedAt;  // 유저 업데이트 시간

  UserModel({
    required this.id,
    required this.name,
    required this.number,
    required this.createdAt,
    required this.updatedAt,
  });

  // Empty
  factory UserModel.empty({
    String? name,
    String? number,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      number: number,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  // Copy
  UserModel copyWith({
    String? id,
    String? name,
    String? number,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      number: number ?? this.number,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'createdAt': createdAt.millisecondsSinceEpoch.toString(),
      'updatedAt': updatedAt.millisecondsSinceEpoch.toString(),
    };
  }

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        number = json['number'],
        createdAt = DateTime.fromMillisecondsSinceEpoch(int.tryParse(json['createdAt'] ?? '0') ?? 0),
        updatedAt = DateTime.fromMillisecondsSinceEpoch(int.tryParse(json['updatedAt'] ?? '0') ?? 0);

  @override
  String toString() {
    return toJson().toString();
  }
}