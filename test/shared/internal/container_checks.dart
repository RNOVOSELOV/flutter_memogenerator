import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';
import 'shared_checks.dart';

void checkContainerColor({
  required final Container container,
  required final Color color,
  final Color? secondColor,
  final String? colorName,
  final String? widgetName,
}) {
  final effectiveWidgetName = widgetName ?? "Container";
  final paramName = "color";
  final actualValue = container.color;
  checkParamExistence(
    widgetName: effectiveWidgetName,
    paramName: paramName,
    actualValue: actualValue,
  );
  checkParamValue(
    widgetName: effectiveWidgetName,
    paramName: paramName,
    actualValue: actualValue,
    rightValue: color,
    secondaryRightValue: secondColor,
    readableRightValueName: colorName,
  );
}

void checkContainerDecorationColor({
  required final Container container,
  required final Color color,
  final Color? secondColor,
  final String? colorName,
}) {
  final String widgetName = "Container";
  checkContainerHaveDecoration(widgetName, container);
  checkContainerHaveDecorationOfTypeBoxDecoration(container, widgetName);

  print("Параметр color в decoration должен быть равен ${colorName ?? color}");
  expect(
    (container.decoration as BoxDecoration).color,
    secondColor != null ? isOneOrAnother(color, secondColor) : color,
    reason: "ОШИБКА! Параметр color в decoration неверный",
  );
}

void checkContainerHaveDecorationOfTypeBoxDecoration(
  final Container container,
  final String widgetName,
) {
  print("decoration внутри виджета $widgetName должен иметь тип BoxDecoration");
  expect(
    container.decoration,
    isInstanceOf<BoxDecoration>(),
    reason: "ОШИБКА! $widgetName содержит decoration неверного типа",
  );
}

void checkContainerHaveDecoration(final String widgetName, final Container container) {
  print("Проверяем наличие decoration в виджете $widgetName");
  expect(
    container.decoration,
    isNotNull,
    reason: "ОШИБКА! В виджете $widgetName отсутствует decoration",
  );
}

void checkContainerDecorationShape({
  required final Container container,
  required final BoxShape shape,
}) {
  final String widgetName = "Container";
  expect(
    container.decoration,
    isNotNull,
    reason: "$widgetName should have not null decoration property",
  );
  expect(
    container.decoration,
    isInstanceOf<BoxDecoration>(),
    reason: "$widgetName should have decoration of BoxDecoration type",
  );
  expect(
    (container.decoration as BoxDecoration).shape,
    shape,
    reason: "$widgetName decoration should have shape $shape}",
  );
}

void checkContainerDecorationBorderRadius({
  required final Container container,
  required final BorderRadius borderRadius,
}) {
  final String widgetName = "Container";
  expect(
    container.decoration,
    isNotNull,
    reason: "$widgetName should have not null decoration property",
  );
  expect(
    container.decoration,
    isInstanceOf<BoxDecoration>(),
    reason: "$widgetName should have decoration of BoxDecoration type",
  );
  expect(
    (container.decoration as BoxDecoration).borderRadius,
    isNotNull,
    reason: "$widgetName decoration should have not null borderRadius",
  );

  expect(
    (container.decoration as BoxDecoration).borderRadius,
    isInstanceOf<BorderRadius>(),
    reason: "$widgetName decoration's borderRadius has type of BorderRadius",
  );

  expect(
    (container.decoration as BoxDecoration).borderRadius as BorderRadius,
    borderRadius,
    reason: "$widgetName decoration's borderRadius should be $borderRadius",
  );
}

void checkContainerBorder({
  required final Container container,
  required final Border border,
  final Border? secondBorder,
  final String? borderName,
}) {
  final String widgetName = "Container";

  checkContainerHaveDecoration(widgetName, container);

  checkContainerHaveDecorationOfTypeBoxDecoration(container, widgetName);

  checkContainerHaveBorderInDecorationOfTypeBorder(container, widgetName);

  print("border внутри decoration должен иметь ${borderName ?? border}");
  expect(
    (container.decoration as BoxDecoration).border as Border,
    secondBorder != null ? isOneOrAnother(border, secondBorder) : border,
    reason: "ОШИБКА! $widgetName содержит decoration с неверным border",
  );
}

void checkContainerHaveBorderInDecorationOfTypeBorder(
  final Container container,
  final String widgetName,
) {
  print("border внутри decoration должен иметь тип Border");
  expect(
    (container.decoration as BoxDecoration).border,
    isInstanceOf<Border>(),
    reason: "ОШИБКА! $widgetName содержит decoration с border неверного типа",
  );
}

