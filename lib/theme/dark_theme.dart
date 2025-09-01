import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../resources/app_colors.dart';
import 'extensions/theme_colors.dart';

final _base = ThemeData.light();

final darkTheme = _base.copyWith(
  extensions: <ThemeExtension<dynamic>>[ThemeColors.dark],
  primaryColor: AppColors.nightPrimaryColor,
  scaffoldBackgroundColor: AppColors.nightSurfacesColor,
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.nightAccentColor),

  bottomNavigationBarTheme: _base.bottomNavigationBarTheme.copyWith(
    backgroundColor: AppColors.nightSurfacesSecondaryColor,
    elevation: 3,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    enableFeedback: true,
    selectedItemColor: AppColors.nightIconColor,
    unselectedItemColor: AppColors.nightIconDisabledColor,
    selectedIconTheme: IconThemeData(color: AppColors.nightIconColor),
    unselectedIconTheme: IconThemeData(color: AppColors.nightIconDisabledColor),
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      fontSize: 16,
      height: 18 / 16,
      color: AppColors.nightTextColor,
    ),
    unselectedLabelStyle: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 18 / 16,
      color: AppColors.nightSecondaryTextColor,
    ),
  ),

  floatingActionButtonTheme: _base.floatingActionButtonTheme.copyWith(
    enableFeedback: true,
    backgroundColor: AppColors.nightAccentColor,
    foregroundColor: AppColors.daySurfacesColor,
    elevation: 3,
  ),

  appBarTheme: _base.appBarTheme.copyWith(
    elevation: 3,
    centerTitle: false,
    backgroundColor: AppColors.nightPrimaryColor,
    foregroundColor: AppColors.nightAppBarForegroundColor,
    titleTextStyle: GoogleFonts.seymourOne(
      fontSize: 22,
      color: AppColors.nightAppBarForegroundColor,
    ),
  ),

  progressIndicatorTheme: _base.progressIndicatorTheme.copyWith(
    color: AppColors.nightAccentColor,
    circularTrackColor: AppColors.nightSurfacesColor,
  ),

  dialogTheme: _base.dialogTheme.copyWith(
    backgroundColor: AppColors.nightSurfacesTertiaryColor.withValues(
      alpha: 1.0,
    ),
    barrierColor: AppColors.nightSurfacesTertiaryColor.withValues(alpha: 0.58),
  ),

  inputDecorationTheme: _base.inputDecorationTheme.copyWith(
    hintStyle: GoogleFonts.roboto(
      color: AppColors.nightSecondaryTextColor.withValues(alpha: 0.8),
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 1,
      letterSpacing: 0.4,
    ),
    labelStyle: GoogleFonts.roboto(
      color: AppColors.nightSecondaryTextColor,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: 20,
      height: 1,
      letterSpacing: 0.4,
    ),
    fillColor: AppColors.nightAccentColor.withValues(alpha: 0.38),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    border: UnderlineInputBorder(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(4),
        topRight: Radius.circular(4),
      ),
      borderSide: BorderSide(
        width: 1,
        color: AppColors.nightAccentColor.withValues(alpha: 0.38),
      ),
    ),
    disabledBorder: UnderlineInputBorder(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(4),
        topRight: Radius.circular(4),
      ),
      borderSide: BorderSide(
        width: 1,
        color: AppColors.nightAccentColor.withValues(alpha: 0.38),
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(4),
        topRight: Radius.circular(4),
      ),
      borderSide: BorderSide(width: 2, color: AppColors.nightAccentColor),
    ),
  ),

  textTheme: _base.textTheme.copyWith(
    // memeBold24
    displayLarge: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      fontSize: 24,
      height: 24 / 24,
      color: AppColors.nightTextColor,
    ),
    // memeSemiBold24
    displayMedium: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      fontSize: 24,
      height: 24 / 24,
      color: AppColors.nightTextColor,
    ),
    // memeRegular24
    displaySmall: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: 24,
      height: 24 / 24,
      color: AppColors.nightTextColor,
    ),
    // memeBold20
    headlineLarge: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      fontSize: 20,
      height: 20 / 20,
      color: AppColors.nightTextColor,
    ),
    // memeSemiBold20
    headlineMedium: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      fontSize: 20,
      height: 20 / 20,
      color: AppColors.nightTextColor,
    ),
    // memeRegular20
    headlineSmall: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: 20,
      height: 20 / 20,
      color: AppColors.nightTextColor,
    ),
    // memeBold16
    titleLarge: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      fontSize: 16,
      height: 16 / 16,
      color: AppColors.nightTextColor,
    ),
    // memeSemiBold16
    titleMedium: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      fontSize: 16,
      height: 16 / 16,
      color: AppColors.nightTextColor,
    ),
    // memeRegular16
    titleSmall: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 16 / 16,
      color: AppColors.nightTextColor,
    ),
    // memeBold14
    bodyLarge: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      fontSize: 14,
      height: 14 / 14,
      color: AppColors.nightTextColor,
    ),
    // memeSemiBold14
    bodyMedium: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      fontSize: 14,
      height: 14 / 14,
      color: AppColors.nightTextColor,
    ),
    // memeRegular14
    bodySmall: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: 14,
      height: 14 / 14,
      color: AppColors.nightTextColor,
    ),
    // memeBold12
    labelLarge: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      fontSize: 12,
      height: 12 / 12,
      color: AppColors.nightTextColor,
    ),
    // memeSemiBold12
    labelMedium: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      fontSize: 12,
      height: 12 / 12,
      color: AppColors.nightTextColor,
    ),
    // memeRegular12
    labelSmall: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: 12,
      height: 12 / 12,
      color: AppColors.nightTextColor,
    ),
  ),

  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.nightSurfacesColor;
      }
      return AppColors.nightSurfacesSecondaryColor;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.nightPrimaryColor;
      }
      return AppColors.nightSurfacesSecondaryColor;
    }),
    trackOutlineColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.nightPrimaryColor;
      }
      return AppColors.nightSurfacesSecondaryColor;
    }),
  ),

  radioTheme: RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.nightPrimaryColor;
      }
      return AppColors.nightSurfacesSecondaryColor;
    }),
  ),
);
