import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:memogenerator/resources/app_colors.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/text_with_position.dart';


class MemeText extends Equatable {
  static const defaultColor = AppColors.dayTextColor;
  static const defaultFontSize = 24.0;
  static const defaultFontWeight = FontWeight.normal;

  final String id;
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;

  const MemeText({
    required this.id,
    required this.text,
    required this.color,
    required this.fontSize,
    required this.fontWeight,
  });

  factory MemeText.createFromTextWithPosition(
      TextWithPosition textWithPosition) {
    return MemeText(
      id: textWithPosition.id,
      text: textWithPosition.text,
      color: textWithPosition.color ?? defaultColor,
      fontSize: textWithPosition.fontSize ?? defaultFontSize,
      fontWeight: textWithPosition.fontWeight ?? defaultFontWeight,
    );
  }

  MemeText copyWithChangedText(final String newText) {
    return MemeText(
        id: id,
        text: newText,
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight);
  }

  MemeText copyWithChangedFontSettings(final Color newColor,
      final double newFontSize, final FontWeight newFontWeight) {
    return MemeText(
      id: id,
      text: text,
      color: newColor,
      fontSize: newFontSize,
      fontWeight: newFontWeight,
    );
  }

  factory MemeText.create() {
    return MemeText(
      id: const Uuid().v4(),
      text: "",
      color: defaultColor,
      fontSize: defaultFontSize,
      fontWeight: defaultFontWeight,
    );
  }

  @override
  List<Object?> get props => [id, text, color, fontSize, fontWeight];
}
