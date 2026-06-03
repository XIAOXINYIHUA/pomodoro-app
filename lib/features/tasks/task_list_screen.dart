import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/task_provider.dart';
import 'widgets/task_card.dart';
import 'widgets/task_form_dialog.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<TaskProvider>().loadTasks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('任务'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => context.read<TaskProvider>().setFilter(value),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('全部')),
              const PopupMenuItem(value: 'todo', child: Text('待做')),
              const PopupMenuItem(value: 'in_progress', child: Text('进行中')),
              const PopupMenuItem(value: 'done', child: Text('已完成')),
            ],
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, _) {
          final tasks = taskProvider.tasks;

          if (tasks.isEmpty) {
            return const Center(child: Text('暂无任务'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return TaskCard(task: tasks[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const TaskFormDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
