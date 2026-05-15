import 'package:flutter/material.dart';

import '../../domain/entities/running_stats.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class FitnessFormCard extends StatelessWidget {
  final RunningStats stats;

  const FitnessFormCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final formColor = stats.formScore > 5
        ? Colors.green
        : stats.formScore < -5
        ? Colors.red
        : Colors.orange;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        onTap: () => _showDetailsSheet(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Training Status',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.4),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _MetricChip(
                    label: 'Fitness',
                    value: stats.fitnessScore.toStringAsFixed(0),
                    color: Colors.blue,
                  ),
                  _MetricChip(
                    label: 'Fatigue',
                    value: stats.fatigueScore.toStringAsFixed(0),
                    color: Colors.red,
                  ),
                  _MetricChip(
                    label: 'Form',
                    value: stats.formScore.toStringAsFixed(0),
                    color: formColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.surfaceSecondaryDark
          : AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      builder: (_) => _TrainingStatusDetails(stats: stats),
    );
  }
}

class _TrainingStatusDetails extends StatelessWidget {
  final RunningStats stats;

  const _TrainingStatusDetails({required this.stats});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.gray900;
    final secondaryTextColor =
        isDark ? AppColors.textSecondaryDark : AppColors.gray500;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.space6,
        right: AppSpacing.space6,
        top: AppSpacing.space3,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.space6,
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
          const SizedBox(height: AppSpacing.space5),
          Text(
            'Training Status Explained',
            style: AppTypography.headingMd.copyWith(color: textColor),
          ),
          const SizedBox(height: AppSpacing.space2),
          Text(
            'Your training metrics are derived from Training Stress Score (TSS) '
            '— a measure of how hard each run was.',
            style: AppTypography.bodySm.copyWith(color: secondaryTextColor),
          ),
          const SizedBox(height: AppSpacing.space6),
          _MetricExplanation(
            label: 'Fitness (CTL)',
            value: stats.fitnessScore.toStringAsFixed(0),
            color: Colors.blue,
            description:
                'Your long-term fitness level based on training load over the '
                'last 42 days. A higher number means better aerobic conditioning.',
            advice: _fitnessAdvice(stats.fitnessScore),
          ),
          const SizedBox(height: AppSpacing.space4),
          _MetricExplanation(
            label: 'Fatigue (ATL)',
            value: stats.fatigueScore.toStringAsFixed(0),
            color: Colors.red,
            description:
                'Your short-term training load from the last 7 days. '
                'This reflects how tired your body currently is.',
            advice: _fatigueAdvice(stats.fatigueScore),
          ),
          const SizedBox(height: AppSpacing.space4),
          _MetricExplanation(
            label: 'Form (TSB)',
            value: stats.formScore.toStringAsFixed(0),
            color: stats.formScore > 5
                ? Colors.green
                : stats.formScore < -5
                    ? Colors.red
                    : Colors.orange,
            description:
                'The balance between Fitness and Fatigue (Fitness − Fatigue). '
                'Positive means fresh, negative means fatigued.',
            advice: _formAdvice(stats.formScore),
          ),
        ],
      ),
    );
  }

  String _fitnessAdvice(double score) {
    if (score < 20) {
      return 'Focus on building consistency with regular easy runs. '
          'Your aerobic base is still developing.';
    }
    if (score < 40) {
      return 'Good foundation! You can handle moderate training loads '
          'and start introducing intensity.';
    }
    return 'Strong fitness base. You\'re ready for advanced training '
        'including intervals and tempo runs.';
  }

  String _fatigueAdvice(double score) {
    if (score < 10) {
      return 'Low fatigue. Consider increasing training volume '
          'or intensity if your form allows.';
    }
    if (score < 20) {
      return 'Normal training fatigue. Your body is responding well '
          'to your current training load.';
    }
    return 'High fatigue. Prioritize recovery: easy runs, extra sleep, '
        'and proper nutrition.';
  }

  String _formAdvice(double score) {
    if (score > 10) {
      return 'You\'re very fresh! Ideal for a race, time trial, '
          'or hard workout day.';
    }
    if (score > 5) {
      return 'Good form. You\'re ready for quality training sessions.';
    }
    if (score > -5) {
      return 'Normal training zone. Keep being consistent '
          'with your current plan.';
    }
    if (score > -10) {
      return 'Fatigue is building. This is productive but watch '
          'for signs of overtraining.';
    }
    return 'High fatigue — prioritize recovery. '
        'Consider a rest day or very easy run.';
  }
}

class _MetricExplanation extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final String description;
  final String advice;

  const _MetricExplanation({
    required this.label,
    required this.value,
    required this.color,
    required this.description,
    required this.advice,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.gray900;
    final secondaryTextColor =
        isDark ? AppColors.textSecondaryDark : AppColors.gray500;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.space2),
              Text(
                label,
                style: AppTypography.bodyMd.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: AppTypography.statValue.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space2),
          Text(
            description,
            style: AppTypography.bodySm.copyWith(color: secondaryTextColor),
          ),
          const SizedBox(height: AppSpacing.space2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lightbulb_outline, size: 14, color: color),
              const SizedBox(width: AppSpacing.space1),
              Expanded(
                child: Text(
                  advice,
                  style: AppTypography.bodySm.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
