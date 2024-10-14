
import 'package:nextseat/domain/model/UserModel.dart';

// MARK: - 유저 Impl
abstract class UserRepositoryImpl {
  // MARK: - 유저 생성
  Future<UserModel> createUser({required UserModel userModel});

  // MARK: - 유저 조회
  Future<UserModel> getUser({required String id});

  // MARK: - 유저 수정
  Future<UserModel> updateUser({required UserModel userModel});

  // MARK: - 내 정보 조회
  UserModel getMyInfo();
}