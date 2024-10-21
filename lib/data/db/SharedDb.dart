
// MARK: - 공유 DB
import 'dart:convert';

import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/domain/model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedDb implements SharedDbImpl {
  static const String _MY_INFO = 'my_info';  // 내 정보

  // MARK: - Key값을 미리 로드
  final Map<String, String?> _preloadingKeys = {};

  Future<void> preloading() async {
    _preloadingKeys[_MY_INFO] = await getString(_MY_INFO);
  }

  // MARK: - 내 정보 저장
  Future<bool> putMyInfo({required UserModel user}) async {
    _preloadingKeys[_MY_INFO] = user.toJson().toString();
    return await putString(_MY_INFO, jsonEncode(user.toJson()));
  }

  // MARK: - 내 정보 조회
  Future<UserModel> getMyInfo() async {
    try {
      final String? myInfoStr = await getString(_MY_INFO);
      if (myInfoStr == null) {
        UserModel empty = UserModel.empty();
        await putMyInfo(user: empty);
        return empty;
      }

      return UserModel.fromJson(jsonDecode(myInfoStr));
    } catch(e, s) {
      Log.e(e, s);
      return UserModel.empty();
    }
  }

  // MARK: - String 값 저장
  @override
  Future<bool> putString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, value);
  }

  // MARK: - String 값 조회
  @override
  Future<String?> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // MARK: - Key 값 삭제
  @override
  Future<bool> remove(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  // MARK: - 모든 값 삭제
  @override
  Future<bool> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  // MARK: - String List 값 조회
  @override
  Future<List<String>> getStringList(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  // MARK: - String List 값 저장
  @override
  Future<bool> putStringList(String key, List<String> value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setStringList(key, value);
  }
}

abstract class SharedDbImpl {
  // MARK: - String 값 저장
  Future<bool> putString(String key, String value);
  
  // MARK: - String 값 조회
  Future<String?> getString(String key);
  
  // MARK: - Key 값 삭제
  Future<bool> remove(String key);
  
  // MARK: - 모든 값 삭제
  Future<bool> clear();
  
  // MARK: - String List 값 조회
  Future<List<String>> getStringList(String key);
  
  // MARK: - String List 값 저장
  Future<bool> putStringList(String key, List<String> value);
}