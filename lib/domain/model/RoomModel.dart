
import 'package:nextseat/domain/model/UserModel.dart';

// MARK: - 채팅방 모델
class RoomModel {
  String id;  // 채팅방 고유 아이디
  String name;  // 채팅방 이름
  String number;  // 채팅방 번호
  String ownerId;  // 채팅방 소유자 아이디
  String? hostAddress;  // 채팅방 호스트 주소
  List<UserModel> joinUserList;  // 채팅방 참여중인 유저
  bool isJoinable;  // 채팅방 참여 가능 여부
  DateTime createdAt;  // 채팅방 생성 시간
  DateTime updatedAt;  // 채팅방 업데이트 시간
  DateTime findedAt;  // 채팅방 검색 시간

  RoomModel({
    required this.id,
    required this.name,
    required this.number,
    required this.ownerId,
    required this.hostAddress,
    required this.joinUserList,
    required this.isJoinable,
    required this.createdAt,
    required this.updatedAt,
    required this.findedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'ownerId': ownerId,
      'hostAddress': hostAddress,
      'joinUserList': joinUserList,
      'isJoinable': isJoinable,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'findedAt': findedAt,
    };
  }

  RoomModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        number = json['number'],
        ownerId = json['ownerId'],
        hostAddress = json['hostAddress'],
        joinUserList = json['joinUserList'],
        isJoinable = json['isJoinable'],
        createdAt = DateTime.parse(json['createdAt']),
        updatedAt = DateTime.parse(json['updatedAt']),
        findedAt = DateTime.parse(json['findedAt']);

  @override
  String toString() {
    return toJson().toString();
  }
}