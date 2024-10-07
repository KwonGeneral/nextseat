

import 'dart:io';

import 'package:get/get.dart';
import 'package:nextseat/common/Scheme.dart';
import 'package:nextseat/common/utils/DialogUtils.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/presenter/lang/LangKeys.dart';
import 'package:nextseat/presenter/lang/Messages.dart';
import 'package:nextseat/presenter/widgets/SeatBottomNavigationBar.dart';

// MARK: - 라우터
class SeatRouter {
  //메인에서 Double back  체크용 변수
  static DateTime? currentBackPressTime;

  // MARK: - 캐시 클리어
  static void clearCache(String? nextPath) {}

  // MARK: - 페이지 이동
  static Future<bool> to(
      {required Scheme scheme,
        Map<String, dynamic>? arguments,
        Map<String, String>? parameter,
        bool isForce = false,  // 해당 값을 통해, 스플래시 페이지에서 강제 이동 시킬지 여부를 결정 (true: 강제 이동, false: 강제 이동 X)
      }) async {
    if(Get.isDialogOpen == true && DialogUtils.getDialogTag() == DialogUtils.ERROR) {
      Log.d("[SeatRouter.to] 에러 다이얼로그가 열려있습니다. 이동을 제한합니다.");
      return false;
    }

    // 현재 페이지의 Scheme
    Scheme? currentScheme = RouterUtils.getCurrentScheme();

    Log.d('[SeatRouter.to] scheme=> $scheme\narguments=> $arguments\nparameter=> $parameter\ncurrentScheme=> $currentScheme');

    List<Scheme> passPermissionList = [
      Scheme.SPLASH,
      Scheme.MIDDLEWARE,
      Scheme.INIT_CHECK,
    ];
    
    if(currentScheme != null && passPermissionList.contains(currentScheme)) {
      Log.d("[SeatRouter.to] 스플래시, 미들웨어, 초기 체크 페이지에서는 권한 체크를 패스합니다.");
    }

    if(currentScheme == Scheme.SPLASH && !isForce) {
      Log.d("[SeatRouter.to] 스플래시에서의 이동은 제한합니다.");
      return false;
    }

    if (currentScheme == scheme) {
      // 현재 페이지와 이동하려는 페이지가 같은 경우
      Log.d("[SeatRouter.to] 현재 페이지와 이동하려는 페이지가 같습니다.\ncurrentScheme => $currentScheme\nscheme => $scheme");
      return false;
    }

    // 메인 스키마 목록
    List<Scheme> mainSchemeList = _getMainSchemeList();

    bool isChild = RouterUtils.isChildScheme(scheme);  // scheme이 자식인지 여부

    if (mainSchemeList.contains(scheme) && !isChild) {
      Log.d("[SeatRouter.to] 전체 스택을 제거하고 메인 페이지로 이동합니다.\ncurrentScheme => $currentScheme\nscheme => $scheme");
      _offAllNamed(scheme.path, arguments: arguments, parameter: parameter);
      return true;
    }

    if (currentScheme == Scheme.SPLASH) {
      Log.d("[SeatRouter.to] 스플래시 페이지에서 전체 스택을 제거하고 이동합니다.\ncurrentScheme => $currentScheme\nscheme => $scheme");
      _offAllNamed(scheme.path, arguments: arguments, parameter: parameter);
      return true;
    }

    if (isChild) {
      Log.d("[SeatRouter.to] 자식 페이지로 이동합니다.\ncurrentScheme => $currentScheme\nscheme => $scheme");
      await _toNamed(scheme.path, arguments: arguments, parameter: parameter);
      return true;
    } else {
      Log.d("[SeatRouter.to] 자식 페이지가 아닙니다. 전체 스택을 제거하고 이동합니다.\ncurrentScheme => $currentScheme\nscheme => $scheme");
      _offAllNamed(scheme.path, arguments: arguments, parameter: parameter);
      return true;
    }

    return false;
  }

