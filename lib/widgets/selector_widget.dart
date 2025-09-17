import 'package:flutter/material.dart';
import 'package:memogenerator/theme/extensions/theme_extensions.dart';

class SelectorWidget extends StatelessWidget {
  const SelectorWidget({
    super.key,
    required this.onPress,
    required this.title,
    required this.selectedValue,
  });

  final VoidCallback onPress;
  final String title;
  final String selectedValue;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPress,
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        ),
        shape: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide.none,
            );
          }
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide.none,
          );
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Color(0x66000000);
          }
          return context.color.textPrimaryColor;
        }),
        elevation: WidgetStatePropertyAll(0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: context.theme.memeSemiBold20),
          Text(
            selectedValue,
            style: context.theme.memeBold20.copyWith(
              color: context.color.accentColor,
            ),
          ),
        ],
      ),
    );
  }
}