import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:memogenerator/di_sm/application_sm/application_sm.dart';
import 'package:memogenerator/navigation/navigation_helper.dart';
import 'package:memogenerator/theme/dark_theme.dart';
import 'package:memogenerator/theme/light_theme.dart';
import 'package:provider/provider.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';
import 'package:yx_state/yx_state.dart';
import 'package:yx_state_flutter/yx_state_flutter.dart';

import 'di_sm/app_scope.dart';
import 'di_sm/application_sm/settings_data.dart';
import 'di_sm/state_observer.dart';
import 'features/settings/entities/theme_types.dart';
import 'generated/l10n.dart';
import 'resources/app_colors.dart';

void main() async {
  EquatableConfig.stringify = true;
  WidgetsFlutterBinding.ensureInitialized();
  CustomNavigationHelper();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appScopeHolder = AppScopeHolder();
  late final ApplicationStateManager _appStateManager;

  @override
  void initState() {
    super.initState();
    _appScopeHolder.create().then((_) {
      _appStateManager = _appScopeHolder.scope!.appStateManager.get;

      StateManagerOverrides.observer = LoggingObserver(
        talker: _appScopeHolder.scope!.talkerDep.get,
      );
    });
  }

  @override
  void dispose() {
    _appStateManager.close();
    _appScopeHolder.drop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopeProvider(
      holder: _appScopeHolder,
      child: ScopeBuilder<AppScopeContainer>.withPlaceholder(
        builder: (BuildContext context, AppScopeContainer appScope) {
          return Provider.value(
            value: _appStateManager,
            child: StateBuilder<ApplicationState>(
              stateReadable: _appStateManager,
              builder: (context, state, child) {
                late final Brightness brightness;
                switch (state.settingsData.themeType) {
                  case ThemeType.lightTheme:
                    brightness = Brightness.light;
                    break;
                  case ThemeType.darkTheme:
                    brightness = Brightness.dark;
                    break;
                  case ThemeType.systemTheme:
                    brightness = MediaQuery.of(context).platformBrightness;
                    break;
                }
                SystemChrome.setSystemUIOverlayStyle(
                  brightness == Brightness.dark
                      ? SystemUiOverlayStyle.light
                      : SystemUiOverlayStyle.dark,
                );

                return MaterialApp.router(
                  title: 'Memegenerator',
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates: const [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  locale: state.settingsData.locale,
                  supportedLocales: S.delegate.supportedLocales,
                  localeResolutionCallback: (locale, supportedLocales) {
                    for (var supportedLocale in supportedLocales) {
                      if (supportedLocale.languageCode ==
                              locale?.languageCode &&
                          supportedLocale.countryCode == locale?.countryCode) {
                        return supportedLocale;
                      }
                    }
                    for (var supportedLocale in supportedLocales) {
                      if (supportedLocale.languageCode ==
                          locale?.languageCode) {
                        return supportedLocale;
                      }
                    }
                    return const Locale('en', 'US');
                  },
                  theme: lightTheme,
                  darkTheme: darkTheme,
                  themeMode: brightness == Brightness.dark
                      ? ThemeMode.dark
                      : ThemeMode.light,
                  routerConfig: CustomNavigationHelper.instance.router,
                );
              },
            ),
          );
        },
        placeholder: Container(
          height: double.infinity,
          width: double.infinity,
          color: AppColors.dayPrimaryColor,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
