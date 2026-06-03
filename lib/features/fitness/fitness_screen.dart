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

              // 今日运动计划
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
