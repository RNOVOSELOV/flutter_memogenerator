import 'package:flutter/foundation.dart';
import 'package:memogenerator/data/browser/sp_images_datasource.dart';
import 'package:memogenerator/data/browser/sp_images_datasource_impl.dart';
import 'package:memogenerator/data/filesystem/fs_images_datasource_impl.dart';
import 'package:memogenerator/data/repositories/meme_repository_impl.dart';
import 'package:memogenerator/data/repositories/template_repository_impl.dart';
import 'package:memogenerator/data/shared_pref/datasources/settings/settings_datasource_impl.dart';
import 'package:memogenerator/di_sm/application_sm/application_sm.dart';
import 'package:memogenerator/di_sm/application_sm/settings_data.dart';
import 'package:memogenerator/features/auth/sm/auth_state.dart';
import 'package:memogenerator/features/auth/sm/auth_state_manager.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:yx_scope/yx_scope.dart';

import '../data/shared_pref/datasources/memes/meme_datasource_impl.dart';
import '../data/shared_pref/datasources/templates/templates_datasource_impl.dart';
import '../data/shared_pref/shared_preference_data.dart';
import '../domain/di/user_scope_holder.dart';
import 'scope_observer.dart' show diObserver;

class AppScopeHolder extends ScopeHolder<AppScopeContainer> {
  AppScopeHolder()
      : super(
    scopeObservers: [diObserver],
    asyncDepObservers: [diObserver],
    depObservers: [diObserver],
  );

  @override
  AppScopeContainer createContainer() => AppScopeContainer();
}

class AppScopeContainer extends ScopeContainer {
  @override
  List<Set<AsyncDep>> get initializeQueue => [
    {sharedPreferencesDataDep},
    {appStateManager, authScopeModule.authStateManager},
  ];

  late final talkerDep = dep(() => TalkerFlutter.init());
  late final sharedPreferencesDataDep = rawAsyncDep(
    () => SharedPreferenceData(),
    init: (dep) async => await dep.init(),
    dispose: (dep) async {},
  );

  late final settingsDatasourceDep = dep(
    () => SettingsDataSourceImpl(
      settingsDataProvider: sharedPreferencesDataDep.get,
    ),
  );

  late final appStateManager = rawAsyncDep(
    () => ApplicationStateManager(
      ApplicationState(settingsData: SettingsData.defaultData()),
      settingsData: settingsDatasourceDep.get,
    ),
    init: (dep) async => await dep.init(),
    dispose: (dep) async {},
  );

  late final authStateHolderDep = dep(() => UserScopeHolder(this));
  late final authScopeModule = AuthScopeModule(this);
}

class AuthScopeModule extends ScopeModule<AppScopeContainer> {
  AuthScopeModule(super.container);

  late final authStateManager = rawAsyncDep(
    () => AuthStateManager(
      AuthInitialState(),
      authZoneScopeHolder: container.authStateHolderDep.get,
      settingsDatasource: container.settingsDatasourceDep.get,
      talker: container.talkerDep.get,
    ),
    init: (dep) async => await dep.init(),
    dispose: (dep) async {},
  );
}
