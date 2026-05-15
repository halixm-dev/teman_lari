import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.brandOrange,
        onPrimary: AppColors.white,
        primaryContainer: AppColors.brandOrangeTint,
        secondary: AppColors.gray700,
        onSecondary: AppColors.white,
        surface: AppColors.white,
        onSurface: AppColors.gray900,
        error: AppColors.danger,
        onError: AppColors.white,
      ),
      scaffoldBackgroundColor: AppColors.gray50,
      textTheme: TextTheme(
        displayLarge: AppTypography.displayXl,
        displayMedium: AppTypography.displayLg,
        displaySmall: AppTypography.displayMd,
        headlineLarge: AppTypography.headingLg,
        headlineMedium: AppTypography.headingMd,
        headlineSmall: AppTypography.headingSm,
        bodyLarge: AppTypography.bodyLg,
        bodyMedium: AppTypography.bodyMd,
        bodySmall: AppTypography.bodySm,
        labelSmall: AppTypography.caption,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.gray50,
        foregroundColor: AppColors.gray900,
        titleTextStyle: AppTypography.headingMd.copyWith(color: AppColors.gray900),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
        ),
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.brandOrange,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brandOrange,
          side: const BorderSide(color: AppColors.brandOrange, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.gray700,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            side: BorderSide(color: AppColors.gray300),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.gray300.withValues(alpha: 0.5),
        thickness: 1,
        space: 0,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: Colors.black,
        backgroundColor: AppColors.white,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.brandOrange);
          }
          return const IconThemeData(color: Colors.white);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (_) => AppTypography.bodySm.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.brandOrange,
        onPrimary: AppColors.white,
        primaryContainer: AppColors.brandOrangeDark,
        secondary: AppColors.textSecondaryDark,
        onSecondary: AppColors.textPrimaryDark,
        surface: AppColors.surfacePrimaryDark,
        onSurface: AppColors.textPrimaryDark,
        error: AppColors.danger,
        onError: AppColors.white,
      ),
      scaffoldBackgroundColor: AppColors.surfacePrimaryDark,
      textTheme: TextTheme(
        displayLarge: AppTypography.displayXl.copyWith(color: AppColors.textPrimaryDark),
        displayMedium: AppTypography.displayLg.copyWith(color: AppColors.textPrimaryDark),
        displaySmall: AppTypography.displayMd.copyWith(color: AppColors.textPrimaryDark),
        headlineLarge: AppTypography.headingLg.copyWith(color: AppColors.textPrimaryDark),
        headlineMedium: AppTypography.headingMd.copyWith(color: AppColors.textPrimaryDark),
        headlineSmall: AppTypography.headingSm.copyWith(color: AppColors.textPrimaryDark),
        bodyLarge: AppTypography.bodyLg.copyWith(color: AppColors.textPrimaryDark),
        bodyMedium: AppTypography.bodyMd.copyWith(color: AppColors.textSecondaryDark),
        bodySmall: AppTypography.bodySm.copyWith(color: AppColors.textSecondaryDark),
        labelSmall: AppTypography.caption.copyWith(color: AppColors.textTertiaryDark),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.surfacePrimaryDark,
        foregroundColor: AppColors.textPrimaryDark,
        titleTextStyle: AppTypography.headingMd.copyWith(color: AppColors.textPrimaryDark),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceSecondaryDark,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: BorderSide.none,
        ),
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.brandOrange,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brandOrange,
          side: const BorderSide(color: AppColors.brandOrange, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textSecondaryDark,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            side: BorderSide(color: AppColors.surfaceTertiaryDark),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.dividerDark,
        thickness: 1,
        space: 0,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: Colors.black,
        backgroundColor: AppColors.surfaceSecondaryDark,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.brandOrange);
          }
          return const IconThemeData(color: Colors.white);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (_) => AppTypography.bodySm.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
