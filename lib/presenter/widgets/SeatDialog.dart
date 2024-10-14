
import 'package:flutter/material.dart';
import 'package:nextseat/common/utils/DialogUtils.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/presenter/lang/LangKeys.dart';
import 'package:nextseat/presenter/lang/Messages.dart';
import 'package:nextseat/presenter/route/SeatRouter.dart';
import 'package:nextseat/presenter/style/TextStyles.dart';
import 'package:nextseat/presenter/theme/Themes.dart';
import 'package:nextseat/presenter/widgets/SeatButton.dart';

// MARK: - 다이얼로그
class SeatDialog {
  String title; // 제목
  String content; // 내용
  String description; // 설명
  Widget? bodyWidget; // 바디 위젯
  Widget? topWidget; // 상단 위젯
  String? positiveText; // 확인 버튼 텍스트
  String? negativeText; // 취소 버튼 텍스트
  double? titleMargin;
  double? contentMargin;
  VoidCallback? positiveCallback; // 확인 버튼 콜백
  VoidCallback? negativeCallback; // 취소 버튼 콜백
  Color? positiveBackgroundColor; // 확인 버튼 컬러
  Color? positiveTextColor; // 확인 버튼 텍스트 컬러
  Color? negativeBackgroundColor; // 취소 버튼 컬러
  Color? negativeTextColor; // 취소 버튼 텍스트 컬러
  TextAlign? titleAlign;  // 제목 정렬
  TextAlign? contentAlign;  // 내용 정렬
  TextAlign? descriptionAlign;  // 설명 정렬
  String tag; // 태그
  EdgeInsets? titlePadding;  // 제목 패딩
  EdgeInsets? contentPadding;  // 내용 패딩
  EdgeInsets? containerPadding;  // 컨테이너 패딩
  bool isOnlyShow;  // 하나만 보이게 할지 여부
  double? topWidgetSpace;  // 상단 위젯 간격
  double? titleSpace;  // 제목 간격
  double? contentSpace;  // 내용 간격
  double? bodyWidgetSpace;  // 바디 위젯 간격
  Widget? titleWidget;  // 제목 아이콘

  SeatDialog({
    Key? key,
    this.title = "",
    this.content = "",
    this.topWidget,
    this.bodyWidget,
    this.description = "",
    this.positiveText,
    this.negativeText,
    this.positiveCallback,
    this.negativeCallback,
    this.positiveBackgroundColor,
    this.positiveTextColor,
    this.negativeBackgroundColor,
    this.negativeTextColor,
    this.titleAlign = TextAlign.center,
    this.contentAlign = TextAlign.center,
    this.descriptionAlign,
    this.titlePadding,
    this.contentPadding,
    this.containerPadding = const EdgeInsets.all(8),
    this.titleSpace = 16,
    this.contentSpace = 16,
    this.topWidgetSpace = 16,
    this.bodyWidgetSpace = 16,
    this.titleWidget,
    this.tag = "",
    this.isOnlyShow = true,
  }) : super() {
    DialogUtils.showDialog(
      KwonDialog(
        key: key,
        title: title,
        content: content,
        topWidget: topWidget,
        bodyWidget: bodyWidget,
        description: description,
        positiveText: positiveText ?? Messages.get(LangKeys.confirmOk),
        negativeText: negativeText ?? Messages.get(LangKeys.cancel),
        positiveCallback: positiveCallback != null
            ? () {
          DialogUtils.clearDialogTag();
          positiveCallback?.call();
        }
            : null,
        negativeCallback: negativeCallback != null
            ? () {
          DialogUtils.clearDialogTag();
          negativeCallback?.call();
        }
            : null,
        positiveBackgroundColor: positiveBackgroundColor,
        positiveTextColor: positiveTextColor,
        negativeBackgroundColor: negativeBackgroundColor,
        negativeTextColor: negativeTextColor,
        titleAlign: titleAlign,
        contentAlign: contentAlign,
        titlePadding: titlePadding,
        contentPadding: contentPadding,
        descriptionAlign: descriptionAlign,
        containerPadding: containerPadding,
        titleSpace: titleSpace,
        contentSpace: contentSpace,
        bodyWidgetSpace: bodyWidgetSpace,
        topWidgetSpace: topWidgetSpace,
        titleWidget: titleWidget,
      ),
      tag: tag,
      isOnlyOneShow: isOnlyShow,
    );
  }

