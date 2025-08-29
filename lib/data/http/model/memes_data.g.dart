// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memes_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemesData _$MemesDataFromJson(Map<String, dynamic> json) => MemesData(
  memes:
      (json['memes'] as List<dynamic>?)
          ?.map((e) => MemeDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$MemesDataToJson(MemesData instance) => <String, dynamic>{
  'memes': instance.memes.map((e) => e.toJson()).toList(),
};
