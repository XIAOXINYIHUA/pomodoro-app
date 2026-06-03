import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/stat_provider.dart';
import '../../../providers/task_provider.dart';
import '../../../core/utils/date_utils.dart';

class StatCardGrid extends StatelessWidget {
  const StatCardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<StatProvider, TaskProvider>(
      builder: (context, statProvider, taskProvider, _) {
        final stat = statProvider.todayStat;
        final completedTasks = taskProvider.allTasks.where((t) => t.status == 'done').length;
        final totalTasks = taskProvider.allTasks.length;

        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _StatCard(
              icon: Icons.timer,
              title: '专注',
              value: '${stat?.totalPomodoros ?? 0} 番茄',
              subtitle: AppDateUtils.formatDurationHours(stat?.totalFocusSeconds ?? 0),
              color: AppColors.tomatoRed,
            ),
            _StatCard(
              icon: Icons.directions_walk,
              title: '步数',
              value: '${stat?.steps ?? 0}',
              subtitle: '目标 10,000',
              color: AppColors.fitnessGreen,
            ),
            _StatCard(
              icon: Icons.check_circle,
              title: '任务',
              value: '$completedTasks / $totalTasks',
              subtitle: '已完成',
              color: AppColors.warmOrange,
            ),
            _StatCard(
              icon: Icons.fitness_center,
              title: '运动',
              value: '${stat?.completedWorkouts ?? 0} / ${stat?.plannedWorkouts ?? 0}',
              subtitle: '计划完成',
              color: AppColors.info,
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 4),
                Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
