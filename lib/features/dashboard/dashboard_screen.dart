import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../providers/stat_provider.dart';
import '../../providers/task_provider.dart';
import '../../providers/workout_plan_provider.dart';
import '../../providers/workout_log_provider.dart';
import '../../providers/focus_plan_provider.dart';
import '../../providers/todo_provider.dart';
import '../../providers/navigation_provider.dart';
import '../focus_plans/focus_plan_card.dart';
import '../focus_plans/focus_plan_form_dialog.dart';
import '../fitness/widgets/workout_plan_card.dart';
import '../fitness/widgets/workout_form_dialog.dart';
import 'widgets/stat_card_grid.dart';
import 'widgets/todo_section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with WidgetsBindingObserver {
  String? _lastLoadedDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() => _loadAllData());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App 从后台恢复时检查日期是否变化
    if (state == AppLifecycleState.resumed) {
      _checkDateChange();
    }
  }

  void _checkDateChange() {
    final today = AppDateUtils.formatDate(DateTime.now());
    if (_lastLoadedDate != null && _lastLoadedDate != today) {
      _loadAllData();
    }
  }

  Future<void> _loadAllData() async {
    _lastLoadedDate = AppDateUtils.formatDate(DateTime.now());
    await context.read<TaskProvider>().loadTasks();
    await context.read<WorkoutPlanProvider>().loadPlans();
    await context.read<WorkoutLogProvider>().loadTodayLogs();
    await context.read<FocusPlanProvider>().loadPlans();
    await context.read<TodoProvider>().loadTodos();
    await context.read<StatProvider>().loadTodayStats();
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
        onRefresh: _loadAllData,
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
              const SizedBox(height: 16),

              // 待办事项
              const TodoSection(),
              const SizedBox(height: 24),

              // 快捷操作（含加号）
              _buildQuickActions(context),
              const SizedBox(height: 24),

              // 专注计划列表
              _buildFocusPlans(context),
              const SizedBox(height: 24),

              // 运动计划列表
              _buildWorkoutPlans(context),
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
              context.read<NavigationProvider>().changeTab(1);
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
        const SizedBox(width: 8),
        SizedBox(
          width: 48,
          height: 48,
          child: FloatingActionButton(
            onPressed: () => _showAddPlanSheet(context),
            backgroundColor: AppColors.warmOrange,
            mini: true,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              context.read<NavigationProvider>().changeTab(2);
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

  void _showAddPlanSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.timer, color: AppColors.tomatoRed),
              title: const Text('新建专注计划'),
              subtitle: const Text('创建番茄钟专注计划'),
              onTap: () {
                Navigator.pop(ctx);
                showDialog(
                  context: context,
                  builder: (_) => const FocusPlanFormDialog(),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center, color: AppColors.fitnessGreen),
              title: const Text('新建运动计划'),
              subtitle: const Text('创建运动锻炼计划'),
              onTap: () {
                Navigator.pop(ctx);
                showDialog(
                  context: context,
                  builder: (_) => const WorkoutFormDialog(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFocusPlans(BuildContext context) {
    return Consumer<FocusPlanProvider>(
      builder: (context, planProvider, _) {
        final plans = planProvider.plans.take(3).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('专注计划', style: Theme.of(context).textTheme.titleMedium),
                if (planProvider.plans.length > 3)
                  TextButton(
                    onPressed: () {
                      // 可以后续跳转到完整列表页
                    },
                    child: const Text('查看全部'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (plans.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.tomatoRed.withOpacity(0.5)),
                      const SizedBox(width: 8),
                      const Text('暂无专注计划，点击 + 创建'),
                    ],
                  ),
                ),
              )
            else
              ...plans.map((plan) => FocusPlanCard(plan: plan)),
          ],
        );
      },
    );
  }

  Widget _buildWorkoutPlans(BuildContext context) {
    return Consumer<WorkoutPlanProvider>(
      builder: (context, planProvider, _) {
        final plans = planProvider.plans.take(3).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('运动计划', style: Theme.of(context).textTheme.titleMedium),
                if (planProvider.plans.length > 3)
                  TextButton(
                    onPressed: () {
                      context.read<NavigationProvider>().changeTab(2);
                    },
                    child: const Text('查看全部'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (plans.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.fitnessGreen.withOpacity(0.5)),
                      const SizedBox(width: 8),
                      const Text('暂无运动计划，点击 + 创建'),
                    ],
                  ),
                ),
              )
            else
              ...plans.map((plan) => WorkoutPlanCard(plan: plan)),
          ],
        );
      },
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
              child: Text('暂无待办任务'),
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
