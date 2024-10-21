
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/common/utils/Utils.dart';
import 'package:nextseat/data/db/MemorialDb.dart';
import 'package:nextseat/domain/model/ServerBroadcastModel.dart';
import 'package:nextseat/domain/usecase/user/GetMyInfoUseCase.dart';
import 'package:nextseat/injection/injection.dart';
import 'package:udp/udp.dart';

// MARK: - Udp Service
class UdpService {
  static final UdpService _instance = UdpService._internal();

  factory UdpService() => _instance;
  UdpService._internal() {
    Log.d('[ UdpService ] created');
  }

  // UDP 서버 포트 (0 고정)
  static const int SENDER_PORT = 0;

  // UDP 클라이언트 포트
  static int RECEIVER_PORT = 11174;

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
      _senderUdp = await UDP.bind(Endpoint.any(port: const Port(SENDER_PORT))).timeout(const Duration(seconds: 10));
      _receiverUdp = await UDP.bind(Endpoint.any(port: Port(RECEIVER_PORT))).timeout(const Duration(seconds: 10));
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
        String data = utf8.decode(datagram.data);

        try {
          final ServerBroadcastModel broadcastModel = ServerBroadcastModel.fromJson(json.decode(data));
          String? myIp = await Utils.getIPAddress();
          if(broadcastModel.address == myIp && myIp != null) {
            return;
          }

          Log.d("[ UdpService: _receiveBroadcast ] * 브로드 캐스트 수신"
          "\n내 아이피: $myIp"
              "\n${broadcastModel.toJson()}");
        } catch(e, s) {
          Log.e(e, s);
        }
      }
    });
  }

  // MARK: - 브로드 캐스트 전송
  Future<void> _sendBroadcast() async {
    String? getIp = await Utils.getIPAddress();
    ServerBroadcastModel broadcastModel = ServerBroadcastModel.empty(
      address: getIp,
      isJoinAble: true,
      joinUserList: [
        await getIt<GetMyInfoUseCase>()(),
      ],
      name: 'NextSeat_$getIp',
      timestamp: DateTime.now(),
    );

    final data = utf8.encode(json.encode(broadcastModel.toJson()));
    _senderUdp?.send(data, Endpoint.broadcast(port: Port(RECEIVER_PORT)));
  }
}