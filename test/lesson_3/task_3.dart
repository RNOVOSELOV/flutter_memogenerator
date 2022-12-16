import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/presentation/create_meme/create_meme_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/internal/printer.dart';
import 'shared.dart';

///
/// 3. Удаление одного текста
///     1. Добавить кнопку удаления текста в BottomMemeText по аналогии с
///        кнопкой изменения параметров шрифта (см макет)
///     2. Использовать иконку Icons.delete_forever_outlined
///     3. При нажатии на кнопку удалять соответствующий MemeText из
///        `memeTextsSubject` внутри CreateMemeBloc. После удаления текст должен
///        исчезнуть с экрана
///
void runTestLesson3Task3() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  SharedPreferences.setMockInitialValues(<String, Object>{});
  testWidgets('module3', (WidgetTester tester) async {
    fancyPrint(
      "Запускаем тест к 3 заданию 11-го урока",
      printType: PrintType.startEnd,
    );

    fancyPrint("Открываем экран CreateMemePage");
    await tester.pumpWidget(MaterialApp(home: CreateMemePage()));

    fancyPrint(
      "Добавляем тестовые тексты на страницу и проверяем что они корректно добавились",
      printType: PrintType.headline,
    );

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

    fancyPrint(
        "На странице CreateMemePage находится единственный виджет с типом TextField");
    final textFieldFinder = find.byType(TextField);
    expect(
      textFieldFinder,
      findsOneWidget,
      reason:
          "ОШИБКА! На странице CreateMemePage невозможно найти единственный виджет с типом TextField",
    );

    final firstText = 'Первый текст';
    await addMemeTextWithText(
        tester, addMemeTextButtonFinder, textFieldFinder, firstText);

    final secondText = 'Второй текст';
    await addMemeTextWithText(
        tester, addMemeTextButtonFinder, textFieldFinder, secondText);

    final thirdText = 'Третий текст';
    await addMemeTextWithText(
        tester, addMemeTextButtonFinder, textFieldFinder, thirdText);

    final bottomMemeByTextFinder =
        (text) => find.widgetWithText(BottomMemeText, text);

    final draggableByTextFinder =
        (text) => find.widgetWithText(DraggableMemeText, text);

    fancyPrint(
        "Проверяем что на странице CreateMemePage содержится 3 виджета BottomMemeText с текстами '$firstText', '$secondText' и '$thirdText'");

    expect(bottomMemeByTextFinder(firstText), findsOneWidget,
        reason:
            "ОШИБКА! Невозможно найти единственный виджет BottomMemeText с текстом '$firstText'");
    expect(
      bottomMemeByTextFinder(secondText),
      findsOneWidget,
      reason:
          "ОШИБКА! Невозможно найти единственный виджет BottomMemeText с текстом '$secondText'",
    );
    expect(
      bottomMemeByTextFinder(thirdText),
      findsOneWidget,
      reason:
          "ОШИБКА! Невозможно найти единственный виджет BottomMemeText с текстом '$thirdText'",
    );

    fancyPrint(
        "Проверяем что на странице CreateMemePage содержится 3 виджета DraggableMemeText с текстами '$firstText', '$secondText' и '$thirdText'");

    expect(
      draggableByTextFinder(firstText),
      findsOneWidget,
      reason:
          "ОШИБКА! Невозможно найти единственный виджет DraggableMemeText с текстом '$firstText'",
    );
    expect(
      draggableByTextFinder(secondText),
      findsOneWidget,
      reason:
          "ОШИБКА! Невозможно найти единственный виджет DraggableMemeText с текстом '$secondText'",
    );
    expect(
      draggableByTextFinder(thirdText),
      findsOneWidget,
      reason:
          "ОШИБКА! Невозможно найти единственный виджет DraggableMemeText с текстом '$thirdText'",
    );

    fancyPrint(
      "Удаляем текст '$firstText' и проверяем корректность удаления",
      printType: PrintType.headline,
    );

    final deleteIconFinder = find.byWidgetPredicate((widget) {
      return widget is Icon && widget.icon == Icons.delete_forever_outlined;
    });

    final deleteMemeTextByTextButtonFinder = (text) => find.descendant(
        of: bottomMemeByTextFinder(text), matching: deleteIconFinder);

    fancyPrint(
        "Находим кнопку удаления в BottomMemeText с текстом '$firstText'");
    expect(
      deleteMemeTextByTextButtonFinder(firstText),
      findsOneWidget,
      reason:
          "ОШИБКА! Невозможно найти единственную виджет Icon с иконкой Icons.delete_forever_outlined в BottomMemeText с текстом '$firstText'",
    );

    fancyPrint("Тапаем на найденную кнопку удаления текста '$firstText'");
    await tester.tap(deleteMemeTextByTextButtonFinder(firstText));

    await tester.pumpAndSettle();

    fancyPrint(
        "Проверяем что на странице CreateMemePage содержится 2 виджета BottomMemeText с текстами '$secondText' и '$thirdText'");

    expect(
      bottomMemeByTextFinder(firstText),
      findsNothing,
      reason:
          "ОШИБКА! Найден виджет BottomMemeText с текстом '$firstText', хотя не должен",
    );
    expect(
      bottomMemeByTextFinder(secondText),
      findsOneWidget,
      reason:
          "ОШИБКА! Невозможно найти единственный виджет BottomMemeText с текстом '$secondText'",
    );
    expect(
      bottomMemeByTextFinder(thirdText),
      findsOneWidget,
      reason:
          "ОШИБКА! Невозможно найти единственный виджет BottomMemeText с текстом '$thirdText'",
    );

    fancyPrint(
        "Проверяем что на странице CreateMemePage содержится 2 виджета DraggableMemeText с текстами '$secondText' и '$thirdText'");
    expect(
      draggableByTextFinder(firstText),
      findsNothing,
      reason:
          "ОШИБКА! Найден виджет DraggableMemeText с текстом '$firstText', хотя не должен",
    );
    expect(
      draggableByTextFinder(secondText),
      findsOneWidget,
      reason:
          "ОШИБКА! Невозможно найти единственный виджет DraggableMemeText с текстом '$secondText'",
    );
    expect(
      draggableByTextFinder(thirdText),
      findsOneWidget,
      reason:
          "ОШИБКА! Невозможно найти единственный виджет DraggableMemeText с текстом '$thirdText'",
    );

    fancyPrint(
      "Удаляем текст '$secondText' и проверяем корректность удаления",
      printType: PrintType.headline,
    );

    fancyPrint(
        "Находим кнопку удаления в BottomMemeText с текстом $secondText");
    expect(
      deleteMemeTextByTextButtonFinder(secondText),
      findsOneWidget,
      reason:
          "ОШИБКА! Невозможно найти единственную виджет Icon с иконкой Icons.delete_forever_outlined в BottomMemeText с текстом $secondText",
    );

    fancyPrint("Тапаем на найденную кнопку удаления текста '$secondText'");
    await tester.tap(deleteMemeTextByTextButtonFinder(secondText));

    await tester.pumpAndSettle();

    fancyPrint(
        "Проверяем что на странице CreateMemePage содержится 1 виджет BottomMemeText с текстом '$thirdText'");

    expect(
      bottomMemeByTextFinder(firstText),
      findsNothing,
      reason:
          "ОШИБКА! Найден виджет BottomMemeText с текстом '$firstText', хотя не должен",
    );
    expect(
      bottomMemeByTextFinder(secondText),
      findsNothing,
      reason:
          "ОШИБКА! Найден виджет BottomMemeText с текстом '$firstText', хотя не должен",
    );
    expect(
      bottomMemeByTextFinder(thirdText),
      findsOneWidget,
      reason:
          "ОШИБКА! Невозможно найти единственный виджет BottomMemeText с текстом '$thirdText'",
    );

    fancyPrint(
        "Проверяем что на странице CreateMemePage содержится 2 виджета DraggableMemeText с текстами '$secondText' и '$thirdText'");
    expect(
      draggableByTextFinder(firstText),
      findsNothing,
      reason:
          "ОШИБКА! Найден виджет DraggableMemeText с текстом '$firstText', хотя не должен",
    );
    expect(
      draggableByTextFinder(secondText),
      findsNothing,
      reason:
          "ОШИБКА! Найден виджет DraggableMemeText с текстом '$secondText', хотя не должен",
    );
    expect(
      draggableByTextFinder(thirdText),
      findsOneWidget,
      reason:
          "ОШИБКА! Невозможно найти единственный виджет DraggableMemeText с текстом '$thirdText'",
    );

    fancyPrint(
      "УСПЕХ! Тест пройден!",
      printType: PrintType.startEnd,
    );
  });
}
