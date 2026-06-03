import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/task.dart';
import '../../../providers/task_provider.dart';
import 'task_form_dialog.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: AppColors.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('确认删除'),
            content: Text('确定要删除任务"${task.title}"吗？'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('删除')),
            ],
          ),
        );
      },
      onDismissed: (_) {
        context.read<TaskProvider>().deleteTask(task.id);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: _buildStatusIcon(context),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.status == 'done' ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            '${task.pomodoroCount} 番茄${task.estimatedPomodoros != null ? ' / ${task.estimatedPomodoros}' : ''}',
          ),
          trailing: _buildActions(context),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(BuildContext context) {
    IconData icon;
    Color color;

    switch (task.status) {
      case 'todo':
        icon = Icons.circle_outlined;
        color = AppColors.textSecondaryLight;
        break;
      case 'in_progress':
        icon = Icons.play_circle;
        color = AppColors.tomatoRed;
        break;
      case 'done':
        icon = Icons.check_circle;
        color = AppColors.success;
        break;
      default:
        icon = Icons.circle_outlined;
        color = AppColors.textSecondaryLight;
    }

    return IconButton(
      icon: Icon(icon, color: color),
      onPressed: () {
        if (task.status == 'todo') {
          context.read<TaskProvider>().updateTask(
            task.copyWith(status: 'in_progress'),
          );
        } else if (task.status == 'in_progress') {
          context.read<TaskProvider>().completeTask(task.id);
        }
      },
    );
  }

  Widget _buildActions(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'edit', child: Text('编辑')),
        const PopupMenuItem(value: 'delete', child: Text('删除')),
      ],
      onSelected: (value) {
        if (value == 'edit') {
          showDialog(
            context: context,
            builder: (_) => TaskFormDialog(task: task),
          );
        } else if (value == 'delete') {
          context.read<TaskProvider>().deleteTask(task.id);
        }
      },
    );
  }
}
