

import 'package:injectable/injectable.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/domain/repository/ChatRepositoryImpl.dart';

// MARK: - 채팅 전송 UseCase
@singleton
class SendChatMessageUseCase {
  final ChatRepositoryImpl chatRepository;

  SendChatMessageUseCase(this.chatRepository);

  Future<bool> call({required String roomId, required String message}) async {
    try {
      return await chatRepository.sendChatMessage(roomId: roomId, message: message);
    } catch(e, s) {
      Log.e(e, s);
      return false;
    }
  }
}