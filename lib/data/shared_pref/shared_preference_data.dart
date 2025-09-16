import 'package:memogenerator/data/shared_pref/datasources/settings/settings_data_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'datasources/memes/meme_data_provider.dart';
import 'datasources/templates/template_data_provider.dart';

class SharedPreferenceData
    implements MemeDataProvider, TemplateDataProvider, SettingsDataProvider {
  static const _memeKey = "meme_key";
  static const _templateKey = "template_key";
  static const _settingsKey = "settings_key";

  late final SharedPreferences sp;

  SharedPreferenceData();

  Future<void> init() async {
    sp = await SharedPreferences.getInstance();
  }

  @override
  Future<String?> getMemeData() => _getItem(_memeKey);

  @override
  Future<bool> setMemeData(String? data) => _setItem(key: _memeKey, item: data);

  @override
  Future<String?> getTemplatesData() => _getItem(_templateKey);

  @override
  Future<bool> setTemplatesData(String? data) =>
      _setItem(key: _templateKey, item: data);

  @override
  Future<String?> getSettingsData() => _getItem(_settingsKey);

  @override
  Future<bool> setSettingsData(String? data) =>
      _setItem(key: _settingsKey, item: data);

  Future<bool> _setItem({
    required final String key,
    required final String? item,
  }) async {
    // TODO move sp instance to constructor
    // final sp = await SharedPreferences.getInstance();
    final result = sp.setString(key, item ?? '');
    return result;
  }

  Future<String?> _getItem(final String key) async {
    // TODO move sp instance to constructor
    // final sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }
}
