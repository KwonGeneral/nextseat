

import 'package:injectable/injectable.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/domain/model/UserModel.dart';
import 'package:nextseat/domain/repository/UserRepositoryImpl.dart';

// MARK: - 유저 수정 UseCase
@singleton
class UpdateUserUseCase {
  final UserRepositoryImpl userRepository;

  UpdateUserUseCase(this.userRepository);

  Future<UserModel?> call({required UserModel userModel}) async {
    try {
      return await userRepository.updateUser(userModel: userModel);
    } catch(e, s) {
      Log.e(e, s);
      return null;
    }
  }
}