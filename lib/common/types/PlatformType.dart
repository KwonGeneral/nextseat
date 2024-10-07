
// ignore_for_file: constant_identifier_names

// MARK: - 플랫폼 타입 (안드로이드, IOS, 웹 ...)
enum PlatformType {
  // 안드로이드
  ANDROID(
      value: "android",
      name: "Android"
  ),

  // 아이폰
  IOS(
      value: "ios",
      name: "IOS"
  ),

  // 웹
  WEB(
      value: "web",
      name: "Web"
  ),

  // 맥
  MACOS(
      value: "macos",
      name: "MacOS"
  ),

  // 윈도우
  WINDOWS(
      value: "windows",
      name: "Windows"
  ),

  // 리눅스
  LINUX(
      value: "linux",
      name: "Linux"
  ),

  // 퓨시아
  FUCHSIA(
      value: "fuchsia",
      name: "Fuchsia"
  ),

  // 알 수 없음
  UNKNOWN(
      value: "unknown",
      name: "Unknown"
  );

  final String value;
  final String name;

  const PlatformType({required this.value, required this.name});
}