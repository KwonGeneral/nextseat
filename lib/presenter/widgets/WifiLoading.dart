
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nextseat/presenter/style/ImageResource.dart';

class WifiLoading extends StatelessWidget {
  bool isAnimation;
  WifiLoading({super.key, required this.isAnimation});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      ImageResource.wifi_loading,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,

      // 애니메이션 재생 여부
      animate: !isAnimation,
    );
  }
}