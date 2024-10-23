// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'dart:async';

import 'package:get/get.dart';
import 'package:nextseat/common/types/ChatTypes.dart';
import 'package:nextseat/common/utils/DateTimeUtils.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/domain/model/ChatModel.dart';
import 'package:nextseat/domain/model/UserModel.dart';
import 'package:nextseat/domain/usecase/user/GetMyInfoUseCase.dart';
import 'package:nextseat/injection/injection.dart';
import 'package:nextseat/presenter/lang/LangKeys.dart';
import 'package:nextseat/presenter/lang/Messages.dart';

// MARK: - 채팅 DB (휘발성)
class ChatDb {
  static final ChatDb _instance = ChatDb._internal();

  factory ChatDb() => _instance;
  ChatDb._internal();

  // 읽지않은 메세지 여부 스트림
  final StreamController<bool> unreadMessageStreamController = StreamController<bool>.broadcast();

  // 현재까지 채팅 메세지
  List<ChatModel> chatList = [];

  // 전송 대기중인 채팅 메세지
  List<ChatModel> get pendingChatList => chatList.where((element) {
    return element.isSendSuccess == false;
  }).toList();

  // 채팅 유저 목록
  List<UserModel> chatUserList = [];

  // MARK: - 전체 초기화
  Future<void> clear() async {
    clearChat();
  }

  // MARK: - 채팅 초기화
  Future<void> clearChat() async {
    chatList.clear();
    unreadMessageStreamController.add(false);

    await checkNextDate();
  }

  // MARK: - chatList에서 날짜 체크 후, 다음 날짜가 없는 경우 추가
  Future<void> checkNextDate() async {
    DateTime now = DateTime.now();
    String todayMessage = DateTimeUtils.chatSystemDate(now);
    if (!chatList.any((element) => element.type == ChatTypes.DATE && element.message == todayMessage)) {
      chatList.add(
        ChatModel.empty(
          type: ChatTypes.DATE,
          message: todayMessage,
          isSendSuccess: true,
        ),
      );

      Log.d("날짜 메세지 추가: ${DateTimeUtils.chatSystemDate(now)}");
    }
  }

  // MARK: - 신규 유저 입장
  Future<void> receiveUser({required String userId}) async {
    // userId가 empty인 경우 제외
    if (userId.isEmpty) {
      return;
    }

    // 내 정보인 경우 제외
    UserModel myInfo = await getIt<GetMyInfoUseCase>()();
    if (myInfo.id == userId) {
      return;
    }

    // 채팅 유저 목록에 해당 유저 Id가 없는 경우 추가
    if (!chatUserList.any((element) => element.id == userId)) {
      String userName = "${chatUserList.length.toString()}${Messages.get(LangKeys.nameAnonymous)}";

      chatUserList.add(
        UserModel.empty(
          id: userId,
          name: userName,
          createdAt: DateTime.fromMillisecondsSinceEpoch(int.tryParse(userId) ?? DateTime.now().millisecondsSinceEpoch),
          updatedAt: DateTime.now(),
          number: chatUserList.length.toString(),
        ),
      );

      chatList.add(
        ChatModel.empty(
          type: ChatTypes.SYSTEM,
          message: "$userName${Messages.get(LangKeys.newUserEnter)}",
          userId: userId,
          userName: userName,
          isSendSuccess: true,
        ),
      );

      unreadMessageStreamController.add(true);

      Log.d("신규 유저 입장: id: $userId / name: $userName");
    } else {
      // 채팅 유저 목록에 해당 유저 Id가 있는 경우, updatedAt 갱신
      UserModel user = chatUserList.firstWhere((element) => element.id == userId);
      user.updatedAt = DateTime.now();
    }

    // chatUserList에서 현재 시간과 updateAt이 5분 이상 차이나는 유저는 제거
    // 그리고, chatList에 퇴장 메세지 추가
    chatUserList.removeWhere((chat) {
      if (DateTime.now().difference(chat.updatedAt).inMinutes > 5) {
        chatList.add(
          ChatModel.empty(
            type: ChatTypes.SYSTEM,
            message: "${chat.name}${Messages.get(LangKeys.userExit)}",
            userId: chat.id,
            userName: chat.name,
            isSendSuccess: true,
          ),
        );
        unreadMessageStreamController.add(true);

        Log.d("유저 퇴장: id: ${chat.id} / name: ${chat.name}");
        return true;
      }
      return false;
    });
  }

  // MARK: - 전송 완료 처리
  Future<void> completeSend(List<String> ids) async {
    for (var element in chatList) {
      if (ids.contains(element.id)) {
        element.isSendSuccess = true;
      }
    }
  }

  // MARK: - 채팅 전송
  Future<bool> sendChat(ChatModel chat) async {
    try {
      // 날짜 메세지 체크 후 추가
      await checkNextDate();

      // 채팅 목록에 해당 chat Id가 없는 경우 추가
      if (!chatList.any((element) => element.id == chat.id)) {
        chatList.add(chat);
        unreadMessageStreamController.add(false);
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  // MARK: - 채팅 수신
  Future<bool> receiveChat(ChatModel chat) async {
    try {
      if(chat.type != ChatTypes.NORMAL) {
        return false;
      }

      // 날짜 메세지 체크 후 추가
      await checkNextDate();

      // 채팅 목록에 해당 chat Id가 없는 경우 추가
      if (!chatList.any((element) => element.id == chat.id)) {
        await receiveUser(userId: chat.userId);

        // chat의 userName을 chatUserList의 userName으로 변경
        // 단, chat의 userName이 empty인 경우에만 실행
        if (chat.userName.isEmpty) {
          chat.userName = chatUserList.firstWhereOrNull((element) => element.id == chat.userId)?.name ?? "";
        }

        chatList.add(chat);
        unreadMessageStreamController.add(true);

        Log.d("채팅 수신: id: ${chat.id} / userId: ${chat.userId} / userName: ${chat.userName} / message: ${chat.message}");
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
