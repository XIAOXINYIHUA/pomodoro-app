import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/task.dart';
import '../../../providers/task_provider.dart';

class TaskFormDialog extends StatefulWidget {
  final Task? task;

  const TaskFormDialog({super.key, this.task});

  @override
  State<TaskFormDialog> createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _estimatedPomodorosController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _estimatedPomodorosController = TextEditingController(
      text: widget.task?.estimatedPomodoros?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _estimatedPomodorosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? '新建任务' : '编辑任务'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: '任务标题'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入任务标题';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: '描述（可选）'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _estimatedPomodorosController,
              decoration: const InputDecoration(labelText: '预估番茄数（可选）'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('保存'),
        ),
      ],
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final taskProvider = context.read<TaskProvider>();
    final title = _titleController.text;
    final description = _descriptionController.text.isEmpty ? null : _descriptionController.text;
    final estimatedPomodoros = _estimatedPomodorosController.text.isEmpty
        ? null
        : int.tryParse(_estimatedPomodorosController.text);

    if (widget.task == null) {
      taskProvider.addTask(
        title,
        description: description,
        estimatedPomodoros: estimatedPomodoros,
      );
    } else {
      taskProvider.updateTask(
        widget.task!.copyWith(
          title: title,
          description: description,
          estimatedPomodoros: estimatedPomodoros,
        ),
      );
    }

    Navigator.pop(context);
  }
}
