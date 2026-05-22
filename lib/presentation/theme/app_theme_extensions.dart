import 'package:flutter/material.dart';
import 'package:teman_lari/presentation/theme/app_colors.dart';
import 'package:teman_lari/presentation/theme/app_spacing.dart';

class AppSpacingExtension extends ThemeExtension<AppSpacingExtension> {
  final double space1;
  final double space2;
  final double space3;
  final double space4;
  final double space5;
  final double space6;
  final double space8;
  final double space10;
  final double space12;
  final double space16;

  const AppSpacingExtension({
    required this.space1,
    required this.space2,
    required this.space3,
    required this.space4,
    required this.space5,
    required this.space6,
    required this.space8,
    required this.space10,
    required this.space12,
    required this.space16,
  });

  @override
  ThemeExtension<AppSpacingExtension> copyWith() {
    return this;
  }

  @override
  ThemeExtension<AppSpacingExtension> lerp(
      covariant ThemeExtension<AppSpacingExtension>? other, double t) {
    if (other is! AppSpacingExtension) {
      return this;
    }
    return AppSpacingExtension(
      space1: _lerpDouble(space1, other.space1, t),
      space2: _lerpDouble(space2, other.space2, t),
      space3: _lerpDouble(space3, other.space3, t),
      space4: _lerpDouble(space4, other.space4, t),
      space5: _lerpDouble(space5, other.space5, t),
      space6: _lerpDouble(space6, other.space6, t),
      space8: _lerpDouble(space8, other.space8, t),
      space10: _lerpDouble(space10, other.space10, t),
      space12: _lerpDouble(space12, other.space12, t),
      space16: _lerpDouble(space16, other.space16, t),
    );
  }

  double _lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }
}

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color brandOrange;
  final Color brandOrangeTint;
  final Color brandOrangeDark;
  final Color kudos;
  final Color pr;
  final Color kom;
  final Color run;
  final Color ride;
  final Color swim;
  final Color hike;
  final Color success;
  final Color danger;
  final Color warning;
  final Color info;

  const AppColorsExtension({
    required this.brandOrange,
    required this.brandOrangeTint,
    required this.brandOrangeDark,
    required this.kudos,
    required this.pr,
    required this.kom,
    required this.run,
    required this.ride,
    required this.swim,
    required this.hike,
    required this.success,
    required this.danger,
    required this.warning,
    required this.info,
  });

  @override
  ThemeExtension<AppColorsExtension> copyWith() {
    return this;
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
      covariant ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) {
      return this;
    }
    return AppColorsExtension(
      brandOrange: Color.lerp(brandOrange, other.brandOrange, t)!,
      brandOrangeTint: Color.lerp(brandOrangeTint, other.brandOrangeTint, t)!,
      brandOrangeDark: Color.lerp(brandOrangeDark, other.brandOrangeDark, t)!,
      kudos: Color.lerp(kudos, other.kudos, t)!,
      pr: Color.lerp(pr, other.pr, t)!,
      kom: Color.lerp(kom, other.kom, t)!,
      run: Color.lerp(run, other.run, t)!,
      ride: Color.lerp(ride, other.ride, t)!,
      swim: Color.lerp(swim, other.swim, t)!,
      hike: Color.lerp(hike, other.hike, t)!,
      success: Color.lerp(success, other.success, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}

// Default instances
const defaultSpacingExtension = AppSpacingExtension(
  space1: AppSpacing.space1,
  space2: AppSpacing.space2,
  space3: AppSpacing.space3,
  space4: AppSpacing.space4,
  space5: AppSpacing.space5,
  space6: AppSpacing.space6,
  space8: AppSpacing.space8,
  space10: AppSpacing.space10,
  space12: AppSpacing.space12,
  space16: AppSpacing.space16,
);

const defaultColorsExtension = AppColorsExtension(
  brandOrange: AppColors.brandOrange,
  brandOrangeTint: AppColors.brandOrangeTint,
  brandOrangeDark: AppColors.brandOrangeDark,
  kudos: AppColors.kudos,
  pr: AppColors.pr,
  kom: AppColors.kom,
  run: AppColors.run,
  ride: AppColors.ride,
  swim: AppColors.swim,
  hike: AppColors.hike,
  success: AppColors.success,
  danger: AppColors.danger,
  warning: AppColors.warning,
  info: AppColors.info,
);
