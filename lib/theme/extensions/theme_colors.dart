import 'package:flutter/material.dart';
import 'package:memogenerator/resources/app_colors.dart';

class ThemeColors extends ThemeExtension<ThemeColors> {
  final Color iconSelectedColor;
  final Color iconUnselectedColor;
  final Color cardBackgroundColor;
  final Color cardBorderColor;
  final Color textIconColor;
  final Color textPrimaryColor;
  final Color texSecondaryColor;
  final Color accentColor;

  const ThemeColors({
    required this.iconSelectedColor,
    required this.iconUnselectedColor,
    required this.cardBackgroundColor,
    required this.cardBorderColor,
    required this.textIconColor,
    required this.textPrimaryColor,
    required this.texSecondaryColor,
    required this.accentColor,
  });

  @override
  ThemeExtension<ThemeColors> copyWith({
    Color? iconSelectedColor,
    Color? iconUnselectedColor,
    Color? cardBackgroundColor,
    Color? cardBorderColor,
    Color? textIconColor,
    Color? textPrimaryColor,
    Color? texSecondaryColor,
    Color? accentColor,
  }) {
    return ThemeColors(
      iconSelectedColor: iconSelectedColor ?? this.iconSelectedColor,
      iconUnselectedColor: iconUnselectedColor ?? this.iconUnselectedColor,
      cardBackgroundColor: cardBackgroundColor ?? this.cardBackgroundColor,
      cardBorderColor: cardBorderColor ?? this.cardBorderColor,
      textIconColor: textIconColor ?? this.textIconColor,
      textPrimaryColor: textPrimaryColor ?? this.textPrimaryColor,
      texSecondaryColor: texSecondaryColor ?? this.texSecondaryColor,
      accentColor: accentColor ?? this.accentColor,
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
      cardBackgroundColor: Color.lerp(
        cardBackgroundColor,
        other.cardBackgroundColor,
        t,
      )!,
      cardBorderColor: Color.lerp(cardBorderColor, other.cardBorderColor, t)!,
      textIconColor: Color.lerp(textIconColor, other.textIconColor, t)!,
      textPrimaryColor: Color.lerp(textPrimaryColor, other.textPrimaryColor, t)!,
      texSecondaryColor: Color.lerp(texSecondaryColor, other.texSecondaryColor, t)!,
      accentColor: Color.lerp(accentColor, other.accentColor, t)!,
    );
  }

  static ThemeColors get light => const ThemeColors(
    iconSelectedColor: AppColors.dayIconColor,
    iconUnselectedColor: AppColors.dayIconDisabledColor,
    cardBackgroundColor: AppColors.daySurfacesTertiaryColor,
    cardBorderColor: AppColors.daySecondaryTextColor,
    textIconColor: AppColors.daySecondaryTextColor,
    textPrimaryColor: AppColors.dayTextColor,
    texSecondaryColor: AppColors.dayTextTertiaryColor,
    accentColor: AppColors.dayAccentColor,
  );

  static ThemeColors get dark => const ThemeColors(
    iconSelectedColor: AppColors.nightIconColor,
    iconUnselectedColor: AppColors.nightIconDisabledColor,
    cardBackgroundColor: AppColors.nightSurfacesTertiaryColor,
    cardBorderColor: AppColors.nightSecondaryTextColor,
    textIconColor: AppColors.nightSecondaryTextColor,
    textPrimaryColor: AppColors.nightTextColor,
    texSecondaryColor: AppColors.nightTextTertiaryColor,
    accentColor: AppColors.nightAccentColor,
  );
}
