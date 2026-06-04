import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_utils.dart';
import '../../../providers/stat_provider.dart';

class WeeklyChart extends StatelessWidget {
  const WeeklyChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StatProvider>(
      builder: (context, statProvider, _) {
        final weekStats = statProvider.weekStats;

        if (weekStats.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(child: Text('暂无数据')),
          );
        }

        // 纵坐标：分钟
        final maxY = weekStats
            .map((s) => s.totalFocusSeconds / 60.0)
            .fold(0.0, (a, b) => a > b ? a : b);
        final topY = maxY > 0 ? (maxY * 1.3).ceilToDouble() : 60.0;

        return SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: topY,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: topY / 4,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: AppColors.dividerLight,
                  strokeWidth: 0.5,
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    getTitlesWidget: (value, meta) {
                      return Text('${value.toInt()}',
                          style: const TextStyle(fontSize: 11));
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < weekStats.length) {
                        final date = DateTime.parse(weekStats[index].date);
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            AppDateUtils.getWeekdayShort(date.weekday),
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              barGroups: weekStats.asMap().entries.map((entry) {
                final minutes = entry.value.totalFocusSeconds / 60.0;
                final isToday = AppDateUtils.isToday(
                    DateTime.parse(entry.value.date));
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: minutes,
                      color: isToday
                          ? AppColors.tomatoRed
                          : AppColors.tomatoRed.withOpacity(0.5),
                      width: 28,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
                  ],
                );
              }).toList(),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final date = DateTime.parse(weekStats[group.x].date);
                    return BarTooltipItem(
                      '${AppDateUtils.getWeekdayName(date.weekday)}\n${rod.toY.toStringAsFixed(0)} 分钟',
                      const TextStyle(color: Colors.white, fontSize: 12),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
