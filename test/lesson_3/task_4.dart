import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/data/models/meme.dart';
import 'package:memogenerator/data/models/position.dart';
import 'package:memogenerator/data/models/text_with_position.dart';
import 'package:memogenerator/presentation/create_meme/create_meme_page.dart';
import 'package:memogenerator/presentation/create_meme/font_settings_bottom_sheet.dart';
import 'package:memogenerator/presentation/create_meme/models/meme_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../shared/test_helpers.dart';

///
/// 4. Добавить слайдер для изменения начертания шрифта
///     1. В FontSettingsBottomSheet добавить новый слайдер для изменения
///        начертания шрифта (FontWeight) выбранного текста
///         1. В качестве значений слайдера использовать поле index из класса
///            FontWeight
///         2. Минимальное начертание — FontWeight.w100, максимальное —
///            FontWeight.w900. Начертания типа bold, normal и пр не
///            использовать. Использовать только те, которые начинаются с 'w'.
///         3. Дивайдер должен иметь количество делений по количеству возможных
///            вариантов FontWeight
///         4. Тему слайдера сделать такой же, как и для слайдера с изменением
///            размера шрифта, только без Value Indicator'а.
///         5. При изменении значения в этом слайдере, необходимо обновлять
///            значение FontWeight и в виджете с предпросмотром
///            `MemeTextOnCanvas`
///     2. Обновить модели с данными
///         1. MemeText. Добавить поле FontWeight fontWeight. По умолчанию
///            fontWeight должен быть равен FontWeight.w400
///         2. TextWithPosition. Добавить поле FontWeight? fontWeight
///     3. Информаци о начертании должна успешно записываться в
///        SharedPreferences при сохранении мема
///     4. При заходе на существующий мем, должны подтягиваться данные из
///        SharedPreferences о выбранном начертании текстов.
///     5. Внутри DraggableMemeText должно корректно отображаться текущее
///        выбранное начертание
///
void runTestLesson3Task4() {
  final textWithPosition = TextWithPosition(
    id: Uuid().v4(),
    text: "Первый текст",
    position: Position(top: 0, left: 0),
    fontSize: 30,
    color: Colors.black,
    fontWeight: FontWeight.w700,
  );

  final meme = Meme(id: Uuid().v4(), texts: [textWithPosition]);

  final memeText = MemeText(
    id: textWithPosition.id,
    text: textWithPosition.text,
    fontSize: textWithPosition.fontSize!,
    color: textWithPosition.color!,
    fontWeight: textWithPosition.fontWeight!,
  );

  final memeKey = "meme_key";
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues(<String, Object>{
      memeKey: [jsonEncode(meme.toJson())]
    });
  });

  testWidgets('module4', (WidgetTester tester) async {
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
      "Запускаем тест к 4 заданию 11-го урока",
      printType: PrintType.startEnd,
    );

    fancyPrint("Открываем CreateMemePage");

    await tester.pumpWidget(MaterialApp(home: CreateMemePage(id: meme.id)));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    fancyPrint(
      "Проверяем что в CreateMemePage подтягиваются данные о начертании шрифта из SharedPreferences",
      printType: PrintType.headline,
    );

    final draggableTextFinder = find.byType(DraggableMemeText);

    fancyPrint("Находим на странице единственный виджет DraggableMemeText");
    expect(
      draggableTextFinder,
      findsOneWidget,
      reason: "ОШИБКА! Невозможно найти единственный виджет DraggableMemeText",
    );

    final textOnDraggableTextFinder = find.descendant(
      of: draggableTextFinder,
      matching: find.byType(Text),
    );

    fancyPrint("Находим внутри DraggableMemeText единственный Text");
    expect(
      textOnDraggableTextFinder,
      findsOneWidget,
      reason:
          "ОШИБКА! Невозможно найти единственный Text внутри виджета DraggableMemeText",
    );

    final textOnDraggableText = tester.widget<Text>(textOnDraggableTextFinder);
    fancyPrint(
        "Text внутри виджета DraggableMemeText с текстом '${memeText.text}' имеет style не равный null");
    expect(
      textOnDraggableText.style,
      isNotNull,
      reason:
          "ОШИБКА! Text внутри виджета DraggableMemeText с текстом '${memeText.text}' имеет style равный null",
    );

    fancyPrint(
        "Text внутри виджета DraggableMemeText с текстом '${memeText.text}' имеет style в котором fontWeight равен значению, сохраненному в SharedPreferences");
    expect(
      textOnDraggableText.style!.fontWeight,
      memeText.fontWeight,
      reason:
          "ОШИБКА! Text внутри виджета DraggableMemeText с текстом '${memeText.text}' имеет style в котором fontWeight неверный",
    );

    final changeFontSettingsIconFinder = find.byWidgetPredicate((widget) {
      return widget is Icon && widget.icon == Icons.font_download_outlined;
    });

    fancyPrint(
      "Проверяем верстку FontSettingBottomSheet",
      printType: PrintType.headline,
    );

    fancyPrint(
        "Находим кнопку изменения настроек шрифта в BottomMemeText с текстом '${memeText.text}'");
    expect(
      changeFontSettingsIconFinder,
      findsOneWidget,
      reason:
          "ОШИБКА! Невозможно найти единственную виджет Icon с иконкой Icons.font_download_outlined в BottomMemeText с текстом '${memeText.text}'",
    );

    fancyPrint(
        "Тапаем на найденную кнопку изменения настроек шрифта для текста '${memeText.text}'");
    await tester.tap(changeFontSettingsIconFinder);

    await tester.pumpAndSettle();

    final fontSettingBottomSheetFinder = find.byType(FontSettingBottomSheet);

    fancyPrint("Проверяем, что открылся FontSettingBottomSheet");
    expect(
      fontSettingBottomSheetFinder,
      findsOneWidget,
      reason: "ОШИБКА! Невозможно найти единственный FontSettingBottomSheet",
    );

    fancyPrint(
      "Проверяем что на FontSettingBottomSheet присутствует Slider для изменения FontWeight",
      printType: PrintType.headline,
    );

    final fontWeightText = 'Font Weight:';
    fancyPrint(
        "На FontSettingBottomSheet находится единственный виджет Text с текстом '$fontWeightText'");
    expect(
      find.text(fontWeightText),
      findsOneWidget,
      reason:
          "ОШИБКА! На FontSettingBottomSheet невозможно найти единственный виджет Text с текстом '$fontWeightText'",
    );

    final fontWeightSliderFinder = find.byWidgetPredicate(
      (widget) =>
          widget is Slider &&
          widget.min == FontWeight.w100.index.toDouble() &&
          widget.max == FontWeight.w900.index.toDouble(),
    );
    fancyPrint(
        "На FontSettingBottomSheet находится единственный виджет Slider с минимальным значением равным FontWeight.w100.index и максимальным равным FontWeight.w900.index");
    expect(
      fontWeightSliderFinder,
      findsOneWidget,
      reason:
          "ОШИБКА! На FontSettingBottomSheet невозможно найти единственный виджет Slider с минимальным значением равным FontWeight.w100.index и максимальным равным FontWeight.w900.index",
    );

    final fontWeightSlider = tester.widget<Slider>(fontWeightSliderFinder);
    final divisionsCount = FontWeight.w900.index - FontWeight.w100.index;
    fancyPrint("В этом слайдере $divisionsCount делений");
    expect(
      fontWeightSlider.divisions,
      divisionsCount,
      reason: "ОШИБКА! В найденном слайдере неверное количество делений",
    );

    final fontWeightSliderThemeFinder = find.ancestor(
      of: fontWeightSliderFinder,
      matching: find.byType(SliderTheme),
    );
    fancyPrint("Этот слайдер обернут в SliderTheme");
    expect(
      fontWeightSliderThemeFinder,
      findsOneWidget,
      reason:
          "ОШИБКА! Невозможно найти SliderTheme, находящийся над нужным слайдером",
    );

    final fontWeightSliderTheme =
        tester.widget<SliderTheme>(fontWeightSliderThemeFinder);

    if (fontWeightSlider.label == null) {
      fancyPrint("В этом слайдере label равен null");
    } else {
      fancyPrint(
          "Если в Slider label не равен null, удостоверяемся, что в SliderThemeData определен корректный showValueIndicator параметр. Но по хорошему, label не должен быть определен");
      expect(
        fontWeightSliderTheme.data.showValueIndicator,
        isOneOrAnother(
          ShowValueIndicator.never,
          ShowValueIndicator.onlyForContinuous,
        ),
        reason:
            "ОШИБКА! В Slider label не равен null, а в соответствующем SliderTheme определен некорректный showValueIndicator",
      );
    }

    fancyPrint(
      "Проверяем что предпросмотр текста учитывает выбранный FontWeight",
      printType: PrintType.headline,
    );

    final textOnFontSettingBottomSheetFinder = find.descendant(
      of: fontSettingBottomSheetFinder,
      matching: find.byWidgetPredicate(
          (widget) => widget is Text && widget.data == memeText.text),
    );

    fancyPrint(
        "На FontSettingBottomSheet находится единственный виджет Text с текстом '${memeText.text}'");
    expect(
      textOnFontSettingBottomSheetFinder,
      findsOneWidget,
      reason:
          "ОШИБКА! На FontSettingBottomSheet невозможно найти единственный виджет Text с текстом '${memeText.text}'",
    );

    final text = tester.widget<Text>(textOnFontSettingBottomSheetFinder);

    fancyPrint(
        "Виджет с текстом '${memeText.text}' имеет style не равный null");
    expect(
      text.style,
      isNotNull,
      reason:
          "ОШИБКА! Виджет с текстом '${memeText.text}' имеет style равный null",
    );

    fancyPrint(
        "Виджет с текстом '${memeText.text}' имеет style в котором fontWeight равен исходному значению переданному в конструктор FontSettingBottomSheet");
    expect(
      text.style!.fontWeight,
      memeText.fontWeight,
      reason:
          "ОШИБКА! Виджет с текстом '${memeText.text}' имеет style в котором fontWeight неверный",
    );

    fancyPrint(
        "Выделяем на Slider с выбором FontWeight самое крайнее левое значение");

    final Offset topLeft = tester.getTopLeft(fontWeightSliderFinder);
    final Offset bottomRight = tester.getBottomRight(fontWeightSliderFinder);

    await tester.tapAt(Offset(
      topLeft.dx,
      topLeft.dy + (bottomRight.dy - topLeft.dy) / 2,
    ));

    await tester.pump();

    final newFontWeight = FontWeight.w100;
    fancyPrint(
        "Проверяем, что Text с текстом '${memeText.text}' изменил свой fontWeight на FontWeight.w100");
    expect(
      tester.widget<Text>(textOnFontSettingBottomSheetFinder).style!.fontWeight,
      newFontWeight,
      reason:
          "ОШИБКА! Text с текстом '${memeText.text}' имеет неверное значение",
    );

    fancyPrint(
      "Проверяем, что изменения сделанные на FontSettingsBottomSheet корректно применяются на CreateMemePage",
      printType: PrintType.headline,
    );

    final saveText = "Сохранить".toUpperCase();
    final saveButtonFinder = find.text(saveText);
    fancyPrint("Находим кнопку с текстом '$saveText'");
    expect(
      saveButtonFinder,
      findsOneWidget,
      reason: "ОШИБКА! Невозможно найти кнопку с текстом '$saveText'",
    );

    fancyPrint("Нажимаем на кнопку с текстом '$saveText'");
    await tester.tap(saveButtonFinder);

    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    fancyPrint("Проверяем, что FontSettingBottomSheet закрылся");
    expect(
      saveButtonFinder,
      findsNothing,
      reason: "ОШИБКА! FontSettingBottomSheet не закрылся",
    );

    fancyPrint("Проверяем, что FontSettingBottomSheet закрылся");

    final textOnDraggableText2 = tester.widget<Text>(textOnDraggableTextFinder);

    fancyPrint(
        "Проверяем, что Text внутри виджета DraggableMemeText с текстом '${memeText.text}' имеет style в котором fontWeight равен $newFontWeight");
    expect(
      textOnDraggableText2.style!.fontWeight,
      newFontWeight,
      reason:
          "ОШИБКА! Text внутри виджета DraggableMemeText с текстом '${memeText.text}' имеет style в котором fontWeight неверный",
    );

    fancyPrint(
      "Проверяем, что при сохранении мема данные о FontWeight записываются в SharedPreferences",
      printType: PrintType.headline,
    );

    final saveMemeIconFinder = find.byWidgetPredicate((widget) {
      return widget is Icon && widget.icon == Icons.save;
    });

    fancyPrint("Находим кнопку сохранения мема");
    expect(
      saveMemeIconFinder,
      findsOneWidget,
      reason: "ОШИБКА! Невозможно найти единственный виджет Icon с Icons.save",
    );

    fancyPrint("Тапаем на найденную кнопку сохранения мема");
    await tester.tap(saveMemeIconFinder);

    await tester.pumpAndSettle(const Duration(milliseconds: 200));

    final sp = await SharedPreferences.getInstance();
    final memesRaw = sp.getStringList(memeKey) ?? <String>[];
    final memes = memesRaw.map((rawMeme) => Meme.fromJson(jsonDecode(rawMeme)));

    fancyPrint(
        "Ожидаем, что в SharedPreferences будет сохранен только один мем");
    expect(
      memes.length,
      1,
      reason:
          "ОШИБКА! В SharedPreferences под ключем '$memeKey' после сохранения мема на странице CreateMemePage находится больше одного мем",
    );

    fancyPrint(
        "Ожидаем, что в сохраненном меме в содержится только один TextWithPosition в texts");

    final updatedMeme = memes.first;
    expect(
      updatedMeme.texts.length,
      1,
      reason:
          "ОШИБКА! В сохраненном меме неверное количество TextWithPosition в texts",
    );

    fancyPrint(
        "Проверяем, что в обновленном TextWithPosition содержится новый выбранный fontWeight: '$newFontWeight'");

    final updatedTextWithPosition = updatedMeme.texts.first;
    expect(
      updatedTextWithPosition.fontWeight,
      newFontWeight,
      reason:
          "ОШИБКА! В обновленном TextWithPosition содержится неверный fontWeight",
    );

    fancyPrint("УСПЕХ! Тест пройден!", printType: PrintType.startEnd);
  });
}
