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
      fontSize: 14,
      height: 16 / 14,
      color: AppColors.nightTextColor,
    ),
    unselectedLabelStyle: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: 14,
      height: 16 / 14,
      color: AppColors.nightSecondaryTextColor,
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
    backgroundColor: AppColors.nightPrimaryColor,
    foregroundColor: AppColors.nightAppBarForegroundColor,
    titleTextStyle: GoogleFonts.seymourOne(
      fontSize: 22,
      color: AppColors.nightAppBarForegroundColor,
    ),
  ),

  // textSelectionTheme: _base.textSelectionTheme.copyWith(
  //   selectionColor: AppColors.niebieski100A40,
  //   cursorColor: AppColors.niebieski100,
  //   selectionHandleColor: Colors.transparent,
  // ),
  //
  // inputDecorationTheme: _base.inputDecorationTheme.copyWith(
  //   hintStyle: GoogleFonts.roboto(
  //     color: AppColors.textSecondaryNight,
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w400,
  //     fontSize: 20,
  //     height: 1,
  //     letterSpacing: 0.4,
  //   ),
  //   labelStyle: GoogleFonts.roboto(
  //     color: AppColors.textSecondaryNight,
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w400,
  //     fontSize: 20,
  //     height: 1,
  //     letterSpacing: 0.4,
  //   ),
  //   prefixIconColor: AppColors.interactiveIconRestNight,
  //   suffixIconColor: AppColors.interactiveIconRestNight,
  //   fillColor: AppColors.interactiveBgRestNight,
  //   filled: true,
  //   errorStyle: GoogleFonts.roboto(
  //     color: AppColors.textErrorNight,
  //     fontSize: 14,
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w400,
  //     height: 1,
  //     letterSpacing: 0.4,
  //   ),
  //   contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
  //   border: OutlinedInputBorder(
  //     borderSide: BorderSide(color: AppColors.interactiveBgRestNight, width: 0),
  //     borderRadius: BorderRadius.all(Radius.circular(12)),
  //   ),
  //   enabledBorder: const OutlinedInputBorder(
  //     borderSide: BorderSide(color: AppColors.interactiveBgRestNight, width: 0),
  //     borderRadius: BorderRadius.all(Radius.circular(12)),
  //   ),
  //   focusedBorder: const OutlinedInputBorder(
  //     borderSide:
  //         BorderSide(color: AppColors.interactiveBgTappedNight, width: 0),
  //     borderRadius: BorderRadius.all(Radius.circular(12)),
  //   ),
  //   errorBorder: const OutlinedInputBorder(
  //     borderSide: BorderSide(color: AppColors.indicatorDangerNight, width: 3),
  //     borderRadius: BorderRadius.all(Radius.circular(12)),
  //   ),
  //   focusedErrorBorder: const OutlinedInputBorder(
  //     borderSide: BorderSide(color: AppColors.indicatorDangerNight, width: 3),
  //     borderRadius: BorderRadius.all(Radius.circular(12)),
  //   ),
  //   outlineBorder:
  //       BorderSide(color: AppColors.interactiveBgRestNight, width: 0),
  //   // disabledBorder: const OutlinedInputBorder(
  //   //   borderSide: BorderSide(
  //   //       color: AppColors.crewSysLightOutlineVariantColor, width: 1),
  //   //   borderRadius: BorderRadius.all(Radius.circular(12)),
  //   // ),
  // ),
  //
  // elevatedButtonTheme: ElevatedButtonThemeData(
  //   style: ButtonStyle(
  //     alignment: Alignment.center,
  //     padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 8)),
  //     shape: WidgetStatePropertyAll(RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(16),
  //     )),
  //     backgroundColor: WidgetStateProperty.resolveWith((states) {
  //       if (states.contains(WidgetState.disabled)) {
  //         return Color(0xFF26282F);
  //       }
  //       return AppColors.primaryDarkColor;
  //     }),
  //     foregroundColor: WidgetStateProperty.resolveWith((states) {
  //       if (states.contains(WidgetState.disabled)) {
  //         return Color(0xFFFFFFFF).withValues(alpha: 0.3);
  //       }
  //       return AppColors.whiteColor;
  //     }),
  //     textStyle: WidgetStateProperty.resolveWith(
  //       (states) {
  //         if (states.contains(WidgetState.disabled)) {
  //           return GoogleFonts.roboto(
  //             fontWeight: FontWeight.w500,
  //             fontSize: 20,
  //             fontStyle: FontStyle.normal,
  //             height: 14 / 20,
  //             letterSpacing: 0.4,
  //           );
  //         } else {
  //           return GoogleFonts.roboto(
  //             fontWeight: FontWeight.w500,
  //             fontSize: 20,
  //             fontStyle: FontStyle.normal,
  //             height: 14 / 20,
  //             letterSpacing: 0.4,
  //           );
  //         }
  //       },
  //     ),
  //   ),
  // ),
  //
  // textButtonTheme: TextButtonThemeData(
  //   style: ButtonStyle(
  //     alignment: Alignment.center,
  //     padding: WidgetStateProperty.all(EdgeInsets.zero),
  //     shape: WidgetStatePropertyAll(RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(16),
  //     )),
  //     foregroundColor: WidgetStateProperty.resolveWith((states) {
  //       if (states.contains(WidgetState.disabled)) {
  //         return Color(0xFFACACAC);
  //       }
  //       return AppColors.primaryColor;
  //     }),
  //     textStyle: WidgetStateProperty.resolveWith(
  //       (states) {
  //         if (states.contains(WidgetState.disabled)) {
  //           return GoogleFonts.roboto(
  //             fontWeight: FontWeight.w500,
  //             fontSize: 20,
  //             fontStyle: FontStyle.normal,
  //             height: 1,
  //             letterSpacing: 0.4,
  //           );
  //         } else {
  //           return GoogleFonts.roboto(
  //             fontWeight: FontWeight.w500,
  //             fontSize: 20,
  //             fontStyle: FontStyle.normal,
  //             height: 1,
  //             letterSpacing: 0.4,
  //           );
  //         }
  //       },
  //     ),
  //   ),
  // ),
  //
  // // TODO CHANGE
  // appBarTheme: _base.appBarTheme.copyWith(
  //   toolbarHeight: 48,
  //   elevation: 4,
  //   backgroundColor: AppColors.colorDarkBackground,
  //   surfaceTintColor: AppColors.colorDarkBackground,
  //   foregroundColor: AppColors.crewSysDarkOnSurfaceVariantFFC6C5D0,
  //   shadowColor: AppColors.colorDarkBackground..withValues(alpha: 0.5),
  //   centerTitle: false,
  //   titleTextStyle: GoogleFonts.roboto(
  //     fontSize: 22,
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w400,
  //     height: 28 / 22,
  //     color: AppColors.crewSysDarkOnSurfaceFFC8C6CA,
  //   ),
  // ),
  // bottomSheetTheme: _base.bottomSheetTheme.copyWith(
  //   elevation: 0,
  //   backgroundColor: const Color(0xFF1F1F23),
  //   shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.all(Radius.zero)),
  // ),
  // bottomNavigationBarTheme: _base.bottomNavigationBarTheme.copyWith(
  //   backgroundColor: AppColors.surfaceSurface10,
  //   elevation: 0,
  //   showSelectedLabels: true,
  //   showUnselectedLabels: true,
  //   selectedItemColor: AppColors.rolePrimaryNight,
  //   unselectedItemColor: AppColors.neutralNeutral100,
  //   selectedLabelStyle: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w700,
  //     fontSize: 12,
  //     height: 14 / 12,
  //   ),
  //   unselectedLabelStyle: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w400,
  //     fontSize: 12,
  //     height: 14 / 12,
  //   ),
  // ),
  // dialogTheme: _base.dialogTheme.copyWith(
  //   backgroundColor: AppColors.onSurfaceColorFF1B1B1F,
  //   surfaceTintColor: AppColors.onSurfaceColorFF1B1B1F,
  //   elevation: 4,
  //   shadowColor:
  //       AppColors.crewSysLightSurfaceContainerF0EDF1.withValues(alpha: 0.5),
  // ),
  // textTheme: _base.textTheme.copyWith(
  //   //   crewBold24
  //   displayLarge: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w700,
  //     fontSize: 24,
  //     height: 24 / 24,
  //     color: AppColors.textPrimaryNight,
  //   ),
  //   // crewSemiBold24
  //   displayMedium: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w600,
  //     fontSize: 24,
  //     height: 24 / 24,
  //     color: AppColors.textPrimaryNight,
  //   ),
  //   // crewRegular24
  //   displaySmall: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w400,
  //     fontSize: 24,
  //     height: 24 / 24,
  //     color: AppColors.textPrimaryNight,
  //   ),
  //   // crewBold20
  //   headlineLarge: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w700,
  //     fontSize: 20,
  //     height: 20 / 20,
  //     color: AppColors.textPrimaryNight,
  //   ),
  //   // crewSemiBold20
  //   headlineMedium: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w600,
  //     fontSize: 20,
  //     height: 20 / 20,
  //     color: AppColors.textPrimaryNight,
  //   ),
  //   // crewRegular20
  //   headlineSmall: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w400,
  //     fontSize: 20,
  //     height: 20 / 20,
  //     color: AppColors.textPrimaryNight,
  //   ),
  //   // crewBold16
  //   titleLarge: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w700,
  //     fontSize: 16,
  //     height: 16 / 16,
  //     color: AppColors.textPrimaryNight,
  //   ),
  //   // crewSemiBold16
  //   titleMedium: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w600,
  //     fontSize: 16,
  //     height: 16 / 16,
  //     color: AppColors.textPrimaryNight,
  //   ),
  //   // crewRegular16
  //   titleSmall: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w400,
  //     fontSize: 16,
  //     height: 16 / 16,
  //     color: AppColors.textPrimaryNight,
  //   ),
  //   // crewBold14
  //   bodyLarge: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w700,
  //     fontSize: 14,
  //     height: 14 / 14,
  //     color: AppColors.textPrimaryNight,
  //   ),
  //   // crewSemiBold14
  //   bodyMedium: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w600,
  //     fontSize: 14,
  //     height: 14 / 14,
  //     color: AppColors.textPrimaryNight,
  //   ),
  //   // crewRegular14
  //   bodySmall: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w400,
  //     fontSize: 14,
  //     height: 14 / 14,
  //     color: AppColors.textPrimaryNight,
  //   ),
  //   // crewBold12
  //   labelLarge: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w700,
  //     fontSize: 12,
  //     height: 12 / 12,
  //     color: AppColors.textPrimaryNight,
  //   ),
  //   // crewSemiBold12
  //   labelMedium: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w600,
  //     fontSize: 12,
  //     height: 12 / 12,
  //     color: AppColors.textPrimaryNight,
  //   ),
  //   // crewRegular12
  //   labelSmall: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w400,
  //     fontSize: 12,
  //     height: 12 / 12,
  //     color: AppColors.textPrimaryNight,
  //   ),
  // ),
  // switchTheme: SwitchThemeData(
  //   thumbColor: WidgetStateProperty.resolveWith((states) {
  //     if (states.contains(WidgetState.selected)) {
  //       return AppColors.crewSysDarkOnPrimary;
  //     }
  //     return AppColors.crewSysDarkOutlineColorFF90909A;
  //   }),
  //   trackColor: WidgetStateProperty.resolveWith((states) {
  //     if (states.contains(WidgetState.selected)) {
  //       return AppColors.primaryDarkColorFFB9C3FF;
  //     }
  //     return AppColors.crewSysDarkSurfaceContainerHighest353438;
  //   }),
  //   trackOutlineColor: WidgetStateProperty.resolveWith((states) {
  //     if (states.contains(WidgetState.selected)) {
  //       return AppColors.primaryDarkColorFFB9C3FF;
  //     }
  //     return AppColors.crewSysDarkOutlineColorFF90909A;
  //   }),
  // ),
  // radioTheme: RadioThemeData(
  //   fillColor: WidgetStateProperty.resolveWith((states) {
  //     if (states.contains(WidgetState.selected)) {
  //       return AppColors.primaryDarkColorFFB9C3FF;
  //     }
  //     return AppColors.crewSysDarkSurfaceContainerHighest353438;
  //   }),
  // ),
);
