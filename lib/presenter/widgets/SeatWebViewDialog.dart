// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, must_be_immutable


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nextseat/common/types/PlatformType.dart';
import 'package:nextseat/common/utils/ExceptionWidgetUtils.dart';
import 'package:nextseat/presenter/BaseViewModel.dart';
import 'package:nextseat/presenter/widgets/SeatAppBar.dart';
import 'package:nextseat/presenter/widgets/SeatDialog.dart';
import 'package:nextseat/presenter/widgets/SeatScaffold.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../common/utils/Log.dart';
import '../../common/utils/Utils.dart';

// MARK: - 웹뷰 (팝업)
class SeatWebViewDialog {
  static void showUrl({String title = '', required String url}) {
    SeatDialog.showCustomDialog(
      child: _KWebViewPage(
        title: title,
        initialUrl: url,
      ),
      tag: "SeatWebViewDialog",
    );
  }

  static void showHtml({String title = '', required String html}) {
    SeatDialog.showCustomDialog(
      child: _KWebViewPage(
        title: title,
        initialUrl: "data:text/html;base64,${base64Encode(const Utf8Encoder().convert(html))}",
      ),
      tag: "SeatWebViewDialog",
    );
  }
}

// MARK: - 웹뷰 페이지
class _KWebViewPage extends StatelessWidget {
  final String title;
  final String initialUrl;

  _KWebViewPage({Key? key, required this.title, required this.initialUrl})
      : super(key: key);

  final WebViewController _controller = WebViewController();

  @override
  Widget build(BuildContext context) {
    Log.d("[ _KWebViewPage ] build");
    try {
      return GetBuilder<_KWebViewPageViewModel>(
        init: _KWebViewPageViewModel(),
        builder: (model) {
          return SeatScaffold(
            isLoadingShow: false,
            appBar: SeatAppBar(
              title: title,
              isBack: true,
              actions: const [],
              isActionHide: true,
            ),
            body: Stack(
              children: [
                FutureBuilder(
                  future: model.getUserAgent(),
                  builder: (context, snapshot) {
                    if(snapshot.data == null) {
                      return Container();
                    }

                    return WebViewWidget(
                      controller: _controller
                        ..setUserAgent(snapshot.data == "" ? null : snapshot.data)
                        ..setJavaScriptMode(JavaScriptMode.unrestricted)
                        ..setBackgroundColor(const Color(0x00000000))
                        ..setNavigationDelegate(
                          NavigationDelegate(
                            onUrlChange: (UrlChange change) async {},
                            onProgress: (int progress) {},
                            onPageStarted: (String url) {},
                            onPageFinished: (String url) async {},
                            onNavigationRequest: (NavigationRequest request) async {
                              String url = request.url;
                              Log.d("onNavigationRequest url: $url");

                              try {
                                Uri parse = Uri.parse(url);

                                /// 만약 url의 scheme이 http 또는 https가 아닌 경우, 해당 url을 스킴으로 이동
                                /// 단, url이 https://play.google.com/store/apps/details인 경우는 예외
                                if (url.contains(
                                    "https://play.google.com/store/apps/details")) {
                                  return NavigationDecision.navigate;
                                }

                                /// 또한, url이 intent://play.google.com/store/apps/details인 경우에는 launchUrl을 하지 않고
                                /// 해당 url을 웹뷰로 표시
                                if (url.contains(
                                    "intent://play.google.com/store/apps/details")) {
                                  url.replaceAll("intent://", "https://");
                                  return NavigationDecision.prevent;
                                }
                                if (parse.scheme != ("http") &&
                                    parse.scheme != ("https")) {
                                  Log.d("onNavigationRequest parse : $parse");

                                  bool result = await launchUrl(parse);
                                  Log.d("onNavigationRequest result : $result");

                                  if (result) {
                                    return NavigationDecision.prevent;
                                  }
                                }
                              } catch (e, s) {
                                Log.d("onNavigationRequest error : $e");
                                Log.e(e, s);
                                return NavigationDecision.prevent;
                              }

                              return NavigationDecision.navigate;
                            },
                            onWebResourceError: (WebResourceError error) {
                              Log.d("onWebResourceError: $error");
                            },
                          ),
                        )
                        ..loadRequest(
                          Uri.parse(initialUrl),
                        ),
                    );
                  }
                ),
              ],
            ),
          );
        },
      );
    } catch (e, s) {
      return ExceptionWidgetUtils.ExceptionWidget(e, s,
          division: "_KWebViewPage");
    }
  }
}

// MARK: - 웹뷰 페이지 뷰모델
class _KWebViewPageViewModel extends BaseViewModel {
  Future<String?> getUserAgent() async {
    if (Utils.getPlatformType() == PlatformType.ANDROID) {
      return "Mozilla/5.0 (Linux; Android ${await Utils.getOsVersion()}; ${await Utils.getDeviceModel()}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/.0.4324.181 Mobile Safari/537.36";
    } else if (Utils.getPlatformType() == PlatformType.IOS) {
      return "Mozilla/5.0 (iPhone; CPU iPhone OS ${await Utils.getOsVersion()} like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Mobile/15E148 Safari/604.1";
    }
    return "";
  }

  // MARK: - 데이터 초기화
  @override
  void clear({bool isInitClear = false}) {}

  // MARK: - 데이터 업데이트
  @override
  Future<void> dataUpdate() async {
    update();
  }

  // MARK: - 초기 로드
  @override
  Future<void> init() async {
    await dataUpdate();
  }
}
