// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nextseat/presenter/BaseViewModel.dart';
import 'package:nextseat/presenter/route/SeatRouter.dart';
import 'package:nextseat/presenter/style/ImageResource.dart';
import 'package:nextseat/presenter/style/TextStyles.dart';
import 'package:nextseat/presenter/theme/Themes.dart';

class SeatAppBar extends AppBar {
  SeatAppBar({
    super.key,
    required List<Widget> actions,
    required String title,
    required bool isBack,
    bool isActionHide = false,
    bool isShowAlarmList = true,
    bool isShowAlarmSetting = true,
    VoidCallback? onBack,
    bool isLogo = false,
  }) : super(
            leadingWidth: 0,
            titleSpacing: 0,
            toolbarHeight: 56,
            centerTitle: false,
            backgroundColor: SeatThemes().background,
            automaticallyImplyLeading: false,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            foregroundColor: SeatThemes().background,
            scrolledUnderElevation: 0,
            shadowColor: Colors.transparent,
            shape: const Border(
              bottom: BorderSide(
                color: Colors.black12,
                width: 1,
              ),
            ),
            title: GetBuilder<SeatAppBarViewModel>(
                init: Get.put(SeatAppBarViewModel(
                  isActionHide: isActionHide,
                )),
                builder: (model) {
                  return Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Row(
                        children: [
                          Visibility(
                            visible: isBack,
                            child: SizedBox(
                              width: 48,
                              height: 48,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(1000),
                                child: Material(
                                  color: Colors.transparent,
                                  child: IconButton(
                                    onPressed: () async {
                                      if (onBack == null) {
                                        await SeatRouter.back();
                                      } else {
                                        onBack.call();
                                      }
                                    },
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      color: SeatThemes().surface01,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Visibility(
                              visible: !isLogo,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: isActionHide == true
                                      ? 16
                                      : actions.isEmpty
                                          ? 120
                                          : actions.length * 60,
                                  left: isLogo == false && isBack == false ? 16 : 0,
                                ),
                                child: Text(
                                  title,
                                  style: TextStyles.bold(
                                    fontSize: 16,
                                  )
                                      .copyWith(color: SeatThemes().surface01),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Visibility(
                        visible: isLogo,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Image.asset(
                            ImageResource.background_logo,
                            width: 139,
                            height: 29,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: isActionHide == true
                              ? []
                              : actions.isNotEmpty
                                  ? actions
                                  : model.getDefaultActions(),
                        ),
                      ),
                    ],
                  );
                }));
}

class SeatAppBarViewModel extends BaseViewModel {
  bool isActionHide;

  SeatAppBarViewModel({required this.isActionHide});

  int notificationUnreadCount = 0;
  int childRequestUnreadCount = 0;

  // MARK: - 기본 앱바 위젯
  List<Widget> getDefaultActions() {
    return [];
  }

  @override
  void clear({bool isInitClear = false}) {}

  @override
  Future<void> dataUpdate() async {
    update();
  }

  @override
  Future<void> init() async {
    await dataUpdate();
  }
}