void checkContainerEdgeInsetsProperties({
  required final Container container,
  final EdgeInsetsCheck? padding,
  final EdgeInsetsCheck? margin,
  final EdgeInsetsCheck? paddingOrMargin,
}) {
  assert(padding != null || margin != null || paddingOrMargin != null);
  if (paddingOrMargin != null) {
    assert(padding == null && margin == null);
  }
  final String widgetName = "Container";
  if (margin != null) {
    checkEdgeInsetParam(
      widgetName: widgetName,
      param: container.margin,
      paramName: "margin",
      edgeInsetsCheck: margin,
    );
  }
  if (padding != null) {
    checkEdgeInsetParam(
      widgetName: widgetName,
      param: container.padding,
      paramName: "padding",
      edgeInsetsCheck: padding,
    );
  }
  if (paddingOrMargin != null) {
    checkEdgeInsetParam(
      widgetName: widgetName,
      param: container.padding ?? container.margin,
      paramName: "margin or padding",
      edgeInsetsCheck: paddingOrMargin,
    );
  }
}

void checkContainerWidthOrHeightProperties({
  required final Container container,
  required final WidthAndHeight widthAndHeight,
  final WidthAndHeight? secondWidthAndHeight,
}) {
  final String widgetName = "Container";
  final widthAndHeightConstraints = BoxConstraints.tightFor(
    width: widthAndHeight.width,
    height: widthAndHeight.height,
  );

  if (widthAndHeight.width != null) {
    print(
        "$widgetName должен иметь width равный ${secondWidthAndHeight == null ? widthAndHeight.width : "${widthAndHeight.width} или ${secondWidthAndHeight.width}"}");
  }

  if (widthAndHeight.height != null) {
    print(
        "$widgetName должен иметь параметр height равный ${secondWidthAndHeight == null ? widthAndHeight.height : "${widthAndHeight.height} или ${secondWidthAndHeight.height}"}");
  }

  expect(
    container.constraints,
    secondWidthAndHeight != null
        ? isOneOrAnother(
            widthAndHeightConstraints,
            BoxConstraints.tightFor(
              width: secondWidthAndHeight.width,
              height: secondWidthAndHeight.height,
            ),
          )
        : widthAndHeightConstraints,
    reason: "ОШИБКА! В $widgetName указаны неверные размеры",
  );
}

void checkContainerAlignment({
  required final Container container,
  required final Alignment alignment,
}) {
  final String widgetName = "Container";
  final String paramName = "alignment";
  final actualValue = container.alignment;
  checkParamExistence(
    widgetName: widgetName,
    paramName: paramName,
    actualValue: actualValue,
  );
  checkParamValue(
    widgetName: widgetName,
    paramName: paramName,
    rightValue: alignment,
    actualValue: actualValue,
  );
}

void checkEdgeInsetParam({
  required final String widgetName,
  required final EdgeInsetsGeometry? param,
  required final String paramName,
  required final EdgeInsetsCheck edgeInsetsCheck,
}) {
  checkParamExistence(
    widgetName: widgetName,
    paramName: paramName,
    actualValue: param,
  );
  checkParamType<EdgeInsets>(
    widgetName: widgetName,
    paramName: paramName,
    actualValue: param,
    type: EdgeInsets,
  );

  if (edgeInsetsCheck.top != null) {
    checkParamValue(
      widgetName: widgetName,
      paramName: "top внутри $paramName",
      rightValue: (param as EdgeInsets).top,
      actualValue: edgeInsetsCheck.top,
    );
  }
  if (edgeInsetsCheck.bottom != null) {
    checkParamValue(
      widgetName: widgetName,
      paramName: "bottom внутри $paramName",
      rightValue: (param as EdgeInsets).bottom,
      actualValue: edgeInsetsCheck.bottom,
    );
  }
  if (edgeInsetsCheck.left != null) {
    checkParamValue(
      widgetName: widgetName,
      paramName: "left внутри $paramName",
      rightValue: (param as EdgeInsets).left,
      actualValue: edgeInsetsCheck.left,
    );
  }
  if (edgeInsetsCheck.right != null) {
    checkParamValue(
      widgetName: widgetName,
      paramName: "right внутри $paramName",
      rightValue: (param as EdgeInsets).right,
      actualValue: edgeInsetsCheck.right,
    );
  }
}

class EdgeInsetsCheck {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const EdgeInsetsCheck({this.top, this.bottom, this.left, this.right});

  @override
  String toString() {
    return 'EdgeInsetsCheck{top: $top, bottom: $bottom, left: $left, right: $right}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EdgeInsetsCheck &&
          runtimeType == other.runtimeType &&
          top == other.top &&
          bottom == other.bottom &&
          left == other.left &&
          right == other.right;

  @override
  int get hashCode => top.hashCode ^ bottom.hashCode ^ left.hashCode ^ right.hashCode;
}

class WidthAndHeight {
  final double? width;
  final double? height;

  WidthAndHeight({this.width, this.height});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidthAndHeight &&
          runtimeType == other.runtimeType &&
          width == other.width &&
          height == other.height;

  @override
  int get hashCode => width.hashCode ^ height.hashCode;

  @override
  String toString() {
    return 'WidthAndHeight{width: $width, height: $height}';
  }
}
