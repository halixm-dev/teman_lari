import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/responsive.dart';
import '../../domain/entities/training_plan.dart';
import '../providers/training_plan_provider.dart';
import '../theme/app_colors.dart';

class PlanScreen extends ConsumerWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(trainingPlanProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            color: AppColors.brandOrange,
            onPressed: () => _showInfoSheet(context),
          ),
        ],
      ),
      body: ConstrainedContent(
        child: plan.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => const _PlanErrorView(),
          data: (plan) => _PlanDataView(plan: plan),
        ),
      ),
    );
  }

  void _showInfoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'How Your Plan Works',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _InfoRow(
                icon: Icons.history,
                text:
                    'Your training plan is generated from your workout history and performance analysis.',
              ),
              const SizedBox(height: 16),
              _InfoRow(
                icon: Icons.auto_awesome,
                text:
                    'It dynamically updates each time you log a new run, adapting to your current fitness and recovery.',
              ),
              const SizedBox(height: 16),
              _InfoRow(
                icon: Icons.calendar_today,
                text:
                    'Your next workout is confirmed based on your latest data. Later days are projected and may adjust as you train.',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: AppColors.gray500),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 14, height: 1.55)),
        ),
      ],
    );
  }
}

class _PlanErrorView extends StatelessWidget {
  const _PlanErrorView();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Could not generate your training plan.\nMake sure you\'re connected to Strava.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PlanDataView extends StatelessWidget {
  final TrainingPlan plan;
  const _PlanDataView({required this.plan});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PlanHeader(plan: plan),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: plan.days.length,
            itemBuilder: (context, i) {
              final isFirst = i == 0;
              final card = _PlanDayCard(day: plan.days[i], isFirst: isFirst);

              if (isFirst) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 12),
                      child: Text(
                        'Next Workout',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: AppColors.brandOrange,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    card,
                    if (plan.days.length > 1) ...[
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 8),
                        child: Text(
                          'Upcoming',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              }

              return Opacity(opacity: 0.65, child: card);
            },
          ),
        ),
      ],
    );
  }
}

class _PlanHeader extends StatelessWidget {
  final TrainingPlan plan;

  const _PlanHeader({required this.plan});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final phaseName = plan.cyclePhase.name;
    final formattedPhase =
        '${phaseName[0].toUpperCase()}${phaseName.substring(1).replaceAllMapped(RegExp(r'[A-Z]'), (m) => ' ${m.group(0)}')} Phase';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [AppColors.brandOrange, AppColors.brandOrangeLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandOrange.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.track_changes_rounded,
              size: 140,
              color: Colors.white.withValues(alpha: 0.15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        formattedPhase,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (plan.weekInCycle > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Week ${plan.weekInCycle}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Current Goal',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  plan.goal,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  plan.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanDayCard extends StatelessWidget {
  final TrainingDay day;
  final bool isFirst;

  const _PlanDayCard({required this.day, this.isFirst = false});

  @override
  Widget build(BuildContext context) {
    final isRest = day.type == WorkoutType.rest;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: isFirst
            ? Border.all(color: AppColors.brandOrange, width: 1.5)
            : Border.all(color: AppColors.gray200, width: 1),
        boxShadow: isFirst
            ? [
                BoxShadow(
                  color: AppColors.brandOrange.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: isFirst ? 12 : 8,
        ),
        leading: _DayIcon(type: day.type),
        title: _DayTitle(day: day, isFirst: isFirst),
        subtitle: _DaySubtitle(day: day, isRest: isRest),
        trailing: isRest ? null : const Icon(Icons.chevron_right),
        onTap: isRest ? null : () => context.push('/run-session', extra: day),
      ),
    );
  }
}

class _DayIcon extends StatelessWidget {
  final WorkoutType type;
  const _DayIcon({required this.type});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: typeColor(type).withValues(alpha: 0.15),
      child: Icon(typeIcon(type), color: typeColor(type)),
    );
  }
}

class _DayTitle extends StatelessWidget {
  final TrainingDay day;
  final bool isFirst;
  const _DayTitle({required this.day, this.isFirst = false});
  @override
  Widget build(BuildContext context) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final label = days[day.date.weekday - 1];
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 8),
        _WorkoutTypeBadge(type: day.type),
        if (!isFirst) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.gray300.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Projected',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.gray500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _DaySubtitle extends StatelessWidget {
  final TrainingDay day;
  final bool isRest;
  const _DaySubtitle({required this.day, required this.isRest});

  @override
  Widget build(BuildContext context) {
    final paceTarget = day.paceTarget;
    final hrTarget = day.heartRateTarget;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        if (!isRest && day.targetMinutes != null)
          day.warmUpMinutes != null
              ? Text(
                  'Warmup ${day.warmUpMinutes} min + Run ${day.workMinutes} min + Cooldown ${day.coolDownMinutes} min',
                )
              : Text('${day.targetMinutes} min'),
        if (paceTarget != null)
          Text(
            '${_paceStr(paceTarget.fastestPace)} - ${_paceStr(paceTarget.slowestPace)} /km',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        if (hrTarget != null)
          Text('♡ ${hrTarget.minBpm}-${hrTarget.maxBpm} bpm'),
        const SizedBox(height: 4),
        Text(day.description, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  String _paceStr(Duration pace) {
    final m = pace.inSeconds ~/ 60;
    final s = pace.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

class _WorkoutTypeBadge extends StatelessWidget {
  final WorkoutType type;

  const _WorkoutTypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: typeColor(type).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        typeLabel(type),
        style: TextStyle(
          color: typeColor(type),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

Color typeColor(WorkoutType type) {
  return switch (type) {
    WorkoutType.easy => Colors.green,
    WorkoutType.tempo => Colors.orange,
    WorkoutType.intervals => Colors.red,
    WorkoutType.longRun => Colors.blue,
    WorkoutType.rest => AppColors.gray500,
    WorkoutType.crossTraining => Colors.purple,
  };
}

IconData typeIcon(WorkoutType type) {
  return switch (type) {
    WorkoutType.easy => Icons.directions_walk,
    WorkoutType.tempo => Icons.speed,
    WorkoutType.intervals => Icons.timer,
    WorkoutType.longRun => Icons.map,
    WorkoutType.rest => Icons.hotel,
    WorkoutType.crossTraining => Icons.fitness_center,
  };
}

String typeLabel(WorkoutType type) {
  return switch (type) {
    WorkoutType.easy => 'Easy',
    WorkoutType.tempo => 'Tempo',
    WorkoutType.intervals => 'Intervals',
    WorkoutType.longRun => 'Long Run',
    WorkoutType.rest => 'Rest',
    WorkoutType.crossTraining => 'Cross Train',
  };
}
