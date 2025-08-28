import 'package:memogenerator/data/shared_pref/repositories/memes/memes_repository.dart';
import 'package:memogenerator/data/shared_pref/repositories/templates/templates_repository.dart';
import 'package:memogenerator/data/shared_pref/shared_preference_data.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:yx_scope/yx_scope.dart';

import 'scope_observer.dart' show diObserver;

class AppScopeContainer extends ScopeContainer {
  late final talkerDep = dep(() => TalkerFlutter.init());
  late final _sharedPreferencesDep = dep(() => SharedPreferenceData());
  late final memeRepositoryDep = dep(
    () => MemesRepository(memeDataProvider: _sharedPreferencesDep.get),
  );
  late final templateRepositoryDep = dep(
    () => TemplatesRepository(templateDataProvider: _sharedPreferencesDep.get),
  );
}

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
