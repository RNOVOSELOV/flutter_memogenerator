import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/resources/app_colors.dart';

import '../../resources/app_images.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppColors.backgroundAppbar,
        foregroundColor: AppColors.foregroundAppBar,
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
            Text("Настройки", style: GoogleFonts.seymourOne(fontSize: 24)),
          ],
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(child: SizedBox.shrink()),
    );
  }
}
