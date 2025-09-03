import 'dart:convert';

import 'package:memogenerator/data/datasources/meme_datasource.dart';
import 'package:memogenerator/data/shared_pref/dto/meme_model.dart';

import '../../dto/memes_model.dart';
import '../reactive_sp_datasource.dart';
import 'meme_data_provider.dart';

class MemesDataSourceImpl
    extends ReactiveSharedPreferencesDatasource<MemesModel>
    implements MemeDatasource {
  final MemeDataProvider _dataProvider;

  MemesDataSourceImpl({required MemeDataProvider memeDataProvider})
    : _dataProvider = memeDataProvider;

  @override
  MemesModel convertFromString(String rawItem) =>
      MemesModel.fromJson(json.decode(rawItem));

  @override
  String convertToString(MemesModel item) => json.encode(item.toJson());

  @override
  Future<String?> getRawData() => _dataProvider.getMemeData();

  @override
  Future<bool> saveRawData(String? item) => _dataProvider.setMemeData(item);

  @override
  Stream<List<MemeModel>> observeMemesList() =>
      observeItem().map((model) => model == null ? [] : model.memes);

  @override
  Future<List<MemeModel>> getMemeModels() async {
    return (await getItem())?.memes ?? [];
  }

  @override
  Future<bool> setMemeModels({required List<MemeModel> models}) async {
    return await setItem(MemesModel(memes: models));
  }
}
