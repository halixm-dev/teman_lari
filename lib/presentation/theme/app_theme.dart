import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_theme_extensions.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      extensions: const [
        defaultSpacingExtension,
        defaultColorsExtension,
      ],
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.brandOrange,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.gray50,
      textTheme: TextTheme(
        displayLarge: AppTypography.displayXl,
        displayMedium: AppTypography.displayLg,
        displaySmall: AppTypography.displayMd,
        headlineLarge: AppTypography.headingLg,
        headlineMedium: AppTypography.headingMd,
        headlineSmall: AppTypography.headingSm,
        titleLarge: AppTypography.headingMd,
        titleMedium: AppTypography.headingSm,
        titleSmall: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.gray500,
        ),
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
        titleTextStyle: AppTypography.headingMd.copyWith(
          color: AppColors.gray900,
        ),
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
        indicatorColor: AppColors.gray200,
        backgroundColor: AppColors.white,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.brandOrange);
          }
          return const IconThemeData(color: AppColors.gray900);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return AppTypography.bodySm.copyWith(
            color: AppColors.gray900,
            fontWeight: FontWeight.w600,
          );
        }),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      extensions: const [
        defaultSpacingExtension,
        defaultColorsExtension,
      ],
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.brandOrange,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: AppColors.surfacePrimaryDark,
      textTheme: TextTheme(
        displayLarge: AppTypography.displayXl.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        displayMedium: AppTypography.displayLg.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        displaySmall: AppTypography.displayMd.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        headlineLarge: AppTypography.headingLg.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        headlineMedium: AppTypography.headingMd.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        headlineSmall: AppTypography.headingSm.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        titleLarge: AppTypography.headingMd.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        titleMedium: AppTypography.headingSm.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        titleSmall: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondaryDark,
        ),
        bodyLarge: AppTypography.bodyLg.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        bodyMedium: AppTypography.bodyMd.copyWith(
          color: AppColors.textSecondaryDark,
        ),
        bodySmall: AppTypography.bodySm.copyWith(
          color: AppColors.textSecondaryDark,
        ),
        labelSmall: AppTypography.caption.copyWith(
          color: AppColors.textTertiaryDark,
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.surfacePrimaryDark,
        foregroundColor: AppColors.textPrimaryDark,
        titleTextStyle: AppTypography.headingMd.copyWith(
          color: AppColors.textPrimaryDark,
        ),
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
        indicatorColor: AppColors.surfaceTertiaryDark,
        backgroundColor: AppColors.surfaceSecondaryDark,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.brandOrange);
          }
          return const IconThemeData(color: AppColors.textPrimaryDark);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return AppTypography.bodySm.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
          );
        }),
      ),
    );
  }
}
