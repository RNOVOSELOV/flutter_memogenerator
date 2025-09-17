// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) =>
    SettingsModel(
      themeType: SettingsModel._themeFromJson(
        (json['theme_type'] as num).toInt(),
      ),
      langType: SettingsModel._langFromJson((json['lang_type'] as num).toInt()),
      useBiometry: json['use_biometry'] as bool,
    );

Map<String, dynamic> _$SettingsModelToJson(SettingsModel instance) =>
    <String, dynamic>{
      'theme_type': SettingsModel._themeToJson(instance.themeType),
      'lang_type': SettingsModel._langToJson(instance.langType),
      'use_biometry': instance.useBiometry,
    };
