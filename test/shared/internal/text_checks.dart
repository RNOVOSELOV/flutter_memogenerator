import 'package:flutter/material.dart';

import '../test_helpers.dart';

void checkTextProperties({
  required final Text textWidget,
  final String? text,
  final TextAlign? textAlign,
  final double? fontSize,
  final Color? textColor,
  final FontWeight? fontWeight,
}) {
  final String widgetName = "Text${text != null ? " с текстом '$text'" : ""}";
  if (textAlign != null) {
    final paramName = "textAlign";
    checkParamExistence(
      widgetName: widgetName,
      paramName: paramName,
      actualValue: textWidget.textAlign,
    );
    checkParamValue(
      widgetName: widgetName,
      paramName: paramName,
      rightValue: textAlign,
      actualValue: textWidget.textAlign,
    );
  }
  if (fontSize == null && textColor == null && fontWeight == null) {
    return;
  }
  checkParamExistence(
    widgetName: widgetName,
    paramName: "style",
    actualValue: textWidget.style,
  );
  final TextStyle notNullTextStyle = textWidget.style!;
  if (fontSize != null) {
    final paramName = "fontSize внутри style";
    checkParamExistence(
      widgetName: widgetName,
      paramName: paramName,
      actualValue: notNullTextStyle.fontSize,
    );
    checkParamValue(
      widgetName: widgetName,
      paramName: paramName,
      rightValue: fontSize,
      actualValue: notNullTextStyle.fontSize,
    );
  }
  if (textColor != null) {
    final paramName = "color внутри style";
    checkParamExistence(
      widgetName: widgetName,
      paramName: paramName,
      actualValue: notNullTextStyle.color,
    );
    checkParamValue(
      widgetName: widgetName,
      paramName: paramName,
      rightValue: textColor,
      actualValue: notNullTextStyle.color,
    );
  }

  if (fontWeight != null) {
    final paramName = "fontWeight внутри style";
    checkParamExistence(
      widgetName: widgetName,
      paramName: paramName,
      actualValue: notNullTextStyle.fontWeight,
    );
    checkParamValue(
      widgetName: widgetName,
      paramName: paramName,
      rightValue: fontWeight,
      actualValue: notNullTextStyle.fontWeight,
    );
  }
}
