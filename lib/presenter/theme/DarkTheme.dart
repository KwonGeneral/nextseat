
import 'package:flutter/material.dart';
import 'package:nextseat/presenter/colors/Colors.dart';
import 'Themes.dart';

class DarkTheme implements AppThemes {
  @override
  Color get background => DarkColors.background;

  @override
  Color get backgroundSub => DarkColors.backgroundSub;

  @override
  Color get primary => DarkColors.primary;

  @override
  Color get surface01 => DarkColors.surface01;

  @override
  Color get black60 => DarkColors.black60;

  @override
  Color get black => DarkColors.black;

  @override
  Color get white => DarkColors.white;
}