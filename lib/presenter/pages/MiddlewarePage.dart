// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/presenter/BaseViewModel.dart';
import 'package:nextseat/presenter/lang/LangKeys.dart';
import 'package:nextseat/presenter/lang/Messages.dart';
import 'package:nextseat/presenter/route/SeatRouter.dart';
import 'package:nextseat/presenter/theme/Themes.dart';
import 'package:nextseat/presenter/widgets/SeatButton.dart';
import 'package:nextseat/presenter/widgets/WifiLoading.dart';

// MARK: - 미들웨어 페이지
class MiddlewarePage extends StatelessWidget {
  final String? route;

  const MiddlewarePage({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    Log.d('MiddlewarePage Build');
    return GetBuilder<MiddlewarePageViewModel>(
      init: MiddlewarePageViewModel(
        route: route,
      ),
      builder: (model) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: WifiLoading(
                      isAnimation: false,
                    ),
                  ),
                  Visibility(
                    visible: model.getIsWifiConnect() == false,
                    child: Expanded(
                      child: Column(
                        children: [
                          SeatButton(
                            onPressed: () async {
                              await model.dataUpdate();
                            },
                            title: Messages.get(LangKeys.connectCheck),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            model.getIsWifiConnect() == false ? Messages.get(LangKeys.wifiConnectFail) : '',
                            style: TextStyle(
                              fontSize: 20,
                              color: SeatThemes().surface01,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// MARK: - 미들웨어 페이지 뷰모델
class MiddlewarePageViewModel extends BaseViewModel {
  final String? route;
  MiddlewarePageViewModel({required this.route})
      : super(
          updateKeys: [
            BaseViewModel.PAGE_UPDATE,
          ],
        );

  // 와이파이 연결 여부
  bool? _isWifiConnect;

  // MARK: - 와이파이 연결 여부 업데이트
  Future<void> isWifiUpdate() async {
    _isWifiConnect = await NetworkInfo().getWifiName() != null;
    return;
  }

  // MARK: - 와이파이 연결 여부
  bool getIsWifiConnect() {
    return _isWifiConnect ?? false;
  }


  @override
  void clear({bool isInitClear = false}) {
    _isWifiConnect = false;
  }

  @override
  Future<void> dataUpdate() async {
    Log.d('MiddlewarePageViewModel dataUpdate');

    // 와이파이 연결 여부 업데이트
    await isWifiUpdate();

    update();

    if(_isWifiConnect == true) {
      await SeatRouter.back();
    }
  }

  @override
  Future<void> init() async {
    await dataUpdate();
  }
}
