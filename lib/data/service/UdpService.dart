
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/common/utils/Utils.dart';
import 'package:nextseat/data/db/MemorialDb.dart';
import 'package:nextseat/domain/model/ServerBroadcastModel.dart';
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

  // UDP 클라이언트 포트 (11000 ~ 12000 랜덤)
  static int RECEIVER_PORT = Random().nextInt(1000) + 11000;

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

    String? getIp = await Utils.getIPAddress();
    Log.d("[ UdpService: _startNsdService ] getIp: $getIp");

    // 메인 Job 시작
    await _startMainJob();

    // Nsd 서비스 시작
    await _startNsdService(
      broadcastModel: ServerBroadcastModel.empty(
        address: getIp,
        isJoinAble: true,
        joinUserList: [
          MemorialDb().myInfo,
        ],
        name: 'NextSeat_$getIp',
        timestamp: DateTime.now(),
      ),
    );
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
  Future<void> _startNsdService({required ServerBroadcastModel broadcastModel}) async {
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
    _sendJob = Timer.periodic(const Duration(seconds: 1), (_) async {

      // 브로드 캐스트 전송
      await _sendBroadcast(
        broadcastModel: broadcastModel
      );
    });
  }

  // MARK: - 브로드 캐스트 전송
  Future<void> _sendBroadcast({required ServerBroadcastModel broadcastModel}) async {
    final data = utf8.encode(json.encode(broadcastModel.toJson()));
    _senderUdp?.send(data, Endpoint.broadcast(port: Port(RECEIVER_PORT)));
  }
}