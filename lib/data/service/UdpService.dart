
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:nextseat/common/contains/PortContains.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/data/db/ChatDb.dart';
import 'package:nextseat/domain/model/ChatModel.dart';
import 'package:udp/udp.dart';

// MARK: - Udp Service
class UdpService {
  static final UdpService _instance = UdpService._internal();

  factory UdpService() => _instance;
  UdpService._internal() {
    Log.d('[ UdpService ] created');
  }

  // 보내는 UDP
  UDP? _senderUdp;

  // 받는 UDP
  UDP? _receiverUdp;

  // 메인 Job
  Timer? _mainJob;

  // Send Job
  Timer? _sendJob;

  // MARK: - Udp Service 시작
  Future<void> start() async {
    Log.d("[ UdpService: start ] Udp Service 시작");

    // 메인 Job 시작
    await _startMainJob();

    // Nsd 서비스 시작
    await _startNsdService();
  }

  // MARK: - Udp Service 종료
  Future<void> stop() async {
    Log.d("[ UdpService: stop ] Udp Service 종료");

    // 메인 Job 종료
    _mainJob?.cancel();

    // Send Job 종료
    _sendJob?.cancel();

    // Udp 서버 종료
    _senderUdp?.close();
    _receiverUdp?.close();
  }

  // MARK: - 메인 Job 시작
  Future<void> _startMainJob() async {
    _mainJob ??= Timer.periodic(const Duration(seconds: 30), (_) {
      Log.d("[ UdpService: _startMainJob ] MainJob 서비스 시작");
    });
  }

  // MARK: - Nsd 서비스 시작
  Future<void> _startNsdService() async {
    Log.d("[ UdpService: _startNsdService ] Nsd 서비스 시작");

    // Udp 서버 시작
    try {
      _senderUdp = await UDP.bind(Endpoint.any(port: const Port(PortContains.UDP_SENDER_PORT))).timeout(const Duration(seconds: 10));
      _receiverUdp = await UDP.bind(Endpoint.any(port: const Port(PortContains.UDP_RECEIVER_PORT))).timeout(const Duration(seconds: 10));
    } catch(e, s) {
      Log.e(e, s);
    }

    Log.d("[ UdpService: _startNsdService ] _senderUdp: $_senderUdp");
    Log.d("[ UdpService: _startNsdService ] _receiverUdp: $_receiverUdp");

    // Send Job 시작
    _sendJob = Timer.periodic(const Duration(seconds: 5), (_) async {
      // 브로드 캐스트 전송
      await _sendBroadcast();
    });

    // 브로드 캐스트 수신
    _receiverUdp?.asStream().listen((Datagram? datagram) async {
      if(datagram != null) {
        try {
          final data = utf8.decode(datagram.data);
          final List<dynamic> jsonList = json.decode(data);

          List<ChatModel> chatList = ChatModel.fromJsonList(jsonList);

          for (var chat in chatList) {
            await ChatDb().receiveChat(chat);
          }
        } catch(e, s) {
          Log.e(e, s);
        }
      }
    });
  }

  // MARK: - 브로드 캐스트 전송
  Future<void> _sendBroadcast() async {
    // 채팅이 없으면 전송하지 않음
    if(ChatDb().pendingChatList.isEmpty) {
      return;
    }

    List<ChatModel> copyPendingChatList = ChatModel.copyList(ChatDb().pendingChatList);

    final data = utf8.encode(json.encode(ChatModel.toJsonList(copyPendingChatList)));
    int? result = await _senderUdp?.send(data, Endpoint.broadcast(port: const Port(PortContains.UDP_RECEIVER_PORT)));

    if(result == -1 || result == null) {
      Log.d("[ UdpService: _sendBroadcast ] 브로드 캐스트 전송 실패");
    } else {
      Log.d("[ UdpService: _sendBroadcast ] 브로드 캐스트 전송 성공");
      ChatDb().completeSend(copyPendingChatList.map((e) => e.id).toList());
    }
  }
}