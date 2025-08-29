import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../resources/app_colors.dart';
import '../resources/app_images.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 3,
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
          Text(title, style: GoogleFonts.seymourOne(fontSize: 24)),
        ],
      ),
      floating: true,
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, kToolbarHeight);
}