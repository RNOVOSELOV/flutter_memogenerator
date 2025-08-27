import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

abstract class ReactiveRepository<T> {
  final updater = PublishSubject<Null>();

  @protected
  Future<List<String>> getRawData();

  @protected
  Future<bool> saveRawData(final List<String> items);

  @protected
  T convertFromString(final String rawItem);

  @protected
  String convertToString(final T item);

  @protected
  dynamic getId(final T item);

  Future<List<T>> getItems() async {
    final rawItems = await getRawData();
    return rawItems.map((rawItem) => convertFromString(rawItem)).toList();
  }

  Future<bool> setItems(final List<T> items) async {
    final rawMemes = items.map((item) => convertToString(item)).toList();
    return _setRawItems(rawMemes);
  }

  Stream<List<T>> observeItems() async* {
    yield await getItems();
    await for (final _ in updater) {
      yield await getItems();
    }
  }

  // Добавить новый элемент в конец списка
  Future<bool> addItem(final T item) async {
    final items = await getItems();
    items.add(item);
    return setItems(items);
  }

  Future<bool> removeItem(final T item) async {
    final items = await getItems();
    items.remove(item);
    return setItems(items);
  }

  Future<bool> addItemOrReplaceById(final T newItem) async {
    final items = await getItems();
    final itemIndex = items.indexWhere((item) => getId(item) == getId(newItem));
    if (itemIndex == -1) {
      items.add(newItem);
    } else {
      items[itemIndex] = newItem;
    }
    return setItems(items);
  }

  Future<bool> removeFromItemsById(final dynamic id) async {
    final items = await getItems();
    items.removeWhere((item) => getId(item) == id);
    return setItems(items);
  }

  Future<T?> getItemById(final dynamic id) async {
    final items = await getItems();
    return items.firstWhereOrNull((item) => getId(item) == id);
  }

  Future<bool> _setRawItems(final List<String> rawItems) {
    updater.add(null);
    return saveRawData(rawItems);
  }
}
