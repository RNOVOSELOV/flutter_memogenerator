import 'package:flutter/material.dart';
import 'package:memogenerator/theme/extensions/theme_extensions.dart';

import '../../generated/l10n.dart';
import '../../resources/app_images.dart';

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
      body: SafeArea(child: SizedBox.shrink()),
    );
  }
}
