
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
  // MARK: - 내 정보 조회
  @override
  Future<UserModel> getMyInfo() async {
    try {
      return await SharedDb().getMyInfo();
    } catch (e, s) {
      Log.e(e, s);
      rethrow;
    }
  }

  // MARK: - 내 정보 수정
  @override
  Future<UserModel> updateMyInfo({required UserModel myInfo}) async {
    try {
      UserModel tempMyInfo = myInfo.copyWith(
        name: myInfo.name ?? '',
        number: myInfo.number ?? '',
        createdAt: myInfo.createdAt,
        updatedAt: DateTime.now(),
      );

      await SharedDb().putMyInfo(user: tempMyInfo);

      return tempMyInfo;
    } catch (e, s) {
      Log.e(e, s);
      rethrow;
    }
  }
}