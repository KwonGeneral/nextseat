
import 'package:injectable/injectable.dart';
import 'package:nextseat/common/contains/Env.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/data/exceptions/DataExceptions.dart';
import 'package:nextseat/domain/model/UserModel.dart';
import 'package:nextseat/domain/repository/UserRepositoryImpl.dart';

// MARK: - 유저 Repository
@Singleton(as: UserRepositoryImpl, env: [Env.DEV, Env.DEPLOY])
class UserRepository implements UserRepositoryImpl {
  // MARK: - 유저 생성
  @override
  Future<UserModel> createUser({required UserModel userModel}) async {
    try {

      throw DataException("유저 생성 실패");
    } catch (e, s) {
      Log.e(e, s);
      rethrow;
    }
  }

  // MARK: - 유저 조회
  @override
  Future<UserModel> getUser({required String id}) async {
    try {
      throw DataException("유저 조회 실패");
    } catch (e, s) {
      Log.e(e, s);
      rethrow;
    }
  }

  // MARK: - 유저 수정
  @override
  Future<UserModel> updateUser({required UserModel userModel}) async {
    try {
      throw DataException("유저 수정 실패");
    } catch (e, s) {
      Log.e(e, s);
      rethrow;
    }
  }
}