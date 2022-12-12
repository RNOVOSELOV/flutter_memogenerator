import 'package:flutter_test/flutter_test.dart';

import 'lesson_2/task_1.dart';
import 'lesson_2/task_2.dart';
import 'lesson_2/task_3.dart';
import 'lesson_2/task_4.dart';

void main() async {
  group("l10h01", () => runTestLesson2Task1());
  group("l10h02", () => runTestLesson2Task2());
  group("l10h03", () => runTestLesson2Task3());
  group("l10h04", () => runTestLesson2Task4());
}
