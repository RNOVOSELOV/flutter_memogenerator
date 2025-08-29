import 'package:memogenerator/di_sm/state_logs.dart';
import 'package:talker/talker.dart';
import 'package:yx_state/yx_state.dart';

class LoggingObserver extends StateManagerObserver {
  final Talker _talker;

  const LoggingObserver({required final Talker talker}) : _talker = talker;

  @override
  void onChange(
    StateManagerBase<Object?> stateManager,
    Object? currentState,
    Object? nextState,
    Object? identifier,
  ) {
    _talker.logCustom(
      YxStateLog('${stateManager.runtimeType}: $currentState -> $nextState'),
    );
    super.onChange(stateManager, currentState, nextState, identifier);
  }

  @override
  void onError(
    StateManagerBase<Object?> stateManager,
    Object error,
    StackTrace stackTrace,
    Object? identifier,
  ) {
    _talker.error('ERROR IN ${stateManager.runtimeType}: $error \n$stackTrace');
    super.onError(stateManager, error, stackTrace, identifier);
  }
}
