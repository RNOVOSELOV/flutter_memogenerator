import 'package:flutter/material.dart';
import 'package:memogenerator/features/settings/entities/lang_types.dart';
import 'package:memogenerator/theme/extensions/theme_extensions.dart';
import 'package:memogenerator/widgets/switch_widget.dart';

import '../../generated/l10n.dart';
import '../../resources/app_images.dart';
import '../../widgets/selector_bottom_sheet.dart';
import '../../widgets/selector_widget.dart';
import 'entities/theme_types.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  SelectorWidget(
                    title: S.of(context).lang,
                    selectedValue: 'Значение',
                    onPress: () {
                      Future.delayed(Duration(milliseconds: 150), () async {
                        if (context.mounted) {
                          // final bloc = context.read<SettingsBloc>();
                          // final themeCubit = context.read<ThemeCubit>();
                          // final int? returnedCode;
                          final returnedCode = await showItemsBottomSheet(
                            context,
                            items: LangType.getLangMap(context: context),
                            selectedItemCode: -1,
                            title: 'Выбери язык',
                          );
                          // if (returnedCode != null) {
                          //   final ThemeType type = ThemeType.getTypeByCode(returnedCode);
                          //   bloc.add(SettingsSetThemeModeEvent(themeType: type));
                          //   themeCubit.setThemeBrightness(type);
                          // }
                        }
                      });
                    },
                  ),
                  SizedBox(height: 8),
                  SelectorWidget(
                    title: S.of(context).theme,
                    selectedValue: 'Значение',
                    onPress: () {
                      Future.delayed(Duration(milliseconds: 150), () async {
                        if (context.mounted) {
                          // final bloc = context.read<SettingsBloc>();
                          // final themeCubit = context.read<ThemeCubit>();
                          // final int? returnedCode;
                          final returnedCode = await showItemsBottomSheet(
                            context,
                            items: ThemeType.getThemeTypesMap(context: context),
                            selectedItemCode: -1,
                            title: 'Выбери тему',
                          );
                          // if (returnedCode != null) {
                          //   final ThemeType type = ThemeType.getTypeByCode(returnedCode);
                          //   bloc.add(SettingsSetThemeModeEvent(themeType: type));
                          //   themeCubit.setThemeBrightness(type);
                          // }
                        }
                      });
                    },
                  ),
                  SizedBox(height: 8),
                  SwitchWidget(
                    text: 'Использовать вход по биометрии',
                    onStateChanged: ({required value}) {},
                    initialState: false,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: context.color.accentColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
                child: Text(
                  S.of(context).settings_cache,
                  style: context.theme.memeSemiBold24.copyWith(color: Colors.white)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
