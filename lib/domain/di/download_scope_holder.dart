import 'package:memogenerator/di_sm/auth_scope.dart';
import 'package:yx_scope/yx_scope.dart';

import '../../di_sm/download_scope.dart';
import '../../di_sm/scope_observer.dart';
import '../repositories/download_repository.dart';

abstract class ApiStateHolder {
  Future<void> toggle();

  DownloadRepository get downloadRepository;
}

class ApiScopeHolder
    extends
        BaseChildScopeHolder<
          ApiDataScope,
          ApiScopeContainer,
          UserScopeContainer
        >
    implements ApiStateHolder {
  ApiScopeHolder(super.parent)
    : super(
        scopeObservers: [diObserver],
        asyncDepObservers: [diObserver],
        depObservers: [diObserver],
      );

  @override
  ApiScopeContainer createContainer(UserScopeContainer parent) =>
      ApiScopeContainer(parent: parent);

  @override
  DownloadRepository get downloadRepository => scope!.downloadRepository;

  @override
  Future<void> toggle() async {
    if (scope == null) {
      await create();
    } else {
      await drop();
    }
  }
}
