import 'package:flutter/material.dart';
import 'package:memogenerator/resources/app_colors.dart';

class ThemeColors extends ThemeExtension<ThemeColors> {
  final Color iconSelectedColor;
  final Color iconUnselectedColor;
  final Color textPrimaryColor;

  const ThemeColors({
    required this.iconSelectedColor,
    required this.iconUnselectedColor,
    required this.textPrimaryColor,
  });

  @override
  ThemeExtension<ThemeColors> copyWith({
    Color? iconSelectedColor,
    Color? iconUnselectedColor,
    Color? textPrimaryColor,
  }) {
    return ThemeColors(
      iconSelectedColor: iconSelectedColor ?? this.iconSelectedColor,
      iconUnselectedColor: iconUnselectedColor ?? this.iconUnselectedColor,
      textPrimaryColor: textPrimaryColor ?? this.textPrimaryColor,
    );
  }

  @override
  ThemeExtension<ThemeColors> lerp(
    ThemeExtension<ThemeColors>? other,
    double t,
  ) {
    if (other is! ThemeColors) {
      return this;
    }
    return ThemeColors(
      iconSelectedColor: Color.lerp(
        iconSelectedColor,
        other.iconSelectedColor,
        t,
      )!,
      iconUnselectedColor: Color.lerp(
        iconUnselectedColor,
        other.iconUnselectedColor,
        t,
      )!,
      textPrimaryColor: Color.lerp(
        textPrimaryColor,
        other.textPrimaryColor,
        t,
      )!,
    );
  }

  static ThemeColors get light => const ThemeColors(
    iconSelectedColor: AppColors.dayIconColor,
    iconUnselectedColor: AppColors.dayIconDisabledColor,
    textPrimaryColor: AppColors.dayTextColor,
  );

  static ThemeColors get dark => const ThemeColors(
    iconSelectedColor: AppColors.nightIconColor,
    iconUnselectedColor: AppColors.nightIconDisabledColor,
    textPrimaryColor: AppColors.nightTextColor,
  );
}
