// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alt_meme_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AltMemeDto _$AltMemeDtoFromJson(Map<String, dynamic> json) => AltMemeDto(
  id: json['id'] as String,
  name: json['name'] as String,
  url: json['blank'] as String,
);

Map<String, dynamic> _$AltMemeDtoToJson(AltMemeDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'blank': instance.url,
    };
