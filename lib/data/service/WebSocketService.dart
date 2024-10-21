

import 'dart:io';
import 'dart:math';

import 'package:nextseat/common/contains/PortContains.dart';
import 'package:nextseat/common/utils/Log.dart';

// MARK: - WebSocket Service
class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();

  factory WebSocketService() => _instance;
  WebSocketService._internal() {
    Log.d('[ UdpService ] created');
  }

  // HttpServer
  HttpServer? _socketServer;

  // WebSocket
  WebSocket? _webSocket;

  int currentPort = PortContains.WEBSOCKET_PROT;

  // MARK: - WebSocket Service 시작
  Future<void> start({required int port}) async {
    Log.d("[ WebSocketService: start ] WebSocket Service 시작");

    // 웹소켓 시작
    await _startWebSocketServer(
      port: port,
    );
  }

  // MARK: - WebSocket Service 종료
  Future<void> stop() async {
    Log.d("[ WebSocketService: stop ] WebSocket Service 종료");

    if(_socketServer != null) {
      await _socketServer?.close(force: true);
    }

    if(_webSocket != null) {
      await _webSocket?.close();
    }

    _socketServer = null;
    _webSocket = null;
  }

  Future<void> _startWebSocketServer({required int port}) async {
    Log.d('[ WebSocketService: _startWebSocketServer] Starting WebSocket server');
    try {
      // 포트가 변경된 경우 서버를 종료하고 다시 시작
      if(port != currentPort) {
        await stop();
      }

      // 포트가 같은 경우 무시
      if(port == currentPort && _socketServer != null) {
        return;
      }

      _socketServer = await HttpServer.bind(InternetAddress.anyIPv4, port);
      Log.d('[ WebSocketService: _startWebSocketServer] WebSocket server started on port $port');

      if(_socketServer != null) {
        _socketServer!.listen((HttpRequest request) async {
          if (WebSocketTransformer.isUpgradeRequest(request)) {
            _webSocket = await WebSocketTransformer.upgrade(request);
            Log.d("[ WebSocketService: _startWebSocketServer] 클라이언트 접속 : ${request.connectionInfo?.remoteAddress.address}");

            _webSocket!.listen((message) {
              _handleMessage("clientId", message);
            }, onDone: () {
              Log.d('[ WebSocketService: _startWebSocketServer] 클라이언트 연결 종료');
            }, onError: (error) {
              Log.d('[ WebSocketService: _startWebSocketServer] WebSocket 서버 오류: $error');
            }, cancelOnError: true);
          }
        }, onError: (error) {
          Log.d('[ WebSocketService: _startWebSocketServer] 서버 오류: $error');
        },
          onDone: () {
            Log.d('[ WebSocketService: _startWebSocketServer] 서버 종료');
          },
        );
      }

      currentPort = port;
    } catch (e, s) {
      Log.e(e, s);
    }
  }

  // MARK: - 웹소켓에 메세지 전송
  void sendMessage(String message) {
    if(_webSocket != null) {
      Log.d("[ WebSocketService: sendMessage] sendMessage: $message");
      _webSocket?.add(message);
    }
  }

  // MARK: - 메세지 핸들링
  void _handleMessage(String clientId, dynamic message) {
    try {
      Log.d("[ WebSocketService: _handleMessage] 클라이언트 아이디: $clientId, 메세지: $message");
    } catch (e , s) {
      Log.e(e, s);
    }
  }
}