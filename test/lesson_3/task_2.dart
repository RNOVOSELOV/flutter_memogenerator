import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/main.dart';
import 'package:memogenerator/presentation/main/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/test_helpers.dart';

///
/// 2. Диалог при закрытии приложения
///     1. Добавить виджет WillPopScope на главную страницу приложения
///     2. При нажатии на кнопку назад с главного экрана показывать диалог, см
///        макеты
///     3. При нажатии на кнопку ОСТАТЬСЯ, оставаться в приложении
///     4. При нажатии на кнопку ВЫЙТИ, выходить из приложения
///
void runTestLesson3Task2() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  SharedPreferences.setMockInitialValues(<String, Object>{});
  testWidgets('module2', (WidgetTester tester) async {
    fancyPrint(
      "Запускаем тест к 2 заданию 11-го урока",
      printType: PrintType.startEnd,
    );

    fancyPrint("Открываем виджет MyApp");
    await tester.pumpWidget(MyApp());

    final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));

    fancyPrint("Имитируем нажатие на кнопку назад");
    widgetsAppState.didPopRoute();

    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    final dialogTitle = "Точно хотите выйти?";
    fancyPrint(
        "Проверяем, что в диалоге есть виджет Text с текстом '$dialogTitle'");
    expect(
      find.text(dialogTitle),
      findsOneWidget,
      reason: "ОШИБКА! Виджет Text с текстом '$dialogTitle' не найден",
    );

    final dialogContent = "Мемы сами себя не сделают";
    fancyPrint(
        "Проверяем, что в диалоге есть виджет Text с текстом '$dialogContent'");
    expect(
      find.text(dialogContent),
      findsOneWidget,
      reason: "ОШИБКА! Виджет Text с текстом '$dialogContent' не найден",
    );

    final dialogCancelButton = "ОСТАТЬСЯ";
    final cancelButtonFinder = find.text(dialogCancelButton);
    fancyPrint(
        "Проверяем, что в диалоге есть кнопка с текстом '$dialogCancelButton'");
    expect(
      cancelButtonFinder,
      findsOneWidget,
      reason: "ОШИБКА! Кнопка с текстом '$dialogCancelButton' не найдена",
    );

    fancyPrint("Нажимаем на кнопку с текстом '$dialogCancelButton'");
    await tester.tap(cancelButtonFinder);

    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    fancyPrint("Проверяем, что диалог закрылся");
    expect(
      find.text(dialogTitle),
      findsNothing,
      reason:
          "ОШИБКА! Найден виджет Text с текстом '$dialogTitle', хотя не должен",
    );

    fancyPrint("Проверяем, что диалог MainPage находится в стеке страниц");
    expect(
      find.byType(MainPage),
      findsOneWidget,
      reason: "ОШИБКА! MainPage не найден",
    );

    fancyPrint("Имитируем нажатие на кнопку назад еще раз");
    widgetsAppState.didPopRoute();

    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    final dialogExitButton = "ВЫЙТИ";
    final exitButtonFinder = find.text(dialogExitButton);
    fancyPrint(
        "Проверяем, что в диалоге есть кнопка с текстом '$dialogExitButton'");
    expect(
      exitButtonFinder,
      findsOneWidget,
      reason: "ОШИБКА! Кнопка с текстом '$dialogExitButton' не найдена",
    );

    fancyPrint("Нажимаем на кнопку с текстом '$dialogExitButton'");
    await tester.tap(exitButtonFinder);

    fancyPrint(
      "УСПЕХ! Тест пройден!",
      printType: PrintType.startEnd,
    );
  });
}
