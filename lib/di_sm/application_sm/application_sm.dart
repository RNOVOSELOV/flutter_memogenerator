import 'package:equatable/equatable.dart';
import 'package:memogenerator/data/datasources/settings_datasource.dart';
import 'package:memogenerator/data/shared_pref/datasources/settings/settings_datasource_impl.dart';
import 'package:memogenerator/data/shared_pref/dto/settings_model.dart';
import 'package:memogenerator/di_sm/application_sm/settings_data.dart';
import 'package:memogenerator/features/settings/entities/lang_types.dart';
import 'package:memogenerator/features/settings/entities/theme_types.dart';
import 'package:yx_state/yx_state.dart';

class ApplicationState extends Equatable {
  const ApplicationState({required this.settingsData});

  final SettingsData settingsData;

  @override
  List<Object?> get props => [settingsData];
}

class ApplicationStateManager extends StateManager<ApplicationState> {
  final SettingsDatasource _settingsDatasource;

  ApplicationStateManager(
    super.state, {
    required SettingsDataSourceImpl settingsData,
  }) : _settingsDatasource = settingsData;

  Future<void> init() => handle((emit) async {
    final result = (await _settingsDatasource.getSettings()).toSettings();
    emit(ApplicationState(settingsData: result));
  });

  Future<void> setTheme({required ThemeType theme}) => handle((emit) async {
    final settings = (await _settingsDatasource.getSettings()).toSettings();
    final newSettings = settings.copyWith(themeType: theme);
    await _settingsDatasource.setSettings(
      settings: SettingsModel.fromSettings(settings: newSettings),
    );
    emit(ApplicationState(settingsData: newSettings));
  });

  Future<void> setLanguage({required LangType lang}) => handle((emit) async {
    final settings = (await _settingsDatasource.getSettings()).toSettings();
    final newSettings = settings.copyWith(langType: lang);
    await _settingsDatasource.setSettings(
      settings: SettingsModel.fromSettings(settings: newSettings),
    );
    emit(ApplicationState(settingsData: newSettings));
  });

  Future<void> setBiometry({required bool useBio}) => handle((emit) async {
    final settings = (await _settingsDatasource.getSettings()).toSettings();
    final newSettings = settings.copyWith(useBiometry: useBio);
    await _settingsDatasource.setSettings(
      settings: SettingsModel.fromSettings(settings: newSettings),
    );
    emit(ApplicationState(settingsData: newSettings));
  });

}
