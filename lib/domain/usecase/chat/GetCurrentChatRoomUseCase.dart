

import 'package:injectable/injectable.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/domain/model/ChatModel.dart';
import 'package:nextseat/domain/model/RoomModel.dart';
import 'package:nextseat/domain/repository/ChatRepositoryImpl.dart';

// MARK: - 현재 채팅방 조회 UseCase
@singleton
class GetCurrentChatRoomUseCase {
  final ChatRepositoryImpl chatRepository;

  GetCurrentChatRoomUseCase(this.chatRepository);

  Future<RoomModel> call() async {
    try {
      return await chatRepository.getCurrentChatRoom();
    } catch(e, s) {
      Log.e(e, s);
      return RoomModel.empty();
    }
  }
}