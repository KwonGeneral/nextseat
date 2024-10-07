// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/presenter/route/SeatRouter.dart';
import 'package:nextseat/presenter/widgets/SeatBottomNavigationBar.dart';

class SeatMiddleware {
  // MARK: - 바텀 네비게이션 미들웨어
  static BaseMiddleware bottomNavigationMiddleware({bool isShow = true}) {
    return _BottomNavigationMiddleware(isShow: isShow);
  }

  // MARK: - 초기 체크 미들웨어
  static GetMiddleware initialCheckMiddleware() {
    return _InitialCheckMiddleware();
  }

  // MARK: - 권한 체크 미들웨어
  static BaseMiddleware permissionCheckMiddleware() {
    return _PermissionCheckMiddleware();
  }

  // MARK: - 딥 링크 미들웨어
  static BaseMiddleware deepLinkMiddleware() {
    return _DeepLinkMiddleware();
  }
}

// MARK: - 베이스 미들웨어
class BaseMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return null;
  }

  @override
  Future<GetNavConfig?> redirectDelegate(GetNavConfig route) async {}
}

// MARK: - 바텀 네비게이션 미들웨어
class _BottomNavigationMiddleware extends BaseMiddleware {
  _BottomNavigationMiddleware({this.isShow = true});

  bool isShow;

  @override
  RouteSettings? redirect(String? route) {
    Get.put(GlobalBottomMenuBarViewModel()).setIsShow(isShow);
    Get.put(GlobalBottomMenuBarViewModel()).changeRoute(route: route);
    return null;
  }
}

// MARK: - 초기 체크 미들웨어
class _InitialCheckMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return null;
  }
}

// MARK: - 권한 체크 미들웨어
class _PermissionCheckMiddleware extends BaseMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return null;
  }
}

// MARK: - 딥 링크 미들웨어
class _DeepLinkMiddleware extends BaseMiddleware {
  String? pageBuiltRoute;

  @override
  RouteSettings? redirect(String? route) {
    pageBuiltRoute = null;
    Log.d("_DeepLinkMiddleware route: $route");
    if (route != null && route.isNotEmpty) {
      Uri? uri = Uri.tryParse(route);
      if (uri != null) {
        String? deepLink = uri.queryParameters['deepLink'];
        if (deepLink != null && deepLink.isNotEmpty) {
          String nextRoute = deepLink;
          if (uri.queryParameters.isNotEmpty) {
            nextRoute += "?";
            uri.queryParameters.forEach((key, value) {
              nextRoute += "$key=$value&";
            });

            // 마지막 & 제거
            nextRoute = nextRoute.substring(0, nextRoute.length - 1);
          }
          pageBuiltRoute = nextRoute;
          Log.d("pageBuiltRoute: $pageBuiltRoute");
        }
      }
    }
    return null;
  }

  @override
  Widget onPageBuilt(Widget page) {
    if (pageBuiltRoute != null) {
      String tempRoute = pageBuiltRoute ?? "";
      pageBuiltRoute = null;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        SeatRouter.routeTo(route: tempRoute);
      });
    }
    return page;
  }
}