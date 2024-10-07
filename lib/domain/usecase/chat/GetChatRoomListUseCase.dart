

import 'package:injectable/injectable.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/domain/model/RoomModel.dart';
import 'package:nextseat/domain/repository/ChatRepositoryImpl.dart';

// MARK: - 채팅방 목록 조회 UseCase
@singleton
class GetChatRoomListUseCase {
  final ChatRepositoryImpl chatRepository;

  GetChatRoomListUseCase(this.chatRepository);

  Future<List<RoomModel>> call() async {
    try {
      return await chatRepository.getChatRoomList();
    } catch(e, s) {
      Log.e(e, s);
      return [];
    }
  }
}