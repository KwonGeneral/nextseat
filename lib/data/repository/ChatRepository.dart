

import 'package:injectable/injectable.dart';
import 'package:nextseat/common/contains/Env.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/data/db/ChatDb.dart';
import 'package:nextseat/data/repository/UserRepository.dart';
import 'package:nextseat/domain/model/ChatModel.dart';
import 'package:nextseat/domain/model/UserModel.dart';
import 'package:nextseat/domain/repository/ChatRepositoryImpl.dart';

// MARK: - 채팅 Repository
@Singleton(as: ChatRepositoryImpl, env: [Env.DEV, Env.DEPLOY])
class ChatRepository implements ChatRepositoryImpl {
  // MARK: - 채팅 목록 조회
  @override
  List<ChatModel> getChatMessageList() {
    try {
      List<ChatModel> tChatList = [];

      // Id 중복 제거
      for (ChatModel chat in ChatDb().chatList) {
        if (tChatList.any((element) => element.id == chat.id)) {
          continue;
        }

        tChatList.add(chat);
      }

      ChatDb().chatList = tChatList;
      return tChatList;
    } catch (e, s) {
      Log.e(e, s);
      rethrow;
    }
  }

  // MARK: - 채팅 전송
  @override
  Future<bool> sendChatMessage({required String message}) async {
    try {
      UserModel myInfo = await UserRepository().getMyInfo();

      ChatDb().sendChat(ChatModel.empty(
        userId: myInfo.id,
        userName: myInfo.name,
        isMyChat: true,
        message: message,
        createdAt: DateTime.now(),
      ));

      return true;
    } catch (e, s) {
      Log.e(e, s);
      rethrow;
    }
  }
}