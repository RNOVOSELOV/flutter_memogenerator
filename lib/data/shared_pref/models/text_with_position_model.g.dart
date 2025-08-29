// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_with_position_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextWithPositionModel _$TextWithPositionModelFromJson(
  Map<String, dynamic> json,
) => TextWithPositionModel(
  id: json['id'] as String,
  text: json['text'] as String,
  position: PositionModel.fromJson(json['position'] as Map<String, dynamic>),
  fontSize: (json['font_size'] as num?)?.toDouble(),
  color: colorFromJson(json['color'] as String?),
  fontWeight: fwFromJson((json['font_weight'] as num?)?.toInt()),
);

Map<String, dynamic> _$TextWithPositionModelToJson(
  TextWithPositionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'position': instance.position.toJson(),
  'font_size': instance.fontSize,
  'color': colorToJson(instance.color),
  'font_weight': fwToJson(instance.fontWeight),
};
