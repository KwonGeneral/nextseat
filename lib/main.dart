import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:nextseat/SeatRoutePage.dart';
import 'package:nextseat/common/Scheme.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/common/utils/Utils.dart';
import 'package:nextseat/data/db/SharedDb.dart';
import 'package:nextseat/data/service/UdpService.dart';
import 'package:nextseat/injection/injection.dart';
import 'package:nextseat/presenter/lang/LangKeys.dart';
import 'package:nextseat/presenter/lang/Messages.dart';
import 'package:nextseat/presenter/theme/Themes.dart';
import 'package:nextseat/presenter/widgets/SeatBottomNavigationBar.dart';

Future<void> main() async {
  // MARK: - 플러터 엔진 상호작용 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // MARK: - 의존성 역전 셋팅
  await getItSetup();

  await SharedDb().clear();
  Log.d("초기화!!!!!!!!!");

  // MARK: - 프리로드
  await SharedDb().preloading();

  // MARK: - Udp 서비스 시작
  await UdpService().start();

  runApp(const SeatApp());
}

class SeatApp extends StatefulWidget {
  const SeatApp({super.key});

  @override
  State<SeatApp> createState() => _SeatAppState();
}

class _SeatAppState extends State<SeatApp> with WidgetsBindingObserver {
  // MARK: - 초기 설정
  @override
  void initState() {
    super.initState();

    Get.put(GlobalBottomMenuBarViewModel());

    WidgetsBinding.instance.addObserver(this);
  }

  // MARK: - 앱 라이프사이클
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // 앱이 포그라운드로 전환될 때 호출
      Log.d('didChangeAppLifecycleState: resumed');
    } else if (state == AppLifecycleState.paused) {
      // 앱이 백그라운드로 전환될 때 호출
      Log.d('didChangeAppLifecycleState: paused');
    } else if (state == AppLifecycleState.inactive) {
      // 앱이 중지될 때 호출
      Log.d('didChangeAppLifecycleState: inactive');
    } else if (state == AppLifecycleState.detached) {
      // 앱이 종료될 때 호출
      Log.d('didChangeAppLifecycleState: detached');
    }
  }

  // MARK: - 플랫폼 밝기 변경
  @override
  void didChangePlatformBrightness() {
    Log.d('didChangePlatformBrightness: ${Utils.isDarkMode()}');
  }

  // MARK: - 앱 종료
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // MARK: - 앱 초기화
  static TransitionBuilder seatInit({
    TransitionBuilder? builder,
  }) {
    return (BuildContext context, Widget? child) {
      if (builder != null) {
        return builder(context, FlutterEasyLoading(child: child));
      } else {
        return PopScope(
            canPop: true,
            onPopInvokedWithResult: (bool didPop, dynamic result) {
              Log.d('[seatInit] onPopInvokedWithResult: $didPop, $result');
            },
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: FlutterEasyLoading(child: child),
            ));
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: Messages.get(LangKeys.appName),
      translationsKeys: Messages.translations,
      locale: const Locale('ko', 'KR'),
      fallbackLocale: const Locale('ko', 'KR'),
      builder: seatInit(),
      popGesture: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: SeatThemes().primary),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      getPages: appRoutes,
      initialRoute: Scheme.SPLASH.path,
      themeMode: ThemeMode.system,
    );
  }
}

// MARK: - 라우트 관리
final List<GetPage> appRoutes = [
  // MARK: - 미들웨어 페이지
  SeatRoutePage.middlewarePage(),

  // MARK: - 스플래시 페이지
  SeatRoutePage.splashPage(),

  // MARK: - 홈 페이지
  SeatRoutePage.homePage(),
];
