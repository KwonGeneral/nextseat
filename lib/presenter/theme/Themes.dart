
import 'package:flutter/material.dart';
import 'package:nextseat/presenter/theme/LightTheme.dart';

class SeatThemes {
  AppThemes _currentTheme = LightTheme();

  AppThemes getCurrentTheme() {
    return _currentTheme;
  }

  void setTheme(AppThemes theme) {
    _currentTheme = theme;
  }
}

abstract class AppThemes {
  final Color background;
  final Color backgroundSub;
  final Color primary;
  final Color surface01;

  AppThemes(this.background, this.backgroundSub, this.primary, this.surface01);
}