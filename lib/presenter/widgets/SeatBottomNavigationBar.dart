

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nextseat/common/Scheme.dart';
import 'package:nextseat/presenter/lang/LangKeys.dart';
import 'package:nextseat/presenter/lang/Messages.dart';

// MARK: - 바텀 네비게이션 타입
enum BottomMenuType {
  HOME(
    value: 0,
  );

  final int value;

  const BottomMenuType({required this.value,});

  static String getTitle(BottomMenuType type) {
    switch(type) {
      case HOME:
        return Messages.get(LangKeys.bottom_nav_home);
    }
  }

  static IconData getIcon(BottomMenuType type) {
    switch(type) {
      case HOME:
        return Icons.home;
    }
  }

  static Scheme getScheme(BottomMenuType type) {
    switch(type) {
      case HOME:
        return Scheme.HOME;
    }
  }
}

// MARK: - 바텀 네비게이션 아이템
class SeatBottomMenuItem {
  final Key? key;
  final IconData icon;
  final String title;

  SeatBottomMenuItem(
      {this.key,
        required this.icon,
        required this.title,
      });
}

// MARK: - 바텀 네비게이션 뷰모델
class GlobalBottomMenuBarViewModel extends GetxController {
  bool _isShow = true;
  bool get isShow => _isShow;
  BottomMenuType _currentPage = BottomMenuType.HOME;
  String _currentRoute = '';
  int get currentPageIndex => _currentPage.value;

  // MARK: - 현재 바텀 네비 스키마 가져오기
  Scheme getCurrentScheme() {
    return BottomMenuType.getScheme(_currentPage);
  }

  // MARK: - 바텀 네비게이션 Show, Hide 설정 (외부 허용)
  void setIsShow(bool isShowValue) {
    _isShow = isShowValue;
    update();
  }

  // MARK: - 라우트 변경 (외부 허용)
  void changeRoute({required String? route}) {
    if(route != null) {
      BottomMenuType? getBottomMenuType = _getBottomMenuTypeFromRoute(route: route);

      if(getBottomMenuType != null) {
        _currentRoute = route;

        if(_currentPage != getBottomMenuType) {
          _currentPage = getBottomMenuType;
        }
        update();
      }
    }
  }

  // MARK: - 라우트로부터 바텀 메뉴 타입 가져오기
  BottomMenuType? _getBottomMenuTypeFromRoute({required String route}) {
    for(BottomMenuType type in BottomMenuType.values) {
      if(route.contains(BottomMenuType.getScheme(type).path)) {
        return type;
      }
    }

    return null;
  }

  // MARK: - 바텀 메뉴 아이템 리스트 생성
  List<SeatBottomMenuItem> _getBottomItems() {
    List<SeatBottomMenuItem> list = [];
    for (int i = 0; i < BottomMenuType.values.length; i++) {
      list.add(_getItem(BottomMenuType.values.elementAt(i)));
    }
    return list;
  }

  // MARK: - 바텀 메뉴 아이템 생성
  SeatBottomMenuItem _getItem(BottomMenuType bottomMenuType) {
    return SeatBottomMenuItem(
      icon: BottomMenuType.getIcon(bottomMenuType),
      title: BottomMenuType.getTitle(bottomMenuType),
    );
  }

  // MARK: - 사용자의 인터렉션으로 페이지 이동
  Future<void> _onTapBottomSelect({required int index}) async {
    BottomMenuType? nextBottomMenuType;
    for(BottomMenuType type in BottomMenuType.values) {
      if (type.value == index) {
        nextBottomMenuType = type;
        break;
      }
    }

    if(nextBottomMenuType != null && nextBottomMenuType != _currentPage) {
      _currentPage = nextBottomMenuType;
      _currentRoute = BottomMenuType.getScheme(nextBottomMenuType).path;
      Get.offAllNamed(_currentRoute);
    }
  }
}