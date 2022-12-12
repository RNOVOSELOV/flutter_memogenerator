import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/presentation/create_meme/create_meme_page.dart';

///
/// 2. Сохранять изначальную позицию текста при добавлении
///    Обязательное, 1 балл
///    1. После добавлении нового текста с помощью кнопки ДОБАВИТЬ, сохраняем
///       изначальную позицию, которую занял текст в bloc
///
void runTestLesson2Task2() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  testWidgets('module2', (WidgetTester tester) async {
    print(
        "\n------------- Запускаем тест к 2 заданию 10-го урока -------------\n");

    await tester.pumpWidget(MaterialApp(home: CreateMemePage()));

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

    final draggableMemeTextWithEnteredTextFinder =
        find.widgetWithText(DraggableMemeText, firstText);

    final aspectRatioFinder = find.byType(AspectRatio);
    print("Находим единственный виджет AspectRatio");
    expect(
      draggableMemeTextWithEnteredTextFinder,
      findsOneWidget,
      reason:
          "ОШИБКА! На странице CreateMemePage невозможно найти единственный виджет AspectRatio",
    );

    final aspectRatioPosition = tester.getTopLeft(aspectRatioFinder);

    print(
        "Находим единственный виджет DraggableMemeText с текстом '$firstText'");
    expect(
      draggableMemeTextWithEnteredTextFinder,
      findsOneWidget,
      reason:
          "ОШИБКА! На странице CreateMemePage невозможно найти единственный виджет DraggableMemeText с текстом '$firstText'",
    );

    print("Вычисляем начальную позицию этого виджета глобально");
    final absoluteOffset =
        tester.getTopLeft(draggableMemeTextWithEnteredTextFinder);
    print(
        "Вычисляем начальную позицию этого виджета локально, по отношению к позиции AspectRatio");

    final relativeOffset = absoluteOffset - aspectRatioPosition;
    final relativeOffsetWithOneDecimalPoint = Offset(
      roundDoubleToFixedDecimalPoints(relativeOffset.dx, 1),
      roundDoubleToFixedDecimalPoints(relativeOffset.dy, 1),
    );
    final delayBeforeChecking = const Duration(milliseconds: 500);
    print("Ждем ${delayBeforeChecking.inMilliseconds} миллисекунд до проверки");
    await tester.pumpAndSettle(delayBeforeChecking);

    final draggableMemeTextWithEnteredText = tester
        .widget<DraggableMemeText>(draggableMemeTextWithEnteredTextFinder);

    print(
        "Проверяем что параметр offset в объекте memeTextWithOffset внутри DraggableMemeText не равен null");
    expect(
      draggableMemeTextWithEnteredText.memeTextWithOffset.offset,
      isNotNull,
      reason:
          "ОШИБКА! Параметр параметр offset в объекте memeTextWithOffset внутри DraggableMemeText равен null",
    );

    final savedOffset =
        draggableMemeTextWithEnteredText.memeTextWithOffset.offset!;
    final savedOffsetWithOneDecimalPoint = Offset(
      roundDoubleToFixedDecimalPoints(savedOffset.dx, 1),
      roundDoubleToFixedDecimalPoints(savedOffset.dy, 1),
    );

    print(
        "Проверяем параметр offset в объекте memeTextWithOffset внутри DraggableMemeText совпадает с реальной относительной позицией виджета с точностью до 1 знака после запятой");
    expect(
      savedOffsetWithOneDecimalPoint,
      relativeOffsetWithOneDecimalPoint,
      reason:
          "ОШИБКА! Позиция виджета из параметра memeTextWithOffset не совпадает с реальной позицией виджета",
    );

    print("------------- УСПЕХ! Тест пройден! -------------\n");
  });
}

double roundDoubleToFixedDecimalPoints(
    final double value, final int decimalPoints) {
  return double.parse(value.toStringAsFixed(decimalPoints));
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
