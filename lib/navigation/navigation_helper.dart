import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memogenerator/features/create_meme/create_meme_page.dart';
import 'package:memogenerator/features/create_meme/models/meme_parameters.dart';
import 'package:memogenerator/features/settings/settings_page.dart';
import 'package:memogenerator/navigation/navigation_path.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../features/main/main_page.dart';
import '../features/template_download/template_download_page.dart';
import '../features/templates/templates_page.dart';
import '../features/memes/memes_page.dart';

class CustomNavigationHelper {
  static final CustomNavigationHelper _instance =
      CustomNavigationHelper._internal();

  static CustomNavigationHelper get instance => _instance;

  static late final GoRouter _router;

  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _sectionNavigatorKey =
      GlobalKey<NavigatorState>();

  GoRouter get router => _router;

  BuildContext get context =>
      _router.routerDelegate.navigatorKey.currentContext!;

  GoRouterDelegate get routerDelegate => _router.routerDelegate;

  GoRouteInformationParser get routeInformationParser =>
      _router.routeInformationParser;

  factory CustomNavigationHelper() {
    return _instance;
  }

  CustomNavigationHelper._internal() {
    final talker = TalkerFlutter.init();
    _router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: NavigationPagePath.memesPage.path,
      observers: [TalkerRouteObserver(talker)],
      debugLogDiagnostics: kDebugMode ? true : false,
      routes: <RouteBase>[
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          name: NavigationPagePath.editMemePage.name,
          path: NavigationPagePath.editMemePage.path,
          pageBuilder: (context, state) {
            final arguments = state.extra as MemeArgs;
            return getPage(
              child: CreateMemePage(memeArgs: arguments),
              state: state,
            );
          },
        ),
        StatefulShellRoute.indexedStack(
          pageBuilder: (context, state, navigationShell) {
            return getPage(
              child: MainPage(navigationShell: navigationShell),
              state: state,
            );
          },
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
              preload: false,
              observers: [TalkerRouteObserver(talker)],
              navigatorKey: _sectionNavigatorKey,
              routes: <RouteBase>[
                GoRoute(
                  path: NavigationPagePath.memesPage.path,
                  pageBuilder: (context, state) {
                    return getPage(child: MemesPage(), state: state);
                  },
                  routes: <RouteBase>[],
                ),
              ],
            ),
            StatefulShellBranch(
              observers: [TalkerRouteObserver(talker)],
              routes: <RouteBase>[
                GoRoute(
                  name: NavigationPagePath.templatesPage.name,
                  path: NavigationPagePath.templatesPage.path,
                  pageBuilder: (context, state) =>
                      getPage(child: TemplatesPage(), state: state),
                  routes: <RouteBase>[
                    GoRoute(
                      name: NavigationPagePath.templateDownloadPage.name,
                      path: NavigationPagePath.templateDownloadPage.path,
                      builder: (BuildContext context, GoRouterState state) =>
                          const TemplateDownloadPage(),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              observers: [TalkerRouteObserver(talker)],
              routes: <RouteBase>[
                GoRoute(
                  path: NavigationPagePath.settingsPage.path,
                  pageBuilder: (context, state) =>
                      getPage(child: SettingsPage(), state: state),
                  routes: <RouteBase>[],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static Page getPage({
    required Widget child,
    required GoRouterState state,
    bool isFullScreenDialog = false,
  }) {
    return MaterialPage(
      key: state.pageKey,
      fullscreenDialog: isFullScreenDialog,
      child: child,
    );
  }
}
