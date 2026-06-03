import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/task_provider.dart';
import '../../../providers/timer_provider.dart';

class TaskSelectorSheet extends StatelessWidget {
  const TaskSelectorSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('选择任务', style: Theme.of(context).textTheme.titleLarge),
              TextButton(
                onPressed: () {
                  context.read<TimerProvider>().selectTask(null);
                  Navigator.pop(context);
                },
                child: const Text('清除选择'),
              ),
            ],
          ),
          const Divider(),
          Consumer<TaskProvider>(
            builder: (context, taskProvider, _) {
              final tasks = taskProvider.allTasks
                  .where((t) => t.status != 'done')
                  .toList();

              if (tasks.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: Text('暂无待办任务')),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    leading: Icon(
                      task.status == 'in_progress'
                          ? Icons.play_circle
                          : Icons.circle_outlined,
                      color: task.status == 'in_progress'
                          ? AppColors.tomatoRed
                          : null,
                    ),
                    title: Text(task.title),
                    subtitle: Text('${task.pomodoroCount} 番茄'),
                    onTap: () {
                      context.read<TimerProvider>().selectTask(task.id);
                      Navigator.pop(context);
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