  // MARK: - 뒤로가기 처리
  static Future<bool> back({bool isAllClear = false}) async {
    //현재 라우트가 마지막인지 체크
    Log.d('[SeatRouter.back] DeepLink back\ncurrent=> ${Get.currentRoute}\nprevious=> ${Get.previousRoute}');
    if(isAllClear) {
      RouterUtils.dialogClose();
      RouterUtils.bottomSheetClose();
    } else {
      if(RouterUtils.dialogClose()) {
        Log.d("[SeatRouter.back] 다이얼로그를 닫습니다.");
        return false;
      }

      if(RouterUtils.bottomSheetClose()) {
        Log.d("[SeatRouter.back] 바텀시트를 닫습니다.");
        return false;
      }
    }

    Scheme? currentScheme = RouterUtils.getCurrentScheme();

    if (currentScheme == Scheme.HOME) {
      Log.d("[SeatRouter.back] 홈 페이지에서 뒤로가기를 눌렀습니다.");
      // 현재 페이지가 홈 또는 로그인 경우
      if (currentBackPressTime == null ||
          currentBackPressTime!.difference(DateTime.now()).inSeconds.abs() >
              1) {
        currentBackPressTime = DateTime.now();
        Get.snackbar(Messages.get(LangKeys.app_exit), Messages.get(LangKeys.app_exit_content));
        return false;
      }
      // 앱 종료
      exit(0);
      return true;
    }

    if(RouterUtils.snackbarClose()) {
      Log.d("[SeatRouter.back] 스낵바를 닫습니다.");
      // return false;
    }

    List<Scheme> bottomSchemeList = RouterUtils.getBottomSchemeList();
    Scheme? previousScheme = RouterUtils.getPreviousScheme();
    if (previousScheme == null) {
      Log.d("[SeatRouter.back] 뒤로 이동할 페이지가 없습니다. 로그인 여부를 조회합니다.\ncurrentScheme => $currentScheme\npreviousScheme => $previousScheme");

      return false;
    }

    else if (bottomSchemeList.contains(currentScheme) &&
        currentScheme != Scheme.HOME) {
      Log.d("[SeatRouter.back] 바텀 네비게이션 페이지에서 뒤로 이동합니다. => 홈으로 이동\ncurrentScheme => $currentScheme\npreviousScheme => $previousScheme");

      _offAllNamed(Scheme.HOME.path);
      return false;
    }

    clearCache(null);
    Get.back();

    Log.d("[SeatRouter.back] 이전 페이지로 이동합니다. => moveScheme: ${RouterUtils.getCurrentScheme()}");
    return false;
  }

  static Future _toNamed(String path,
      {Map<String, dynamic>? arguments, Map<String, String>? parameter}) async {
    clearCache(path);
    await Get.toNamed(path, arguments: arguments, parameters: parameter);
  }

  static Future _offNamed(String path,
      {Map<String, dynamic>? arguments, Map<String, String>? parameter}) async {
    clearCache(path);
    Get.offNamed(path, arguments: arguments, parameters: parameter);
  }

  static Future _offAllNamed(String path,
      {Map<String, dynamic>? arguments, Map<String, String>? parameter}) async {
    clearCache(path);
    Get.offAllNamed(path, arguments: arguments, parameters: parameter);
  }

  // MARK: - 메인 Scheme 조회
  static List<Scheme> _getMainSchemeList() {
    return [
      Scheme.HOME, // 홈
      Scheme.SPLASH, // 스플래시
      Scheme.MIDDLEWARE,  // 미들웨어
    ];
  }
}

// MARK: - 라우터 유틸
class RouterUtils {
  // MARK: - 특정 path의 Scheme 조회
  static Scheme? getScheme(String path) {
    Uri getUri = Uri.parse(path);
    String uriPath = getUri.path;
    List<Scheme> allSchemeList = Scheme.values;

    for (Scheme scheme in allSchemeList) {
      if (uriPath == scheme.path) {
        return scheme;
      }
    }

    return null;
  }
  
