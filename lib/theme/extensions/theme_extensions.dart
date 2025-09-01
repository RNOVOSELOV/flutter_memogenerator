import 'package:flutter/material.dart';
import 'package:memogenerator/theme/extensions/theme_colors.dart';

extension ThemeBuildContext on BuildContext {
  ThemeData get theme => Theme.of(this);

  ThemeColors get color => Theme.of(this).extension<ThemeColors>()!;
}

extension ThemeStylesExtension on ThemeData {
  TextStyle get memeBold24 => textTheme.displayLarge!;

  TextStyle get memeSemiBold24 => textTheme.displayMedium!;

  TextStyle get memeRegular24 => textTheme.displaySmall!;

  TextStyle get memeBold20 => textTheme.headlineLarge!;

  TextStyle get memeSemiBold20 => textTheme.headlineMedium!;

  TextStyle get memeRegular20 => textTheme.headlineSmall!;

  TextStyle get memeBold16 => textTheme.titleLarge!;

  TextStyle get memeSemiBold16 => textTheme.titleMedium!;

  TextStyle get memeRegular16 => textTheme.titleSmall!;

  TextStyle get memeBold14 => textTheme.bodyLarge!;

  TextStyle get memeSemiBold14 => textTheme.bodyMedium!;

  TextStyle get memeRegular14 => textTheme.bodySmall!;

  TextStyle get memeBold12 => textTheme.labelLarge!;

  TextStyle get memeSemiBold12 => textTheme.labelMedium!;

  TextStyle get memeRegular12 => textTheme.labelSmall!;
}

/*
displayLarge
displayMedium
displaySmall
headlineLarge
headlineMedium
headlineSmall
titleLarge
titleMedium
titleSmall
bodyLarge
bodyMedium
bodySmall
labelLarge
labelMedium
labelSmall
 */
