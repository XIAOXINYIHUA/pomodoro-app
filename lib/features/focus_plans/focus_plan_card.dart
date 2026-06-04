import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/focus_plan.dart';
import '../../providers/focus_plan_provider.dart';
import '../../providers/timer_provider.dart';
import '../../providers/navigation_provider.dart';

class FocusPlanCard extends StatelessWidget {
  final FocusPlan plan;

  const FocusPlanCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.tomatoRed.withValues(alpha: 0.1),
          child: const Icon(Icons.timer, color: AppColors.tomatoRed),
        ),
        title: Text(plan.title),
        subtitle: Text(
          '${plan.workDuration}分钟专注 · ${plan.breakDuration}分钟休息'
          '${plan.targetPomodoros != null ? ' · 目标${plan.targetPomodoros}个番茄' : ''}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.play_circle_outline),
              color: AppColors.tomatoRed,
              onPressed: () => _startFocus(context),
              tooltip: '开始专注',
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showOptions(context),
            ),
          ],
        ),
        onTap: () => _startFocus(context),
      ),
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

  void _startFocus(BuildContext context) {
    // 加载计划配置到 TimerProvider
    context.read<TimerProvider>().loadPlanConfig(plan);
    // 跳转到专注 Tab
    context.read<NavigationProvider>().changeTab(1);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('已加载计划「${plan.title}」，点击开始按钮启动')),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('查看详情'),
            subtitle: Text(_getFrequencyText()),
            onTap: () {
              Navigator.pop(ctx);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: AppColors.error),
            title: const Text('删除', style: TextStyle(color: AppColors.error)),
            onTap: () {
              Navigator.pop(ctx);
              context.read<FocusPlanProvider>().deletePlan(plan.id);
            },
          ),
        ],
      ),
    );
  }
}
