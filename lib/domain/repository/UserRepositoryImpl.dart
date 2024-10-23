
import 'package:nextseat/domain/model/UserModel.dart';

// MARK: - 유저 Impl
abstract class UserRepositoryImpl {
  // MARK: - 내 정보 조회
  Future<UserModel> getMyInfo();

  // MARK: - 내 정보 수정
  Future<UserModel> updateMyInfo({required UserModel myInfo});
}