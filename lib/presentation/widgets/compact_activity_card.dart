import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:teman_lari/domain/entities/analyzed_activity.dart';
import 'package:teman_lari/presentation/theme/app_theme_extensions.dart';
import 'package:teman_lari/presentation/theme/app_colors.dart';
import 'package:teman_lari/core/utils/date_utils.dart';
import 'package:teman_lari/domain/entities/activity.dart';
import 'package:teman_lari/presentation/widgets/workout_type_badge.dart';
import 'kudos_button.dart';

class CompactActivityCard extends StatefulWidget {
  final AnalyzedActivity analyzedRun;

  const CompactActivityCard({super.key, required this.analyzedRun});

  @override
  State<CompactActivityCard> createState() => _CompactActivityCardState();
}

class _CompactActivityCardState extends State<CompactActivityCard> {
  final GlobalKey<KudosButtonState> _kudosKey = GlobalKey<KudosButtonState>();
  bool _showDoubleTapBurst = false;

  void _handleDoubleTap() {
    // 1. Medium haptic impact for a solid physical feel
    HapticFeedback.mediumImpact();

    // 2. Programmatically give kudos via the state key
    _kudosKey.currentState?.externalKudos();

    // 3. Show the beautiful thumbs-up elastic overlay pop
    setState(() {
      _showDoubleTapBurst = true;
    });

    // 4. Hide the burst after the animation finishes
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _showDoubleTapBurst = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final typoExt = Theme.of(context).extension<AppTypographyExtension>();
    final run = widget.analyzedRun.activity;

    return GestureDetector(
      onDoubleTap: _handleDoubleTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        run.name,
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    WorkoutTypeBadge(type: widget.analyzedRun.type),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  AppDateUtils.formatDate(run.date),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: _StatColumn(
                        label: 'DISTANCE',
                        value: '${run.distanceKm.toStringAsFixed(2)} km',
                        typoExt: typoExt,
                      ),
                    ),
                    Expanded(
                      child: _StatColumn(
                        label: 'PACE',
                        value:
                            (run.type == ActivityType.run ||
                                run.type == ActivityType.walk)
                            ? run.paceString
                            : '--',
                        typoExt: typoExt,
                      ),
                    ),
                    Expanded(
                      child: _StatColumn(
                        label: 'TIME',
                        value: _formatDuration(run.movingTime),
                        typoExt: typoExt,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: KudosButton(
                        key: _kudosKey,
                        initialCount: run.id % 7,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_showDoubleTapBurst)
            Positioned.fill(
              child: Center(
                child:
                    Icon(
                          Icons.thumb_up_rounded,
                          color: AppColors.brandOrange.withValues(alpha: 0.9),
                          size: 56,
                        )
                        .animate()
                        .scale(
                          duration: 350.ms,
                          curve: Curves.elasticOut,
                          begin: const Offset(0.2, 0.2),
                          end: const Offset(1.2, 1.2),
                        )
                        .fadeOut(delay: 350.ms, duration: 200.ms),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final AppTypographyExtension? typoExt;

  const _StatColumn({required this.label, required this.value, this.typoExt});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              typoExt?.statLabel ??
              Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(letterSpacing: 0.05),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style:
              typoExt?.statValue ??
              Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
