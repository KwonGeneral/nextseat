

import 'package:injectable/injectable.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/domain/model/ChatModel.dart';
import 'package:nextseat/domain/repository/ChatRepositoryImpl.dart';

// MARK: - 채팅 목록 조회 UseCase
@singleton
class GetChatMessageListUseCase {
  final ChatRepositoryImpl chatRepository;

  GetChatMessageListUseCase(this.chatRepository);

  List<ChatModel> call() {
    try {
      List<ChatModel> result = chatRepository.getChatMessageList();

      // ID 중복 제거
      List<ChatModel> tChatList = [];
      for (ChatModel chat in result) {
        if (tChatList.any((element) => element.id == chat.id)) {
          continue;
        }

        tChatList.add(chat);
      }

      // 최신순 정렬
      tChatList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return tChatList;
    } catch(e, s) {
      Log.e(e, s);
      return [];
    }
  }
}