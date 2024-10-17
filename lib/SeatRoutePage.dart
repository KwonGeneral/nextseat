

import 'package:get/get.dart';
import 'package:nextseat/SeatMiddleware.dart';
import 'package:nextseat/common/Scheme.dart';
import 'package:nextseat/presenter/pages/HomePage.dart';
import 'package:nextseat/presenter/pages/MiddlewarePage.dart';
import 'package:nextseat/presenter/pages/SplashPage.dart';

// MARK: - 라우트 페이지 정의
class SeatRoutePage {
  static const Transition transition = Transition.noTransition;
  static const Duration transitionDuration = Duration(milliseconds: 0);

  // MARK: - 미들웨어 페이지
  static GetPage middlewarePage() {
    return GetPage(
      name: Scheme.MIDDLEWARE.path,
      page: () => MiddlewarePage(
        route: Get.parameters['route'],
      ),
      transition: transition,
      transitionDuration: transitionDuration,
      middlewares: [
        // 초기 체크 미들웨어
        SeatMiddleware.initialCheckMiddleware(),
      ],
    );
  }

  // MARK: - 스플래시 페이지
  static GetPage splashPage() {
    return GetPage(
      name: Scheme.SPLASH.path,
      page: () => SplashPage(),
      transition: transition,
      transitionDuration: transitionDuration,
      fullscreenDialog: true,
      middlewares: [
        // 초기 체크 미들웨어
        SeatMiddleware.initialCheckMiddleware(),

        // 권한 체크 미들웨어
        SeatMiddleware.permissionCheckMiddleware(),
      ],
    );
  }

  // MARK: - 홈 페이지
  static GetPage homePage() {
    return GetPage(
      name: Scheme.HOME.path,
      page: () => HomePage(),
      // 중복 페이지 방지
      preventDuplicates: true,
      // 페이지 상태 유지
      maintainState: true,
      transition: transition,
      transitionDuration: transitionDuration,
      children: [],
      middlewares: [
        // 초기 체크 미들웨어
        SeatMiddleware.initialCheckMiddleware(),

        // 바텀 네비게이션 미들웨어
        SeatMiddleware.bottomNavigationMiddleware(),

        // 딥 링크 미들웨어
        SeatMiddleware.deepLinkMiddleware(),

        // 와이파이 체크 미들웨어
        SeatMiddleware.wifiCheckMiddleware(),
      ],
    );
  }
}