import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:memogenerator/di_sm/application_sm/settings_data.dart';

import '../../../features/settings/entities/lang_types.dart';
import '../../../features/settings/entities/theme_types.dart';

part 'settings_model.g.dart';

@JsonSerializable()
class SettingsModel extends Equatable {
  @JsonKey(fromJson: _themeFromJson, toJson: _themeToJson)
  final ThemeType themeType;
  @JsonKey(fromJson: _langFromJson, toJson: _langToJson)
  final LangType langType;
  final bool useBiometry;

  const SettingsModel({
    required this.themeType,
    required this.langType,
    required this.useBiometry,
  });

  const SettingsModel.defaultData()
    : this(
        themeType: ThemeType.systemTheme,
        langType: LangType.systemLang,
        useBiometry: false,
      );

  factory SettingsModel.fromSettings({required SettingsData settings}) {
    return SettingsModel(
      themeType: settings.themeType,
      useBiometry: settings.useBiometry,
      langType: settings.langType,
    );
  }

  SettingsModel copyWith({
    ThemeType? themeType,
    LangType? langType,
    bool? useBiometry,
  }) {
    return SettingsModel(
      themeType: themeType ?? this.themeType,
      langType: langType ?? this.langType,
      useBiometry: useBiometry ?? this.useBiometry,
    );
  }

  factory SettingsModel.fromJson(final Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsModelToJson(this);

  SettingsData toSettings() {
    return SettingsData(
      themeType: themeType,
      langType: langType,
      useBiometry: useBiometry,
    );
  }

  @override
  List<Object?> get props => [themeType, langType, useBiometry];

  static ThemeType _themeFromJson(int theme) => ThemeType.getThemeByCode(theme);

  static int _themeToJson(ThemeType theme) => theme.code;

  static LangType _langFromJson(int langCode) =>
      LangType.getLangByCode(langCode);

  static int _langToJson(LangType lang) => lang.code;
}
