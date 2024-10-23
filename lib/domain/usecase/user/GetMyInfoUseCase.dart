

import 'package:injectable/injectable.dart';
import 'package:nextseat/common/utils/Log.dart';
import 'package:nextseat/domain/model/UserModel.dart';
import 'package:nextseat/domain/repository/UserRepositoryImpl.dart';

// MARK: - 내 정보 조회 UseCase
@singleton
class GetMyInfoUseCase {
  final UserRepositoryImpl userRepository;

  GetMyInfoUseCase(this.userRepository);

  Future<UserModel> call() async {
    try {
      return userRepository.getMyInfo();
    } catch(e, s) {
      Log.e(e, s);
      return UserModel.empty();
    }
  }
}