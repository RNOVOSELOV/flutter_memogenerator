import 'package:shared_preferences/shared_preferences.dart';

import 'datasources/memes/meme_data_provider.dart';
import 'datasources/templates/template_data_provider.dart';

class SharedPreferenceData implements MemeDataProvider, TemplateDataProvider {
  static const _memeKey = "meme_key";
  static const _templateKey = "template_key";

  const SharedPreferenceData();

  @override
  Future<String?> getMemeData() => _getItem(_memeKey);

  @override
  Future<bool> setMemeData(String? data) => _setItem(key: _memeKey, item: data);

  @override
  Future<String?> getTemplatesData() => _getItem(_templateKey);

  @override
  Future<bool> setTemplatesData(String? data) =>
      _setItem(key: _templateKey, item: data);

  Future<bool> _setItem({
    required final String key,
    required final String? item,
  }) async {
    // TODO move sp instance to constructor
    final sp = await SharedPreferences.getInstance();
    final result = sp.setString(key, item ?? '');
    return result;
  }

  Future<String?> _getItem(final String key) async {
    // TODO move sp instance to constructor
    final sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }
}
