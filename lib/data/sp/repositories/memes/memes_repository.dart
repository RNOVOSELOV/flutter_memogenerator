import 'dart:convert';

import '../../models/meme_model.dart';
import '../reactive_repository.dart';
import '../../shared_preference_data.dart';

class MemesRepository extends ReactiveRepository<MemeModel> {
  final SharedPreferenceData spData;

  static MemesRepository? instance;

  MemesRepository._internal(this.spData);

  factory MemesRepository.getInstance() => instance ??=
      MemesRepository._internal(SharedPreferenceData.getInstance());

  @override
  MemeModel convertFromString(String rawItem) =>
      MemeModel.fromJson(json.decode(rawItem));

  @override
  String convertToString(MemeModel item) => json.encode(item.toJson());

  @override
  dynamic getId(MemeModel item) => item.id;

  @override
  Future<List<String>> getRawData() => spData.getMemes();

  @override
  Future<bool> saveRawData(List<String> items) => spData.setMemes(items);
}
