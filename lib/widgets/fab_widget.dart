import 'package:flutter/material.dart';

import '../resources/app_colors.dart';

class CreateFab extends StatelessWidget {
  const CreateFab({super.key, required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onTap,
      icon: const Icon(Icons.add, color: AppColors.white),
      backgroundColor: AppColors.fabColor,
      label: Text(text, style: TextStyle(color: AppColors.white)),
    );
  }
}
