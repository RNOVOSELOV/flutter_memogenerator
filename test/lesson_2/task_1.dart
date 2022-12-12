import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/presentation/create_meme/create_meme_page.dart';

///
/// 1. Выделять текст при нажатии в нижнем списке
///    Обязательное, 1 балл
///    1. При нажатии на текст в нижнем списке, делать этот текст выделенным
///
void runTestLesson2Task1() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  testWidgets('module1', (WidgetTester tester) async {
    print(
        "\n------------- Запускаем тест к 1 заданию 10-го урока -------------\n");

    print("Открываем страницу CreateMemePage");
    await tester.pumpWidget(MaterialApp(home: CreateMemePage()));

    final addTextText = 'ДОБАВИТЬ ТЕКСТ';
    print(
        "На странице CreateMemePage находится единственная кнопка с текстом '$addTextText'");
    final addMemeTextButtonFinder = find.text(addTextText);
    expect(
      addMemeTextButtonFinder,
      findsOneWidget,
      reason:
          "ОШИБКА! На странице CreateMemePage невозможно найти единственную кнопку с текстом '$addTextText'",
    );

    print(
        "На странице CreateMemePage находится единственный виджет с типом TextField");
    final textFieldFinder = find.byType(TextField);
    expect(
      textFieldFinder,
      findsOneWidget,
      reason:
          "ОШИБКА! На странице CreateMemePage невозможно найти единственный виджет с типом TextField",
    );

    final firstText = 'Первый текст';
    await _addMemeTextWithText(
        tester, addMemeTextButtonFinder, textFieldFinder, firstText);

    final secondText = 'Второй текст';
    await _addMemeTextWithText(
        tester, addMemeTextButtonFinder, textFieldFinder, secondText);

    print("Выделенным должен быть виджет с текстом '$secondText'");
    expect(
      tester.widget<TextField>(textFieldFinder).controller?.text,
      secondText,
      reason: "ОШИБКА! Текущий текст в TextField не совпадает с ожидаемым",
    );

    final bottomMemeTextWithFirstTextFinder =
        find.widgetWithText(BottomMemeText, firstText);

    print("Находим единственный виджет BottomMemeText с текстом '$firstText'");
    expect(
      bottomMemeTextWithFirstTextFinder,
      findsOneWidget,
      reason:
          "ОШИБКА! На странице CreateMemePage невозможно найти единственный виджет BottomMemeText с текстом '$firstText'",
    );

    print("Нажимаем на центр найденного BottomMemeText");
    await tester.tapAt(tester.getCenter(bottomMemeTextWithFirstTextFinder));
    await tester.pumpAndSettle(Duration(milliseconds: 100));

    print("Выделенным должен быть виджет с текстом '$firstText'");
    expect(
      tester.widget<TextField>(textFieldFinder).controller?.text,
      firstText,
      reason: "ОШИБКА! Текущий текст в TextField не совпадает с ожидаемым",
    );

    final bottomMemeTextWithSecondTextFinder =
        find.widgetWithText(BottomMemeText, secondText);

    print("Находим единственный виджет BottomMemeText с текстом '$secondText'");
    expect(
      bottomMemeTextWithSecondTextFinder,
      findsOneWidget,
      reason:
          "ОШИБКА! На странице CreateMemePage невозможно найти единственный виджет BottomMemeText с текстом '$secondText'",
    );

    print("Тапаем на центр найденного BottomMemeText");
    await tester.tapAt(tester.getCenter(bottomMemeTextWithSecondTextFinder));
    await tester.pumpAndSettle(Duration(milliseconds: 100));

    print("Выделенным должен быть виджет с текстом '$secondText'");
    expect(
      tester.widget<TextField>(textFieldFinder).controller?.text,
      secondText,
      reason: "ОШИБКА! Текущий текст в TextField не совпадает с ожидаемым",
    );

    print("------------- УСПЕХ! Тест пройден! -------------\n");
  });
}

Future<void> _addMemeTextWithText(
  final WidgetTester tester,
  final Finder addMemeTextButtonFinder,
  final Finder textFieldFinder,
  final String firstText,
) async {
  print("Нажимаем на кнопку с текстом 'ДОБАВИТЬ ТЕКСТ'");

  await tester.tap(addMemeTextButtonFinder);
  await tester.pumpAndSettle();

  print("Вводим текст '$firstText' в TextField");
  await tester.enterText(textFieldFinder, firstText);
  await tester.pumpAndSettle(Duration(milliseconds: 100));
}
