import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/main.dart';

///
/// 2. Снятие выделения активного текста при нажатии вне текстовых блоков.
///     1. При нажатии на белый квадрат, вне областей с введенными текстами,
///        должно сбрасываться текущий выделенный текст.
///
void runTestLesson1Task2() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  testWidgets('module2', (WidgetTester tester) async {
    print("\n------------- Запускаем тест к 2 заданию 9-го урока -------------\n");

    await tester.pumpWidget(MyApp());

    final fabFinder = find.byType(FloatingActionButton);

    print("На странице MainPage находится единственный виджет с типом FloatingActionButton");
    expect(
      fabFinder,
      findsOneWidget,
      reason:
          "ОШИБКА! На странице MainPage невозможно найти единственный виджет с типом FloatingActionButton",
    );

    print("Нажимаем на найденную FloatingActionButton");

    await tester.tap(fabFinder);
    await tester.pumpAndSettle();

    print("На странице CreateMemePage находится единственная кнопка с текстом 'ДОБАВИТЬ ТЕКСТ'");
    final addMemeTextButtonFinder = find.text("ДОБАВИТЬ ТЕКСТ".toUpperCase());
    expect(
      addMemeTextButtonFinder,
      findsOneWidget,
      reason:
          "ОШИБКА! На странице CreateMemePage невозможно найти единственную кнопку с текстом 'ДОБАВИТЬ ТЕКСТ'",
    );

    print("Нажимаем на найденную кнопку с текстом 'ДОБАВИТЬ ТЕКСТ'");

    await tester.tap(addMemeTextButtonFinder);
    await tester.pumpAndSettle();

    final textFieldFinder = find.byType(TextField);

    final firstText = 'Первый текст';
    print("Вводим текст '$firstText' в TextField");
    await tester.enterText(textFieldFinder, firstText);
    await tester.pumpAndSettle(Duration(milliseconds: 100));

    print("Активным должен быть виджет с текстом '$firstText'");
    expect(
      tester.widget<TextField>(textFieldFinder).controller?.text,
      firstText,
      reason: "ОШИБКА! Текущий текст в TextField не совпадает с ожидаемым",
    );

    print("Нажимаем на найденную кнопку с текстом 'ДОБАВИТЬ ТЕКСТ'");

    await tester.tap(addMemeTextButtonFinder);
    await tester.pumpAndSettle();

    final secondText = 'Второй текст';
    print("Вводим текст '$secondText' в TextField");
    await tester.enterText(textFieldFinder, secondText);
    await tester.pumpAndSettle(Duration(milliseconds: 100));

    print("Активным должен быть виджет с текстом '$secondText'");
    expect(
      tester.widget<TextField>(textFieldFinder).controller?.text,
      secondText,
      reason: "ОШИБКА! Текущий текст в TextField не совпадает с ожидаемым",
    );

    print(
        "На странице CreateMemePage находится единственный виджет с типом Stack, являющийся потомком LayoutBuilder'а");
    final stackFinder = find.ancestor(
      of: find.byType(Stack),
      matching: find.byType(LayoutBuilder),
    );
    expect(
      stackFinder,
      findsOneWidget,
      reason:
          "ОШИБКА! На странице CreateMemePage невозможно найти единственный виджет с типом Stack",
    );

    final bottomRight = await tester.getBottomRight(stackFinder);
    await tester.tapAt(bottomRight - Offset(1, 1));
    await tester.pumpAndSettle();

    print(
        "При нажатии в нижний правый угол виджета Stack выделение текущего текста должно сбрасываться");
    expect(
      tester.widget<TextField>(textFieldFinder).controller?.text,
      "",
      reason:
          "ОШИБКА! После нажатия на правый угол виджета Stack остается выделенным текст ${tester.widget<TextField>(textFieldFinder).controller?.text}, а должен быть пустой текст",
    );

    print("------------- УСПЕХ! Тест пройден! -------------\n");
  });
}
