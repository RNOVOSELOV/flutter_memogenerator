// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memes_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemesModel _$MemesModelFromJson(Map<String, dynamic> json) => MemesModel(
  memes: (json['memes'] as List<dynamic>)
      .map((e) => MemeModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MemesModelToJson(MemesModel instance) =>
    <String, dynamic>{'memes': instance.memes.map((e) => e.toJson()).toList()};
