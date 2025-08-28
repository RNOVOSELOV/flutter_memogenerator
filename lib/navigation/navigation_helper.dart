import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memogenerator/navigation/navigation_path.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../features/home/main_page.dart';
import '../features/main/main_page.dart';
import '../main.dart';

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
      routes: <RouteBase>[
        // The details screen to display stacked on navigator
        // This will cover all screen with
        // shell (bottom navigation bar).
        // GoRoute(
        //   parentNavigatorKey: _rootNavigatorKey,
        //   name: '/root_path_name',
        //   path: '/root_path_name',
        //   pageBuilder: (context, state) => MaterialPage(
        //     child: DetailsScreen(label: 'QWERT'),
        //     key: state.pageKey,
        //     fullscreenDialog: false,
        //   ),
        // ),
        StatefulShellRoute.indexedStack(
          pageBuilder: (context, state, navigationShell) => getPage(
            child: MainPage(navigationShell: navigationShell),
            state: state,
          ),
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
              preload: false,
              observers: [TalkerRouteObserver(talker)],
              navigatorKey: _sectionNavigatorKey,
              routes: <RouteBase>[
                GoRoute(
                  path: NavigationPagePath.memesPage.path,
                  pageBuilder: (context, state) =>
                      getPage(child: MemesPage(), state: state),
                  routes: <RouteBase>[
                    // The details screen to display stacked on navigator of the
                    // first tab. This will cover screen A but not the application
                    // shell (bottom navigation bar).
                    // GoRoute(
                    //   path: '/memes/edit',
                    //   builder: (BuildContext context, GoRouterState state) =>
                    //       const EditMemesPage(),
                    // ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              observers: [TalkerRouteObserver(talker)],
              routes: <RouteBase>[
                GoRoute(
                  path: '/NavigationPagePath.memesPage.path',
                  pageBuilder: (context, state) =>
                      getPage(child: MemesPage(), state: state),
                  routes: <RouteBase>[],
                ),
              ],
            ),
            StatefulShellBranch(
              observers: [TalkerRouteObserver(talker)],
              routes: <RouteBase>[
                GoRoute(
                  path: '/NavigationPage',
                  pageBuilder: (context, state) =>
                      getPage(child: MemesPage(), state: state),
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
