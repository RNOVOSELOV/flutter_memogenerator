import 'package:flutter/cupertino.dart';

import '../../../generated/l10n.dart';

enum LangType {
  systemTheme(code: 0, hide: false),
  rusLang(code: 1),
  engTheme(code: 2);

  const LangType({required this.code, this.hide = false});

  final int code;
  final bool hide;

  static String getLangByCode(final BuildContext context, final int code) {
    final themeType = LangType.values.firstWhere(
      (element) => element.code == code,
      orElse: () => LangType.systemTheme,
    );
    return getLangMap(context: context)[themeType.code] ?? '';
  }

  static Map<int, String> getLangMap({required BuildContext context}) {
    final typesList = [...LangType.values.where((type) => type.hide == false)];
    typesList.sort((a, b) => a.index.compareTo(b.index));
    final descriptions = [
      S.of(context).lang_system,
      S.of(context).lang_rus,
      S.of(context).lang_eng,
    ];
    return Map.fromEntries(
      typesList.map(
        (type) => MapEntry(type.code, descriptions.elementAt(type.code)),
      ),
    );
  }
}
