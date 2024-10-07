

import 'package:injectable/injectable.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/domain/model/RoomModel.dart';
import 'package:nextseat/domain/repository/ChatRepositoryImpl.dart';

// MARK: - 채팅방 입장 UseCase
@singleton
class JoinChatRoomUseCase {
  final ChatRepositoryImpl chatRepository;

  JoinChatRoomUseCase(this.chatRepository);

  Future<bool> call({required String roomId}) async {
    try {
      return await chatRepository.joinChatRoom(roomId: roomId);
    } catch(e, s) {
      Log.e(e, s);
      return false;
    }
  }
}