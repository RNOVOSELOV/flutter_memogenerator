import 'package:flutter/cupertino.dart';

import '../../../generated/l10n.dart';

enum LangType {
  systemLang(code: 0, languageCode: '', hide: false),
  rusLang(code: 1, languageCode: 'ru'),
  engLang(code: 2, languageCode: 'en');

  const LangType({
    required this.code,
    required this.languageCode,
    this.hide = false,
  });

  final int code;
  final String languageCode;
  final bool hide;

  static String getLangValueByCode(final BuildContext context, final int code) {
    final themeType = getLangByCode(code);
    return getLangMap(context: context)[themeType.code] ?? '';
  }

  static LangType getLangByCode(final int code) {
    return LangType.values.firstWhere(
      (element) => element.code == code,
      orElse: () => LangType.systemLang,
    );
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
