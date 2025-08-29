import 'package:memogenerator/data/http/api_service.dart';
import 'package:memogenerator/data/http/dio_builder.dart';
import 'package:memogenerator/data/shared_pref/repositories/memes/memes_repository.dart';
import 'package:memogenerator/data/shared_pref/repositories/templates/templates_repository.dart';
import 'package:memogenerator/data/shared_pref/shared_preference_data.dart';
import 'package:memogenerator/domain/interactors/copy_unique_file_interactor.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:yx_scope/yx_scope.dart';

import '../data/http/domain/api_repository.dart';
import '../domain/interactors/meme_interactor.dart';
import '../domain/interactors/template_interactor.dart';
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

  late final copyFileInteractorDep = dep(() => CopyUniqueFileInteractor());
  late final memesInteractorDep = dep(
    () => MemeInteractor(
      memeRepository: memeRepositoryDep.get,
      copyUniqueFileInteractor: copyFileInteractorDep.get,
    ),
  );
  late final templatesInteractorDep = dep(
    () => TemplateInteractor(
      templateRepository: templateRepositoryDep.get,
      copyUniqueFileInteractor: copyFileInteractorDep.get,
    ),
  );

  late final _apiServiceDep = dep(
    () => ApiService(
      dio: DioBuilder(
        talker: talkerDep.get,
      ).addHeaderParameters().addAuthorizationInterceptor().build(),
      talker: talkerDep.get,
    ),
  );
  late final memeApiRepositoryDep = dep(
    () => ApiRepository(dataProvider: _apiServiceDep.get),
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
