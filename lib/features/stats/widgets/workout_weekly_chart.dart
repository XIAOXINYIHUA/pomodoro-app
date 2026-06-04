import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_utils.dart';
import '../../../providers/stat_provider.dart';

enum WorkoutChartMode { minutes, calories }

class WorkoutWeeklyChart extends StatefulWidget {
  const WorkoutWeeklyChart({super.key});

  @override
  State<WorkoutWeeklyChart> createState() => _WorkoutWeeklyChartState();
}

class _WorkoutWeeklyChartState extends State<WorkoutWeeklyChart> {
  WorkoutChartMode _mode = WorkoutChartMode.minutes;

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

        final values = _mode == WorkoutChartMode.minutes
            ? weekStats.map((s) => s.workoutMinutes.toDouble()).toList()
            : weekStats.map((s) => s.calories).toList();

        final maxY = values.fold(0.0, (a, b) => a > b ? a : b);
        final topY = maxY > 0 ? (maxY * 1.3).ceilToDouble() : 30.0;
        final unit = _mode == WorkoutChartMode.minutes ? '分钟' : 'kcal';
        final color = _mode == WorkoutChartMode.minutes
            ? AppColors.fitnessGreen
            : AppColors.warmOrange;

        return Column(
          children: [
            // 切换按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildToggleChip('运动分钟', WorkoutChartMode.minutes, AppColors.fitnessGreen),
                const SizedBox(width: 8),
                _buildToggleChip('卡路里', WorkoutChartMode.calories, AppColors.warmOrange),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
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
                        reservedSize: 40,
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
                    final val = values[entry.key];
                    final isToday = AppDateUtils.isToday(
                        DateTime.parse(entry.value.date));
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: val,
                          color: isToday
                              ? color
                              : color.withOpacity(0.5),
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
                          '${AppDateUtils.getWeekdayName(date.weekday)}\n${_mode == WorkoutChartMode.minutes ? rod.toY.toStringAsFixed(0) : rod.toY.toStringAsFixed(1)} $unit',
                          const TextStyle(color: Colors.white, fontSize: 12),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildToggleChip(String label, WorkoutChartMode mode, Color color) {
    final selected = _mode == mode;
    return GestureDetector(
      onTap: () => setState(() => _mode = mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : color,
          ),
        ),
      ),
    );
  }
}