  // MARK: - 현재 내 라우트의 Scheme 조회
  static Scheme? getCurrentScheme() {
    return getScheme(Get.currentRoute);
  }

  // MARK: - 이전 페이지의 Scheme 조회
  static Scheme? getPreviousScheme() {
    return getScheme(Get.previousRoute);
  }
  
  // MARK: - 해당 scheme이 자식 scheme인지 확인
  static bool isChildScheme(Scheme scheme) {
    List<Scheme> childSchemeList = getChildSchemeList();
    for (Scheme childScheme in childSchemeList) {
      if (childScheme == scheme) {
        return true;
      }
    }
    return false;
  }

  // MARK: - 현재 내 페이지에서 이동 가능한 자식 Scheme 목록 조회
  static List<Scheme> getChildSchemeList() {
    Scheme? getCurrentSheme = getCurrentScheme();
    if (getCurrentSheme == null) {
      return [];
    }

    List<Scheme> allSchemeList = Scheme.values;
    List<Scheme> childRouteList = [];

    for (GetPage page in Get.routeTree.routes) {
      if (page.name.contains(getCurrentSheme.path)) {
        for (Scheme scheme in allSchemeList) {
          if (page.name.contains(scheme.path) && scheme != getCurrentSheme) {
            childRouteList.add(scheme);
          }
        }
      }
    }

    return childRouteList;
  }

  // MARK: - 바텀 네비게이션 Scheme 조회
  static List<Scheme> getBottomSchemeList() {
    List<BottomMenuType> allBottomMenuType = BottomMenuType.values;
    List<Scheme> result = [];

    for(BottomMenuType bottomMenuType in allBottomMenuType) {
      result.add(BottomMenuType.getScheme(bottomMenuType));
    }

    return result;
  }

  // MARK: - 바텀 스킴의 자식 Scheme 목록 조회
  // key: 바텀 스킴, value: 자식 스킴
  static Map<Scheme, List<Scheme>> getBottomSchemeChildList() {
    List<Scheme> bottomSchemeList = getBottomSchemeList();

    List<Scheme> allSchemeList = Scheme.values;
    Map<Scheme, List<Scheme>> result = {};

    for(Scheme bottomScheme in bottomSchemeList) {
      for (GetPage page in Get.routeTree.routes) {
        if (page.name.contains(bottomScheme.path)) {
          for (Scheme scheme in allSchemeList) {
            if (page.name.contains(scheme.path) && scheme != bottomScheme) {
              if(result[bottomScheme] == null) {
                result[bottomScheme] = [];
              }
              result[bottomScheme]!.add(scheme);
            }
          }
        }
      }
    }

    return result;
  }

  // MARK: - 해당 scheme이 바텀의 자식 scheme인지 확인하고 자식 scheme의 path를 반환
  static String? getBottomSchemeChild(Scheme scheme) {
    List<Scheme> bottomSchemeList = getBottomSchemeList();
    for (Scheme bottomScheme in bottomSchemeList) {
      if (bottomScheme == scheme) {
        return null;
      }
    }

    Map<Scheme, List<Scheme>> bottomSchemeChildList = getBottomSchemeChildList();
    for (Scheme bottomScheme in bottomSchemeChildList.keys) {
      for (Scheme childScheme in bottomSchemeChildList[bottomScheme]!) {
        if (childScheme == scheme) {
          return bottomScheme.path + scheme.path;
        }
      }
    }

    return null;
  }

  // MARK: - 다이얼로그 닫기
  static bool dialogClose() {
    if (Get.isDialogOpen == true) {
      Get.back();
      return true;
    }
    return false;
  }

  // MARK: - 바텀시트 닫기
  static bool bottomSheetClose() {
    snackbarClose();
    if (Get.isBottomSheetOpen == true) {
      Get.back();
      return true;
    }
    return false;
  }

  // MARK: - 스낵바 닫기
  static bool snackbarClose() {
    if (Get.isSnackbarOpen == true) {
      Get.back();
      return true;
    }
    return false;
  }
}