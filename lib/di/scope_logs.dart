import 'package:talker_flutter/talker_flutter.dart';

class YxScopeLog extends TalkerLog {
  YxScopeLog(String super.message);

  @override
  String get title => 'YX_SCOPE';

  @override
  String get key => 'yx_scope_log_key';

  @override
  AnsiPen get pen => AnsiPen()..cyan();
}
