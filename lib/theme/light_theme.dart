import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../resources/app_colors.dart';
import 'extensions/theme_colors.dart';

final _base = ThemeData.light();

final lightTheme = _base.copyWith(
  extensions: <ThemeExtension<dynamic>>[ThemeColors.light],
  primaryColor: AppColors.dayPrimaryColor,
  scaffoldBackgroundColor: AppColors.daySurfacesColor,
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.dayAccentColor),

  bottomNavigationBarTheme: _base.bottomNavigationBarTheme.copyWith(
    backgroundColor: AppColors.daySurfacesSecondaryColor,
    elevation: 3,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    enableFeedback: true,
    selectedItemColor: AppColors.dayIconColor,
    unselectedItemColor: AppColors.dayIconDisabledColor,
    selectedIconTheme: IconThemeData(color: AppColors.nightIconColor),
    unselectedIconTheme: IconThemeData(color: AppColors.nightIconDisabledColor),
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      fontSize: 16,
      height: 18 / 16,
      color: AppColors.dayTextColor,
    ),
    unselectedLabelStyle: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 18 / 16,
      color: AppColors.daySecondaryTextColor,
    ),
  ),

  floatingActionButtonTheme: _base.floatingActionButtonTheme.copyWith(
    enableFeedback: true,
    backgroundColor: AppColors.dayAccentColor,
    foregroundColor: AppColors.daySurfacesColor,
    elevation: 3,
  ),

  appBarTheme: _base.appBarTheme.copyWith(
    elevation: 3,
    centerTitle: false,
    backgroundColor: AppColors.dayPrimaryColor,
    foregroundColor: AppColors.dayAppBarForegroundColor,
    titleTextStyle: GoogleFonts.seymourOne(
      fontSize: 22,
      color: AppColors.dayAppBarForegroundColor,
    ),
  ),

  progressIndicatorTheme: _base.progressIndicatorTheme.copyWith(
    color: AppColors.dayAccentColor,
    circularTrackColor: AppColors.daySurfacesColor,
  ),

  dialogTheme: _base.dialogTheme.copyWith(
    backgroundColor: AppColors.daySurfacesTertiaryColor.withValues(alpha: 1.0),
    barrierColor: AppColors.daySurfacesTertiaryColor.withValues(alpha: 0.58),
  ),

  inputDecorationTheme: _base.inputDecorationTheme.copyWith(
    hintStyle: GoogleFonts.roboto(
      color: AppColors.daySecondaryTextColor.withValues(alpha: 0.8),
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 1,
      letterSpacing: 0.4,
    ),
    labelStyle: GoogleFonts.roboto(
      color: AppColors.daySecondaryTextColor,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: 20,
      height: 1,
      letterSpacing: 0.4,
    ),
    fillColor: AppColors.dayAccentColor.withValues(alpha: 0.38),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    border: UnderlineInputBorder(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(4),
        topRight: Radius.circular(4),
      ),
      borderSide: BorderSide(
        width: 1,
        color: AppColors.dayAccentColor.withValues(alpha: 0.38),
      ),
    ),
    disabledBorder: UnderlineInputBorder(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(4),
        topRight: Radius.circular(4),
      ),
      borderSide: BorderSide(
        width: 1,
        color: AppColors.dayAccentColor.withValues(alpha: 0.38),
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(4),
        topRight: Radius.circular(4),
      ),
      borderSide: BorderSide(width: 2, color: AppColors.dayAccentColor),
    ),
  ),

  textTheme: _base.textTheme.copyWith(
    // memeBold24
    displayLarge: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      fontSize: 24,
      height: 24 / 24,
      color: AppColors.dayTextColor,
    ),
    // memeSemiBold24
    displayMedium: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      fontSize: 24,
      height: 24 / 24,
      color: AppColors.dayTextColor,
    ),
    // memeRegular24
    displaySmall: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: 24,
      height: 24 / 24,
      color: AppColors.dayTextColor,
    ),
    // memeBold20
    headlineLarge: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      fontSize: 20,
      height: 20 / 20,
      color: AppColors.dayTextColor,
    ),
    // memeSemiBold20
    headlineMedium: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      fontSize: 20,
      height: 20 / 20,
      color: AppColors.dayTextColor,
    ),
    // memeRegular20
    headlineSmall: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: 20,
      height: 20 / 20,
      color: AppColors.dayTextColor,
    ),
    // memeBold16
    titleLarge: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      fontSize: 16,
      height: 16 / 16,
      color: AppColors.dayTextColor,
    ),
    // memeSemiBold16
    titleMedium: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      fontSize: 16,
      height: 16 / 16,
      color: AppColors.dayTextColor,
    ),
    // memeRegular16
    titleSmall: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 16 / 16,
      color: AppColors.dayTextColor,
    ),
    // memeBold14
    bodyLarge: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      fontSize: 14,
      height: 14 / 14,
      color: AppColors.dayTextColor,
    ),
    // memeSemiBold14
    bodyMedium: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      fontSize: 14,
      height: 14 / 14,
      color: AppColors.dayTextColor,
    ),
    // memeRegular14
    bodySmall: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: 14,
      height: 14 / 14,
      color: AppColors.dayTextColor,
    ),
    // memeBold12
    labelLarge: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      fontSize: 12,
      height: 12 / 12,
      color: AppColors.dayTextColor,
    ),
    // memeSemiBold12
    labelMedium: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      fontSize: 12,
      height: 12 / 12,
      color: AppColors.dayTextColor,
    ),
    // memeRegular12
    labelSmall: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: 12,
      height: 12 / 12,
      color: AppColors.dayTextColor,
    ),
  ),

  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.daySurfacesColor;
      }
      return AppColors.daySurfacesSecondaryColor;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.dayPrimaryColor;
      }
      return AppColors.daySurfacesSecondaryColor;
    }),
    trackOutlineColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.dayPrimaryColor;
      }
      return AppColors.daySurfacesSecondaryColor;
    }),
  ),

  radioTheme: RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.dayPrimaryColor;
      }
      return AppColors.daySurfacesSecondaryColor;
    }),
  ),
);
