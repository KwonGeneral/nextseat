
// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Log.dart';

class ExceptionWidgetUtils {
  ExceptionWidgetUtils._privateConstructor();

  static final ExceptionWidgetUtils _instance = ExceptionWidgetUtils._privateConstructor();

  factory ExceptionWidgetUtils() {
    return _instance;
  }

  static const ERROR_DIVISION = "ERROR_DIVISION";
  String division = "";
  static Widget ExceptionWidget(Object error, StackTrace stackTrace,
      {required String division}) {
    Log.e(error, stackTrace, tag: division);

    if(_instance.division != ERROR_DIVISION) {
      _instance.division = division;
    }
    Future.delayed(Duration(seconds: 10)).then((value) {
      if(division == _instance.division) {
        Get.forceAppUpdate();
        division = ERROR_DIVISION;
      } else {
        return;
      }
    });
    return Container(
      color: Colors.transparent,
    );
  }
}