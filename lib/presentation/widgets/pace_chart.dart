import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/utils/date_utils.dart';
import '../../domain/entities/running_stats.dart';
import '../theme/app_colors.dart';

class PaceProgressionChart extends StatelessWidget {
  final List<PaceDataPoint> dataPoints;

  const PaceProgressionChart({super.key, required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    if (dataPoints.isEmpty) return const SizedBox.shrink();

    final spots = dataPoints.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), -e.value.paceSecondsPerKm.toDouble());
    }).toList();

    final rawMinY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final rawMaxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final minY = rawMinY - 30;
    final maxY = rawMaxY + 30;

    final paceRange = (-rawMinY) - (-rawMaxY);
    final interval = paceRange > 60 ? 30.0 : 15.0;

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Theme.of(context).colorScheme.primary,
              barWidth: 2,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value % interval != 0) return const SizedBox.shrink();
                  final abs = (-value).toInt();
                  final mins = abs ~/ 60;
                  final secs = abs % 60;
                  return Text('$mins:${secs.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 10));
                },
              ),
            ),
            bottomTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: interval,
            getDrawingHorizontalLine: (_) => FlLine(
              color: AppColors.gray500.withValues(alpha: 0.2),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (spot) =>
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              tooltipRoundedRadius: 8,
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              getTooltipItems: (touchedSpots) {
                return touchedSpots?.map((spot) {
                  final dp = dataPoints[spot.x.toInt()];
                  final paceMin = dp.paceSecondsPerKm ~/ 60;
                  final paceSec = dp.paceSecondsPerKm % 60;
                  return LineTooltipItem(
                    '${AppDateUtils.formatDate(dp.date)}\n'
                        '${paceMin}:${paceSec.toString().padLeft(2, '0')}'
                        ' /km · ${dp.distanceKm.toStringAsFixed(1)} km',
                    TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }).toList() ??
                    [];
              },
            ),
            getTouchedSpotIndicator: (barData, spotIndexes) {
              return spotIndexes.map((index) {
                return TouchedSpotIndicatorData(
                  indicatorLine: FlLine(
                    color: Theme.of(context).colorScheme.primary,
                    strokeWidth: 2,
                  ),
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, bar, dotIndex) =>
                        FlDotCirclePainter(
                      radius: 4,
                      color: Theme.of(context).colorScheme.primary,
                      strokeWidth: 2,
                      strokeColor: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
