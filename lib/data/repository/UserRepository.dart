
import 'package:injectable/injectable.dart';
import 'package:nextseat/common/contains/Env.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/data/db/SharedDb.dart';
import 'package:nextseat/data/exceptions/DataExceptions.dart';
import 'package:nextseat/domain/model/UserModel.dart';
import 'package:nextseat/domain/repository/UserRepositoryImpl.dart';

// MARK: - 유저 Repository
@Singleton(as: UserRepositoryImpl, env: [Env.DEV, Env.DEPLOY])
class UserRepository implements UserRepositoryImpl {
  UserModel? _myInfo;

  // MARK: - 유저 생성
  @override
  Future<UserModel> createUser({required String? name, required String? number}) async {
    try {
      _myInfo = UserModel.empty(
        name: name ?? '',
        number: number ?? '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await SharedDb().putMyInfo(user: _myInfo ?? UserModel.empty());

      return _myInfo ?? UserModel.empty();
    } catch (e, s) {
      Log.e(e, s);
      rethrow;
    }
  }

  // MARK: - 내 정보 조회
  @override
  Future<UserModel> getMyInfo() async {
    try {
      _myInfo = await SharedDb().getMyInfo();

      return _myInfo ?? UserModel.empty();
    } catch (e, s) {
      Log.e(e, s);
      rethrow;
    }
  }

  // MARK: - 내 정보 수정
  @override
  Future<UserModel> updateMyInfo({required String? name, required String? number}) async {
    try {
      _myInfo = UserModel.empty(
        name: name ?? '',
        number: number ?? '',
        createdAt: _myInfo?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await SharedDb().putMyInfo(user: _myInfo ?? UserModel.empty());

      return _myInfo ?? UserModel.empty();
    } catch (e, s) {
      Log.e(e, s);
      rethrow;
    }
  }
}