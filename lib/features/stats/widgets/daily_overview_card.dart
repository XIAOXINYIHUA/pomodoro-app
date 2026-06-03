import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_utils.dart';
import '../../../providers/stat_provider.dart';

class DailyOverviewCard extends StatelessWidget {
  const DailyOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StatProvider>(
      builder: (context, statProvider, _) {
        final stat = statProvider.todayStat;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('今日专注概览', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildItem(
                      context,
                      '番茄数',
                      '${stat?.totalPomodoros ?? 0}',
                      Icons.timer,
                      AppColors.tomatoRed,
                    ),
                    _buildItem(
                      context,
                      '专注时长',
                      AppDateUtils.formatDurationHours(stat?.totalFocusSeconds ?? 0),
                      Icons.access_time,
                      AppColors.warmOrange,
                    ),
                    _buildItem(
                      context,
                      '完成任务',
                      '${stat?.completedTasks ?? 0}',
                      Icons.check_circle,
                      AppColors.success,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(color: AppColors.textSecondaryLight)),
      ],
    );
  }
}
