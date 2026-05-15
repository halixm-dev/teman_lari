import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HrZoneDistributionChart extends StatelessWidget {
  final Map<int, double> zoneDistribution;

  const HrZoneDistributionChart({super.key, required this.zoneDistribution});

  static const zoneColors = [
    Colors.grey,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    if (zoneDistribution.isEmpty) {
      return const Center(child: Text('No heart rate data available'));
    }

    final sections = zoneDistribution.entries.map((e) {
      final zoneIndex = e.key - 1;
      return PieChartSectionData(
        value: e.value * 100,
        color: zoneColors[zoneIndex.clamp(0, zoneColors.length - 1)],
        title: 'Z${e.key}\n${(e.value * 100).toStringAsFixed(0)}%',
        titleStyle: const TextStyle(
            color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
        radius: 60,
      );
    }).toList();

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: sections,
          sectionsSpace: 2,
          centerSpaceRadius: 30,
        ),
      ),
    );
  }
}
