// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:nextseat/data/repository/ChatRepository.dart' as _i770;
import 'package:nextseat/data/repository/UserRepository.dart' as _i348;
import 'package:nextseat/domain/repository/ChatRepositoryImpl.dart' as _i634;
import 'package:nextseat/domain/repository/UserRepositoryImpl.dart' as _i37;
import 'package:nextseat/domain/usecase/chat/GetChatMessageListUseCase.dart'
    as _i140;
import 'package:nextseat/domain/usecase/chat/SendChatMessageUseCase.dart'
    as _i928;
import 'package:nextseat/domain/usecase/user/GetMyInfoUseCase.dart' as _i619;
import 'package:nextseat/domain/usecase/user/UpdateMyInfoUseCase.dart' as _i47;

const String _dev = 'dev';
const String _deploy = 'deploy';

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt initGetIt({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i634.ChatRepositoryImpl>(
      () => _i770.ChatRepository(),
      registerFor: {
        _dev,
        _deploy,
      },
    );
    gh.singleton<_i37.UserRepositoryImpl>(
      () => _i348.UserRepository(),
      registerFor: {
        _dev,
        _deploy,
      },
    );
    gh.singleton<_i619.GetMyInfoUseCase>(
        () => _i619.GetMyInfoUseCase(gh<_i37.UserRepositoryImpl>()));
    gh.singleton<_i47.UpdateMyInfoUseCase>(
        () => _i47.UpdateMyInfoUseCase(gh<_i37.UserRepositoryImpl>()));
    gh.singleton<_i140.GetChatMessageListUseCase>(
        () => _i140.GetChatMessageListUseCase(gh<_i634.ChatRepositoryImpl>()));
    gh.singleton<_i928.SendChatMessageUseCase>(
        () => _i928.SendChatMessageUseCase(gh<_i634.ChatRepositoryImpl>()));
    return this;
  }
}
