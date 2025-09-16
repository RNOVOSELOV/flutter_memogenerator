import 'dart:convert';

import 'package:memogenerator/data/datasources/settings_datasource.dart';
import 'package:memogenerator/data/shared_pref/datasources/settings/settings_data_provider.dart';
import 'package:memogenerator/data/shared_pref/dto/settings_model.dart';

import '../reactive_sp_datasource.dart';

class SettingsDataSourceImpl
    extends ReactiveSharedPreferencesDatasource<SettingsModel>  implements SettingsDatasource{
  final SettingsDataProvider _dataProvider;

  SettingsDataSourceImpl({required SettingsDataProvider settingsDataProvider})
    : _dataProvider = settingsDataProvider;

  @override
  SettingsModel convertFromString(String rawItem) =>
      SettingsModel.fromJson(json.decode(rawItem));

  @override
  String convertToString(SettingsModel item) => json.encode(item.toJson());

  @override
  Future<String?> getRawData() => _dataProvider.getSettingsData();

  @override
  Future<bool> saveRawData(String? item) => _dataProvider.setSettingsData(item);

  @override
  Future<SettingsModel> getSettings() async {
    return (await getItem()) ?? SettingsModel.defaultData();
  }

  @override
  Future<bool> setSettings({required SettingsModel settings}) async {
    return await setItem(settings);
  }
}
