import '../shared_pref/dto/settings_model.dart';

abstract interface class SettingsDatasource {
  Future<SettingsModel> getSettings();

  Future<bool> setSettings({required SettingsModel settings});
}
