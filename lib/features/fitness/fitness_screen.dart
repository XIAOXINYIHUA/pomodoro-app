import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/health_provider.dart';
import '../../providers/workout_plan_provider.dart';
import '../../providers/workout_log_provider.dart';
import '../../providers/stat_provider.dart';
import 'widgets/health_overview_card.dart';
import 'widgets/workout_plan_card.dart';
import 'widgets/workout_form_dialog.dart';

class FitnessScreen extends StatefulWidget {
  const FitnessScreen({super.key});

  @override
  State<FitnessScreen> createState() => _FitnessScreenState();
}

class _FitnessScreenState extends State<FitnessScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HealthProvider>().fetchTodayData();
      context.read<WorkoutPlanProvider>().loadPlans();
      context.read<WorkoutLogProvider>().loadTodayLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('运动'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note),
            tooltip: '手动记录',
            onPressed: () => _showManualRecordDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<HealthProvider>().fetchTodayData(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<HealthProvider>().fetchTodayData();
          await context.read<WorkoutPlanProvider>().loadPlans();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 健康数据概览
              const HealthOverviewCard(),
              const SizedBox(height: 24),

              // 手动记录快捷按钮
              _buildManualRecordButton(context),
              const SizedBox(height: 24),

              // 运动计划
              _buildTodayPlans(context),
              const SizedBox(height: 24),

              // 全部运动计划
              _buildAllPlans(context),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const WorkoutFormDialog(),
          );
        },
        backgroundColor: AppColors.fitnessGreen,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildManualRecordButton(BuildContext context) {
    return Card(
      color: AppColors.fitnessGreen.withOpacity(0.08),
      child: InkWell(
        onTap: () => _showManualRecordDialog(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.edit_calendar, color: AppColors.fitnessGreen),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('手动记录运动', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.fitnessGreen)),
                    const SizedBox(height: 2),
                    Text('没有运动设备？手动输入步数、卡路里等数据', style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.fitnessGreen),
            ],
          ),
        ),
      ),
    );
  }

  void _showManualRecordDialog(BuildContext context) {
    final stepsController = TextEditingController();
    final caloriesController = TextEditingController();
    final minutesController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.edit_calendar, color: AppColors.fitnessGreen),
            SizedBox(width: 8),
            Text('手动记录运动数据'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: stepsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '步数',
                hintText: '例如：8000',
                suffixText: '步',
                prefixIcon: Icon(Icons.directions_walk),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: caloriesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '卡路里',
                hintText: '例如：200',
                suffixText: 'kcal',
                prefixIcon: Icon(Icons.local_fire_department),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: minutesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '运动时长',
                hintText: '例如：30',
                suffixText: '分钟',
                prefixIcon: Icon(Icons.timer),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              final steps = int.tryParse(stepsController.text) ?? 0;
              final calories = double.tryParse(caloriesController.text) ?? 0;
              final minutes = int.tryParse(minutesController.text) ?? 0;

              if (steps == 0 && calories == 0 && minutes == 0) {
                Navigator.pop(ctx);
                return;
              }

              await context.read<StatProvider>().updateHealthData(
                steps: steps > 0 ? steps : null,
                calories: calories > 0 ? calories : null,
                workoutMinutes: minutes > 0 ? minutes : null,
              );

              // 同步到 HealthProvider 的显示数据
              if (steps > 0) context.read<HealthProvider>().setSteps(steps);
              if (calories > 0) context.read<HealthProvider>().setCalories(calories);
              if (minutes > 0) context.read<HealthProvider>().setWorkoutMinutes(minutes);

              if (ctx.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('运动数据已记录')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.fitnessGreen),
            child: const Text('保存', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayPlans(BuildContext context) {
    return Consumer<WorkoutPlanProvider>(
      builder: (context, planProvider, _) {
        final plans = planProvider.plans;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('运动计划', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (plans.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('暂无运动计划，点击右下角添加'),
                ),
              )
            else
              ...plans.map((plan) => WorkoutPlanCard(plan: plan)),
          ],
        );
      },
    );
  }

  Widget _buildAllPlans(BuildContext context) {
    return const SizedBox.shrink();
  }
}
