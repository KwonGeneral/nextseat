

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

  // 내 HttpServer
  HttpServer? _mySocketServer;

  // 내 WebSocket
  WebSocket? _myWebSocket;

  // 내 포트
  int myWebSocketPort = PortContains.WEBSOCKET_PROT;

  // 타겟 WebSocket
  WebSocket? _targetWebSocket;

  // 타겟 주소
  String? targetWebSocketAddress;

  // 타겟 포트
  int? targetWebSocketPort;

  // MARK: - WebSocket Service 종료
  Future<void> stop() async {
    Log.d("[ WebSocketService: stop ] WebSocket Service 종료");

    if(_mySocketServer != null) {
      await _mySocketServer?.close(force: true);
    }

    if(_myWebSocket != null) {
      await _myWebSocket?.close();
    }

    _mySocketServer = null;
    _myWebSocket = null;
  }

  // MARK: - WebSocket My Service 시작
  Future<void> startMyServer() async {
    try {
      if(_mySocketServer != null && _myWebSocket != null) {
        await stop();
      }

      Log.d('[ WebSocketService: _startWebSocketServer] WebSocket Service 시작');

      _mySocketServer = await HttpServer.bind(InternetAddress.anyIPv4, myWebSocketPort, shared: true);
      Log.d('[ WebSocketService: _startWebSocketServer] WebSocket server started on port $myWebSocketPort');

      if(_mySocketServer != null) {
        _mySocketServer!.listen((HttpRequest request) async {
          if (WebSocketTransformer.isUpgradeRequest(request)) {
            _myWebSocket = await WebSocketTransformer.upgrade(request);
            Log.d("[ WebSocketService: _startWebSocketServer] 클라이언트 접속 : ${request.connectionInfo?.remoteAddress.address}");

            _myWebSocket!.listen((message) {
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
    } catch (e, s) {
      Log.e(e, s);
    }
  }
  
  // MARK: - WebSocket Target Service 시작
  Future<void> startTargetServer({
    required String ip,
    required int port,
  }) async {
    try {
      // 포트가 변경된 경우 서버를 종료하고 다시 시작
      if(port != targetWebSocketPort) {
        await stop();
      }

      // 포트가 같은 경우 무시
      if(port == targetWebSocketPort && ip == targetWebSocketAddress && _targetWebSocket != null) {
        Log.d('[ WebSocketService: start] WebSocket Service 이미 시작된 상태 => 포트: $port / 현재 포트: $targetWebSocketPort / 웹소켓: $_targetWebSocket');
        return;
      }

      if(ip.isEmpty || port == 0) {
        Log.d('[ WebSocketService: _startWebSocketServer] WebSocket Target Service 시작 실패 => ip: $ip / port: $port');
        return;
      }

      Log.d('[ WebSocketService: _startWebSocketServer] WebSocket Target Service 시작');

      targetWebSocketPort = port;
      targetWebSocketAddress = ip;

      _targetWebSocket = await WebSocket.connect('ws://$ip:$port');

      if(_targetWebSocket != null) {
        _targetWebSocket!.listen((message) {
          _handleMessage("clientId", message);
        }, onDone: () {
          Log.d('[ WebSocketService: _startWebSocketServer] 클라이언트 연결 종료');
        }, onError: (error) {
          Log.d('[ WebSocketService: _startWebSocketServer] WebSocket 서버 오류: $error');
        }, cancelOnError: true);
      }
    } catch (e, s) {
      Log.e(e, s);
    }
  }

  // MARK: - 웹소켓에 메세지 전송
  void sendMessage(String message) {
    if(_myWebSocket != null) {
      Log.d("[ WebSocketService: sendMessage] {mySocket} sendMessage: $message");
      _myWebSocket?.add(message);
    }

    if(_targetWebSocket != null) {
      Log.d("[ WebSocketService: sendMessage] {targetSocket} sendMessage: $message");
      _targetWebSocket?.add(message);
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