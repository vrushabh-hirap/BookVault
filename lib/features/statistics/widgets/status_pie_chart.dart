import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';

class StatusPieChart extends StatelessWidget {
  final int reading;
  final int finished;
  final int wantToRead;
  final int dropped;

  const StatusPieChart({
    super.key,
    required this.reading,
    required this.finished,
    required this.wantToRead,
    required this.dropped,
  });

  @override
  Widget build(BuildContext context) {
    final total = reading + finished + wantToRead + dropped;
    if (total == 0) {
      return const Center(child: Text('No books to display', style: TextStyle(color: AppColors.textSecondary)));
    }

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: AspectRatio(
            aspectRatio: 1,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 40,
                sections: _buildSections(),
              ),
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLegend('Reading', reading, AppColors.warningAmber),
              _buildLegend('Finished', finished, AppColors.successGreen),
              _buildLegend('Want to Read', wantToRead, AppColors.infoBlue),
              _buildLegend('Dropped', dropped, AppColors.errorRed),
            ],
          ),
        )
      ],
    );
  }

  List<PieChartSectionData> _buildSections() {
    return [
      if (reading > 0)
        PieChartSectionData(
          color: AppColors.warningAmber,
          value: reading.toDouble(),
          title: '$reading',
          radius: 40,
          titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      if (finished > 0)
        PieChartSectionData(
          color: AppColors.successGreen,
          value: finished.toDouble(),
          title: '$finished',
          radius: 40,
          titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      if (wantToRead > 0)
        PieChartSectionData(
          color: AppColors.infoBlue,
          value: wantToRead.toDouble(),
          title: '$wantToRead',
          radius: 40,
          titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      if (dropped > 0)
        PieChartSectionData(
          color: AppColors.errorRed,
          value: dropped.toDouble(),
          title: '$dropped',
          radius: 40,
          titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
    ];
  }

  Widget _buildLegend(String label, int value, Color color) {
    if (value == 0) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        ],
      ),
    );
  }
}
