
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nextseat/data/db/MemorialDb.dart';
import 'package:nextseat/presenter/route/SeatRouter.dart';

// MARK: - 다이얼로그 유틸
class DialogUtils {
  DialogUtils._privateConstructor();

  static final DialogUtils _instance = DialogUtils._privateConstructor();

  factory DialogUtils() {
    return _instance;
  }

  StreamController<bool> loadingStream = StreamController<bool>.broadcast();
  bool isLoadingShow = false;

  static String LOADING_DIALOG_TAG = "loading_dialog_tag";

  static String ERROR = "error";

  String dialogTag = "";

  static String getDialogTag() {
    return _instance.dialogTag;
  }

  static void setDialogTag(String tag) {
    _instance.dialogTag = tag;
  }

  static void clearDialogTag() {
    _instance.dialogTag = "";
  }

  static Future<void> showDialog(Widget widget,
      {String tag = "",
        Color? barrierColor,
        bool? barrierDismissible,
        bool isOnlyOneShow = false}) async {
    if (isOnlyOneShow) {
      if (Get.isDialogOpen == true) {
        if (tag == _instance.dialogTag) {
          return;
        } else {
          await SeatRouter.back();
          // return;
        }
      } else {
        clearDialogTag();
      }
    }
    setDialogTag(tag);
    Get.dialog(
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible ?? false,
      widget,
      useSafeArea: true,
      transitionCurve: Curves.easeInOut,
      transitionDuration: const Duration(milliseconds: 0),
    );
  }

  static Future<void> showLoading({bool? isLoadingShow}) async {
    _instance.isLoadingShow = isLoadingShow ?? true;
    MemorialDb().updateDialogCloseTime();
    if (_instance.isLoadingShow == false) {
      _instance.loadingStream.add(false);
      return;
    }

    _instance.loadingStream.add(true);
  }

  static Future<void> hideLoading({bool? isLoadingShow}) async {
    _instance.isLoadingShow = isLoadingShow ?? false;
    MemorialDb().updateDialogCloseTime();
    if (_instance.isLoadingShow == false) {
      _instance.loadingStream.add(false);
      return;
    }

    _instance.loadingStream.add(false);
  }
}