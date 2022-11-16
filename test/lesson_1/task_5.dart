import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/main.dart';

import '../shared/internal/container_checks.dart';
import '../shared/internal/text_checks.dart';
import 'shared_colors.dart';

///
/// 5. Добавление списка со всеми текстами внизу
///     1. В нижней части экрана, под кнопкой с текстом "Добавить текст"
///        добавить список со всеми текстами (MemeText), добавленными на экран
///     2. Добавлять элементы в тот же ListView, куда на занятии мы добавили
///        кнопку с текстом "Добавить текст"
///     3. Элемент в списке с текстом создать с помощью одного виджета Container
///         1. Указать корректные паддинги по 16 с боков
///         2. Высота виджет должна быть зафиксирована и равна 48
///         3. Текст должен быть отцентрирован по вертикали, но находится с
///            левой стороны
///         4. Стиль текста взять из макетов
///     4. Использовать специализированный конструктор у ListView, чтобы
///        добавить разделители между элементами
///         1. Разделитель должен присутствовать только между элементами с
///            текстом. Таким образом его не должно быть между кнопкой с текстом
///            "ДОБАВИТЬ ТЕКСТ" и первым текстовым элементом
///         2. Разделитель сверстать с помощью одного виджета Container
///         3. Слева должен быть отступ в 16
///         4. Высота разделителя равна 1
///         5. Цвет задника Dark Grey
///
void runTestLesson1Task5() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  testWidgets('module5', (WidgetTester tester) async {
    print("\n------------- Запускаем тест к 5 заданию 9-го урока -------------\n");

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
    final secondText = 'Второй текст';
    final thirdText = 'Третий текст';
    await _addMemeTextWithText(tester, addMemeTextButtonFinder, textFieldFinder, firstText);
    await _addMemeTextWithText(tester, addMemeTextButtonFinder, textFieldFinder, secondText);
    await _addMemeTextWithText(tester, addMemeTextButtonFinder, textFieldFinder, thirdText);

    tester.testTextInput.hide();

    print("На странице CreateMemePage находится единственный виджет с типом ListView");
    final listViewFinder = find.byType(ListView);
    expect(
      listViewFinder,
      findsOneWidget,
      reason:
          "ОШИБКА! На странице CreateMemePage невозможно найти единственный виджет с типом ListView",
    );
    print("В ListView находится кнопка c текстом '$addTextText'");
    expect(
      find.descendant(of: listViewFinder, matching: find.text(addTextText)),
      findsOneWidget,
      reason:
          "ОШИБКА! Внутри ListView невозможно найти единственный виджет с текстом '$addTextText'",
    );

    print('---------- Проверяем наличие виджетов с текстом внутри ListView ----------');

    _checkForTextInListView(listViewFinder, firstText);
    _checkForTextInListView(listViewFinder, secondText);
    _checkForTextInListView(listViewFinder, thirdText);


    print('---------- Проверяем правильность виджета с текстом "$firstText" ----------');


    final firstTextContainerFinder = find.descendant(
      of: listViewFinder,
      matching: find.widgetWithText(Container, firstText),
    );

    final firstTextContainer = tester.widget<Container>(firstTextContainerFinder);

    checkContainerEdgeInsetsProperties(
      container: firstTextContainer,
      padding: EdgeInsetsCheck(left: 16, right: 16),
    );

    checkContainerWidthOrHeightProperties(
      container: firstTextContainer,
      widthAndHeight: WidthAndHeight(height: 48),
    );

    checkContainerAlignment(
      container: firstTextContainer,
      alignment: Alignment.centerLeft,
    );

    final firstTextWidget = tester.widget<Text>(find.descendant(
      of: firstTextContainerFinder,
      matching: find.byType(Text),
    ));

    checkTextProperties(
      textWidget: firstTextWidget,
      text: firstText,
      fontSize: 16,
      textColor: darkGrey,
    );

    print('---------- Проверяем разделители между виджетами с текстом внутри ListView ----------');

    final dividersFinder = find.descendant(
      of: listViewFinder,
      matching: find.byWidgetPredicate((widget) => widget is Container && widget.child == null),
    );

    print("В ListView должно быть 2 виджета Container с child = null");

    expect(dividersFinder, findsNWidgets(2),
        reason: "В ListView неверное количество виджетов Container с child = null");

    final firstDividerContainer = tester.widgetList<Container>(dividersFinder).first;

    checkContainerWidthOrHeightProperties(
      container: firstDividerContainer,
      widthAndHeight: WidthAndHeight(height: 1),
    );

    checkContainerEdgeInsetsProperties(
      container: firstDividerContainer,
      margin: EdgeInsetsCheck(left: 16),
    );

    checkContainerColor(
      container: firstDividerContainer,
      color: darkGrey,
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

void _checkForTextInListView(final Finder listViewFinder, final String firstText) {
  print("В ListView находится Container c текстом '$firstText'");
  final firstTextFinder = find.descendant(
    of: listViewFinder,
    matching: find.widgetWithText(Container, firstText),
  );
  expect(
    firstTextFinder,
    findsOneWidget,
    reason: "ОШИБКА! Внутри ListView невозможно найти единственный виджет с текстом '$firstText'",
  );
}
