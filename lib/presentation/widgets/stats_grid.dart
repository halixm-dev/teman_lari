import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../domain/entities/running_stats.dart';
import '../theme/app_colors.dart';

class StatsGrid extends StatelessWidget {
  final RunningStats stats;
  final bool showVo2Max;

  const StatsGrid({super.key, required this.stats, this.showVo2Max = false});

  void _showVo2MaxInfo(BuildContext context) {
    HapticFeedback.lightImpact();
    final vo2max = stats.vo2MaxEstimate;
    final vo2maxText = vo2max?.toStringAsFixed(1) ?? 'N/A';
    final (category, categoryColor) = vo2max == null
        ? ('Unknown', AppColors.gray500)
        : vo2max >= 56
        ? ('Excellent', AppColors.success)
        : vo2max >= 51
        ? ('Good', AppColors.success)
        : vo2max >= 45
        ? ('Fair', AppColors.warning)
        : ('Needs Improvement', AppColors.danger);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return _Vo2MaxInfoSheet(
          vo2maxText: vo2maxText,
          category: category,
          categoryColor: categoryColor,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children:
          [
                _StatCard(
                  icon: Icons.run_circle,
                  label: 'Total Runs',
                  value: '${stats.totalRuns}',
                  color: AppColors.run,
                ),
                _StatCard(
                  icon: Icons.straighten,
                  label: 'Total Distance',
                  value: '${stats.totalDistanceKm.toStringAsFixed(1)} km',
                  color: AppColors.success,
                ),
                _StatCard(
                  icon: Icons.speed,
                  label: 'Avg Pace',
                  value:
                      '${stats.averagePace.inMinutes}:${(stats.averagePace.inSeconds % 60).toString().padLeft(2, '0')} /km',
                  color: AppColors.warning,
                ),
                if (showVo2Max)
                  _StatCard(
                    icon: Icons.favorite,
                    label: 'VO2 Max',
                    value: stats.vo2MaxEstimate?.toStringAsFixed(1) ?? 'N/A',
                    color: AppColors.pr,
                    onTap: () => _showVo2MaxInfo(context),
                  )
                else
                  _StatCard(
                    icon: Icons.show_chart,
                    label: 'Weekly Avg',
                    value: '${stats.recentWeeklyAvgKm.toStringAsFixed(1)} km',
                    color: AppColors.pr,
                  ),
              ]
              .animate(interval: 50.ms)
              .fade(duration: 300.ms)
              .scale(curve: Curves.easeOutBack),
    );
  }
}

class _Vo2MaxInfoSheet extends StatelessWidget {
  final String vo2maxText;
  final String category;
  final Color categoryColor;

  const _Vo2MaxInfoSheet({
    super.key,
    required this.vo2maxText,
    required this.category,
    required this.categoryColor,
  });

  Widget _buildRangeRow(String label, String value, Color color, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.gray500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 12,
          bottom: MediaQuery.of(context).padding.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceTertiaryDark
                      : AppColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.pr.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: AppColors.pr,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'VO2 Max Estimate',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceSecondaryDark
                    : AppColors.gray50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? AppColors.surfaceTertiaryDark
                      : AppColors.gray200,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CURRENT ESTIMATE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.gray500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            vo2maxText,
                            style: const TextStyle(
                              fontFamily: 'JetBrains Mono',
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: AppColors.pr,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'mL/kg/min',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.gray500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: categoryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'VO₂ Max measures your body\'s maximum ability to consume and utilize oxygen during high-intensity running. It represents your ultimate cardiovascular fitness baseline.',
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 12),
            Text(
              'How it is calculated: We analyze your optimal speed and heart rate correlation from sustained efforts lasting 12 minutes or more, using the world-renowned Daniels Cooper formula.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.gray700,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'REFERENCE RANGES (ADULT MALES)',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.gray500,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            _buildRangeRow(
              'Excellent',
              '≥ 56 mL/kg/min',
              AppColors.success,
              isDark,
            ),
            _buildRangeRow(
              'Good',
              '51 - 55 mL/kg/min',
              AppColors.success,
              isDark,
            ),
            _buildRangeRow(
              'Fair',
              '45 - 50 mL/kg/min',
              AppColors.warning,
              isDark,
            ),
            _buildRangeRow(
              'Needs Work',
              '< 45 mL/kg/min',
              AppColors.danger,
              isDark,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pop();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.brandOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Got it',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ).animate().fade(duration: 250.ms).slideY(begin: 0.08, curve: Curves.easeOutCubic),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Semantics(
        button: onTap != null,
        label: '$label: $value',
        child: InkWell(
          onTap: onTap != null
              ? () {
                  HapticFeedback.lightImpact();
                  onTap!();
                }
              : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: color,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label.toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
