import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/workout_plan.dart';

class WorkoutDetailScreen extends StatelessWidget {
  final WorkoutPlan plan;

  const WorkoutDetailScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plan.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 运动类型图标
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.fitnessGreen.withOpacity(0.1),
                child: Icon(
                  _getTypeIcon(),
                  size: 48,
                  color: AppColors.fitnessGreen,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 详情卡片
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDetailRow('运动类型', _getTypeName()),
                    const Divider(),
                    _buildDetailRow('时长', '${plan.durationMinutes} 分钟'),
                    const Divider(),
                    _buildDetailRow('频率', _getFrequencyName()),
                    if (plan.timeOfDay != null) ...[
                      const Divider(),
                      _buildDetailRow('时间段', plan.timeOfDay!),
                    ],
                    if (plan.notes != null && plan.notes!.isNotEmpty) ...[
                      const Divider(),
                      _buildDetailRow('备注', plan.notes!),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondaryLight)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  IconData _getTypeIcon() {
    switch (plan.workoutType) {
      case 'running': return Icons.directions_run;
      case 'strength': return Icons.fitness_center;
      case 'yoga': return Icons.self_improvement;
      case 'cycling': return Icons.directions_bike;
      case 'swimming': return Icons.pool;
      case 'walking': return Icons.directions_walk;
      default: return Icons.sports;
    }
  }

  String _getTypeName() {
    return WorkoutType.values
        .firstWhere((t) => t.name == plan.workoutType, orElse: () => WorkoutType.custom)
        .label;
  }

  String _getFrequencyName() {
    return WorkoutFrequency.values
        .firstWhere((f) => f.name == plan.frequency, orElse: () => WorkoutFrequency.custom)
        .label;
  }
}
