import 'package:flutter/material.dart';
import 'package:memogenerator/di_sm/application_sm/application_sm.dart';
import 'package:memogenerator/features/settings/entities/lang_types.dart';
import 'package:memogenerator/theme/extensions/theme_extensions.dart';
import 'package:memogenerator/widgets/switch_widget.dart';
import 'package:provider/provider.dart';

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
                  LanguageSelectorWidget(),
                  SizedBox(height: 8),
                  ThemeSelectorWidget(),
                  SizedBox(height: 8),
                  BioSelectorWidget(),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  S.of(context).settings_cache,
                  style: context.theme.memeSemiBold24.copyWith(
                    color: Colors.white,
                  ),
                ),
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
    return SelectorWidget(
      title: S.of(context).theme,
      selectedValue: ThemeType.getThemeNameByCode(
        context,
        sm.state.settingsData.themeType.code,
      ),
      onPress: () {
        Future.delayed(Duration(milliseconds: 150), () async {
          if (context.mounted) {
            final returnedCode = await showItemsBottomSheet(
              context,
              items: ThemeType.getThemeTypesMap(context: context),
              selectedItemCode: sm.state.settingsData.themeType.code,
              title: S.of(context).settings_select_theme,
            );
            if (returnedCode != null) {
              final type = ThemeType.getThemeByCode(returnedCode);
              sm.setTheme(theme: type);
            }
          }
        });
      },
    );
  }
}

class LanguageSelectorWidget extends StatelessWidget {
  const LanguageSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final sm = Provider.of<ApplicationStateManager>(context, listen: false);
    return SelectorWidget(
      title: S.of(context).lang,
      selectedValue: LangType.getLangValueByCode(
        context,
        sm.state.settingsData.langType.code,
      ),
      onPress: () {
        Future.delayed(Duration(milliseconds: 150), () async {
          if (context.mounted) {
            final returnedCode = await showItemsBottomSheet(
              context,
              items: LangType.getLangMap(context: context),
              selectedItemCode: sm.state.settingsData.langType.code,
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
  }
}
