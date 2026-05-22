import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/running_stats.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

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

    final paceRange = (-rawMinY) - (-rawMaxY);
    final interval = paceRange > 60 ? 30.0 : 15.0;
    final minY = (rawMinY / interval).floor() * interval;
    final maxY = (rawMaxY / interval).ceil() * interval;

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              tooltipMargin: 8,
              tooltipBorderRadius: BorderRadius.circular(8),
              getTooltipColor: (spot) => AppColors.gray900.withValues(alpha: 0.85),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final idx = spot.spotIndex;
                  final point = dataPoints[idx];
                  final mins = point.paceSecondsPerKm ~/ 60;
                  final secs = point.paceSecondsPerKm % 60;
                  return LineTooltipItem(
                    '',
                    const TextStyle(fontSize: 0, height: 0),
                    children: [
                      TextSpan(
                        text: DateFormat.MMMd().format(point.date),
                        style: AppTypography.caption.copyWith(
                          color: AppColors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      TextSpan(
                        text: '\n$mins:${secs.toString().padLeft(2, '0')} /km',
                        style: AppTypography.jetbrainsMono.copyWith(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: '\n${point.distanceKm.toStringAsFixed(2)} km',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  );
                }).toList();
              },
            ),
            getTouchedSpotIndicator: (barData, spotIndexes) {
              return spotIndexes.map((i) {
                return TouchedSpotIndicatorData(
                  FlLine(
                    color: Theme.of(context).colorScheme.primary,
                    strokeWidth: 1,
                  ),
                  FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: Theme.of(context).colorScheme.primary,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                );
              }).toList();
            },
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Theme.of(context).colorScheme.primary,
              barWidth: 2,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                interval: interval,
                getTitlesWidget: (value, meta) {
                  final pace = value.abs().toInt();
                  if (pace % interval.toInt() != 0) {
                    return const SizedBox.shrink();
                  }
                  final mins = pace ~/ 60;
                  final secs = pace % 60;
                  return Text(
                    '$mins:${secs.toString().padLeft(2, '0')}',
                    style: AppTypography.jetbrainsMono.copyWith(
                      fontSize: 11,
                      color: AppColors.gray500,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: (dataPoints.length > 8)
                    ? (dataPoints.length / 6).ceilToDouble()
                    : 1,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= dataPoints.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.Md().format(dataPoints[idx].date),
                      style: AppTypography.caption.copyWith(
                        color: AppColors.gray500,
                      ),
                    ),
                  );
                },
              ),
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
              color: const Color.fromRGBO(0, 0, 0, 0.06),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
