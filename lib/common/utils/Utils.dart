
// MARK: - 유틸리티 (공통으로 사용되는 유틸리티)
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:nextseat/common/types/PlatformType.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Utils {
  // MARK: - 다크모드 여부 반환
  static bool isDarkMode() {
    return Get.isDarkMode;
  }

  // MARK: - 플랫폼 타입 조회
  static PlatformType getPlatformType() {
    try {
      // 웹 체크
      if (GetPlatform.isWeb) {
        return PlatformType.WEB;
      } else if (Platform.isAndroid) {
        return PlatformType.ANDROID;
      } else if (Platform.isIOS) {
        return PlatformType.IOS;
      } else if (Platform.isMacOS) {
        return PlatformType.MACOS;
      } else if (Platform.isWindows) {
        return PlatformType.WINDOWS;
      } else if (Platform.isLinux) {
        return PlatformType.LINUX;
      } else if (Platform.isFuchsia) {
        return PlatformType.FUCHSIA;
      } else {
        return PlatformType.UNKNOWN;
      }
    } catch (e, s) {
      return PlatformType.UNKNOWN;
    }
  }

  // MARK: - 디바이스 Number 조회
  static Future<String> getDeviceNumber() async {
    String deviceNumber = "";
    try {
      if (getPlatformType() == PlatformType.IOS) {
        // IOS의 경우
        deviceNumber =
            (await DeviceInfoPlugin().iosInfo).identifierForVendor ?? "";
      } else if (PlatformType.ANDROID == getPlatformType()) {
        // Android의 경우
        deviceNumber = await const AndroidId().getId() ?? "";
      }
    } catch (e, s) {
      return "";
    }
    return deviceNumber;
  }

  // MARK: - 앱 버전 조회
  static Future<String> getAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e, s) {
      return "";
    }
  }

  // MARK: - OS 버전 조회
  static Future<String> getOsVersion() async {
    String osVersion = "";
    try {
      if (PlatformType.ANDROID == getPlatformType()) {
        // Android의 경우
        osVersion = (await DeviceInfoPlugin().androidInfo).version.release;
      } else if (getPlatformType() == PlatformType.IOS) {
        // IOS의 경우
        osVersion = (await DeviceInfoPlugin().iosInfo).systemVersion;
      }
    } catch (e, s) {
      return "";
    }
    return osVersion;
  }

  // MARK: - 디바이스 모델명 조회
  static Future<String> getDeviceModel() async {
    String deviceModel = "";
    try {
      if (getPlatformType() == PlatformType.IOS) {
        // IOS의 경우
        deviceModel = (await DeviceInfoPlugin().iosInfo).model;
      } else if (getPlatformType() == PlatformType.ANDROID) {
        // Android의 경우
        deviceModel = (await DeviceInfoPlugin().androidInfo).model;
      }
    } catch (e, s) {
      return "";
    }
    return deviceModel;
  }
}