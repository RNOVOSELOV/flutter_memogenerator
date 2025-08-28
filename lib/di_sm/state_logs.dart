import 'package:talker_flutter/talker_flutter.dart';

class YxStateLog extends TalkerLog {
  YxStateLog(String super.message);

  @override
  String get title => 'YX_STATE';

  @override
  String get key => 'yx_state_log_key';

  @override
  AnsiPen get pen => AnsiPen()..magenta();
}
