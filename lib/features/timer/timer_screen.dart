import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/timer_provider.dart';
import '../../providers/task_provider.dart';
import '../../providers/focus_plan_provider.dart';
import 'widgets/circular_timer.dart';
import 'widgets/timer_controls.dart';
import 'widgets/task_selector_sheet.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TaskProvider>().loadTasks();
      context.read<FocusPlanProvider>().loadPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('专注'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<TimerProvider>().reset(),
          ),
        ],
      ),
      body: Consumer<TimerProvider>(
        builder: (context, timer, _) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 今日统计
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStat('今日番茄', '${timer.completedPomodoros}'),
                      const SizedBox(width: 32),
                      _buildStat('当前状态', timer.stateLabel),
                    ],
                  ),
                ),

                const Spacer(),

                // 环形计时器
                CircularTimer(
                  progress: timer.progress,
                  timeDisplay: timer.timeDisplay,
                  state: timer.state,
                ),

                const SizedBox(height: 32),

                // 专注计划选择
                _buildPlanSelector(context, timer),

                const SizedBox(height: 12),

                // 任务选择
                _buildTaskSelector(context, timer),

                const Spacer(),

                // 控制按钮
                TimerControls(
                  state: timer.state,
                  onStart: timer.start,
                  onPause: timer.pause,
                  onReset: timer.reset,
                  onSkip: timer.skip,
                ),

                const SizedBox(height: 48),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: AppColors.textSecondaryLight),
        ),
      ],
    );
  }

  Widget _buildPlanSelector(BuildContext context, TimerProvider timer) {
    return Consumer<FocusPlanProvider>(
      builder: (context, planProvider, _) {
        final plans = planProvider.plans;
        if (plans.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: OutlinedButton.icon(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) => SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('选择专注计划', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      ...plans.map((plan) => ListTile(
                        leading: const Icon(Icons.timer, color: AppColors.tomatoRed),
                        title: Text(plan.title),
                        subtitle: Text('${plan.workDuration}分钟专注 · ${plan.breakDuration}分钟休息'),
                        onTap: () {
                          Navigator.pop(ctx);
                          timer.loadPlanConfig(plan);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('已加载计划「${plan.title}」')),
                          );
                        },
                      )),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            },
            icon: const Icon(Icons.playlist_play),
            label: Text(
              timer.currentPlanName ?? '选择专注计划（可选）',
              overflow: TextOverflow.ellipsis,
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaskSelector(BuildContext context, TimerProvider timer) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, _) {
        final selectedTask = taskProvider.allTasks
            .where((t) => t.id == timer.selectedTaskId)
            .firstOrNull;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: OutlinedButton.icon(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => const TaskSelectorSheet(),
              );
            },
            icon: const Icon(Icons.task),
            label: Text(
              selectedTask?.title ?? '选择任务（可选）',
              overflow: TextOverflow.ellipsis,
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        );
      },
    );
  }
}
