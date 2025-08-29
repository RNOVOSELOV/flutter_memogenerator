import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:memogenerator/resources/app_colors.dart';
import '../../resources/app_icons.dart';

class MainPage extends StatelessWidget {
  const MainPage({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 3,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcons.iconMeme,
              width: 32,
              height: 32,
              colorFilter: ColorFilter.mode(
                AppColors.darkGrey38,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              AppIcons.iconMeme,
              width: 32,
              height: 32,
            ),
            label: 'Мемы',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcons.iconTemplate,
              width: 32,
              height: 32,
              colorFilter: ColorFilter.mode(
                AppColors.darkGrey38,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              AppIcons.iconTemplate,
              width: 32,
              height: 32,
            ),
            label: 'Шаблоны',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AppIcons.iconSettings,
              width: 32,
              height: 32,
              colorFilter: ColorFilter.mode(
                AppColors.darkGrey38,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              AppIcons.iconSettings,
              width: 32,
              height: 32,
            ),
            label: 'Настройки',
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
