import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/main.dart';
import 'package:memogenerator/pages/create_meme_page.dart';

import '../shared/test_helpers.dart';
import 'shared_colors.dart';

///
/// 3. Выделять текущий редактируемый виджет с текстом на фоне белого квадрата.
///     1. Выделять текущий выделенный текст в центральном виджете.
///         1. Цвет подложки Dark Grey 16%.
///         2. Граница вокруг с цветом Fuchsia и толщиной 1
///     2. Убрать выделение вокруг остальных текстов в центральном виджете.
///         1. Цвет подложки прозрачный
///         2. Границы вокруг быть не должно
///     3. Для задания нужного цвета и бордера используйте Container,
///        находящийся внутри DraggableMemeText
///
void runTestLesson1Task3() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  testWidgets('module3', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    print("\n------------- Запускаем тест к 3 заданию 9-го урока -------------\n");

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

    print(
        '---------- Проверяем правильно ли выглядит активный виджет с текстом "$firstText" ----------');

    _checkActiveWidgetWithText(tester, firstText);

    print("Нажимаем на кнопку с текстом 'ДОБАВИТЬ ТЕКСТ' еще раз");

    await tester.tap(addMemeTextButtonFinder);
    await tester.pumpAndSettle();

    final secondText = 'Второй текст';
    print("Вводим текст '$secondText' в TextField");
    await tester.enterText(textFieldFinder, secondText);
    await tester.pumpAndSettle(Duration(milliseconds: 100));

    print(
        '---------- Проверяем правильно ли выглядит активный виджет с текстом "$secondText" ----------');

    _checkActiveWidgetWithText(tester, secondText);

    print(
        '---------- Проверяем правильно ли выглядит неактивный виджет с текстом "$firstText" ----------');

    _checkInactiveWidgetWithText(tester, firstText);

    print("------------- УСПЕХ! Тест пройден! -------------\n");
  });
}

void _checkActiveWidgetWithText(final WidgetTester tester, final String enteredText) {
  final draggableMemeTextWithEnteredTextFinder =
      find.widgetWithText(DraggableMemeText, enteredText);

  print("Находим единственный виджет DraggableMemeText с текстом '$enteredText'");
  expect(
    draggableMemeTextWithEnteredTextFinder,
    findsOneWidget,
    reason:
        "ОШИБКА! На странице CreateMemePage невозможно найти единственный виджет DraggableMemeText с текстом '$enteredText'",
  );

  final containerInsideDraggableMemeTextFinder = find.descendant(
    of: draggableMemeTextWithEnteredTextFinder,
    matching: find.byType(Container),
  );

  print("Находим единственный виджет Container внутри DraggableMemeText");
  expect(
    containerInsideDraggableMemeTextFinder,
    findsOneWidget,
    reason: "ОШИБКА! В виджете DraggableMemeText невозможно найти единственный виджет Container",
  );

  final selectedContainer = tester.widget<Container>(containerInsideDraggableMemeTextFinder);

  checkContainerDecorationColor(
    container: selectedContainer,
    color: darkGrey16_1,
    secondColor: darkGrey16_2,
    colorName: "Dark Grey 16%",
  );

  checkContainerBorder(
    container: selectedContainer,
    border: Border.all(color: fuchsia, width: 1),
    borderName: "с цветом Fuchsia и толщиной 1",
  );
}

void _checkInactiveWidgetWithText(final WidgetTester tester, final String enteredText) {
  final draggableMemeTextWithEnteredTextFinder =
      find.widgetWithText(DraggableMemeText, enteredText);

  print("Находим единственный виджет DraggableMemeText с текстом '$enteredText'");
  expect(
    draggableMemeTextWithEnteredTextFinder,
    findsOneWidget,
    reason:
        "ОШИБКА! На странице CreateMemePage невозможно найти единственный виджет DraggableMemeText с текстом '$enteredText'",
  );

  final containerInsideDraggableMemeTextFinder = find.descendant(
    of: draggableMemeTextWithEnteredTextFinder,
    matching: find.byType(Container),
  );

  print("Находим единственный виджет Container внутри DraggableMemeText");
  expect(
    containerInsideDraggableMemeTextFinder,
    findsOneWidget,
    reason: "ОШИБКА! В виджете DraggableMemeText невозможно найти единственный виджет Container",
  );

  final selectedContainer = tester.widget<Container>(containerInsideDraggableMemeTextFinder);

  if (selectedContainer.color != null && selectedContainer.decoration == null) {
    print("В случае если color != null, он должен иметь нулевую прозрачность");
    expect(
      selectedContainer.color!.alpha,
      0,
      reason: "ОШИБКА! Указанный цвет имеет не полностью прозрачен",
    );
  } else if (selectedContainer.color == null && selectedContainer.decoration != null) {
    checkContainerHaveDecorationOfTypeBoxDecoration(selectedContainer, "Container");
    final border = (selectedContainer.decoration as BoxDecoration).border;
    if (border == null) {
      // это ок
    } else {
      checkContainerHaveBorderInDecorationOfTypeBorder(selectedContainer, "Container");
      print("В случае если border внутри decoration != null, он должен иметь нулевую прозрачность");
      expect(
        border.bottom.color.alpha,
        0,
        reason: "ОШИБКА! Указанный цвет имеет не полностью прозрачен",
      );
    }

    final color = (selectedContainer.decoration as BoxDecoration).color;
    if (color == null) {
      // это ок
    } else {
      print("В случае если color внутри decoration != null, он должен иметь нулевую прозрачность");
      expect(
        color.alpha,
        0,
        reason: "ОШИБКА! Указанный цвет имеет не полностью прозрачен",
      );
    }
  } else if (selectedContainer.color == null && selectedContainer.decoration == null) {
    // это ок
  } else {
    // если определены и color и decoration, то flutter сам выкинет ошибку
  }
}
