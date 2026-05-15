import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

enum SportType { run, ride, swim, hike, yoga, workout, ski }

class SportIcon extends StatelessWidget {
  final SportType sport;
  final bool compact;
  final bool selected;

  const SportIcon({
    super.key,
    required this.sport,
    this.compact = false,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = compact ? 28.0 : 40.0;
    final iconSize = compact ? 14.0 : 24.0;
    final color = _sportColor();
    final icon = _sportIcon();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: selected ? color : color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: selected ? AppColors.white : color,
      ),
    );
  }

  Color _sportColor() {
    switch (sport) {
      case SportType.run:
        return AppColors.run;
      case SportType.ride:
        return AppColors.ride;
      case SportType.swim:
        return AppColors.swim;
      case SportType.hike:
        return AppColors.hike;
      case SportType.yoga:
        return AppColors.yoga;
      case SportType.workout:
        return AppColors.workout;
      case SportType.ski:
        return AppColors.ski;
    }
  }

  IconData _sportIcon() {
    switch (sport) {
      case SportType.run:
        return PhosphorIconsRegular.personSimpleRun;
      case SportType.ride:
        return PhosphorIconsRegular.bicycle;
      case SportType.swim:
        return PhosphorIconsRegular.personSimpleSwim;
      case SportType.hike:
        return PhosphorIconsRegular.mountains;
      case SportType.yoga:
        return PhosphorIconsRegular.flowerLotus;
      case SportType.workout:
        return PhosphorIconsRegular.barbell;
      case SportType.ski:
        return PhosphorIconsRegular.personSimpleSki;
    }
  }
}

class SportFilterChip extends StatelessWidget {
  final SportType sport;
  final bool isSelected;
  final VoidCallback onTap;

  const SportFilterChip({
    super.key,
    required this.sport,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _sportColor();
    final label = sport.name[0].toUpperCase() + sport.name.substring(1);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
            color: isSelected ? color : AppColors.gray300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _sportIcon(),
              size: 14,
              color: isSelected ? AppColors.white : color,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.white : AppColors.gray700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _sportColor() {
    switch (sport) {
      case SportType.run:
        return AppColors.run;
      case SportType.ride:
        return AppColors.ride;
      case SportType.swim:
        return AppColors.swim;
      case SportType.hike:
        return AppColors.hike;
      case SportType.yoga:
        return AppColors.yoga;
      case SportType.workout:
        return AppColors.workout;
      case SportType.ski:
        return AppColors.ski;
    }
  }

  IconData _sportIcon() {
    switch (sport) {
      case SportType.run:
        return PhosphorIconsRegular.personSimpleRun;
      case SportType.ride:
        return PhosphorIconsRegular.bicycle;
      case SportType.swim:
        return PhosphorIconsRegular.personSimpleSwim;
      case SportType.hike:
        return PhosphorIconsRegular.mountains;
      case SportType.yoga:
        return PhosphorIconsRegular.flowerLotus;
      case SportType.workout:
        return PhosphorIconsRegular.barbell;
      case SportType.ski:
        return PhosphorIconsRegular.personSimpleSki;
    }
  }
}
