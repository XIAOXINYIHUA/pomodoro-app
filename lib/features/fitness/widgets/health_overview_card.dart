import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/health_provider.dart';
import '../../../providers/settings_provider.dart';

class HealthOverviewCard extends StatelessWidget {
  const HealthOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<HealthProvider, SettingsProvider>(
      builder: (context, health, settings, _) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('今日健康数据', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),

                if (health.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (!health.isAuthorized)
                  _buildAuthorizationPrompt(context)
                else
                  _buildHealthGrid(context, health, settings),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAuthorizationPrompt(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.health_and_safety, size: 48, color: AppColors.fitnessGreen),
        const SizedBox(height: 16),
        const Text('需要授权读取健康数据'),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => context.read<HealthProvider>().requestAuthorization(),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.fitnessGreen),
          child: const Text('授权'),
        ),
      ],
    );
  }

  Widget _buildHealthGrid(BuildContext context, HealthProvider health, SettingsProvider settings) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildHealthItem(
          context,
          icon: Icons.directions_walk,
          label: '步数',
          value: '${health.steps}',
          target: '${settings.stepGoal}',
          color: AppColors.fitnessGreen,
          progress: health.steps / settings.stepGoal,
        ),
        _buildHealthItem(
          context,
          icon: Icons.local_fire_department,
          label: '卡路里',
          value: '${health.calories.toStringAsFixed(0)} kcal',
          target: '${settings.calorieGoal} kcal',
          color: AppColors.warmOrange,
          progress: health.calories / settings.calorieGoal,
        ),
        _buildHealthItem(
          context,
          icon: Icons.timer,
          label: '运动时长',
          value: '${health.workoutMinutes} 分钟',
          target: '${settings.workoutMinutesGoal} 分钟',
          color: AppColors.info,
          progress: health.workoutMinutes / settings.workoutMinutesGoal,
        ),
        _buildHealthItem(
          context,
          icon: Icons.favorite,
          label: '心率',
          value: health.heartRate != null ? '${health.heartRate!.toStringAsFixed(0)} bpm' : '--',
          target: '静息',
          color: AppColors.error,
          progress: 0,
        ),
      ],
    );
  }

  Widget _buildHealthItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required String target,
    required Color color,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 4),
              Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text('目标: $target', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
