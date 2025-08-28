import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:memogenerator/di/app_scope.dart';
import 'package:memogenerator/navigation/navigation_helper.dart';
import 'package:yx_scope_flutter/yx_scope_flutter.dart';

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
    _appScopeHolder.create();
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
            theme: ThemeData(primarySwatch: Colors.blue),
            routerConfig: CustomNavigationHelper.instance.router,
          );
        },
        placeholder: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
