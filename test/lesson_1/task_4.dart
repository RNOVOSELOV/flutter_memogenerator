
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/main.dart';

import '../shared/test_helpers.dart';
import 'shared_colors.dart';

///
/// 4. Оформить TextField
///     1. Сверстать состояние, когда не выделен ни один текст
///         1. Цвет заливки — Dark Grey 6%
///         2. Линия подчеркивания толщиной 1 логический пиксель цвета
///            Dark Grey 38%
///     2. В случае если текст еще не введен, но есть текущий выделенный текст:
///         1. Показывать "Ввести текст" в качестве хинта. В случае, если нет
///            текущего выделенного текста, то текст в хинте выводить не надо!
///         2. Этот текст должен иметь цвет Dark Grey 38% и размер 16
///     3. Сверстать состояние когда текст можно вводить, но фокуса в поле нет
///         1. Цвет заливки — Fuchsia 16%
///         2. Линия подчеркивания толщиной 1 логический пиксель цвета
///            Fuchsia 38%
///     4. Сверстать состояние с фокусом в виджете TextField
///         1. Цвет заливки — Fuchsia 16%
///         2. Линия подчеркивания толщиной 2 логических пикселя цвета Fuchsia
///         3. Курсор цвета Fuchsia
///
void runTestLesson1Task4() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  testWidgets('module4', (WidgetTester tester) async {
    print("\n------------- Запускаем тест к 4 заданию 9-го урока -------------\n");

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

    print("На странице CreateMemePage находится единственный виджет с типом TextField");
    final textFieldFinder = find.byType(TextField);
    expect(
      textFieldFinder,
      findsOneWidget,
      reason:
          "ОШИБКА! На странице CreateMemePage невозможно найти единственный виджет с типом TextField",
    );

    print('---------- Проверяем состояние, когда не выделен ни один текст ----------');

    print("После создания страницы CreateMemePage TextField имеет состояние enabled=false");
    expect(
      tester.widget<TextField>(textFieldFinder).enabled,
      isFalse,
      reason: "ОШИБКА! После создания страницы CreateMemePage TextField в состоянии enabled=true",
    );

    print("У найденного TextField decoration != null");
    expect(
      tester.widget<TextField>(textFieldFinder).decoration,
      isNotNull,
      reason: "ОШИБКА! У найденного TextField decoration = null",
    );

    print("В состоянии enabled=false у TextField заливка цвета DarkGrey 6%");
    expect(
      tester.widget<TextField>(textFieldFinder).decoration!.fillColor,
      isOneOrAnother(darkGrey6_1, darkGrey6_2),
      reason: "ОШИБКА! В состоянии enabled=false у TextField подложка некорректного цвета",
    );

    print("В состоянии enabled=false у TextField должен отсутствовать hintText");
    expect(
      tester.widget<TextField>(textFieldFinder).decoration!.hintText,
      isOneOrAnother(null, ""),
      reason: "ОШИБКА! В состоянии enabled=false у TextField неверный hintText",
    );

    print("В состоянии enabled=false у TextField должен быть определен border или disabledBorder");
    expect(
      tester.widget<TextField>(textFieldFinder).decoration!.border != null ||
          tester.widget<TextField>(textFieldFinder).decoration!.disabledBorder != null,
      isTrue,
      reason: "ОШИБКА! В состоянии enabled=false у TextField border и disabledBorder равны null",
    );

    final disabledInputBorder =
        tester.widget<TextField>(textFieldFinder).decoration!.disabledBorder ??
            tester.widget<TextField>(textFieldFinder).decoration!.border;
    final disabledInputBorderName =
        tester.widget<TextField>(textFieldFinder).decoration!.disabledBorder != null
            ? "disabledBorder"
            : "border";

    // если disabledBorder не равен null, то он будет иметь приоритет над border,
    // поэтому проверяем его в первую очерель
    print(
        "В состоянии enabled=false у TextField $disabledInputBorderName должен быть типа UnderlineInputBorder");
    expect(
      disabledInputBorder,
      isInstanceOf<UnderlineInputBorder>(),
      reason:
          "ОШИБКА! В состоянии enabled=false у TextField $disabledInputBorderName неверного типа",
    );

    print(
        "В состоянии enabled=false у TextField $disabledInputBorderName должен иметь borderSide с толщиной 1 и цветом Dark Grey 38%");
    expect(
      (disabledInputBorder as UnderlineInputBorder).borderSide,
      isOneOrAnother(
        BorderSide(width: 1, color: darkGrey38_1),
        BorderSide(width: 1, color: darkGrey38_2),
      ),
      reason:
          "ОШИБКА! В состоянии enabled=false у TextField в $disabledInputBorderName некорректный borderSide",
    );

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

    tester.testTextInput.hide();

    print(
        '---------- Проверяем состояние, когда текст еще не введен, но есть текущий выделенный текст ----------');

    print("После нажатия на кнопку 'ДОБАВИТЬ ТЕКСТ' состояние TextField должно стать enabled=true");
    expect(
      tester.widget<TextField>(textFieldFinder).enabled,
      isTrue,
      reason: "ОШИБКА! После нажатия на кнопку 'ДОБАВИТЬ ТЕКСТ' состояние TextField enabled=false",
    );

    final enabledUnfocusedTextInputDecoration =
        tester.widget<TextField>(textFieldFinder).decoration;
    print("У найденного TextField decoration != null");
    expect(
      enabledUnfocusedTextInputDecoration,
      isNotNull,
      reason: "ОШИБКА! У найденного TextField decoration == null",
    );

    print("У найденного TextField в decoration указан hintText 'Ввести текст'");
    expect(
      enabledUnfocusedTextInputDecoration!.hintText,
      "Ввести текст",
      reason: "ОШИБКА! У найденного TextField в decoration неверный hintText",
    );

    final hintTextStyle = enabledUnfocusedTextInputDecoration.hintStyle;
    print("У найденного TextField в decoration указан hintStyle");
    expect(
      hintTextStyle,
      isNotNull,
      reason: "ОШИБКА! У найденного TextField в decoration отсутствует hintStyle",
    );

    print("В hintStyle размер шрифта равен 16");
    expect(
      hintTextStyle!.fontSize,
      16,
      reason: "ОШИБКА! В hintStyle неверный размер шрифта",
    );

    print("В hintStyle цвет Dark Grey 38%");
    expect(
      hintTextStyle.color,
      isOneOrAnother(darkGrey38_1, darkGrey38_2),
      reason: "ОШИБКА! В hintStyle неверный цвет шрифта",
    );

    print(
        '---------- Проверяем состояние, когда текст еще не введен, но есть текущий выделенный текст ----------');

    print("В состоянии enabled=true и без фокуса у TextField заливка цвета Fuchsia 16%");
    expect(
      enabledUnfocusedTextInputDecoration.fillColor,
      isOneOrAnother(fuchsia16_1, fuchsia16_2),
      reason: "ОШИБКА! В состоянии enabled=true у TextField подложка некорректного цвета",
    );

    print(
        "В состоянии enabled=true и без фокуса у TextField должен быть определен border или enabledBorder");
    expect(
      tester.widget<TextField>(textFieldFinder).decoration!.border != null ||
          tester.widget<TextField>(textFieldFinder).decoration!.enabledBorder != null,
      isTrue,
      reason:
          "ОШИБКА! В состоянии enabled=true и без фокуса у TextField border и enabledBorder равны null",
    );

    // если enabledBorder не равен null, то он будет иметь приоритет над border,
    // поэтому проверяем его в первую очерель
    final enabledUnfocusedBorder =
        tester.widget<TextField>(textFieldFinder).decoration!.enabledBorder ??
            tester.widget<TextField>(textFieldFinder).decoration!.border;
    final enabledUnfocusedBorderName =
        tester.widget<TextField>(textFieldFinder).decoration!.enabledBorder != null
            ? "enabledBorder"
            : "border";
    print(
        "В состоянии enabled=true и без фокуса у TextField $enabledUnfocusedBorderName должен быть типа UnderlineInputBorder");
    expect(
      enabledUnfocusedBorder,
      isInstanceOf<UnderlineInputBorder>(),
      reason:
          "ОШИБКА! В состоянии enabled=true и без фокуса у TextField $enabledUnfocusedBorderName неверного типа",
    );

    print(
        "В состоянии enabled=true и без фокуса у TextField $enabledUnfocusedBorderName должен иметь borderSide с толщиной 1 и цветом Fuchsia 38%");
    expect(
      (enabledUnfocusedBorder as UnderlineInputBorder).borderSide,
      isOneOrAnother(
        BorderSide(width: 1, color: fuchsia38_1),
        BorderSide(width: 1, color: fuchsia38_2),
      ),
      reason:
          "ОШИБКА! В состоянии enabled=true и без фокуса у TextField в $enabledUnfocusedBorderName некорректный borderSide",
    );

    print("Тапаем по полю TextField");

    await tester.tap(textFieldFinder);
    await tester.idle();

    print('---------- Проверяем состояние, когда фокус в виджете TextField ----------');

    final enabledFocusedTextInputDecoration = tester.widget<TextField>(textFieldFinder).decoration;
    print("У TextField decoration != null");
    expect(
      enabledFocusedTextInputDecoration,
      isNotNull,
      reason: "ОШИБКА! У TextField decoration = null",
    );

    print("У найденного TextField в decoration указан hintText 'Ввести текст'");
    expect(
      enabledFocusedTextInputDecoration!.hintText,
      "Ввести текст",
      reason: "ОШИБКА! У найденного TextField в decoration неверный hintText",
    );

    final enabledFocusedHintTextStyle = enabledFocusedTextInputDecoration.hintStyle;
    print("У найденного TextField в decoration указан hintStyle");
    expect(
      enabledFocusedHintTextStyle,
      isNotNull,
      reason: "ОШИБКА! У найденного TextField в decoration отсутствует hintStyle",
    );

    print("В hintStyle размер шрифта равен 16");
    expect(
      enabledFocusedHintTextStyle!.fontSize,
      16,
      reason: "ОШИБКА! В hintStyle неверный размер шрифта",
    );

    print("В hintStyle цвет Dark Grey 38%");
    expect(
      enabledFocusedHintTextStyle.color,
      isOneOrAnother(darkGrey38_1, darkGrey38_2),
      reason: "ОШИБКА! В hintStyle неверный цвет шрифта",
    );

    print("В состоянии enabled=true у TextField заливка цвета Fuchsia 16%");
    expect(
      enabledFocusedTextInputDecoration.fillColor,
      isOneOrAnother(fuchsia16_1, fuchsia16_2),
      reason: "ОШИБКА! В состоянии enabled=true у TextField подложка некорректного цвета",
    );

    print(
        "В состоянии enabled=true и с фокусом у TextField должен быть определен border или focusedBorder");
    expect(
      tester.widget<TextField>(textFieldFinder).decoration!.border != null ||
          tester.widget<TextField>(textFieldFinder).decoration!.focusedBorder != null,
      isTrue,
      reason:
          "ОШИБКА! В состоянии enabled=true и с фокусом у TextField border и focusedBorder равны null",
    );

    // если focusedBorder не равен null, то он будет иметь приоритет над border,
    // поэтому проверяем его в первую очерель
    final enabledFocusedBorder =
        tester.widget<TextField>(textFieldFinder).decoration!.focusedBorder ??
            tester.widget<TextField>(textFieldFinder).decoration!.border;
    final enabledFocusedBorderName =
        tester.widget<TextField>(textFieldFinder).decoration!.focusedBorder != null
            ? "focusedBorder"
            : "border";
    print(
        "В состоянии enabled=true и с фокусом у TextField $enabledFocusedBorderName должен быть типа UnderlineInputBorder");
    expect(
      enabledFocusedBorder,
      isInstanceOf<UnderlineInputBorder>(),
      reason:
          "ОШИБКА! В состоянии enabled=true и с фокусом у TextField $enabledFocusedBorderName неверного типа",
    );

    print(
        "В состоянии enabled=true и с фокусом у TextField $enabledFocusedBorderName должен иметь borderSide с толщиной 2 и цветом Fuchsia");
    expect(
      (enabledFocusedBorder as UnderlineInputBorder).borderSide,
      BorderSide(width: 2, color: fuchsia),
      reason:
          "ОШИБКА! В состоянии enabled=true и с фокусом у TextField в $enabledFocusedBorderName некорректный borderSide",
    );

    print("В состоянии enabled=true и с фокусом у TextField цвет курсора должен быть Fuchsia");
    expect(
      tester.widget<TextField>(textFieldFinder).cursorColor,
      fuchsia,
      reason: "ОШИБКА! В состоянии enabled=true и с фокусом у TextField курсор имеет неверный цвет",
    );

    print("------------- УСПЕХ! Тест пройден! -------------\n");
  });
}
