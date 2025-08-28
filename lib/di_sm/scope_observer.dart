import 'package:flutter/foundation.dart';
import 'package:memogenerator/di_sm/scope_logs.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:yx_scope/yx_scope.dart';

final diObserver = DIObserver(talker: TalkerFlutter.init());

class DIObserver implements ScopeObserver, DepObserver, AsyncDepObserver {
  final Talker _talker;

  const DIObserver({required Talker talker}) : _talker = talker;

  void _log(String message, [Object? exception, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _talker.logCustom(YxScopeLog(message));
      if (exception != null) {
        _talker.logCustom(YxScopeLog(exception.toString()));
        if (stackTrace != null) {
          _talker.logCustom(YxScopeLog(stackTrace.toString()));
        }
      }
    }
  }

  @override
  void onScopeStartInitialize(ScopeId scope) =>
      _log('[$scope] -> onScopeStartInitialize');

  @override
  void onScopeInitialized(ScopeId scope) =>
      _log('[$scope] -> onScopeInitialized');

  @override
  void onScopeInitializeFailed(
    ScopeId scope,
    Object exception,
    StackTrace stackTrace,
  ) => _log('[$scope] -> onScopeInitializeFailed', exception, stackTrace);

  @override
  void onScopeStartDispose(ScopeId scope) =>
      _log('[$scope] -> onScopeStartDispose');

  @override
  void onScopeDisposed(ScopeId scope) => _log('[$scope] -> onScopeDisposed');

  @override
  void onScopeDisposeDepFailed(
    ScopeId scope,
    DepId dep,
    Object exception,
    StackTrace stackTrace,
  ) => _log('[$scope] -> onScopeDisposeDepFailed', exception, stackTrace);

  @override
  void onValueStartCreate(ScopeId scope, DepId dep) =>
      _log('[$scope.$dep] -> onValueStartCreate');

  @override
  void onValueCreated(ScopeId scope, DepId dep, ValueMeta? valueMeta) =>
      _log('[$scope.$dep] -> onValueCreated');

  @override
  void onValueCreateFailed(
    ScopeId scope,
    DepId dep,
    Object exception,
    StackTrace stackTrace,
  ) => _log('[$scope.$dep] -> onValueCreated', exception, stackTrace);

  @override
  void onValueCleared(ScopeId scope, DepId dep, ValueMeta? valueMeta) =>
      _log('[$scope.$dep]($valueMeta) -> onValueCleared');

  @override
  void onDepStartInitialize(ScopeId scope, DepId dep) =>
      _log('[$scope.$dep] -> onDepStartInitialize');

  @override
  void onDepInitialized(ScopeId scope, DepId dep) =>
      _log('[$scope.$dep] -> onDepInitialized');

  @override
  void onDepStartDispose(ScopeId scope, DepId dep) =>
      _log('[$scope.$dep] -> onDepStartDispose');

  @override
  void onDepDisposed(ScopeId scope, DepId dep) =>
      _log('[$scope.$dep] -> onDepDisposed');

  @override
  void onDepInitializeFailed(
    ScopeId scope,
    DepId dep,
    Object exception,
    StackTrace stackTrace,
  ) => _log('[$scope.$dep] -> onDepInitializeFailed', exception, stackTrace);

  @override
  void onDepDisposeFailed(
    ScopeId scope,
    DepId dep,
    Object exception,
    StackTrace stackTrace,
  ) => _log('[$scope.$dep] -> onDepDisposeFailed', exception, stackTrace);
}
