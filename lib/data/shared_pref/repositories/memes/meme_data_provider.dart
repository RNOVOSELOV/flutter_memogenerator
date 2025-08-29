abstract class MemeDataProvider {
  Future<bool> setMemeData(final String? data);

  Future<String?> getMemeData();
}
