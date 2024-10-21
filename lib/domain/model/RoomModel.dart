
import 'package:nextseat/domain/model/UserModel.dart';

// MARK: - 채팅방 모델
class RoomModel {
  String id;  // 채팅방 고유 아이디
  String name;  // 채팅방 이름
  String number;  // 채팅방 번호
  String ownerId;  // 채팅방 소유자 아이디
  String? hostAddress;  // 채팅방 호스트 주소
  List<UserModel> joinUserList;  // 채팅방 참여중인 유저
  bool isJoinAble;  // 채팅방 참여 가능 여부
  DateTime createdAt;  // 채팅방 생성 시간
  DateTime updatedAt;  // 채팅방 업데이트 시간
  DateTime findAt;  // 채팅방 검색 시간

  RoomModel({
    required this.id,
    required this.name,
    required this.number,
    required this.ownerId,
    required this.hostAddress,
    required this.joinUserList,
    required this.isJoinAble,
    required this.createdAt,
    required this.updatedAt,
    required this.findAt,
  });

  // Empty
  factory RoomModel.empty({
    String? name,
    String? number,
    String? ownerId,
    String? hostAddress,
    List<UserModel>? joinUserList,
    bool? isJoinAble,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? findAt,
  }) {
    return RoomModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name ?? '',
      number: number ?? '',
      ownerId: ownerId ?? '',
      hostAddress: hostAddress ?? '',
      joinUserList: joinUserList ?? [],
      isJoinAble: isJoinAble ?? false,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
      findAt: findAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'ownerId': ownerId,
      'hostAddress': hostAddress,
      'joinUserList': joinUserList,
      'isJoinAble': isJoinAble,
      'createdAt': createdAt.millisecondsSinceEpoch.toString(),
      'updatedAt': updatedAt.millisecondsSinceEpoch.toString(),
      'findAt': findAt.millisecondsSinceEpoch.toString(),
    };
  }

  RoomModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        number = json['number'],
        ownerId = json['ownerId'],
        hostAddress = json['hostAddress'],
        joinUserList = json['joinUserList'],
        isJoinAble = json['isJoinAble'],
        createdAt = DateTime.fromMillisecondsSinceEpoch(int.tryParse(json['createdAt'] ?? '0') ?? 0),
        updatedAt = DateTime.fromMillisecondsSinceEpoch(int.tryParse(json['updatedAt'] ?? '0') ?? 0),
        findAt = DateTime.fromMillisecondsSinceEpoch(int.tryParse(json['findAt'] ?? '0') ?? 0);

  @override
  String toString() {
    return toJson().toString();
  }
}