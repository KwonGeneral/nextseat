

import 'package:injectable/injectable.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/domain/model/RoomModel.dart';
import 'package:nextseat/domain/repository/ChatRepositoryImpl.dart';

// MARK: - 채팅방 생성 UseCase
@singleton
class CreateChatRoomUseCase {
  final ChatRepositoryImpl chatRepository;

  CreateChatRoomUseCase(this.chatRepository);

  Future<RoomModel?> call({required String name}) async {
    try {
      return await chatRepository.createChatRoom(name: name);
    } catch(e, s) {
      Log.e(e, s);
      return null;
    }
  }
}