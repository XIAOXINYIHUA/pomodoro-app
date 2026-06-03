import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/workout_plan.dart';
import '../../../providers/workout_plan_provider.dart';
import '../../../providers/workout_log_provider.dart';
import '../workout_detail_screen.dart';

class WorkoutPlanCard extends StatelessWidget {
  final WorkoutPlan plan;

  const WorkoutPlanCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: _buildTypeIcon(),
        title: Text(plan.title),
        subtitle: Text('${plan.durationMinutes}分钟 · ${_getFrequencyText()}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check_circle_outline),
              color: AppColors.fitnessGreen,
              onPressed: () => _completeWorkout(context),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showOptions(context),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WorkoutDetailScreen(plan: plan),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypeIcon() {
    IconData icon;
    switch (plan.workoutType) {
      case 'running':
        icon = Icons.directions_run;
        break;
      case 'strength':
        icon = Icons.fitness_center;
        break;
      case 'yoga':
        icon = Icons.self_improvement;
        break;
      case 'cycling':
        icon = Icons.directions_bike;
        break;
      case 'swimming':
        icon = Icons.pool;
        break;
      case 'walking':
        icon = Icons.directions_walk;
        break;
      default:
        icon = Icons.sports;
    }
    return CircleAvatar(
      backgroundColor: AppColors.fitnessGreen.withOpacity(0.1),
      child: Icon(icon, color: AppColors.fitnessGreen),
    );
  }

  String _getFrequencyText() {
    switch (plan.frequency) {
      case 'daily':
        return '每天';
      case 'weekdays':
        return '工作日';
      case 'weekly':
        return '每周';
      default:
        return '自定义';
    }
  }

  Future<void> _completeWorkout(BuildContext context) async {
    await context.read<WorkoutLogProvider>().addLog(
      planId: plan.id,
      workoutType: plan.workoutType,
      durationMinutes: plan.durationMinutes,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('运动已完成！')),
      );
    }
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('编辑'),
            onTap: () {
              Navigator.pop(context);
              // 编辑逻辑
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: AppColors.error),
            title: const Text('删除', style: TextStyle(color: AppColors.error)),
            onTap: () {
              Navigator.pop(context);
              context.read<WorkoutPlanProvider>().deletePlan(plan.id);
            },
          ),
        ],
      ),
    );
  }
}
