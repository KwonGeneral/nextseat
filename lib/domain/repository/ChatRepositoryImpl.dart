


import 'package:nextseat/domain/model/ChatModel.dart';

// MARK: - 채팅 Impl
abstract class ChatRepositoryImpl {
  // MARK: - 채팅 목록 조회
  List<ChatModel> getChatMessageList();

  // MARK: - 채팅 전송
  Future<bool> sendChatMessage({required String message});
}