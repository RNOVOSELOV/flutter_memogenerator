import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceData {
  static const _memeKey = "meme_key";

  static SharedPreferenceData? _instance;

  factory SharedPreferenceData.getInstance() =>
      _instance ??= SharedPreferenceData._internal();

  SharedPreferenceData._internal();

  Future<bool> setMemes(final List<String> memes) async {
    final sp = await SharedPreferences.getInstance();
    final result = sp.setStringList(_memeKey, memes);
    return result;
  }

  Future<List<String>> getMemes() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getStringList(_memeKey) ?? [];
  }
}