  static Widget getDialogWidget({
    String title = "",
    String content = "",
    Widget? topWidget,
    Widget? bodyWidget,
    String description = "",
    String neutralText = "",
    VoidCallback? neutralCallback,
    String? positiveText,
    String? negativeText,
    VoidCallback? positiveCallback,
    VoidCallback? negativeCallback,
    Color? positiveBackgroundColor,
    Color? positiveTextColor,
    Color? negativeBackgroundColor,
    Color? negativeTextColor,
    Widget? titleWidget,
  }) {
    EdgeInsets containerPadding = const EdgeInsets.all(8);
    double titleSpace = 16;
    double contentSpace = 16;
    double bodyWidgetSpace = 16;
    double topWidgetSpace = 16;
    TextAlign titleAlign = TextAlign.center;
    TextAlign contentAlign = TextAlign.center;
    
    return KwonDialog(
      title: title,
      content: content,
      topWidget: topWidget,
      bodyWidget: bodyWidget,
      description: description,
      positiveText: positiveText ?? Messages.get(LangKeys.confirmOk),
      negativeText: negativeText ?? Messages.get(LangKeys.cancel),
      positiveCallback: positiveCallback,
      negativeCallback: negativeCallback,
      positiveBackgroundColor: positiveBackgroundColor,
      positiveTextColor: positiveTextColor,
      negativeBackgroundColor: negativeBackgroundColor,
      negativeTextColor: negativeTextColor,
      titleAlign: titleAlign,
      contentAlign: contentAlign,
      containerPadding: containerPadding,
      titleSpace: titleSpace,
      contentSpace: contentSpace,
      bodyWidgetSpace: bodyWidgetSpace,
      topWidgetSpace: topWidgetSpace,
      titleWidget: titleWidget,
    );
  }

  static showCustomDialog({required Widget child, String tag = ""}) {
    DialogUtils.showDialog(
      child,
      tag: tag,
    );
  }

  factory SeatDialog.show({
    String title = "",
    String content = "",
    Widget? topWidget,
    Widget? bodyWidget,
    String description = "",
    String neutralText = "",
    VoidCallback? neutralCallback,
    String? positiveText,
    String? negativeText,
    VoidCallback? positiveCallback,
    VoidCallback? negativeCallback,
    Color? positiveBackgroundColor,
    Color? positiveTextColor,
    Color? negativeBackgroundColor,
    Color? negativeTextColor,
    TextAlign? titleAlign,
    TextAlign? contentAlign,
    TextAlign? descriptionAlign,
    EdgeInsets? titlePadding,
    EdgeInsets? contentPadding,
    Widget? titleWidget,
    String tag = "",
  }) {
    return SeatDialog(
      title: title,
      content: content,
      topWidget: topWidget,
      bodyWidget: bodyWidget,
      description: description,
      positiveText: positiveText,
      negativeText: negativeText,
      positiveCallback: positiveCallback,
      negativeCallback: negativeCallback,
      positiveBackgroundColor: positiveBackgroundColor,
      positiveTextColor: positiveTextColor,
      negativeBackgroundColor: negativeBackgroundColor,
      negativeTextColor: negativeTextColor,
      titleAlign: titleAlign,
      contentAlign: contentAlign,
      descriptionAlign: descriptionAlign,
      titlePadding: titlePadding,
      contentPadding: contentPadding,
      titleWidget: titleWidget,
      tag: tag,
    );
  }
}

class KwonDialog extends StatefulWidget {
  final String title; // 제목
  final String content; // 내용
  final Widget? topWidget; // 상단 위젯
  final Widget? bodyWidget; // 바디 위젯
  final String description; // 설명
  final String positiveText; // 확인 버튼 텍스트
  final String negativeText; // 취소 버튼 텍스트
  final VoidCallback? positiveCallback; // 확인 버튼 콜백
  final VoidCallback? negativeCallback; // 취소 버튼 콜백
  final Color? positiveBackgroundColor; // 확인 버튼 컬러
  final Color? positiveTextColor; // 확인 버튼 텍스트 컬러
  final Color? negativeBackgroundColor; // 취소 버튼 컬러
  final Color? negativeTextColor; // 취소 버튼 텍스트 컬러
  final TextAlign? titleAlign;
  final TextAlign? contentAlign;
  final TextAlign? descriptionAlign;
  final EdgeInsets? titlePadding;
  final EdgeInsets? contentPadding;
  final EdgeInsets? containerPadding;
  final double? titleSpace;
  final double? contentSpace;
  final double? topWidgetSpace;
  final double? bodyWidgetSpace;
  final Widget? titleWidget;

