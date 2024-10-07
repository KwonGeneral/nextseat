
import 'package:flutter/material.dart';
import 'package:nextseat/common/utils/DialogUtils.dart';
import 'package:nextseat/presenter/route/SeatRouter.dart';
import 'package:nextseat/presenter/theme/Themes.dart';

// MARK: - 스캐폴드
class SeatScaffold extends StatelessWidget {
  final AppBar? appBar;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final VoidCallback? onBack;
  final bool isLoadingShow;
  final bool isParentTabBar;  // 탭바 여부 (true: 부모 탭바, false: 일반 페이지)
  final Widget? topWidget;  // 상단 위젯 (initLoading중에도 표시)
  final bool isInitLoading;

  const SeatScaffold({
    super.key,
    this.appBar,
    this.body,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.onBack,
    this.isLoadingShow = true,
    this.isParentTabBar = false,
    this.topWidget,
    required this.isInitLoading,
  });

  @override
  Widget build(BuildContext context) {
    if(isParentTabBar || !isLoadingShow) {
      return WillPopScope(
        onWillPop: () async {
          if (onBack != null) {
            onBack?.call();
            return false;
          }

          return await SeatRouter.back();
        },
        child: Scaffold(
          appBar: appBar,
          body: Column(
            children: [
              topWidget ?? Container(),
              Expanded(
                child: body ?? Container(),
              ),
            ],
          ),
          bottomNavigationBar: bottomNavigationBar,
          bottomSheet: bottomSheet,
          backgroundColor:
          backgroundColor ?? SeatThemes().background,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        ),
      );
    }

    if(isInitLoading) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: appBar,
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                topWidget ?? Container(),
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        SeatThemes().primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: bottomNavigationBar,
          bottomSheet: bottomSheet,
          backgroundColor:
          backgroundColor ?? SeatThemes().background,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        ),
      );
    }

    return StreamBuilder<bool>(
      stream: DialogUtils().loadingStream.stream,
      builder: ((context, snapshot) {
        return Stack(
          children: [
            WillPopScope(
              child: Scaffold(
                appBar: appBar,
                body: Column(
                  children: [
                    topWidget ?? Container(),
                    Expanded(
                      child: body ?? Container(),
                    ),
                  ],
                ),
                bottomNavigationBar: bottomNavigationBar,
                bottomSheet: bottomSheet,
                backgroundColor:
                backgroundColor ?? SeatThemes().background,
                resizeToAvoidBottomInset: resizeToAvoidBottomInset,
              ),
              onWillPop: () async {
                if(snapshot.data == true) {
                  return false;
                }

                if (onBack != null) {
                  onBack?.call();
                  return false;
                }

                return await SeatRouter.back();
              },
            ),
            if (snapshot.data == true)
              IgnorePointer(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: SeatThemes().black60,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        SeatThemes().primary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
