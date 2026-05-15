import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/app_shadows.dart';
import 'kudos_button.dart';
import 'sport_icon.dart';

class ActivityCard extends StatelessWidget {
  final String athleteName;
  final String avatarUrl;
  final String timestamp;
  final SportType sport;
  final String title;
  final String distance;
  final String movingTime;
  final String elevation;
  final int kudosCount;
  final bool isKudosed;
  final List<String> kudosNames;
  final VoidCallback? onKudosTap;
  final VoidCallback? onCardTap;
  final Widget? mapPlaceholder;

  const ActivityCard({
    super.key,
    required this.athleteName,
    required this.avatarUrl,
    required this.timestamp,
    required this.sport,
    required this.title,
    required this.distance,
    required this.movingTime,
    required this.elevation,
    this.kudosCount = 0,
    this.isKudosed = false,
    this.kudosNames = const [],
    this.onKudosTap,
    this.onCardTap,
    this.mapPlaceholder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
        boxShadow: AppShadows.md,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onCardTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(
                  athleteName: athleteName,
                  timestamp: timestamp,
                  sport: sport,
                ),
                const SizedBox(height: AppSpacing.space2),
                Text(
                  title,
                  style: AppTypography.headingLg,
                ),
                const SizedBox(height: AppSpacing.space3),
                if (mapPlaceholder != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    child: SizedBox(
                      width: double.infinity,
                      height: 160,
                      child: mapPlaceholder,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space4),
                ],
                _StatsRow(
                  distance: distance,
                  movingTime: movingTime,
                  elevation: elevation,
                ),
                const SizedBox(height: AppSpacing.space3),
                _BottomBar(
                  kudosCount: kudosCount,
                  isKudosed: isKudosed,
                  kudosNames: kudosNames,
                  onKudosTap: onKudosTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String athleteName;
  final String timestamp;
  final SportType sport;

  const _Header({
    required this.athleteName,
    required this.timestamp,
    required this.sport,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.gray100,
          child: Icon(Icons.person, size: 20, color: AppColors.gray500),
        ),
        const SizedBox(width: AppSpacing.space2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                athleteName,
                style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                timestamp,
                style: AppTypography.bodySm.copyWith(color: AppColors.gray500),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.space2),
        SportIcon(sport: sport, compact: true),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  final String distance;
  final String movingTime;
  final String elevation;

  const _StatsRow({
    required this.distance,
    required this.movingTime,
    required this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatItem(value: distance, label: 'Distance'),
        _StatItem(value: movingTime, label: 'Moving Time'),
        _StatItem(value: elevation, label: 'Elevation'),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.jetbrainsMono.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label.toUpperCase(),
            style: AppTypography.caption.copyWith(
              color: AppColors.gray500,
              letterSpacing: 0.05,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int kudosCount;
  final bool isKudosed;
  final List<String> kudosNames;
  final VoidCallback? onKudosTap;

  const _BottomBar({
    required this.kudosCount,
    required this.isKudosed,
    required this.kudosNames,
    this.onKudosTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        KudosButton(
          initialCount: kudosCount,
          isInitiallyKudosed: isKudosed,
        ),
        const Spacer(),
        if (kudosNames.isNotEmpty) ...[
          Text(
            _formatKudosNames(),
            style: AppTypography.bodySm.copyWith(color: AppColors.gray500),
          ),
        ],
        const SizedBox(width: AppSpacing.space3),
        Icon(Icons.mode_comment_outlined, size: 18, color: AppColors.gray500),
        const SizedBox(width: AppSpacing.space2),
        Icon(Icons.share_outlined, size: 18, color: AppColors.gray500),
      ],
    );
  }

  String _formatKudosNames() {
    if (kudosNames.isEmpty) return '';
    final shown = kudosNames.take(3).toList();
    final rest = kudosNames.length - shown.length;
    if (rest > 0) {
      return '${shown.join(", ")} + $rest others';
    }
    return shown.join(", ");
  }
}
