

import 'package:nextseat/common/Scheme.dart';

// MARK: - 바텀 네비게이션 아이템
enum BottomMenuType {
  HOME(
    value: 0,
  );

  final int value;

  const BottomMenuType({required this.value,});

  static Scheme getScheme(BottomMenuType type) {
    switch(type) {
      case HOME:
        return Scheme.HOME;
    }
  }
}