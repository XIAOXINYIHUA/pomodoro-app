import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/focus_plan_provider.dart';

class FocusPlanFormDialog extends StatefulWidget {
  const FocusPlanFormDialog({super.key});

  @override
  State<FocusPlanFormDialog> createState() => _FocusPlanFormDialogState();
}

class _FocusPlanFormDialogState extends State<FocusPlanFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _workDurationController = TextEditingController(text: '25');
  final _breakDurationController = TextEditingController(text: '5');
  final _longBreakDurationController = TextEditingController(text: '15');
  final _longBreakIntervalController = TextEditingController(text: '4');
  final _targetPomodorosController = TextEditingController();

  String _selectedFrequency = 'daily';
  bool _reminderEnabled = false;

  @override
  void dispose() {
    _titleController.dispose();
    _workDurationController.dispose();
    _breakDurationController.dispose();
    _longBreakDurationController.dispose();
    _longBreakIntervalController.dispose();
    _targetPomodorosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('新建专注计划'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: '计划名称'),
                validator: (value) {
                  if (value == null || value.isEmpty) return '请输入计划名称';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _workDurationController,
                decoration: const InputDecoration(labelText: '专注时长（分钟）'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return '请输入时长';
                  if (int.tryParse(value) == null || int.parse(value) <= 0) return '请输入有效数字';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _breakDurationController,
                decoration: const InputDecoration(labelText: '短休息（分钟）'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _longBreakDurationController,
                      decoration: const InputDecoration(labelText: '长休息（分钟）'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _longBreakIntervalController,
                      decoration: const InputDecoration(labelText: '长休息间隔'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _targetPomodorosController,
                decoration: const InputDecoration(labelText: '目标番茄数（可选）'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedFrequency,
                decoration: const InputDecoration(labelText: '频率'),
                items: WorkoutFrequency.values.map((freq) {
                  return DropdownMenuItem(value: freq.name, child: Text(freq.label));
                }).toList(),
                onChanged: (value) => setState(() => _selectedFrequency = value!),
              ),
              const SizedBox(height: 16),

              SwitchListTile(
                title: const Text('开启提醒'),
                value: _reminderEnabled,
                onChanged: (value) => setState(() => _reminderEnabled = value),
                activeThumbColor: AppColors.tomatoRed,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.tomatoRed),
          child: const Text('创建'),
        ),
      ],
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<FocusPlanProvider>().addPlan(
      title: _titleController.text,
      workDuration: int.parse(_workDurationController.text),
      breakDuration: int.tryParse(_breakDurationController.text) ?? 5,
      longBreakDuration: int.tryParse(_longBreakDurationController.text) ?? 15,
      longBreakInterval: int.tryParse(_longBreakIntervalController.text) ?? 4,
      targetPomodoros: int.tryParse(_targetPomodorosController.text),
      frequency: _selectedFrequency,
      reminderEnabled: _reminderEnabled,
    );

    Navigator.pop(context);
  }
}
