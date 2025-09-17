abstract class SettingsDataProvider {
  Future<bool> setSettingsData(final String? data);

  Future<String?> getSettingsData();
}
