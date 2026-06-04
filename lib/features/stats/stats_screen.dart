import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/stat_provider.dart';
import 'widgets/daily_overview_card.dart';
import 'widgets/weekly_chart.dart';
import 'widgets/workout_weekly_chart.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      context.read<StatProvider>().loadTodayStats();
      context.read<StatProvider>().loadWeekStats();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('统计'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '专注'),
            Tab(text: '运动'),
          ],
          labelColor: AppColors.tomatoRed,
          unselectedLabelColor: AppColors.textSecondaryLight,
          indicatorColor: AppColors.tomatoRed,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFocusStats(context),
          _buildWorkoutStats(context),
        ],
      ),
    );
  }

  Widget _buildFocusStats(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DailyOverviewCard(),
          const SizedBox(height: 24),
          Text('本周专注趋势（分钟）', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          const WeeklyChart(),
        ],
      ),
    );
  }

  Widget _buildWorkoutStats(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWorkoutOverview(context),
          const SizedBox(height: 24),
          Text('本周运动趋势', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          const WorkoutWeeklyChart(),
          const SizedBox(height: 24),
          Text('运动完成率', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          _buildWorkoutCompletionRate(context),
        ],
      ),
    );
  }

  Widget _buildWorkoutOverview(BuildContext context) {
    return Consumer<StatProvider>(
      builder: (context, statProvider, _) {
        final stat = statProvider.todayStat;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('今日运动概览', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('步数', '${stat?.steps ?? 0}', Icons.directions_walk, AppColors.fitnessGreen),
                    _buildStatItem('卡路里', '${stat?.calories.toStringAsFixed(0) ?? 0} kcal', Icons.local_fire_department, AppColors.warmOrange),
                    _buildStatItem('运动', '${stat?.workoutMinutes ?? 0} 分钟', Icons.timer, AppColors.info),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label, style: TextStyle(color: AppColors.textSecondaryLight)),
      ],
    );
  }

  Widget _buildWorkoutCompletionRate(BuildContext context) {
    return Consumer<StatProvider>(
      builder: (context, statProvider, _) {
        final stat = statProvider.todayStat;
        final planned = stat?.plannedWorkouts ?? 0;
        final completed = stat?.completedWorkouts ?? 0;
        final rate = planned > 0 ? (completed / planned * 100).toStringAsFixed(0) : '0';

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text('$rate%', style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.fitnessGreen,
                  fontWeight: FontWeight.bold,
                )),
                const SizedBox(height: 8),
                Text('$completed / $planned 计划完成'),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: planned > 0 ? completed / planned : 0,
                  backgroundColor: AppColors.dividerLight,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.fitnessGreen),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
