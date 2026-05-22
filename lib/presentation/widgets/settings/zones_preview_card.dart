import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class ZonesPreviewCard extends StatelessWidget {
  final List<Map<String, dynamic>> zones;

  const ZonesPreviewCard({super.key, required this.zones});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(),
            const SizedBox(height: 8),
            const Text(
              'Real-time estimation of heart rate training zones using the Karvonen formula (Heart Rate Reserve). These zones will be applied to your analysis and workouts upon saving.',
              style: TextStyle(fontSize: 12, color: AppColors.gray500),
            ),
            const SizedBox(height: 16),
            ...zones.map((z) => _ZoneRow(zone: z)),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Heart Rate Zones Preview',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const Icon(Icons.show_chart, color: AppColors.brandOrange),
      ],
    );
  }
}

class _ZoneRow extends StatelessWidget {
  final Map<String, dynamic> zone;

  const _ZoneRow({required this.zone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                zone['label'],
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              Text(
                '${zone['min']} - ${zone['max']} bpm',
                style: const TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.brandOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _ZoneBar(color: zone['color']),
        ],
      ),
    );
  }
}

class _ZoneBar extends StatelessWidget {
  final Color color;

  const _ZoneBar({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: 1.0,
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}
