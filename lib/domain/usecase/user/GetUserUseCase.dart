

import 'package:injectable/injectable.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/domain/model/UserModel.dart';
import 'package:nextseat/domain/repository/UserRepositoryImpl.dart';

// MARK: - 유저 조회 UseCase
@singleton
class GetUserUseCase {
  final UserRepositoryImpl userRepository;

  GetUserUseCase(this.userRepository);

  Future<UserModel?> call({required String id}) async {
    try {
      return await userRepository.getUser(id: id);
    } catch(e, s) {
      Log.e(e, s);
      return null;
    }
  }
}