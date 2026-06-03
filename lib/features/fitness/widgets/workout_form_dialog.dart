import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/workout_plan_provider.dart';

class WorkoutFormDialog extends StatefulWidget {
  const WorkoutFormDialog({super.key});

  @override
  State<WorkoutFormDialog> createState() => _WorkoutFormDialogState();
}

class _WorkoutFormDialogState extends State<WorkoutFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _durationController = TextEditingController(text: '30');

  String _selectedType = 'running';
  String _selectedFrequency = 'daily';
  bool _reminderEnabled = false;

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('新建运动计划'),
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

              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: '运动类型'),
                items: WorkoutType.values.map((type) {
                  return DropdownMenuItem(value: type.name, child: Text(type.label));
                }).toList(),
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: '时长（分钟）'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return '请输入时长';
                  if (int.tryParse(value) == null) return '请输入有效数字';
                  return null;
                },
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
                activeColor: AppColors.fitnessGreen,
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
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.fitnessGreen),
          child: const Text('创建'),
        ),
      ],
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<WorkoutPlanProvider>().addPlan(
      title: _titleController.text,
      workoutType: _selectedType,
      durationMinutes: int.parse(_durationController.text),
      frequency: _selectedFrequency,
      reminderEnabled: _reminderEnabled,
    );

    Navigator.pop(context);
  }
}
