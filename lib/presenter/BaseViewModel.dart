// ignore_for_file: constant_identifier_names, prefer_const_constructors

import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nextseat/common/utils/DialogUtils.dart';
import 'package:nextseat/common/utils/Log.dart';

abstract class BaseViewModel extends GetxController {
  bool isError = false;
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  bool isLoadingShow = true;

  static final HashMap<BaseViewModel, List<String>> _viewModelMap = HashMap();

  //MARK: - 페이지 갱신 요청
  static const String PAGE_UPDATE = 'PAGE_UPDATE';

  final List<String> updateKeys;
  final bool? withOutInit;

  static Future<bool> dataUpdateByTag(String tag) async {
    try {
      _viewModelMap.forEach((key, value) async {
        if (value.contains(tag)) {
          await key.dataUpdate();
        }
      });
      return true;
    } catch (e, s) {
      Log.e(e, s);
      return false;
    }
  }

  BaseViewModel(
      {this.withOutInit = false,
        this.isLoadingShow = true,
        this.updateKeys = const <String>[]})
      : super();

  @override
  onReady() {
    super.onReady();
    if (withOutInit == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        initialize();
      });
    }
    if (updateKeys.isNotEmpty && !_viewModelMap.containsKey(this)) {
      _viewModelMap[this] = updateKeys;
    }
  }

  @override
  @override
  void onClose() {
    super.onClose();
    try {
      _viewModelMap.remove(this);
    } catch (e, s) {
      // Log.e(e, s);
    }
  }

  @override
  void update([List<Object>? ids, bool condition = true]) {
    if (isError) return;
    super.update(ids);
  }

  Future<void> initialize() async {
    try {
      isError = false;
      await init();
    } catch (e, s) {
      isError = true;
      Log.e(e, s);
      update();
    }
  }

  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    if (_isLoading) {
      // 로딩 다이얼로그 표시
      DialogUtils.showLoading(isLoadingShow: isLoadingShow);
    } else if (!isLoading) {
      // 로딩 다이얼로그 숨김
      DialogUtils.hideLoading(isLoadingShow: isLoadingShow);
    }
  }

  void clear({bool isInitClear = false});

  Future<void> dataUpdate();

  Future<void> init();
}