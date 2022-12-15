import 'package:flutter_test/flutter_test.dart';
import 'package:memogenerator/presentation/create_meme/create_meme_page.dart';

import '../shared/test_helpers.dart';

Future<void> addMemeTextWithText(
  final WidgetTester tester,
  final Finder addMemeTextButtonFinder,
  final Finder textFieldFinder,
  final String text,
) async {
  fancyPrint("Нажимаем на кнопку с текстом 'ДОБАВИТЬ ТЕКСТ'");

  await tester.tap(addMemeTextButtonFinder);
  await tester.pumpAndSettle();

  fancyPrint("Вводим текст '$text' в TextField");
  await tester.enterText(textFieldFinder, text);
  await tester.pumpAndSettle(Duration(milliseconds: 100));
}

Future<void> checkThatCreateMemePageIsOpened() async {
  fancyPrint("Ожидаем, что CreateMemePage открыт");
  expect(
    find.byType(CreateMemePage),
    findsOneWidget,
    reason: "ОШИБКА! CreateMemePage не открылся, хотя должен был",
  );
}
