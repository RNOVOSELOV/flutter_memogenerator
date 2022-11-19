import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/main.dart';
import 'package:memogenerator/pages/create_meme_page.dart';

import '../shared/internal/container_checks.dart';
import 'shared_colors.dart';

///
/// 1. Делать активным тот текст, который мы перетаскиваем по экрану
///     1. Выделять тот текст, который начали тащить (делать драг) по экрану
///
void runTestLesson1Task1() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  testWidgets('module1', (WidgetTester tester) async {
    print("\n------------- Запускаем тест к 1 заданию 9-го урока -------------\n");

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

    final addTextText = 'ДОБАВИТЬ ТЕКСТ';
    print("На странице CreateMemePage находится единственная кнопка с текстом '$addTextText'");
    final addMemeTextButtonFinder = find.text(addTextText);
    expect(
      addMemeTextButtonFinder,
      findsOneWidget,
      reason:
          "ОШИБКА! На странице CreateMemePage невозможно найти единственную кнопку с текстом '$addTextText'",
    );

    print("На странице CreateMemePage находится единственный виджет с типом TextField");
    final textFieldFinder = find.byType(TextField);
    expect(
      textFieldFinder,
      findsOneWidget,
      reason:
          "ОШИБКА! На странице CreateMemePage невозможно найти единственный виджет с типом TextField",
    );

    final firstText = 'Первый текст';
    await _addMemeTextWithText(tester, addMemeTextButtonFinder, textFieldFinder, firstText);

    final draggableMemeTextWithFirstTextFinder = find.widgetWithText(DraggableMemeText, firstText);

    print("Находим единственный виджет DraggableMemeText с текстом '$firstText'");
    expect(
      draggableMemeTextWithFirstTextFinder,
      findsOneWidget,
      reason:
          "ОШИБКА! На странице CreateMemePage невозможно найти единственный виджет DraggableMemeText с текстом '$firstText'",
    );

    print("Двигаем DraggableMemeText с текстом '$firstText' вниз на 100");
    await tester.drag(draggableMemeTextWithFirstTextFinder, Offset(0, 100));
    await tester.pumpAndSettle();

    final secondText = 'Второй текст';
    await _addMemeTextWithText(tester, addMemeTextButtonFinder, textFieldFinder, secondText);

    print("Выделенным должен быть виджет с текстом '$secondText'");
    expect(
      tester.widget<TextField>(textFieldFinder).controller?.text,
      secondText,
      reason: "ОШИБКА! Текущий текст в TextField не совпадает с ожидаемым",
    );

    print("Двигаем DraggableMemeText с текстом '$firstText' вниз на 100");
    await tester.drag(draggableMemeTextWithFirstTextFinder, Offset(0, 100));
    await tester.pumpAndSettle();

    print("Выделенным должен быть виджет с текстом '$firstText'");
    expect(
      tester.widget<TextField>(textFieldFinder).controller?.text,
      firstText,
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
