// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meme_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemeModel _$MemeModelFromJson(Map<String, dynamic> json) => MemeModel(
  id: json['id'] as String,
  texts: (json['texts'] as List<dynamic>)
      .map((e) => TextWithPositionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  memePath: json['meme_path'] as String?,
);

Map<String, dynamic> _$MemeModelToJson(MemeModel instance) => <String, dynamic>{
  'id': instance.id,
  'texts': instance.texts.map((e) => e.toJson()).toList(),
  'meme_path': instance.memePath,
};
