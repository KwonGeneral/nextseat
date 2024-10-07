// ignore_for_file: constant_identifier_names

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:nextseat/common/contains/Env.dart';
import 'package:nextseat/data/repository/ChatRepository.dart';
import 'package:nextseat/data/repository/UserRepository.dart';
import 'package:nextseat/domain/repository/ChatRepositoryImpl.dart';
import 'package:nextseat/domain/repository/UserRepositoryImpl.dart';

import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  // 초기화 함수 이름 설정
  initializerName: 'initGetIt',
)
Future<void> _getItInit() async {
  // MARK: - Repository
  if (Env.TARGET_ENV == Env.DEV || Env.TARGET_ENV == Env.DEPLOY) {
    getIt.registerLazySingleton<ChatRepositoryImpl>(() => ChatRepository());
    getIt.registerLazySingleton<UserRepositoryImpl>(() => UserRepository());
  } else {
    getIt.registerLazySingleton<ChatRepositoryImpl>(() => ChatRepository());
    getIt.registerLazySingleton<UserRepositoryImpl>(() => UserRepository());
  }

  // MARK: - 의존성 주입 설정
  getIt.initGetIt();
}

// MARK: - 의존성 역전 셋팅
Future<void> getItSetup() async {
  _getItInit();
}
