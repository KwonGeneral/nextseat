
import 'package:nextseat/domain/model/UserModel.dart';

// MARK: - 서버 브로드캐스트 모델
class ServerBroadcastModel {
  String id;  // 서버 고유 아이디
  String address;  // 서버 주소
  String name;  // 서버 이름
  List<UserModel> joinUserList;  // 서버에 참여중인 유저
  bool isJoinAble;  // 서버 참여 가능 여부
  DateTime timestamp;  // 서버 생성 시간

  ServerBroadcastModel({
    required this.id,
    required this.address,
    required this.name,
    required this.joinUserList,
    required this.isJoinAble,
    required this.timestamp,
  });

  // Empty
  factory ServerBroadcastModel.empty({
    String? address,
    String? name,
    List<UserModel>? joinUserList,
    bool? isJoinAble,
    DateTime? timestamp,
  }) {
    return ServerBroadcastModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      address: address ?? '',
      name: name ?? '',
      joinUserList: joinUserList ?? [],
      isJoinAble: isJoinAble ?? false,
      timestamp: timestamp ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> tJoinUserList = [];
    for (UserModel user in joinUserList) {
      tJoinUserList.add(user.toJson());
    }

    return {
      'id': id,
      'address': address,
      'name': name,
      'joinUserList': tJoinUserList,
      'isJoinAble': isJoinAble,
      'timestamp': timestamp.millisecondsSinceEpoch.toString(),
    };
  }

  factory ServerBroadcastModel.fromJson(Map<String, dynamic> json) {
    List<UserModel> tJoinUserList = [];
    for (Map<String, dynamic> user in json['joinUserList']) {
      tJoinUserList.add(UserModel.fromJson(user));
    }

    return ServerBroadcastModel(
      id: json['id'] ?? '',
      address: json['address'] ?? '',
      name: json['name'] ?? '',
      joinUserList: tJoinUserList,
      isJoinAble: json['isJoinAble'] ?? false,
      timestamp: DateTime.fromMillisecondsSinceEpoch(int.tryParse(json['timestamp'] ?? '0') ?? 0),
    );
  }

  @override
  String toString() {
    return toJson().toString();
  }
}