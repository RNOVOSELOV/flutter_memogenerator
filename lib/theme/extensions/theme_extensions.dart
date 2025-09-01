import 'package:flutter/material.dart';
import 'package:memogenerator/theme/extensions/theme_colors.dart';

extension ThemeBuildContext on BuildContext {
  ThemeData get theme => Theme.of(this);

  ThemeColors get color => Theme.of(this).extension<ThemeColors>()!;
}

// extension ThemeStylesExtension on ThemeData {
//   TextStyle get crewBold24 => textTheme.displayLarge!;
//
//   TextStyle get crewSemiBold24 => textTheme.displayMedium!;
//
//   TextStyle get crewRegular24 => textTheme.displaySmall!;
//
//   TextStyle get crewBold20 => textTheme.headlineLarge!;
//
//   TextStyle get crewSemiBold20 => textTheme.headlineMedium!;
//
//   TextStyle get crewRegular20 => textTheme.headlineSmall!;
//
//   TextStyle get crewBold16 => textTheme.titleLarge!;
//
//   TextStyle get crewSemiBold16 => textTheme.titleMedium!;
//
//   TextStyle get crewRegular16 => textTheme.titleSmall!;
//
//   TextStyle get crewBold14 => textTheme.bodyLarge!;
//
//   TextStyle get crewSemiBold14 => textTheme.bodyMedium!;
//
//   TextStyle get crewRegular14 => textTheme.bodySmall!;
//
//   TextStyle get crewBold12 => textTheme.labelLarge!;
//
//   TextStyle get crewSemiBold12 => textTheme.labelMedium!;
//
//   TextStyle get crewRegular12 => textTheme.labelSmall!;
//
//   // TODO REMOVE BOTTOM AFTER REDESIGN
//
//   TextStyle get cardText => textTheme.labelSmall!;
//
//   TextStyle get crewMobileLabelSmall => textTheme.labelMedium!;
//
//   TextStyle get m3BodyLarge => textTheme.titleSmall!;
//
//   TextStyle get m3LabelSmall => textTheme.labelMedium!;
//
//   TextStyle get m3BodySmall => textTheme.labelSmall!;
// }

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
