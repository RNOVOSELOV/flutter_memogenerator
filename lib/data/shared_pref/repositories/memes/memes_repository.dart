import 'dart:convert';

import '../../models/memes_model.dart';
import '../reactive_repository.dart';
import 'meme_data_provider.dart';

class MemesRepository extends ReactiveRepository<MemesModel> {
  final MemeDataProvider _dataProvider;

  MemesRepository({required MemeDataProvider memeDataProvider})
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
}
