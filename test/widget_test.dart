import 'package:flutter_test/flutter_test.dart';

import 'lesson_4/task_1.dart';
import 'lesson_4/task_2.dart';
import 'lesson_4/task_3.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  group("l12h01", () => runTestLesson4Task1());
  group("l12h02", () => runTestLesson4Task2());
  group("l12h03", () => runTestLesson4Task3());
}
