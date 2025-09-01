import 'package:flutter/material.dart';
import 'package:memogenerator/theme/extensions/theme_extensions.dart';
import 'package:uuid/uuid.dart';

import '../resources/app_colors.dart';

class CreateFab extends StatelessWidget {
  const CreateFab({super.key, required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: Uuid().v1(),
      onPressed: onTap,
      icon: const Icon(Icons.add),
      label: Text(
        text,
        style: context.theme.memeSemiBold16.copyWith(color: AppColors.daySurfacesColor),
      ),
    );
  }
}
