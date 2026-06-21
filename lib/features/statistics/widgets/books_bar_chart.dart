import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';

class BooksBarChart extends StatelessWidget {
  final Map<String, int> addedByMonth;

  const BooksBarChart({super.key, required this.addedByMonth});

  @override
  Widget build(BuildContext context) {
    if (addedByMonth.isEmpty) {
       return const Center(child: Text('No data', style: TextStyle(color: AppColors.textSecondary)));
    }

    final entries = addedByMonth.entries.toList();
    // Reverse because addedByMonth is built backwards in provider
    final orderedEntries = entries.reversed.toList();
    
    double maxY = 0;
    for (final e in orderedEntries) {
      if (e.value > maxY) maxY = e.value.toDouble();
    }
    maxY = maxY < 5 ? 5 : maxY + 2;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        minY: 0,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value >= 0 && value < orderedEntries.length) {
                  // Only show abbreviated month name e.g. 'Jan'
                  final label = orderedEntries[value.toInt()].key.split(' ').first;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value % 1 == 0) {
                  return Text(value.toInt().toString(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => const FlLine(color: AppColors.borderSubtle, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        barGroups: orderedEntries.asMap().entries.map((e) {
          final index = e.key;
          final value = e.value.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: value.toDouble(),
                color: AppColors.accentPrimary,
                width: 16,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
