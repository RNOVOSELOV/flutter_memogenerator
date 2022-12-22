import 'dart:convert';
import 'package:memogenerator/data/models/meme.dart';
import 'package:memogenerator/data/repositories/list_with_ids_reactive_repository.dart';
import 'package:memogenerator/data/shared_preference_data.dart';
import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';

class MemesRepository extends ListWithIdsReactiveRepository<Meme> {
  final updater = PublishSubject<Null>();
  final SharedPreferenceData spData;

  static MemesRepository? instance;

  MemesRepository._internal(this.spData);

  factory MemesRepository.getInstance() => instance ??=
      MemesRepository._internal(SharedPreferenceData.getInstance());

  @override
  Meme convertFromString(String rawItem) => Meme.fromJson(json.decode(rawItem));

  @override
  String convertToString(Meme item) => json.encode(item.toJson());

  @override
  dynamic getId(Meme item) => item.id;

  @override
  Future<List<String>> getRawData() => spData.getMemes();

  @override
  Future<bool> saveRawData(List<String> items) => spData.setMemes(items);
}
