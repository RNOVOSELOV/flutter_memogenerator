import 'package:flutter/cupertino.dart';

import '../../../generated/l10n.dart';

enum ThemeType {
  systemTheme(code: 0, hide: false),
  lightTheme(code: 1),
  darkTheme(code: 2);

  const ThemeType({required this.code, this.hide = false});

  final int code;
  final bool hide;

  static String getThemeByCode(final BuildContext context, final int code) {
    final themeType = ThemeType.values.firstWhere(
      (element) => element.code == code,
      orElse: () => ThemeType.systemTheme,
    );
    return getThemeTypesMap(context: context)[themeType.code] ?? '';
  }

  static Map<int, String> getThemeTypesMap({required BuildContext context}) {
    final typesList = [...ThemeType.values.where((type) => type.hide == false)];
    typesList.sort((a, b) => a.index.compareTo(b.index));
    final descriptions = [
      S.of(context).theme_system,
      S.of(context).theme_light,
      S.of(context).theme_dark,
    ];
    return Map.fromEntries(
      typesList.map(
        (type) => MapEntry(type.code, descriptions.elementAt(type.code)),
      ),
    );
  }
}
