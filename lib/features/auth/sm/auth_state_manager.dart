import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:memogenerator/features/auth/sm/auth_state.dart';
import 'package:talker/talker.dart';
import 'package:yx_state/yx_state.dart';

import '../../../data/datasources/settings_datasource.dart';
import '../../../domain/di/user_scope_holder.dart';

class AuthStateManager extends StateManager<AuthState> {
  final SettingsDatasource _settingsDatasource;
  final UserStateHolder _authZoneScopeHolder;
  final Talker _talker;
  late final bool _useBio;

  AuthStateManager(
    super.state, {
    required final SettingsDatasource settingsDatasource,
    required final UserStateHolder authZoneScopeHolder,
    required final Talker talker,
  }) : _settingsDatasource = settingsDatasource,
       _authZoneScopeHolder = authZoneScopeHolder,
       _talker = talker;

  Future<void> init() async {
    final data = (await _settingsDatasource.getSettings()).toSettings();
    _useBio = data.useBiometry;
  }

  Future<void> launchAuth() => handle((emit) async {
    if (_useBio) {
      await _authenticate(emit);
    } else {
      await openAuthZone(emit);
    }
  });

  Future<void> openAuthZone(Emitter<AuthState> emit) async {
    await _authZoneScopeHolder.toggle();
    emit(OpenApplicationState());
  }

  Future<void> repeatAuth() =>
      handle((emit) async => await _authenticate(emit));

  Future<void> _authenticate(Emitter<AuthState> emit) async {
    final LocalAuthentication auth = LocalAuthentication();
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    final List<BiometricType> availableBiometrics = await auth
        .getAvailableBiometrics();
    final bool isSomeBioMethodAvailable =
        canAuthenticate && availableBiometrics.isNotEmpty;
    if (isSomeBioMethodAvailable) {
      try {
        final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Пройдите аутентификацию для входа в приложение',
          options: const AuthenticationOptions(
            useErrorDialogs: false,
            biometricOnly: true,
          ),
        );
        if (didAuthenticate) {
          openAuthZone(emit);
        } else {
          emit(AuthFailedState());
        }
        _talker.info(
          'PIN/TOUCH/FACE result: $canAuthenticateWithBiometrics $canAuthenticate $availableBiometrics $didAuthenticate',
        );
        // ···
      } on PlatformException catch (e) {
        _talker.error(
          'PIN/TOUCH/FACE result: $canAuthenticateWithBiometrics $canAuthenticate $availableBiometrics $e',
        );
        emit(AuthFailedState());
      }
    } else {
      openAuthZone(emit);
    }
  }
}
