
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:nextseat/common/contains/PortContains.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/data/db/ChatDb.dart';
import 'package:nextseat/domain/model/ChatModel.dart';
import 'package:nextseat/domain/model/UserModel.dart';
import 'package:nextseat/domain/usecase/user/GetMyInfoUseCase.dart';
import 'package:nextseat/domain/usecase/user/UpdateMyInfoUseCase.dart';
import 'package:nextseat/injection/injection.dart';
import 'package:udp/udp.dart';

// MARK: - Udp Service
class UdpService {
  static final UdpService _instance = UdpService._internal();

  factory UdpService() => _instance;
  UdpService._internal() {
    Log.d('[ UdpService ] created');
  }

  // 채팅 송신 UDP
  UDP? _senderChatUdp;

  // 채팅 수신 UDP
  UDP? _receiverChatUdp;

  // 유저 송신 UDP
  UDP? _senderUserUdp;

  // 유저 수신 UDP
  UDP? _receiverUserUdp;

  // 메인 Job
  Timer? _mainJob;

  // 채팅 전송 Job
  Timer? _sendChatJob;

  // 유저 전송 Job
  Timer? _sendUserJob;

  // MARK: - Udp Service 시작
  Future<void> start() async {
    Log.d("[ UdpService: start ] Udp Service 시작");

    // Nsd 서비스 시작
    await _startNsdService();
  }

  // MARK: - Udp Service 종료
  Future<void> stop() async {
    Log.d("[ UdpService: stop ] Udp Service 종료");

    // Job 종료
    _mainJob?.cancel();
    _sendChatJob?.cancel();
    _sendUserJob?.cancel();

    // Udp 서버 종료
    _senderChatUdp?.close();
    _receiverChatUdp?.close();
    _senderUserUdp?.close();
    _receiverUserUdp?.close();
  }

  // MARK: - Nsd 서비스 시작
  Future<void> _startNsdService() async {
    Log.d("[ UdpService: _startNsdService ] Nsd 서비스 시작");

    // Udp 서버 시작
    try {
      // 채팅 UDP
      _senderChatUdp = await UDP.bind(Endpoint.any(port: const Port(PortContains.UDP_SENDER_PORT))).timeout(const Duration(seconds: 10));
      _receiverChatUdp = await UDP.bind(Endpoint.any(port: const Port(PortContains.UDP_CHAT_RECEIVER_PORT))).timeout(const Duration(seconds: 10));

      // 유저 UDP
      _senderUserUdp = await UDP.bind(Endpoint.any(port: const Port(PortContains.UDP_SENDER_PORT))).timeout(const Duration(seconds: 10));
      _receiverUserUdp = await UDP.bind(Endpoint.any(port: const Port(PortContains.UDP_CHAT_USER_RECEIVER_PORT))).timeout(const Duration(seconds: 10));
    } catch(e, s) {
      Log.e(e, s);
    }

    // 채팅 전송 Job 시작
    _sendChatJob = Timer.periodic(const Duration(seconds: 1), (_) async {
      // 브로드 캐스트 전송
      await _sendBroadcastChat();
    });

    // 유저 전송 Job 시작
    _sendUserJob = Timer.periodic(const Duration(seconds: 1), (_) async {
      // 브로드 캐스트 전송
      await _sendBroadcastUser();
    });

    // 채팅 브로드 캐스트 수신
    _receiverChatUdp?.asStream().listen((Datagram? datagram) async {
      if(datagram != null) {
        await receiveChat(datagram);
      }
    });

    // 유저 브로드 캐스트 수신
    _receiverUserUdp?.asStream().listen((Datagram? datagram) async {
      if(datagram != null) {
        await receiveUser(datagram);
      }
    });
  }

  // MARK: - 채팅 브로드 캐스트 전송
  Future<void> _sendBroadcastChat() async {
    await _sendPendingChatList();
  }

  // MARK: - 유저 브로드 캐스트 전송
  Future<void> _sendBroadcastUser() async {
    await _sendMyInfo();
  }

  // MARK: - 유저 정보 전송
  Future<bool> _sendMyInfo() async {
    UserModel myInfo = await getIt<GetMyInfoUseCase>()();

    myInfo.updatedAt = DateTime.now();

    // 유저 정보 수정
    await getIt<UpdateMyInfoUseCase>()(
      myInfo: myInfo,
    );

    final data = utf8.encode(json.encode(myInfo.toJson()));
    int? result = await _senderUserUdp?.send(data, Endpoint.broadcast(port: const Port(PortContains.UDP_CHAT_USER_RECEIVER_PORT)));

    if(result == -1 || result == null) {
      Log.d("[ UdpService: _sendMyInfo ] 브로드 캐스트 [ 내 정보 ] 전송 실패");
      return false;
    } else {
      return true;
    }
  }

  // MARK: - 채팅 전송
  Future<bool> _sendPendingChatList() async {
    // 채팅이 없으면 전송하지 않음
    if(ChatDb().pendingChatList.isEmpty) {
      return false;
    }

    List<ChatModel> copyPendingChatList = ChatModel.copyList(ChatDb().pendingChatList);

    final data = utf8.encode(json.encode(ChatModel.toJsonList(copyPendingChatList)));
    int? result = await _senderChatUdp?.send(data, Endpoint.broadcast(port: const Port(PortContains.UDP_CHAT_RECEIVER_PORT)));

    if(result == -1 || result == null) {
      Log.d("[ UdpService: _sendBroadcast ] 브로드 캐스트 [ 채팅 ] 전송 실패");
      return false;
    } else {
      ChatDb().completeSend(copyPendingChatList.map((e) => e.id).toList());
      return true;
    }
  }

  // MARK: - 채팅 브로드 캐스트 수신
  Future<void> receiveChat(Datagram? datagram) async {
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
  }

  // MARK: - 유저 브로드 캐스트 수신
  Future<void> receiveUser(Datagram? datagram) async {
    if(datagram != null) {
      try {
        final data = utf8.decode(datagram.data);
        final Map<String, dynamic> jsonMap = json.decode(data);

        UserModel user = UserModel.fromJson(jsonMap);

        await ChatDb().receiveUser(userId: user.id);
      } catch(e, s) {
        Log.e(e, s);
      }
    }
  }
}