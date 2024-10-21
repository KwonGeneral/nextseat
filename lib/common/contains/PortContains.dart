
import 'dart:math';

class PortContains {
  // UDP 서버 포트
  static const int UDP_SENDER_PORT = 0;

  // UDP 클라이언트 포트
  static const int UDP_RECEIVER_PORT = 11174;

  // WebSocket 포트 (11000 ~ 12000 랜덤)
  static int WEBSOCKET_PROT = Random().nextInt(1000) + 11000;
}