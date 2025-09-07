import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:memogenerator/theme/extensions/theme_extensions.dart';
import '../../generated/l10n.dart';
import '../../resources/app_icons.dart';

class MainPage extends StatelessWidget {
  const MainPage({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _BottomNavBarIconWidget(
              icon: AppIcons.iconMeme,
              color: context.color.iconUnselectedColor,
            ),
            activeIcon: _BottomNavBarIconWidget(
              icon: AppIcons.iconMeme,
              color: context.color.iconSelectedColor,
            ),
            label: S.of(context).memes,
          ),
          BottomNavigationBarItem(
            icon: _BottomNavBarIconWidget(
              icon: AppIcons.iconTemplate,
              color: context.color.iconUnselectedColor,
            ),
            activeIcon: _BottomNavBarIconWidget(
              icon: AppIcons.iconTemplate,
              color: context.color.iconSelectedColor,
            ),
            label: S.of(context).templates,
          ),
          BottomNavigationBarItem(
            icon: _BottomNavBarIconWidget(
              icon: AppIcons.iconSettings,
              color: context.color.iconUnselectedColor,
            ),
            activeIcon: _BottomNavBarIconWidget(
              icon: AppIcons.iconSettings,
              color: context.color.iconSelectedColor,
            ),
            label: S.of(context).settings,
          ),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) {
          _onTap(context, index);
        },
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class _BottomNavBarIconWidget extends StatelessWidget {
  const _BottomNavBarIconWidget({
    required this.color,
    required this.icon,
  });

  final Color color;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 4),
      child: SvgPicture.asset(
        icon,
        width: 38,
        height: 38,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}
