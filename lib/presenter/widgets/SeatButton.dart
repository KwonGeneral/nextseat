
import 'package:flutter/material.dart';
import 'package:nextseat/presenter/style/TextStyles.dart';
import 'package:nextseat/presenter/theme/Themes.dart';

// MARK: - 서브 버튼 위젯
class SeatSubButton extends SeatButton {
  SeatSubButton({
    super.key,
    required super.onPressed,
    required super.title,
    super.disable,
    super.height,
    super.width,
    super.frontIcon,
    super.padding,
    super.disableBackgroundColor,
  }) : super(
    backgroundColor: SeatThemes().backgroundSub,
    textStyle: TextStyles.regular(
      fontSize: 14,
      color: SeatThemes().surface01,
    ),
  );
}

// MARK: - 서드 버튼 위젯
class SeatThirdButton extends SeatButton {
  SeatThirdButton({
    super.key,
    required super.onPressed,
    required super.title,
    super.disable,
    super.height,
    super.width,
    super.frontIcon,
    super.padding,
    super.disableBackgroundColor,
  }) : super(
    backgroundColor: SeatThemes().background,
    borderColor: SeatThemes().surface01,
    textStyle: TextStyles.regular(
      fontSize: 14,
      color: SeatThemes().surface01,
    ),
  );
}

// MARK: - 테두리 버튼 위젯
class SeatBorderButton extends SeatButton {
  SeatBorderButton({
    super.key,
    required super.onPressed,
    required super.title,
    required super.textStyle,
    required super.borderColor,
    required super.radius,
    required super.padding,
    super.disable,
    super.height,
    super.width,
    super.frontIcon,
    super.disableBackgroundColor,
  }) : super(
    backgroundColor: SeatThemes().background,
  );
}

// MARK: - 기본 버튼 위젯
class SeatButton extends ElevatedButton {
  final Widget? titleWidget;
  final String title;
  final bool disable;
  final TextStyle? textStyle;
  final Widget? frontIcon;

  final Color? backgroundColor;
  final Color? disableBackgroundColor;
  final Color? borderColor;

  final Color defaultBackgroundColor = SeatThemes().primary;
  final Color defaultDisableBackgroundColor = SeatThemes().surface01;
  final Color defaultBorderColor = SeatThemes().primary;
  final Color defaultTextColor = Colors.white;

  final double radius;
  final double? height;
  final double? width;
  final EdgeInsets? padding;

  SeatButton({
    super.key,
    required VoidCallback? onPressed,
    required this.title,
    this.titleWidget,
    this.disable = false,
    this.backgroundColor,
    this.disableBackgroundColor,
    this.borderColor,
    this.radius = 4,
    this.width,
    this.height,
    this.textStyle,
    this.frontIcon,
    this.padding,
  }): super(
    onPressed: disable == true ? null : onPressed,
    style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        )),
        foregroundColor: MaterialStateProperty.all(SeatThemes().primary),
        backgroundColor: MaterialStateProperty.all(disable == false ? backgroundColor ?? SeatThemes().primary : disableBackgroundColor ?? SeatThemes().primary),
        elevation: MaterialStateProperty.all(0),
        side: MaterialStateProperty.all(BorderSide(
          color: borderColor ?? (disable == false ? backgroundColor ?? SeatThemes().primary : disableBackgroundColor ?? SeatThemes().backgroundSub),
          width: 1,
          style: BorderStyle.solid,
        )),
        textStyle: MaterialStateProperty.all(textStyle ??
            TextStyles.regular(
              fontSize: 14,
              color: Colors.white,
            )),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: MaterialStateProperty.all(Size(width ?? 0, height ?? 40)),
        padding: MaterialStateProperty.all(padding ?? const EdgeInsets.all(0))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Visibility(
          visible: frontIcon == null ? false : true,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              frontIcon ?? const SizedBox(),
              const SizedBox(width: 8),
            ],
          ),
        ),
        titleWidget ?? Text(
          title,
          textAlign: TextAlign.center,
          style: textStyle ?? TextStyles.regular(
            fontSize: 14,
          color: disable == true ? SeatThemes().white : SeatThemes().white,
          ),
        ),
      ],
    ),
  );
}