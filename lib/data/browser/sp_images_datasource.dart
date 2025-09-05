import 'dart:convert';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceImageData {
  const SharedPreferenceImageData();

  Future<bool> saveImage({
    required final String key,
    required final Uint8List imageData,
  }) async {
    final base64Data = base64Encode(imageData);
    return await _setItem(key: key, item: base64Data);
  }

  Future<Uint8List?> getImage({required final String key}) async {
    final base64Data = await _getItem(key);
    if (base64Data != null && base64Data.isNotEmpty) {
      return base64Decode(base64Data);
    }
    return null;
  }

  Future<bool> isImageExist({required final String key}) async {
    final data = await _getItem(key);
    return data != null;
  }

  Future<bool> copyTemplateToMeme({
    required String templateKey,
    required String memeKey,
  }) async {
    final data = await _getItem(templateKey);
    return await _setItem(key: memeKey, item: data);
  }

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
