import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/entities/running_stats.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme_extensions.dart';
import '../theme/app_typography.dart';

class WeeklyVolumeChart extends StatefulWidget {
  final RunningStats stats;

  const WeeklyVolumeChart({super.key, required this.stats});

  @override
  State<WeeklyVolumeChart> createState() => _WeeklyVolumeChartState();
}

class _WeeklyVolumeChartState extends State<WeeklyVolumeChart> {
  String? _selectedWeekKey;

  String _weekCommencingKey(DateTime date) {
    final monday = date.subtract(Duration(days: date.weekday - 1));
    return '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
  }

  String get _currentWeekKey {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return _weekCommencingKey(monday);
  }

  List<MapEntry<String, double>> get _entries {
    final now = DateTime.now();
    final currentMonday = now.subtract(Duration(days: now.weekday - 1));
    final entries = <MapEntry<String, double>>[];
    for (int i = 11; i >= 0; i--) {
      final monday = currentMonday.subtract(Duration(days: i * 7));
      final key = _weekCommencingKey(monday);
      final value = widget.stats.weeklyVolume[key] ?? 0.0;
      entries.add(MapEntry(key, value));
    }
    return entries;
  }

  @override
  void initState() {
    super.initState();
    _selectedWeekKey = _currentWeekKey;
  }

  String _formatWeekLabel(String key) {
    if (key == _currentWeekKey) return 'This Week';
    final parts = key.split('-');
    if (parts.length < 3) return key;
    final year = int.tryParse(parts[0]) ?? 0;
    final month = int.tryParse(parts[1]) ?? 1;
    final day = int.tryParse(parts[2]) ?? 1;
    final monday = DateTime(year, month, day);
    final sunday = monday.add(const Duration(days: 6));
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final mMon = months[monday.month - 1];
    final sMon = months[sunday.month - 1];
    if (monday.year == sunday.year) {
      return '${monday.day} $mMon - ${sunday.day} $sMon ${sunday.year}';
    }
    return '${monday.day} $mMon ${monday.year} - ${sunday.day} $sMon ${sunday.year}';
  }

  String _formatMinutes(double minutes) {
    final hrs = minutes ~/ 60;
    final mins = minutes % 60;
    if (hrs > 0) return '${hrs}h ${mins.toInt()}m';
    return '${mins.toInt()}m';
  }

