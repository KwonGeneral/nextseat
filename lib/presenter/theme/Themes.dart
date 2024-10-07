import 'package:flutter/material.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/presenter/theme/LightTheme.dart';

class SeatThemes implements AppThemes {
  AppThemes _currentTheme = LightTheme();

  AppThemes getCurrentTheme() {
    return _currentTheme;
  }

  void setTheme(AppThemes theme) {
    _currentTheme = theme;
  }

  @override
  Color get background => _currentTheme.background;

  @override
  Color get backgroundSub => _currentTheme.backgroundSub;

  @override
  Color get black60 => _currentTheme.black60;

  @override
  Color get primary => _currentTheme.primary;

  @override
  Color get surface01 => _currentTheme.surface01;

  @override
  Color get black => _currentTheme.black;

  @override
  Color get white => _currentTheme.white;
}

abstract class AppThemes {
  final Color background;
  final Color backgroundSub;
  final Color primary;
  final Color surface01;
  final Color black60;
  final Color white;
  final Color black;

  AppThemes(
    this.background,
    this.backgroundSub,
    this.primary,
    this.surface01,
    this.black60,
    this.white,
    this.black,
  );
}
