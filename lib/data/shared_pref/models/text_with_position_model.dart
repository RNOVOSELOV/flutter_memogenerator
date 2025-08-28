import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:memogenerator/domain/entities/text_with_position.dart';

import 'position_model.dart';

part 'text_with_position_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TextWithPositionModel extends Equatable {
  final String id;
  final String text;
  final PositionModel position;
  final double? fontSize;
  @JsonKey(toJson: colorToJson, fromJson: colorFromJson)
  final Color? color;
  @JsonKey(toJson: fwToJson, fromJson: fwFromJson)
  final FontWeight? fontWeight;

  const TextWithPositionModel({
    required this.id,
    required this.text,
    required this.position,
    required this.fontSize,
    required this.color,
    required this.fontWeight,
  });

  factory TextWithPositionModel.fromJson(final Map<String, dynamic> json) =>
      _$TextWithPositionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TextWithPositionModelToJson(this);

  TextWithPosition get textWithPosition => TextWithPosition(
    id: id,
    text: text,
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    position: position.position,
  );

  factory TextWithPositionModel.fromTemplate({
    required final TextWithPosition data,
  }) {
    return TextWithPositionModel(
      id: data.id,
      fontWeight: data.fontWeight,
      fontSize: data.fontSize,
      color: data.color,
      text: data.text,
      position: PositionModel.fromPosition(position: data.position),
    );
  }

  @override
  List<Object?> get props => [id, text, position, fontSize, color, fontWeight];
}

String? colorToJson(Color? color) {
  return color?.toARGB32().toRadixString(16);
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
