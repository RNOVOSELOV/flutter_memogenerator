import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:memogenerator/navigation/navigation_helper.dart';
import 'package:memogenerator/theme/dark_theme.dart';
import 'package:memogenerator/theme/light_theme.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';
import 'package:yx_state/yx_state.dart';

import 'di_sm/app_scope.dart';
import 'di_sm/state_observer.dart';
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

  @override
  void initState() {
    super.initState();
    _appScopeHolder.create().then(
      (_) => StateManagerOverrides.observer = LoggingObserver(
        talker: _appScopeHolder.scope!.talkerDep.get,
      ),
    );
  }

  @override
  void dispose() {
    _appScopeHolder.drop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopeProvider(
      holder: _appScopeHolder,
      child: ScopeBuilder<AppScopeContainer>.withPlaceholder(
        builder: (BuildContext context, AppScopeContainer appScope) {
          return MaterialApp.router(
            title: 'Memegenerator',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: WidgetsBinding.instance.platformDispatcher.locale,
            supportedLocales: S.delegate.supportedLocales,
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode &&
                    supportedLocale.countryCode == locale?.countryCode) {
                  return supportedLocale;
                }
              }
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode) {
                  return supportedLocale;
                }
              }
              return const Locale('en', 'US');
            },
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            routerConfig: CustomNavigationHelper.instance.router,
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
