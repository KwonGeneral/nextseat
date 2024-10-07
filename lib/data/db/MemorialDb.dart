// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'dart:async';

// MARK: - 해당 DB는 휘발성 DB로 앱이 종료되면 초기화
class MemorialDb {
  static final MemorialDb _instance = MemorialDb._internal();

  factory MemorialDb() => _instance;
  MemorialDb._internal();

  // 다이얼로그 닫힌 시간
  int dialogCloseTime = 0;

  // MARK: - 전체 초기화
  Future<void> clear() async {
    dialogCloseTime = 0;
  }

  // MARK: - 다이얼로그 닫힌 시간 조회
  int getDialogCloseTime() {
    return dialogCloseTime;
  }

  // MARK: - 다이얼로그 닫힌 시간 업데이트
  void updateDialogCloseTime() {
    dialogCloseTime = DateTime.now().millisecondsSinceEpoch;
  }
}
