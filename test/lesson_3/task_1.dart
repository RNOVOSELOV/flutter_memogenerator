import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/presentation/create_meme/create_meme_page.dart';
import 'package:memogenerator/presentation/create_meme/font_settings_bottom_sheet.dart';

import '../shared/test_helpers.dart';

///
/// 1. Скругление краев у Bottom Sheet
///     1. Добавить скругление верхних углов у Bottom Sheet с радиусом 24 с
///        помощью нужного параметра из showModalBottomSheet
///     2. Добиться того, чтобы скругление было видно. Подсказка: надо удалить
///        указание цвета в в одном из виджетов.
///
void runTestLesson3Task1() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  testWidgets('module1', (WidgetTester tester) async {
    // change screen size to avoid pixel overflow.
    // Got from https://stackoverflow.com/a/62460566/4312184
    final width = 411.4;
    final height = 797.7;
    tester.binding.window.devicePixelRatioTestValue = 2.625;
    tester.binding.window.textScaleFactorTestValue = 1.1;
    final dpi = tester.binding.window.devicePixelRatio;
    tester.binding.window.physicalSizeTestValue =
        Size(width * dpi, height * dpi);

    fancyPrint(
      "Запускаем тест к 1 заданию 11-го урока",
      printType: PrintType.startEnd,
    );

    fancyPrint("Открываем страницу CreateMemePage");
    await tester.pumpWidget(MaterialApp(home: CreateMemePage()));

    final addTextText = 'ДОБАВИТЬ ТЕКСТ';
    fancyPrint(
        "На странице CreateMemePage находится единственная кнопка с текстом '$addTextText'");
    final addMemeTextButtonFinder = find.text(addTextText);
    expect(
      addMemeTextButtonFinder,
      findsOneWidget,
      reason:
          "ОШИБКА! На странице CreateMemePage невозможно найти единственную кнопку с текстом '$addTextText'",
    );

    fancyPrint("Нажимаем на кнопку с текстом 'ДОБАВИТЬ ТЕКСТ'");

    await tester.tap(addMemeTextButtonFinder);
    await tester.pumpAndSettle();

    fancyPrint(
        "На странице CreateMemePage находится единственный виджет с типом Icon с иконкой Icons.font_download_outlined");
    final changeFontSettingsIconFinder = find.byWidgetPredicate((widget) {
      return widget is Icon && widget.icon == Icons.font_download_outlined;
    });
    expect(
      changeFontSettingsIconFinder,
      findsOneWidget,
      reason:
          "ОШИБКА! На странице CreateMemePage невозможно найти единственный виджет с типом Icon с иконкой Icons.font_download_outlined",
    );

    fancyPrint("Нажимаем на вджет Icon с иконкой Icons.font_download_outlined");

    await tester.tap(changeFontSettingsIconFinder);
    await tester.pumpAndSettle();

    fancyPrint(
        "Ожидаем увидеть виджет BottomSheet (он создается автоматически при вызове метода showModalBottomSheet)");

    final bottomSheetFinder = find.byType(BottomSheet);
    expect(
      bottomSheetFinder,
      findsOneWidget,
      reason: "ОШИБКА! Невозможно найти виджет BottomSheet",
    );

    fancyPrint("BottomSheet имеет shape не равный null");

    final bottomSheet = tester.widget<BottomSheet>(bottomSheetFinder);
    expect(
      bottomSheet.shape,
      isNotNull,
      reason: "ОШИБКА! BottomSheet имеет shape равный null",
    );

    fancyPrint("BottomSheet имеет корректный shape");

    expect(
      bottomSheet.shape,
      RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      reason: "ОШИБКА! BottomSheet имеет некорректный shape",
    );

    fancyPrint(
        "В FontSettingBottomSheet не должно быть виджета Container с заданным белым цветом, иначе скругление углов не будет видно");

    final containerWithIncorrectBackground = find.descendant(
      of: find.byType(FontSettingBottomSheet),
      matching: find.ancestor(
          of: find.byType(Column),
          matching: find.byWidgetPredicate(
              (widget) => widget is Container && widget.color == Colors.white)),
    );

    expect(
      containerWithIncorrectBackground,
      findsNothing,
      reason:
          "ОШИБКА! В FontSettingBottomSheet пристутсвтвует лишний Container с цветом",
    );

    fancyPrint(
      "УСПЕХ! Тест пройден!",
      printType: PrintType.startEnd,
    );
  });
}
