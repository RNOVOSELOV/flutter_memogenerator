import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

abstract class ReactiveRepository<T> {
  final updater = PublishSubject<Null>();

  @protected
  Future<String?> getRawData();

  @protected
  Future<bool> saveRawData(final String? item);

  @protected
  T convertFromString(final String rawItem);

  @protected
  String convertToString(final T item);

  Future<T?> getItem() async {
    final rawItem = await getRawData();
    if (rawItem == null || rawItem.isEmpty) {
      return null;
    }
    return convertFromString(rawItem);
  }

  Future<bool> setItem(final T? item) async {
    return _setRawItem(item == null ? null : convertToString(item));
  }

  Stream<T?> observeItem() async* {
    yield await getItem();
    await for (final _ in updater) {
      yield await getItem();
    }
  }

  Future<bool> _setRawItem(final String? rawItem) {
    updater.add(null);
    return saveRawData(rawItem);
  }
}
