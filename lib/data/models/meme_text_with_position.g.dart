// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meme_text_with_position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemeTextWithPosition _$MemeTextWithPositionFromJson(
        Map<String, dynamic> json) =>
    MemeTextWithPosition(
      id: json['id'] as String,
      text: json['text'] as String,
      position: Position.fromJson(json['position'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MemeTextWithPositionToJson(
        MemeTextWithPosition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'position': instance.position.toJson(),
    };
