// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'templates_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TemplatesModel _$TemplatesModelFromJson(Map<String, dynamic> json) =>
    TemplatesModel(
      templates: (json['templates'] as List<dynamic>)
          .map((e) => TemplateModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TemplatesModelToJson(TemplatesModel instance) =>
    <String, dynamic>{
      'templates': instance.templates.map((e) => e.toJson()).toList(),
    };
