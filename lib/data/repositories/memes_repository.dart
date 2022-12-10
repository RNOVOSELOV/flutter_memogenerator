import 'dart:convert';
import 'package:memogenerator/data/models/meme.dart';
import 'package:memogenerator/data/shared_preference_data.dart';
import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';

class MemesRepository {
  final updater = PublishSubject<Null>();
  final SharedPreferenceData spData;

  static MemesRepository? instance;

  MemesRepository._internal(this.spData);

  factory MemesRepository.getInstance() => instance ??=
      MemesRepository._internal(SharedPreferenceData.getInstance());
/*
  Future<bool> saveMeme(final Meme meme) async {
    final memes = await getMemes();
    final index = memes.indexWhere((element) => element.id == meme.id);
    if (index == -1) {
      return addToMemes(meme);
    }
    memes[index] = meme;
    return _setMemes(memes);
  }

  // Add meme
  Future<bool> addToMemes(final Meme meme) async {
    final rawMemes = await spData.getMemes();
    rawMemes.add(json.encode(meme.toJson()));
    return _setRawMemes(rawMemes);
  }
*/
  // Add meme
  Future<bool> addToMemes(final Meme meme) async {
    final memes = await getMemes();
    final index = memes.indexWhere((element) => element.id == meme.id);
    if (index == -1) {
      final rawMemes = await spData.getMemes();
      rawMemes.add(json.encode(meme.toJson()));
      return _setRawMemes(rawMemes);
    }
    memes[index] = meme;
    return _setMemes(memes);
  }

  // Remove meme
  Future<bool> removeFromMemes(final String id) async {
    final memes = await getMemes();
    memes.removeWhere((meme) => meme.id == id);
    return _setMemes(memes);
  }

  Stream<List<Meme>> observeMemes() async* {
    yield await getMemes();
    await for (final _ in updater) {
      yield await getMemes();
    }
  }

  Future<List<Meme>> getMemes() async {
    final rawMemes = await spData.getMemes();
    return rawMemes
        .map((element) => Meme.fromJson(json.decode(element)))
        .toList();
  }

  Future<Meme?> getMeme(final String id) async {
    final memes = await getMemes();
    return memes.firstWhereOrNull((element) => element.id == id);
  }

  Future<bool> _setMemes(final List<Meme> memes) async {
    final rawMemes =
        memes.map((element) => json.encode(element.toJson())).toList();
    return _setRawMemes(rawMemes);
  }

  Future<bool> _setRawMemes(final List<String> rawMemes) {
    updater.add(null);
    return spData.setMemes(rawMemes);
  }
}
