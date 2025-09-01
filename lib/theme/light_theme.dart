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
      fontSize: 14,
      height: 16 / 14,
      color: AppColors.dayTextColor,
    ),
    unselectedLabelStyle: GoogleFonts.roboto(
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: 14,
      height: 16 / 14,
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

  // textSelectionTheme: _base.textSelectionTheme.copyWith(
  //   selectionColor: AppColors.blueBlue100A30,
  //   cursorColor: AppColors.primaryLightColor,
  //   selectionHandleColor: Colors.transparent,
  // ),
  //
  // inputDecorationTheme: _base.inputDecorationTheme.copyWith(
  //   hintStyle: GoogleFonts.roboto(
  //     color: AppColors.textSecondaryDay,
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w400,
  //     fontSize: 20,
  //     height: 1,
  //     letterSpacing: 0.4,
  //   ),
  //   labelStyle: GoogleFonts.roboto(
  //     color: AppColors.textSecondaryDay,
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w400,
  //     fontSize: 20,
  //     height: 1,
  //     letterSpacing: 0.4,
  //   ),
  //   prefixIconColor: AppColors.interactiveIconRestDay,
  //   suffixIconColor: AppColors.interactiveIconRestDay,
  //   fillColor: AppColors.interactiveBgRestDay,
  //   filled: true,
  //   errorStyle: GoogleFonts.roboto(
  //     color: AppColors.textErrorDay,
  //     fontSize: 14,
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w400,
  //     height: 1,
  //     letterSpacing: 0.4,
  //   ),
  //   contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
  //   border: OutlinedInputBorder(
  //     borderSide: BorderSide(color: AppColors.interactiveBgRestDay, width: 0),
  //     borderRadius: BorderRadius.all(Radius.circular(12)),
  //   ),
  //   enabledBorder: const OutlinedInputBorder(
  //     borderSide: BorderSide(color: AppColors.interactiveBgRestDay, width: 0),
  //     borderRadius: BorderRadius.all(Radius.circular(12)),
  //   ),
  //   focusedBorder: const OutlinedInputBorder(
  //     borderSide: BorderSide(color: AppColors.interactiveBgTappedDay, width: 0),
  //     borderRadius: BorderRadius.all(Radius.circular(12)),
  //   ),
  //   errorBorder: const OutlinedInputBorder(
  //     borderSide: BorderSide(color: AppColors.indicatorDangerDay, width: 3),
  //     borderRadius: BorderRadius.all(Radius.circular(12)),
  //   ),
  //   focusedErrorBorder: const OutlinedInputBorder(
  //     borderSide: BorderSide(color: AppColors.indicatorDangerDay, width: 3),
  //     borderRadius: BorderRadius.all(Radius.circular(12)),
  //   ),
  //   outlineBorder: BorderSide(color: AppColors.interactiveBgRestDay, width: 0),
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
  //         return Color(0xFFF0F0F0);
  //       }
  //       return AppColors.primaryColor;
  //     }),
  //     foregroundColor: WidgetStateProperty.resolveWith((states) {
  //       if (states.contains(WidgetState.disabled)) {
  //         return Color(0xFFACACAC);
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
  // textButtonTheme: TextButtonThemeData(
  //   style: ButtonStyle(
  //     alignment: Alignment.center,
  //     padding:
  //         WidgetStateProperty.all(EdgeInsets.zero),
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
  //   backgroundColor: AppColors.crewSysLightSurfaceContainerF0EDF1,
  //   surfaceTintColor: AppColors.crewSysLightSurfaceContainerF0EDF1,
  //   foregroundColor: AppColors.crewSysLightOnSurfaceVariantColorFF45464F,
  //   shadowColor: AppColors.crewSysLightSurfaceContainerF0EDF1.withValues(alpha:0.5),
  //   centerTitle: false,
  //   titleTextStyle: GoogleFonts.roboto(
  //     fontSize: 22,
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w400,
  //     height: 28 / 22,
  //     color: AppColors.onSurfaceColorFF1B1B1F,
  //   ),
  // ),
  // dialogTheme: _base.dialogTheme.copyWith(
  //   backgroundColor: AppColors.colorLightBackground,
  //   surfaceTintColor: AppColors.colorLightBackground,
  //   elevation: 4,
  //   shadowColor: AppColors.crewSysLightSurfaceContainerF0EDF1.withValues(alpha: 0.5),
  // ),
  // bottomSheetTheme: _base.bottomSheetTheme.copyWith(
  //   elevation: 0,
  //   backgroundColor: AppColors.crewSysLightSurfaceContainerF0EDF1,
  //   shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.all(Radius.zero)),
  // ),

  // textTheme: _base.textTheme.copyWith(
  //   //   crewBold24
  //   displayLarge: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w700,
  //     fontSize: 24,
  //     height: 24 / 24,
  //     color: AppColors.textPrimaryDay,
  //   ),
  //   // crewSemiBold24
  //   displayMedium: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w600,
  //     fontSize: 24,
  //     height: 24 / 24,
  //     color: AppColors.textPrimaryDay,
  //   ),
  //   // crewRegular24
  //   displaySmall: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w400,
  //     fontSize: 24,
  //     height: 24 / 24,
  //     color: AppColors.textPrimaryDay,
  //   ),
  //   // crewBold20
  //   headlineLarge: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w700,
  //     fontSize: 20,
  //     height: 20 / 20,
  //     color: AppColors.textPrimaryDay,
  //   ),
  //   // crewSemiBold20
  //   headlineMedium: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w600,
  //     fontSize: 20,
  //     height: 20 / 20,
  //     color: AppColors.textPrimaryDay,
  //   ),
  //   // crewRegular20
  //   headlineSmall: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w400,
  //     fontSize: 20,
  //     height: 20 / 20,
  //     color: AppColors.textPrimaryDay,
  //   ),
  //   // crewBold16
  //   titleLarge: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w700,
  //     fontSize: 16,
  //     height: 16 / 16,
  //     color: AppColors.textPrimaryDay,
  //   ),
  //   // crewSemiBold16
  //   titleMedium: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w600,
  //     fontSize: 16,
  //     height: 16 / 16,
  //     color: AppColors.textPrimaryDay,
  //   ),
  //   // crewRegular16
  //   titleSmall: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w400,
  //     fontSize: 16,
  //     height: 16 / 16,
  //     color: AppColors.textPrimaryDay,
  //   ),
  //   // crewBold14
  //   bodyLarge: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w700,
  //     fontSize: 14,
  //     height: 14 / 14,
  //     color: AppColors.textPrimaryDay,
  //   ),
  //   // crewSemiBold14
  //   bodyMedium: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w600,
  //     fontSize: 14,
  //     height: 14 / 14,
  //     color: AppColors.textPrimaryDay,
  //   ),
  //   // crewRegular14
  //   bodySmall: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w400,
  //     fontSize: 14,
  //     height: 14 / 14,
  //     color: AppColors.textPrimaryDay,
  //   ),
  //   // crewBold12
  //   labelLarge: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w700,
  //     fontSize: 12,
  //     height: 12 / 12,
  //     color: AppColors.textPrimaryDay,
  //   ),
  //   // crewSemiBold12
  //   labelMedium: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w600,
  //     fontSize: 12,
  //     height: 12 / 12,
  //     color: AppColors.textPrimaryDay,
  //   ),
  //   // crewRegular12
  //   labelSmall: GoogleFonts.roboto(
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w400,
  //     fontSize: 12,
  //     height: 12 / 12,
  //     color: AppColors.textPrimaryDay,
  //   ),
  // ),
  // switchTheme: SwitchThemeData(
  //   thumbColor: WidgetStateProperty.resolveWith((states) {
  //     if (states.contains(WidgetState.selected)) {
  //       return AppColors.whiteColor;
  //     }
  //     return AppColors.crewSysLightOutlineCalendarColorFF767680;
  //   }),
  //   trackColor: WidgetStateProperty.resolveWith((states) {
  //     if (states.contains(WidgetState.selected)) {
  //       return AppColors.primaryColor;
  //     }
  //     return AppColors.sysLightSurfaceContainerHighestFFE4E1E6;
  //   }),
  //   trackOutlineColor: WidgetStateProperty.resolveWith((states) {
  //     if (states.contains(WidgetState.selected)) {
  //       return AppColors.primaryColor;
  //     }
  //     return AppColors.crewSysLightOutlineCalendarColorFF767680;
  //   }),
  // ),
  // radioTheme: RadioThemeData(
  //   fillColor: WidgetStateProperty.resolveWith((states) {
  //     if (states.contains(WidgetState.selected)) {
  //       return AppColors.primaryColor;
  //     }
  //     return AppColors.sysLightSurfaceContainerHighestFFE4E1E6;
  //   }),
  // ),
);
