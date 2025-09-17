import 'dart:ui';

import 'package:flutter/material.dart';

import '../../features/settings/entities/lang_types.dart';
import '../../features/settings/entities/theme_types.dart';

class SettingsData {
  const SettingsData({
    required this.themeType,
    required this.langType,
    required this.useBiometry,
  });

  final ThemeType themeType;
  final LangType langType;
  final bool useBiometry;

  const SettingsData.defaultData()
    : this(
        themeType: ThemeType.systemTheme,
        langType: LangType.systemLang,
        useBiometry: false,
      );

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

  Locale get locale => langType == LangType.systemLang
      ? WidgetsBinding.instance.platformDispatcher.locale
      : Locale(langType.languageCode);
}
