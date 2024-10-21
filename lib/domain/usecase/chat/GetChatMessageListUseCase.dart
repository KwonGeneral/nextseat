

import 'package:injectable/injectable.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/domain/model/ChatModel.dart';
import 'package:nextseat/domain/model/RoomModel.dart';
import 'package:nextseat/domain/repository/ChatRepositoryImpl.dart';

// MARK: - 채팅 목록 조회 UseCase
@singleton
class GetChatMessageListUseCase {
  final ChatRepositoryImpl chatRepository;

  GetChatMessageListUseCase(this.chatRepository);

  Future<List<ChatModel>> call() async {
    try {
      return await chatRepository.getChatMessageList();
    } catch(e, s) {
      Log.e(e, s);
      return [];
    }
  }
}