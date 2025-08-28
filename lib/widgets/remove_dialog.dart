import 'package:flutter/material.dart';
import 'package:memogenerator/resources/app_colors.dart';

Future<bool?> showConfirmationRemoveDialog(
  BuildContext context, {
  required String title,
  required String text,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(text),
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        actionsPadding: const EdgeInsets.only(bottom: 16, right: 16),
        actions: [
          AppButton(
            onTap: () => Navigator.of(context).pop(false),
            labelText: "Отмена",
            color: AppColors.darkGrey,
          ),
          AppButton(
            onTap: () => Navigator.of(context).pop(true),
            labelText: "Удалить",
            color: AppColors.fuchsia,
          ),
        ],
      );
    },
  );
}

class AppButton extends StatelessWidget {
  final VoidCallback onTap;
  final String labelText;
  final IconData? icon;
  final Color color;

  const AppButton({
    super.key,
    required this.onTap,
    required this.labelText,
    this.icon,
    this.color = AppColors.fuchsia,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(
              labelText.toUpperCase(),
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
