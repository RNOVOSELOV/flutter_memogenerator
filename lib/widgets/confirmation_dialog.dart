import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memogenerator/resources/app_colors.dart';
import 'package:memogenerator/theme/extensions/theme_extensions.dart';

Future<bool?> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String text,
  required String actionButtonText,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: context.theme.memeSemiBold20,
        ),
        content: Text(
          text,
          style: context.theme.memeRegular16.copyWith(color: context.color.textSecondaryColor),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        actionsPadding: const EdgeInsets.only(bottom: 16, right: 8),
        actions: [
          AppButton(
            onTap: () async {
              await Future.delayed(Duration(milliseconds: 200), () {});
              if (!context.mounted) {
                return;
              }
              Navigator.of(context).pop(false);
            },
            labelText: 'Отмена',
            color: context.color.textIconColor,
          ),
          AppButton(
            onTap: () async {
              await Future.delayed(Duration(milliseconds: 200), () {});
              if (!context.mounted) {
                return;
              }
              Navigator.of(context).pop(true);
            },
            labelText: actionButtonText,
            color: context.color.accentColor,
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
  final Color? color;
  final double fontSize;

  const AppButton({
    super.key,
    required this.onTap,
    required this.labelText,
    this.icon,
    this.color,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(icon, color: color ?? context.color.accentColor),
            const SizedBox(width: 8),
            Text(
              labelText.toUpperCase(),
              style: TextStyle(
                color: color,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
