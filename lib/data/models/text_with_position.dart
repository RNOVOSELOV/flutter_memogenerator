import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:memogenerator/data/models/position.dart';

part 'text_with_position.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TextWithPosition extends Equatable {
  final String id;
  final String text;
  final Position position;
  final double? fontSize;
  @JsonKey(toJson: colorToJson, fromJson: colorFromJson)
  final Color? color;
  @JsonKey(toJson: fwToJson, fromJson: fwFromJson)
  final FontWeight? fontWeight;

  TextWithPosition({
    required this.id,
    required this.text,
    required this.position,
    required this.fontSize,
    required this.color,
    required this.fontWeight,
  });

  factory TextWithPosition.fromJson(final Map<String, dynamic> json) =>
      _$TextWithPositionFromJson(json);

  Map<String, dynamic> toJson() => _$TextWithPositionToJson(this);

  @override
  List<Object?> get props => [id, text, position, fontSize, color, fontWeight];
}

String? colorToJson(Color? color) {
  return color?.value.toRadixString(16);
}

Color? colorFromJson(String? value) {
  if (value == null) {
    return null;
  }
  final intColor = int.tryParse(value, radix: 16);
  return intColor == null ? null : Color(intColor);
}

int? fwToJson(FontWeight? fontWeight) {
  return fontWeight?.index;
}

FontWeight? fwFromJson(int? value) {
  if (value == null) {
    return null;
  }
  return FontWeight.values.elementAt(value);
}
