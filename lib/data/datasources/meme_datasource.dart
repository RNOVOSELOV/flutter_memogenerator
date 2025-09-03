import 'package:memogenerator/data/shared_pref/dto/meme_model.dart';

abstract interface class MemeDatasource {
  Stream<List<MemeModel>> observeMemesList();

  Future<List<MemeModel>> getMemeModels();

  Future<bool> setMemeModels({required final List<MemeModel> models});
}
