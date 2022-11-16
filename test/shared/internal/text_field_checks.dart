import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';

void checkTextFieldTextInputAction({
  required final TextField textField,
  required final TextInputAction textInputAction,
  final TextInputAction? secondTextInputAction,
}) {
  final String widgetName = "TextField";
  expect(
    textField.textInputAction,
    isNotNull,
    reason: "$widgetName should have not null textInputAction property",
  );
  expect(
    textField.textInputAction,
    secondTextInputAction != null
        ? isOneOrAnother(textInputAction, secondTextInputAction)
        : textInputAction,
    reason: "$widgetName should have textInputAction ${secondTextInputAction != null ? "either "
        "$textInputAction or $secondTextInputAction" : textInputAction}",
  );
}

void checkTextFieldTextCapitalization({
  required final TextField textField,
  required final TextCapitalization textCapitalization,
  final TextCapitalization? secondTextCapitalization,
}) {
  final String widgetName = "TextField";
  expect(
    textField.textCapitalization,
    isNotNull,
    reason: "$widgetName should have not null textCapitalization property",
  );
  expect(
    textField.textCapitalization,
    secondTextCapitalization != null
        ? isOneOrAnother(textCapitalization, secondTextCapitalization)
        : textCapitalization,
    reason: "$widgetName should have textCapitalization ${secondTextCapitalization != null ? "either "
        "$textCapitalization or $secondTextCapitalization" : textCapitalization}",
  );
}

void checkTextFieldCursorColor({
  required final TextField textField,
  required final Color cursorColor,
  final Color? secondCursorColor,
}) {
  final String widgetName = "TextField";
  expect(
    textField.cursorColor,
    isNotNull,
    reason: "$widgetName should have not null cursorColor property",
  );
  expect(
    textField.cursorColor,
    secondCursorColor != null ? isOneOrAnother(cursorColor, secondCursorColor) : cursorColor,
    reason: "$widgetName should have color ${secondCursorColor != null ? "either "
        "$cursorColor or $secondCursorColor" : cursorColor}",
  );
}

void checkTextFieldBorders({
  required final TextField textField,
  final InputBorder? border,
  final InputBorder? secondBorder,
  final InputBorder? focusedBorder,
  final InputBorder? secondFocusedBorder,
  final InputBorder? errorBorder,
  final InputBorder? secondErrorBorder,
  final InputBorder? enabledBorder,
  final InputBorder? secondEnabledBorder,
  final InputBorder? disabledBorder,
  final InputBorder? secondDisabledBorder,
  final InputBorder? focusedErrorBorder,
  final InputBorder? secondFocusedErrorBorder,
}) {
  final String widgetName = "TextField";
  expect(
    textField.decoration,
    isNotNull,
    reason: "$widgetName should have not null decoration property",
  );
  if (border != null) {
    checkTextFieldBorder(
      widgetName: widgetName,
      actualBorderName: "border",
      actualBorder: textField.decoration!.border,
      border: border,
      secondBorder: secondBorder,
    );
  }
  if (focusedBorder != null) {
    checkTextFieldBorder(
      widgetName: widgetName,
      actualBorderName: "focusedBorder",
      actualBorder: textField.decoration!.focusedBorder,
      border: focusedBorder,
      secondBorder: secondFocusedBorder,
    );
  }
  if (errorBorder != null) {
    checkTextFieldBorder(
      widgetName: widgetName,
      actualBorderName: "errorBorder",
      actualBorder: textField.decoration!.errorBorder,
      border: errorBorder,
      secondBorder: secondErrorBorder,
    );
  }
  if (enabledBorder != null) {
    checkTextFieldBorder(
      widgetName: widgetName,
      actualBorderName: "enabledBorder",
      actualBorder: textField.decoration!.enabledBorder,
      border: enabledBorder,
      secondBorder: secondEnabledBorder,
    );
  }
  if (disabledBorder != null) {
    checkTextFieldBorder(
      widgetName: widgetName,
      actualBorderName: "disabledBorder",
      actualBorder: textField.decoration!.disabledBorder,
      border: disabledBorder,
      secondBorder: secondDisabledBorder,
    );
  }
  if (focusedErrorBorder != null) {
    checkTextFieldBorder(
      widgetName: widgetName,
      actualBorderName: "focusedErrorBorder",
      actualBorder: textField.decoration!.focusedErrorBorder,
      border: focusedErrorBorder,
      secondBorder: secondFocusedErrorBorder,
    );
  }
}

void checkTextFieldBorder({
  required final String widgetName,
  required final String actualBorderName,
  required final InputBorder? actualBorder,
  required final InputBorder border,
  required final InputBorder? secondBorder,
}) {
  expect(
    actualBorder,
    isNotNull,
    reason: "$widgetName should have not null $actualBorderName property",
  );

  if (border is OutlineInputBorder &&
      (secondBorder == null || secondBorder is OutlineInputBorder)) {
    expect(
      actualBorder,
      isInstanceOf<OutlineInputBorder>(),
      reason: "$widgetName should have $actualBorderName of type OutlineInputBorder",
    );
    final actualOutlinedInputBorder = actualBorder as OutlineInputBorder;
    final secondOutlinedInputBorder =
        secondBorder != null ? secondBorder as OutlineInputBorder : null;

    expect(
      actualOutlinedInputBorder.borderRadius,
      secondOutlinedInputBorder != null
          ? isOneOrAnother(border.borderRadius, secondOutlinedInputBorder.borderRadius)
          : border.borderRadius,
      reason: "$widgetName should have $actualBorderName with borderRadius "
          "${secondOutlinedInputBorder != null ? "either ${border.borderRadius} or "
              "${secondOutlinedInputBorder.borderRadius}" : border.borderRadius}",
    );

    expect(
      actualOutlinedInputBorder.borderSide,
      secondOutlinedInputBorder != null
          ? isOneOrAnother(border.borderSide, secondOutlinedInputBorder.borderSide)
          : border.borderSide,
      reason: "$widgetName should have $actualBorderName with borderSide "
          "${secondOutlinedInputBorder != null ? "either ${border.borderSide} or "
              "${secondOutlinedInputBorder.borderSide}" : border.borderSide}",
    );
    expect(
      actualOutlinedInputBorder.gapPadding,
      secondOutlinedInputBorder != null
          ? isOneOrAnother(border.gapPadding, secondOutlinedInputBorder.gapPadding)
          : border.gapPadding,
      reason: "$widgetName should have $actualBorderName with gapPadding "
          "${secondOutlinedInputBorder != null ? "either ${border.gapPadding} or "
              "${secondOutlinedInputBorder.gapPadding}" : border.gapPadding}",
    );
  }
  expect(
    actualBorder,
    secondBorder != null ? isOneOrAnother(border, secondBorder) : border,
    reason: "$widgetName should have $actualBorderName ${secondBorder != null ? "either "
        "$border or $secondBorder" : border}",
  );
}
