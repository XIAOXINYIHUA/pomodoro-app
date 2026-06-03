import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../providers/stat_provider.dart';
import '../../providers/task_provider.dart';
import '../../providers/workout_plan_provider.dart';
import '../../providers/timer_provider.dart';
import 'widgets/stat_card_grid.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<StatProvider>().loadTodayStats();
      context.read<TaskProvider>().loadTasks();
      context.read<WorkoutPlanProvider>().loadPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('番茄运动'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<StatProvider>().loadTodayStats();
          await context.read<TaskProvider>().loadTasks();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 日期显示
              Text(
                '${DateTime.now().month}月${DateTime.now().day}日 ${AppDateUtils.getWeekdayName(DateTime.now().weekday)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 16),

              // 2x2 概览卡片
              const StatCardGrid(),
              const SizedBox(height: 24),

              // 快捷操作
              _buildQuickActions(context),
              const SizedBox(height: 24),

              // 今日任务概览
              _buildTodayTasks(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // 跳转到专注Tab
            },
            icon: const Icon(Icons.timer),
            label: const Text('开始专注'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tomatoRed,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // 跳转到运动Tab
            },
            icon: const Icon(Icons.fitness_center),
            label: const Text('开始运动'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.fitnessGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTodayTasks(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, _) {
        final tasks = taskProvider.allTasks.where((t) => t.status != 'done').take(3).toList();
        if (tasks.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('暂无待办任务，点击右下角添加'),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('今日任务', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...tasks.map((task) => Card(
              child: ListTile(
                leading: Icon(
                  task.status == 'in_progress' ? Icons.play_circle : Icons.circle_outlined,
                  color: task.status == 'in_progress' ? AppColors.tomatoRed : null,
                ),
                title: Text(task.title),
                subtitle: Text('${task.pomodoroCount} 番茄${task.estimatedPomodoros != null ? ' / ${task.estimatedPomodoros}' : ''}'),
              ),
            )),
          ],
        );
      },
    );
  }
}
