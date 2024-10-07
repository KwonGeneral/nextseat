
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/presenter/BaseViewModel.dart';

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
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: const Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
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

  @override
  void clear({bool isInitClear = false}) {
  }

  @override
  Future<void> dataUpdate() async {
    Log.d('MiddlewarePageViewModel dataUpdate');
    update();
  }

  @override
  Future<void> init() async {
    await dataUpdate();
  }
}
