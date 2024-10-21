

import 'package:injectable/injectable.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/domain/model/RoomModel.dart';
import 'package:nextseat/domain/repository/ChatRepositoryImpl.dart';

// MARK: - 채팅방 퇴장 UseCase
@singleton
class LeaveChatRoomUseCase {
  final ChatRepositoryImpl chatRepository;

  LeaveChatRoomUseCase(this.chatRepository);

  Future<bool> call() async {
    try {
      return await chatRepository.leaveChatRoom();
    } catch(e, s) {
      Log.e(e, s);
      return false;
    }
  }
}