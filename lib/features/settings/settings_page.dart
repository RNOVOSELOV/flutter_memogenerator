import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:memogenerator/di_sm/application_sm/application_sm.dart';
import 'package:memogenerator/features/settings/entities/lang_types.dart';
import 'package:memogenerator/features/settings/sm/settings_state.dart';
import 'package:memogenerator/features/settings/sm/settings_state_manager.dart';
import 'package:memogenerator/navigation/navigation_helper.dart';
import 'package:memogenerator/navigation/navigation_path.dart';
import 'package:memogenerator/theme/extensions/theme_extensions.dart';
import 'package:memogenerator/widgets/switch_widget.dart';
import 'package:provider/provider.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';
import 'package:yx_state_flutter/yx_state_flutter.dart';

import '../../di_sm/app_scope.dart';
import '../../generated/l10n.dart';
import '../../resources/app_images.dart';
import '../../widgets/selector_bottom_sheet.dart';
import '../../widgets/selector_widget.dart';
import 'entities/theme_types.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final SettingsStateManager _manager;
  String? _lastLocation;

  @override
  void initState() {
    super.initState();
    final appScopeHolder = ScopeProvider.scopeHolderOf<AppScopeContainer>(
      context,
      listen: false,
    );
    _manager = SettingsStateManager(
      SettingsInitialState(),
      templateRepository:
          appScopeHolder.scope!.templateScopeModule.templateRepositoryImpl.get,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final router = CustomNavigationHelper.instance.router;
      router.routerDelegate.addListener(_onRouteChanged);
      _onRouteChanged();
    });
  }

  void _onRouteChanged() {
    if (!mounted) return;

    final location = CustomNavigationHelper
        .instance
        .router
        .routerDelegate
        .currentConfiguration
        .fullPath;
    if (_lastLocation != location &&
        location == NavigationPagePath.settingsPage.path) {
      _manager.getCacheSize();
    }
    _lastLocation = location;
  }

  @override
  void dispose() {
    _manager.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(value: _manager, child: SettingsPageWidget());
  }
}

class SettingsPageWidget extends StatelessWidget {
  const SettingsPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final sm = Provider.of<SettingsStateManager>(context, listen: false);
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                AppImages.iconLauncher,
                height: 32,
                width: 32,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12),
            Text(S.of(context).settings),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  LanguageSelectorWidget(),
                  SizedBox(height: 8),
                  ThemeSelectorWidget(),
                  SizedBox(height: 8),
                  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) BioSelectorWidget(),
                ],
              ),
            ),
            if (!kIsWeb)
              Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                width: double.infinity,
                child: StateBuilder(
                  stateReadable: sm,
                  buildWhen: (previous, current) =>
                      current is SettingsDataState,
                  builder: (context, state, child) {
                    String cacheSize = '';
                    bool isActive = false;
                    if (state is SettingsDataState) {
                      cacheSize = state.cacheSize == 0
                          ? ''
                          : '(${sm.formatBytes(context, bytes: state.cacheSize)})';
                      isActive = state.cacheSize > 0 ? true : false;
                    }
                    return ElevatedButton(
                      onPressed: isActive ? () => sm.clearCache() : null,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: context.color.accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        '${S.of(context).settings_cache} $cacheSize',
                        style: context.theme.memeSemiBold24.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class BioSelectorWidget extends StatelessWidget {
  const BioSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final sm = Provider.of<ApplicationStateManager>(context, listen: false);
    return SwitchWidget(
      text: S.of(context).settings_bio,
      onStateChanged: ({required value}) {
        sm.setBiometry(useBio: value);
      },
      initialState: sm.state.settingsData.useBiometry,
    );
  }
}

class ThemeSelectorWidget extends StatelessWidget {
  const ThemeSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final sm = Provider.of<ApplicationStateManager>(context, listen: false);
    return StateBuilder(
      stateReadable: sm,
      builder: (context, state, child) => SelectorWidget(
        title: S.of(context).theme,
        selectedValue: ThemeType.getThemeNameByCode(
          context,
          state.settingsData.themeType.code,
        ),
        onPress: () {
          Future.delayed(Duration(milliseconds: 150), () async {
            if (context.mounted) {
              final returnedCode = await showItemsBottomSheet(
                context,
                items: ThemeType.getThemeTypesMap(context: context),
                selectedItemCode: state.settingsData.themeType.code,
                title: S.of(context).settings_select_theme,
              );
              if (returnedCode != null) {
                final type = ThemeType.getThemeByCode(returnedCode);
                sm.setTheme(theme: type);
              }
            }
          });
        },
      ),
    );
  }
}

class LanguageSelectorWidget extends StatelessWidget {
  const LanguageSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final sm = Provider.of<ApplicationStateManager>(context, listen: true);
    return StateBuilder<ApplicationState>(
      stateReadable: sm,
      builder: (context, state, child) {
        return SelectorWidget(
          title: S.of(context).lang,
          selectedValue: LangType.getLangValueByCode(
            context,
            state.settingsData.langType.code,
          ),
          onPress: () {
            Future.delayed(Duration(milliseconds: 150), () async {
              if (context.mounted) {
                final returnedCode = await showItemsBottomSheet(
                  context,
                  items: LangType.getLangMap(context: context),
                  selectedItemCode: state.settingsData.langType.code,
                  title: S.of(context).settings_select_lang,
                );
                if (returnedCode != null) {
                  final lang = LangType.getLangByCode(returnedCode);
                  sm.setLanguage(lang: lang);
                }
              }
            });
          },
        );
      },
    );
  }
}
