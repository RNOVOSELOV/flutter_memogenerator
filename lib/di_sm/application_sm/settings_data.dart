import '../../features/settings/entities/lang_types.dart';
import '../../features/settings/entities/theme_types.dart';

class SettingsData {
  SettingsData({
    required this.themeType,
    required this.langType,
    required this.useBiometry,
  });

  final ThemeType themeType;
  final LangType langType;
  final bool useBiometry;

  SettingsData copyWith({
    ThemeType? themeType,
    LangType? langType,
    bool? useBiometry,
  }) {
    return SettingsData(
      themeType: themeType ?? this.themeType,
      langType: langType ?? this.langType,
      useBiometry: useBiometry ?? this.useBiometry,
    );
  }
}
