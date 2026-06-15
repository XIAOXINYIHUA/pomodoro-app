import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/l10n/app_strings.dart';
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
                Text(AppStrings.healthData, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),

                if (health.isLoading)
                  Center(child: Text(AppStrings.loading))
                else if (!health.healthServiceAvailable)
                  _buildServiceUnavailable(context)
                else if (!health.isAuthorized)
                  _buildAuthorizationPrompt(context)
                else ...[
                  _buildHealthGrid(context, health, settings),
                  // 数据来源
                  if (health.dataSources.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildDataSources(context, health),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildServiceUnavailable(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.info_outline, size: 48, color: AppColors.warmOrange),
        const SizedBox(height: 12),
        Text(
          AppStrings.healthServiceUnavailable,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAuthorizationPrompt(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.health_and_safety, size: 48, color: AppColors.fitnessGreen),
        const SizedBox(height: 16),
        Text(AppStrings.needAuth),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => context.read<HealthProvider>().requestAuthorization(),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.fitnessGreen),
          child: Text(AppStrings.authorize),
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
          label: AppStrings.steps,
          value: '${health.steps}',
          target: '${settings.stepGoal}',
          color: AppColors.fitnessGreen,
          progress: health.steps / settings.stepGoal,
        ),
        _buildHealthItem(
          context,
          icon: Icons.local_fire_department,
          label: AppStrings.caloriesLabel,
          value: '${health.calories.toStringAsFixed(0)} kcal',
          target: '${settings.calorieGoal} kcal',
          color: AppColors.warmOrange,
          progress: health.calories / settings.calorieGoal,
        ),
        _buildHealthItem(
          context,
          icon: Icons.timer,
          label: AppStrings.workoutDuration,
          value: AppStrings.formatMinutesLabel(health.workoutMinutes),
          target: AppStrings.formatMinutesLabel(settings.workoutMinutesGoal),
          color: AppColors.info,
          progress: health.workoutMinutes / settings.workoutMinutesGoal,
        ),
        _buildHealthItem(
          context,
          icon: Icons.favorite,
          label: AppStrings.heartRate,
          value: health.heartRate != null ? '${health.heartRate!.toStringAsFixed(0)} bpm' : '--',
          target: AppStrings.resting,
          color: AppColors.error,
          progress: 0,
        ),
        _buildHealthItem(
          context,
          icon: Icons.straighten,
          label: AppStrings.distance,
          value: AppStrings.formatKm(health.distanceKm),
          target: '',
          color: AppColors.tomatoRed,
          progress: 0,
        ),
        _buildHealthItem(
          context,
          icon: Icons.stairs,
          label: AppStrings.floors,
          value: AppStrings.formatFloors(health.floorsClimbed),
          target: '',
          color: AppColors.fitnessGreenLight,
          progress: 0,
        ),
        if (health.sleepHours != null)
          _buildHealthItem(
            context,
            icon: Icons.bedtime,
            label: AppStrings.sleep,
            value: AppStrings.formatSleepHours(health.sleepHours!),
            target: '',
            color: AppColors.info,
            progress: 0,
          ),
        if (health.bloodOxygen != null)
          _buildHealthItem(
            context,
            icon: Icons.bloodtype,
            label: AppStrings.bloodOxygen,
            value: AppStrings.formatBpOxygen(health.bloodOxygen!),
            target: '',
            color: AppColors.tomatoRed,
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
        color: color.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (target.isNotEmpty)
            Text('${AppStrings.target}: $target', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildDataSources(BuildContext context, HealthProvider health) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.fitnessGreen.withValues(alpha:0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fitnessGreen.withValues(alpha:0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.link, size: 16, color: AppColors.fitnessGreen),
              const SizedBox(width: 6),
              Text(
                AppStrings.dataSource,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.fitnessGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            AppStrings.dataSourceDesc,
            style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: health.dataSources.map((source) => Chip(
              label: Text(source, style: const TextStyle(fontSize: 11)),
              backgroundColor: AppColors.fitnessGreen.withValues(alpha:0.1),
              side: BorderSide.none,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
            )).toList(),
          ),
        ],
      ),
    );
  }
}
