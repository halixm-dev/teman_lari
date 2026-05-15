import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class StatTile extends StatelessWidget {
  final String value;
  final String label;
  final String? delta;
  final bool isDeltaPositive;
  final bool isPR;
  final IconData? icon;
  final VoidCallback? onTap;

  const StatTile({
    super.key,
    required this.value,
    required this.label,
    this.delta,
    this.isDeltaPositive = true,
    this.isPR = false,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.space3),
        decoration: BoxDecoration(
          color: AppColors.gray50,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.space1),
                child: Icon(icon, size: 16, color: AppColors.gray500),
              ),
            Row(
              children: [
                if (isPR)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      '\u26A1',
                      style: TextStyle(fontSize: 16, color: AppColors.pr),
                    ),
                  ),
                Flexible(
                  child: Text(
                    value,
                    style: AppTypography.statHero.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: isPR ? AppColors.pr : AppColors.gray900,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label.toUpperCase(),
              style: AppTypography.statLabel.copyWith(color: AppColors.gray500),
            ),
            if (delta != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    isDeltaPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 12,
                    color: isDeltaPositive ? AppColors.success : AppColors.danger,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    delta!,
                    style: AppTypography.caption.copyWith(
                      color: isDeltaPositive ? AppColors.success : AppColors.danger,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
