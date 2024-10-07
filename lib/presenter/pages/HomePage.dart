
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/presenter/BaseViewModel.dart';

// MARK: - 홈 페이지
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Log.d('HomePage Build');
    return GetBuilder<HomePageViewModel>(
      init: HomePageViewModel(),
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

// MARK: - 홈 페이지 뷰모델
class HomePageViewModel extends BaseViewModel {
  HomePageViewModel()
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
    Log.d('HomePageViewModel dataUpdate');
    update();
  }

  @override
  Future<void> init() async {
    await dataUpdate();
  }
}
