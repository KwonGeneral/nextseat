
import 'dart:math';

class PortContains {
  // UDP 서버 포트
  static const int UDP_SENDER_PORT = 0;

  // UDP 채팅 수신 포트
  static const int UDP_CHAT_RECEIVER_PORT = 11174;

  // UDP 채팅 유저 수신 포트
  static const int UDP_CHAT_USER_RECEIVER_PORT = 11175;

  // WebSocket 포트 (11000 ~ 12000 랜덤)
  static int WEBSOCKET_PROT = Random().nextInt(1000) + 11000;
}