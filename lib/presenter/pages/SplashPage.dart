
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nextseat/common/Scheme.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/presenter/BaseViewModel.dart';
import 'package:nextseat/presenter/route/SeatRouter.dart';

// MARK: - 스플래시 페이지
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Log.d('SplashPage Build');
    return GetBuilder<SplashPageViewModel>(
      init: SplashPageViewModel(),
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

// MARK: - 스플래시 페이지 뷰모델
class SplashPageViewModel extends BaseViewModel {
  SplashPageViewModel()
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
    Log.d('SplashPageViewModel dataUpdate');

    // MARK: - 홈 페이지 이동
    SeatRouter.to(scheme: Scheme.HOME, isForce: true);

    update();
  }

  @override
  Future<void> init() async {
    await dataUpdate();
  }
}
