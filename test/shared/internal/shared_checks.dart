import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void checkParamExistence({
  required final String widgetName,
  required final String paramName,
  required final dynamic actualValue,
}) {
  print("$widgetName должен иметь $paramName не равный null");
  expect(
    actualValue,
    isNotNull,
    reason: 'ОШИБКА! В $widgetName $paramName не определен',
  );
}

void checkParamType<T>({
  required final String widgetName,
  required final String paramName,
  required final dynamic actualValue,
  required final Type type,
}) {
  print("Внутри $widgetName $paramName должен быть типа ${type.runtimeType}");
  expect(
    actualValue,
    isInstanceOf<T>(),
    reason: 'ОШИБКА! В $widgetName $paramName имеет некорректный тип',
  );
}

void checkParamValue({
  required final String widgetName,
  required final String paramName,
  required final dynamic actualValue,
  required final dynamic rightValue,
  final dynamic secondaryRightValue,
  final String? readableRightValueName,
}) {
  final name = readableRightValueName ??
      (secondaryRightValue == null
          ? rightValue.toString()
          : "$rightValue или $secondaryRightValue");
  print("Внутри $widgetName значение $paramName должно быть равным $name");
  expect(
    actualValue,
    secondaryRightValue == null ? rightValue : isOneOrAnother(rightValue, secondaryRightValue),
    reason: "ОШИБКА! Внутри $widgetName значение $paramName неверное",
  );
}
