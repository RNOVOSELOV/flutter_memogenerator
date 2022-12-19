import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceData {
  static const _memeKey = "meme_key";
  static const _templateKey = "template_key";

  static SharedPreferenceData? _instance;

  factory SharedPreferenceData.getInstance() =>
      _instance ??= SharedPreferenceData._internal();

  SharedPreferenceData._internal();

  Future<bool> setMemes(final List<String> memes) => setItems(_memeKey, memes);

  Future<List<String>> getMemes() => getItems(_memeKey);

  Future<bool> setTemplates(final List<String> templates) =>
      setItems(_templateKey, templates);

  Future<List<String>> getTemplates() => getItems(_templateKey);

  Future<bool> setItems(
    final String key,
    final List<String> items,
  ) async {
    final sp = await SharedPreferences.getInstance();
    final result = sp.setStringList(key, items);
    return result;
  }

  Future<List<String>> getItems(final String key) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getStringList(key) ?? [];
  }
}
