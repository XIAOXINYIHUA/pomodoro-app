import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/settings_provider.dart';
import 'widgets/settings_section_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return ListView(
            children: [
              _buildPomodoroSection(context, settings),
              const Divider(),
              _buildWorkoutSection(context, settings),
              const Divider(),
              _buildNotificationSection(context, settings),
              const Divider(),
              _buildThemeSection(context, settings),
              const Divider(),
              _buildAboutSection(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPomodoroSection(BuildContext context, SettingsProvider settings) {
    return SettingsSectionTile(
      title: '番茄钟设置',
      icon: Icons.timer,
      children: [
        ListTile(
          title: const Text('工作时长'),
          subtitle: Text('${settings.workDuration} 分钟'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showDurationPicker(context, '工作时长', settings.workDuration, (value) {
            settings.setWorkDuration(value);
          }),
        ),
        ListTile(
          title: const Text('休息时长'),
          subtitle: Text('${settings.breakDuration} 分钟'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showDurationPicker(context, '休息时长', settings.breakDuration, (value) {
            settings.setBreakDuration(value);
          }),
        ),
        ListTile(
          title: const Text('长休息时长'),
          subtitle: Text('${settings.longBreakDuration} 分钟'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showDurationPicker(context, '长休息时长', settings.longBreakDuration, (value) {
            settings.setLongBreakDuration(value);
          }),
        ),
        ListTile(
          title: const Text('长休息间隔'),
          subtitle: Text('每 ${settings.longBreakInterval} 个番茄'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showDurationPicker(context, '长休息间隔', settings.longBreakInterval, (value) {
            settings.setLongBreakInterval(value);
          }),
        ),
      ],
    );
  }

  Widget _buildWorkoutSection(BuildContext context, SettingsProvider settings) {
    return SettingsSectionTile(
      title: '运动目标',
      icon: Icons.fitness_center,
      children: [
        ListTile(
          title: const Text('每日步数目标'),
          subtitle: Text('${settings.stepGoal} 步'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showNumberPicker(context, '每日步数目标', settings.stepGoal, (value) {
            settings.setStepGoal(value);
          }),
        ),
        ListTile(
          title: const Text('每日卡路里目标'),
          subtitle: Text('${settings.calorieGoal} kcal'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showNumberPicker(context, '每日卡路里目标', settings.calorieGoal, (value) {
            settings.setCalorieGoal(value);
          }),
        ),
        ListTile(
          title: const Text('每日运动时长目标'),
          subtitle: Text('${settings.workoutMinutesGoal} 分钟'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showNumberPicker(context, '每日运动时长目标', settings.workoutMinutesGoal, (value) {
            settings.setWorkoutMinutesGoal(value);
          }),
        ),
      ],
    );
  }

  Widget _buildNotificationSection(BuildContext context, SettingsProvider settings) {
    return SettingsSectionTile(
      title: '通知设置',
      icon: Icons.notifications,
      children: [
        SwitchListTile(
          title: const Text('启用通知'),
          subtitle: const Text('番茄结束、运动提醒等'),
          value: settings.notificationsEnabled,
          onChanged: (value) => settings.setNotificationsEnabled(value),
          activeColor: AppColors.tomatoRed,
        ),
      ],
    );
  }

  Widget _buildThemeSection(BuildContext context, SettingsProvider settings) {
    return SettingsSectionTile(
      title: '主题设置',
      icon: Icons.palette,
      children: [
        ListTile(
          title: const Text('主题模式'),
          subtitle: Text(_getThemeModeName(settings.themeMode)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showThemeModePicker(context, settings),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return SettingsSectionTile(
      title: '关于',
      icon: Icons.info,
      children: [
        const ListTile(
          title: Text('版本'),
          subtitle: Text('1.0.0'),
        ),
        ListTile(
          title: const Text('隐私政策'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        ListTile(
          title: const Text('意见反馈'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
      ],
    );
  }

  String _getThemeModeName(String mode) {
    switch (mode) {
      case 'light': return '浅色';
      case 'dark': return '深色';
      default: return '跟随系统';
    }
  }

  void _showDurationPicker(BuildContext context, String title, int currentValue, Function(int) onChanged) {
    showDialog(
      context: context,
      builder: (context) {
        int selectedValue = currentValue;
        return AlertDialog(
          title: Text(title),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (selectedValue > 1) {
                        setState(() => selectedValue--);
                      }
                    },
                  ),
                  Text('$selectedValue', style: const TextStyle(fontSize: 24)),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() => selectedValue++);
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
            ElevatedButton(
              onPressed: () {
                onChanged(selectedValue);
                Navigator.pop(context);
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  void _showNumberPicker(BuildContext context, String title, int currentValue, Function(int) onChanged) {
    final controller = TextEditingController(text: currentValue.toString());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: '数值'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
            ElevatedButton(
              onPressed: () {
                final value = int.tryParse(controller.text);
                if (value != null) {
                  onChanged(value);
                }
                Navigator.pop(context);
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  void _showThemeModePicker(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('主题模式'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('跟随系统'),
                value: 'system',
                groupValue: settings.themeMode,
                onChanged: (value) {
                  settings.setThemeMode(value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('浅色'),
                value: 'light',
                groupValue: settings.themeMode,
                onChanged: (value) {
                  settings.setThemeMode(value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('深色'),
                value: 'dark',
                groupValue: settings.themeMode,
                onChanged: (value) {
                  settings.setThemeMode(value!);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