  @override
  Widget build(BuildContext context) {
    final entries = _entries;

    _selectedWeekKey ??= _currentWeekKey;
    final selectedKey = _selectedWeekKey;
    if (selectedKey == null) return const SizedBox();

    final selectedDistance = widget.stats.weeklyVolume[selectedKey] ?? 0.0;
    final selectedMinutes = widget.stats.weeklyMinutes[selectedKey] ?? 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _WeeklySummary(
              weekLabel: _formatWeekLabel(selectedKey),
              distance: selectedDistance,
              time: _formatMinutes(selectedMinutes),
              labelStyle: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: _VolumeLineChart(
                entries: entries,
                selectedKey: selectedKey,
                isDark: Theme.of(context).brightness == Brightness.dark,
                onWeekSelected: (key) {
                  setState(() => _selectedWeekKey = key);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklySummary extends StatelessWidget {
  final String weekLabel;
  final double distance;
  final String time;
  final TextStyle? labelStyle;

  const _WeeklySummary({
    required this.weekLabel,
    required this.distance,
    required this.time,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(weekLabel, style: labelStyle),
          const SizedBox(height: 8),
          Row(
            children: [
              _SummaryItem(
                label: 'Distance',
                value: '${distance.toStringAsFixed(1)} km',
              ),
              const SizedBox(width: 24),
              _SummaryItem(label: 'Time', value: time),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final typoExt = Theme.of(context).extension<AppTypographyExtension>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              typoExt?.statLabel ??
              Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
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

class _VolumeLineChart extends StatelessWidget {
  final List<MapEntry<String, double>> entries;
  final String selectedKey;
  final bool isDark;
  final ValueChanged<String> onWeekSelected;

  const _VolumeLineChart({
    required this.entries,
    required this.selectedKey,
    required this.isDark,
    required this.onWeekSelected,
  });

  int _indexFromDx(double dx, double width) {
    const paddingLeft = 16.0;
    const paddingRight = 40.0;
    final chartWidth = width - paddingLeft - paddingRight;
    final stepX = entries.length > 1
        ? chartWidth / (entries.length - 1)
        : chartWidth;
    final tapX = dx - paddingLeft;
    return (tapX / stepX).round().clamp(0, entries.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Semantics(
          label: 'Weekly volume chart. Tap or pan to select weeks.',
          child: GestureDetector(
            onTapDown: (details) {
              final index = _indexFromDx(
                details.localPosition.dx,
                constraints.maxWidth,
              );
              onWeekSelected(entries[index].key);
            },
            onPanUpdate: (details) {
              final index = _indexFromDx(
                details.localPosition.dx,
                constraints.maxWidth,
              );
              onWeekSelected(entries[index].key);
            },
            child: CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: _VolumeLinePainter(
                entries: entries,
                selectedKey: selectedKey,
                isDark: isDark,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _VolumeLinePainter extends CustomPainter {
  final List<MapEntry<String, double>> entries;
  final String selectedKey;
  final bool isDark;

  _VolumeLinePainter({
    required this.entries,
    required this.selectedKey,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const paddingLeft = 16.0;
    const paddingRight = 40.0;
    const paddingTop = 20.0;
    const paddingBottom = 30.0;

    final chartWidth = size.width - paddingLeft - paddingRight;
    final chartHeight = size.height - paddingTop - paddingBottom;

    if (entries.isEmpty || chartWidth <= 0 || chartHeight <= 0) return;

    final maxVol = entries.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final effectiveMax = maxVol > 0 ? maxVol.ceilToDouble() : 1.0;

    final stepX = entries.length > 1
        ? chartWidth / (entries.length - 1)
        : chartWidth;

    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.gray500;
    final gridColor = isDark ? AppColors.dividerDark : AppColors.gray200;

    _drawGridLinesAndYAxis(
      canvas,
      size,
      paddingTop,
      chartHeight,
      paddingLeft,
      paddingRight,
      effectiveMax,
      gridColor,
      labelColor,
    );

    _drawYAxisTitle(canvas, paddingTop, chartHeight, labelColor);

    _drawXAxisLabels(
      canvas,
      size,
      paddingLeft,
      paddingBottom,
      stepX,
      labelColor,
    );

    final points = _buildPoints(
      paddingLeft,
      paddingTop,
      chartHeight,
      stepX,
      effectiveMax,
    );

    _drawLine(canvas, points);

    _drawDotsAndSelectedMarker(canvas, size, points, paddingTop, paddingBottom);
  }

  void _drawGridLinesAndYAxis(
    Canvas canvas,
    Size size,
    double paddingTop,
    double chartHeight,
    double paddingLeft,
    double paddingRight,
    double effectiveMax,
    Color gridColor,
    Color labelColor,
  ) {
    final tp = TextPainter(
      textAlign: TextAlign.right,
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < 3; i++) {
      final yRatio = i / 2.0;
      final y = paddingTop + chartHeight * (1 - yRatio);
      final value = (effectiveMax * yRatio).toStringAsFixed(1);

      canvas.drawLine(
        Offset(paddingLeft, y),
        Offset(size.width - paddingRight, y),
        Paint()
          ..color = gridColor
          ..strokeWidth = 0.5,
      );

      tp.text = TextSpan(
        text: '$value km',
        style: AppTypography.caption.copyWith(color: labelColor),
      );
      tp.layout();
      tp.paint(
        canvas,
        Offset(size.width - paddingRight + 4, y - tp.height / 2),
      );
    }
  }

  void _drawYAxisTitle(
    Canvas canvas,
    double paddingTop,
    double chartHeight,
    Color labelColor,
  ) {
    final titleTp = TextPainter(
      text: TextSpan(
        text: 'Volume Trend',
        style: AppTypography.caption.copyWith(color: labelColor),
      ),
      textDirection: TextDirection.ltr,
    );
    titleTp.layout();
    canvas.save();
    canvas.translate(6, paddingTop + chartHeight / 2);
    canvas.rotate(-math.pi / 2);
    titleTp.paint(canvas, Offset(-titleTp.width / 2, 0));
    canvas.restore();
  }

  void _drawXAxisLabels(
    Canvas canvas,
    Size size,
    double paddingLeft,
    double paddingBottom,
    double stepX,
    Color labelColor,
  ) {
    final xTp = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < entries.length; i++) {
      final x = paddingLeft + stepX * i;
      final label = _xLabel(entries[i].key);

      if (label.isEmpty) continue;

      xTp.text = TextSpan(
        text: label,
        style: AppTypography.caption.copyWith(
          color: labelColor,
          fontWeight: FontWeight.w600,
        ),
      );
      xTp.layout();
      xTp.paint(
        canvas,
        Offset(x - xTp.width / 2, size.height - paddingBottom + 8),
      );
    }
  }

  List<Offset> _buildPoints(
    double paddingLeft,
    double paddingTop,
    double chartHeight,
    double stepX,
    double effectiveMax,
  ) {
    final points = <Offset>[];
    final hasVolume = entries.any((e) => e.value > 0);
    for (int i = 0; i < entries.length; i++) {
      final x = paddingLeft + stepX * i;
      final yRatio = hasVolume ? entries[i].value / effectiveMax : 0.0;
      final y = paddingTop + chartHeight * (1 - yRatio);
      points.add(Offset(x, y));
    }
    return points;
  }

  void _drawLine(Canvas canvas, List<Offset> points) {
    if (points.isEmpty) return;

    final linePaint = Paint()
      ..color = AppColors.brandOrange
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        path.moveTo(points[i].dx, points[i].dy);
      } else {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }
    canvas.drawPath(path, linePaint);
  }

  void _drawDotsAndSelectedMarker(
    Canvas canvas,
    Size size,
    List<Offset> points,
    double paddingTop,
    double paddingBottom,
  ) {
    final dotPaint = Paint()
      ..color = AppColors.brandOrange
      ..style = PaintingStyle.fill;

    final selectedIdx = entries.indexWhere((e) => e.key == selectedKey);

    for (int i = 0; i < points.length; i++) {
      if (i == selectedIdx) {
        // Full vertical white line marker
        final markerPaint = Paint()
          ..color = isDark ? Colors.white : AppColors.gray700
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;

        canvas.drawLine(
          Offset(points[i].dx, size.height - paddingBottom),
          Offset(points[i].dx, paddingTop),
          markerPaint,
        );

        // Glow
        final glowPaint = Paint()
          ..color = AppColors.brandOrange.withValues(alpha: 0.3)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(points[i], 10, glowPaint);

        // Main dot
        canvas.drawCircle(points[i], 5, dotPaint);
      } else {
        canvas.drawCircle(points[i], 3.5, dotPaint);
      }
    }
  }

  String _xLabel(String isoWeek) {
    final parts = isoWeek.split('-');
    if (parts.length < 3) return '';
    final month = int.tryParse(parts[1]) ?? 0;
    final day = int.tryParse(parts[2]) ?? 0;
    if (day > 7) return '';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    if (month < 1 || month > 12) return '';
    return months[month - 1];
  }

  @override
  bool shouldRepaint(covariant _VolumeLinePainter oldDelegate) {
    return oldDelegate.entries != entries ||
        oldDelegate.selectedKey != selectedKey ||
        oldDelegate.isDark != isDark;
  }
}