  const KwonDialog({
    super.key,
    required this.title,
    required this.content,
    this.topWidget,
    this.bodyWidget,
    required this.description,
    required this.positiveText,
    required this.negativeText,
    required this.positiveCallback,
    this.negativeCallback,
    this.positiveBackgroundColor,
    this.positiveTextColor,
    this.negativeBackgroundColor,
    this.negativeTextColor,
    this.titleAlign,
    this.contentAlign,
    this.descriptionAlign,
    this.titlePadding,
    this.contentPadding,
    this.containerPadding,
    this.titleSpace,
    this.contentSpace,
    this.topWidgetSpace,
    this.bodyWidgetSpace,
    this.titleWidget,
  }) : super();

  @override
  State<KwonDialog> createState() => _KwonDialogState();
}

class _KwonDialogState extends State<KwonDialog> {
  @override
  Widget build(BuildContext context) {
    Log.d("KwonDialog build");
    return WillPopScope(
      onWillPop: widget.negativeText == "" ? () async {
        // MARK: - 뒤로가기 액션

        // negativeText가 없을 경우, 뒤로가기 제거
        return false;
      } : null,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            color: Colors.transparent,
            alignment: Alignment.center,
            child: Container(
              // color: R.CompColorBackgroundDialogue,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              padding: widget.containerPadding ?? EdgeInsets.only(
                  top: 24,
                  bottom: widget.negativeText == "" ? 24 : 24),
              decoration: BoxDecoration(
                color: SeatThemes().background,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // MARK: - 상단 위젯
                    if (widget.topWidget != null) widget.topWidget!,
                    if (widget.topWidget != null)
                      SizedBox(
                        height: widget.topWidgetSpace ?? 24,
                      ),

                    // MARK: - 제목 위젯
                    if (widget.titleWidget != null) widget.titleWidget!,

                    // MARK: - 제목
                    if (widget.title != "")
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.title,
                              style: TextStyles.bold(
                                fontSize: 18,
                                color: SeatThemes().surface01,
                              ),
                              textAlign: widget.titleAlign ?? TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    if (widget.title != "")
                      SizedBox(
                        height: widget.titleSpace ?? 8,
                      ),

                    // MARK: - 내용
                    if (widget.content != "")
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.content,
                              style: TextStyles.regular(
                                fontSize: 16,
                                color: SeatThemes().surface01,
                              ),
                              textAlign: widget.contentAlign ?? TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    if (widget.content != "")
                      SizedBox(
                        height: widget.contentSpace ?? 24,
                      ),

                    // MARK: - 내용 위젯
                    if (widget.bodyWidget != null) widget.bodyWidget!,
                    if (widget.bodyWidget != null)
                      SizedBox(
                        height: widget.bodyWidgetSpace ?? 24,
                      ),

                    // MARK: - 설명
                    if (widget.description != "")
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.description,
                                style: TextStyles.regular(
                                  fontSize: 14,
                                  color: SeatThemes().surface01,
                                ),
                                textAlign: widget.descriptionAlign ?? TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (widget.description != "")
                      const SizedBox(
                        height: 24,
                      ),

                    // MARK: - 버튼
                    Row(
                      children: [
                        if (widget.negativeText != "")
                          Expanded(
                            child: SeatButton(
                              onPressed: widget.negativeCallback ??
                                      () async {
                                    await SeatRouter.back();
                                  },
                              title: widget.negativeText,
                              textStyle: TextStyles.medium(
                                fontSize: 16,
                                color: widget.negativeTextColor ??
                                    SeatThemes().surface01,
                              ),
                              backgroundColor: widget.negativeBackgroundColor ??
                                  SeatThemes().backgroundSub,
                            ),
                          ),
                        if (widget.negativeText != "")
                          const SizedBox(
                            width: 8,
                          ),
                        if (widget.positiveText != "")
                          Expanded(
                            child: SeatButton(
                              onPressed: widget.positiveCallback,
                              title: widget.positiveText,
                              textStyle: TextStyles.medium(
                                fontSize: 16,
                                color: SeatThemes().white,
                              ),
                              backgroundColor: widget.positiveBackgroundColor ??
                                  SeatThemes().primary,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
