import 'package:flutter/foundation.dart';
import 'package:memogenerator/data/repositories/download_repository_impl.dart';
import 'package:memogenerator/di_sm/app_scope.dart';
import 'package:memogenerator/domain/repositories/download_repository.dart';
import 'package:yx_scope/yx_scope.dart';

import '../data/http/api_datasource_impl.dart';
import '../data/http/api_service.dart';
import '../data/http/dio_builder.dart';

abstract class ApiDataScope implements Scope {
  DownloadRepository get downloadRepository;
}

class ApiScopeContainer extends ChildScopeContainer<AppScopeContainer>
    implements ApiDataScope {
  ApiScopeContainer({required super.parent});

  late final _apiServiceDep = dep(
    () => ApiService(
      dio: DioBuilder(
        talker: parent.talkerDep.get,
      ).addHeaderParameters().addAuthorizationInterceptor().build(),
      talker: parent.talkerDep.get,
    ),
  );

  late final _memeApiDatasourceDep = dep(
    () => ApiDatasourceImpl(dataProvider: _apiServiceDep.get),
  );

  late final _downloadRepositoryDep = dep(
    () => DownloadRepositoryImp(
      templateDatasource: parent.templateScopeModule.templateDatasourceDep.get,
      imageDatasource: kIsWeb
          ? parent.datasourceScopeModule.spImagesDatasourceDep.get
          : parent.datasourceScopeModule.fileSystemDatasourceDep.get,
      templatesRepository:
          parent.templateScopeModule.templateRepositoryImpl.get,
      apiDatasource: _memeApiDatasourceDep.get,
    ),
  );

  @override
  DownloadRepository get downloadRepository => _downloadRepositoryDep.get;
}
