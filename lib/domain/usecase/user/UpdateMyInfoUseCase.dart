

import 'package:injectable/injectable.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/domain/model/UserModel.dart';
import 'package:nextseat/domain/repository/UserRepositoryImpl.dart';

// MARK: - 내 정보 수정 UseCase
@singleton
class UpdateMyInfoUseCase {
  final UserRepositoryImpl userRepository;

  UpdateMyInfoUseCase(this.userRepository);

  Future<UserModel?> call({required String? name, required String? number}) async {
    try {
      return await userRepository.updateMyInfo(
        name: name,
        number: number,
      );
    } catch(e, s) {
      Log.e(e, s);
      return null;
    }
  }
}