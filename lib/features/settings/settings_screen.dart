import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../core/l10n/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/settings_provider.dart';
import 'widgets/settings_section_tile.dart';
import 'privacy_policy_screen.dart';
import 'data_export_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.navSettings)),
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
              _buildLanguageSection(context, settings),
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
      title: AppStrings.settingsPomodoro,
      icon: Icons.timer,
      children: [
        ListTile(
          title: Text(AppStrings.settingsWorkDuration),
          subtitle: Text(AppStrings.durationSubtitle(settings.workDuration)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showDurationPicker(context, AppStrings.settingsWorkDuration, settings.workDuration, (value) {
            settings.setWorkDuration(value);
          }),
        ),
        ListTile(
          title: Text(AppStrings.settingsBreakDuration),
          subtitle: Text(AppStrings.durationSubtitle(settings.breakDuration)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showDurationPicker(context, AppStrings.settingsBreakDuration, settings.breakDuration, (value) {
            settings.setBreakDuration(value);
          }),
        ),
        ListTile(
          title: Text(AppStrings.settingsLongBreakDuration),
          subtitle: Text(AppStrings.durationSubtitle(settings.longBreakDuration)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showDurationPicker(context, AppStrings.settingsLongBreakDuration, settings.longBreakDuration, (value) {
            settings.setLongBreakDuration(value);
          }),
        ),
        ListTile(
          title: Text(AppStrings.settingsLongBreakInterval),
          subtitle: Text(AppStrings.intervalSubtitle(settings.longBreakInterval)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showDurationPicker(context, AppStrings.settingsLongBreakInterval, settings.longBreakInterval, (value) {
            settings.setLongBreakInterval(value);
          }),
        ),
      ],
    );
  }

  Widget _buildWorkoutSection(BuildContext context, SettingsProvider settings) {
    return SettingsSectionTile(
      title: AppStrings.settingsWorkoutGoal,
      icon: Icons.fitness_center,
      children: [
        ListTile(
          title: Text(AppStrings.settingsStepGoal),
          subtitle: Text('${settings.stepGoal} ${AppStrings.stepsUnit}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showNumberPicker(context, AppStrings.settingsStepGoal, settings.stepGoal, (value) {
            settings.setStepGoal(value);
          }),
        ),
        ListTile(
          title: Text(AppStrings.settingsCalorieGoal),
          subtitle: Text('${settings.calorieGoal} kcal'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showNumberPicker(context, AppStrings.settingsCalorieGoal, settings.calorieGoal, (value) {
            settings.setCalorieGoal(value);
          }),
        ),
        ListTile(
          title: Text(AppStrings.settingsWorkoutMinGoal),
          subtitle: Text(AppStrings.durationSubtitle(settings.workoutMinutesGoal)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showNumberPicker(context, AppStrings.settingsWorkoutMinGoal, settings.workoutMinutesGoal, (value) {
            settings.setWorkoutMinutesGoal(value);
          }),
        ),
      ],
    );
  }

  Widget _buildNotificationSection(BuildContext context, SettingsProvider settings) {
    return SettingsSectionTile(
      title: AppStrings.settingsNotification,
      icon: Icons.notifications,
      children: [
        SwitchListTile(
          title: Text(AppStrings.enableNotifications),
          subtitle: Text(AppStrings.notificationDesc),
          value: settings.notificationsEnabled,
          onChanged: (value) => settings.setNotificationsEnabled(value),
          activeColor: AppColors.tomatoRed,
        ),
      ],
    );
  }

  Widget _buildThemeSection(BuildContext context, SettingsProvider settings) {
    return SettingsSectionTile(
      title: AppStrings.settingsTheme,
      icon: Icons.palette,
      children: [
        ListTile(
          title: Text(AppStrings.themeMode),
          subtitle: Text(_getThemeModeName(settings.themeMode)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showThemeModePicker(context, settings),
        ),
      ],
    );
  }

  Widget _buildLanguageSection(BuildContext context, SettingsProvider settings) {
    return SettingsSectionTile(
      title: AppStrings.settingsLanguage,
      icon: Icons.language,
      children: [
        ListTile(
          title: Text(AppStrings.language),
          subtitle: Text(settings.languageCode == 'zh' ? AppStrings.languageZh : AppStrings.languageEn),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showLanguagePicker(context, settings),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return SettingsSectionTile(
      title: AppStrings.settingsAbout,
      icon: Icons.info,
      children: [
        FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snapshot) {
            final info = snapshot.data;
            return ListTile(
              title: Text(AppStrings.version),
              subtitle: Text(info != null ? '${info.version}+${info.buildNumber}' : '...'),
            );
          },
        ),
        ListTile(
          title: Text(AppStrings.privacyPolicy),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.download, color: AppColors.tomatoRed),
          title: Text(AppStrings.isZh ? '数据导出' : 'Export Data'),
          subtitle: Text(AppStrings.isZh ? '导出任务和统计为CSV文件' : 'Export tasks and stats as CSV'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DataExportScreen()),
            );
          },
        ),
        ListTile(
          title: Text(AppStrings.feedback),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Clipboard.setData(const ClipboardData(text: '1722609793@qq.com'));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppStrings.feedbackCopied),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
      ],
    );
  }

  String _getThemeModeName(String mode) {
    switch (mode) {
      case 'light': return AppStrings.themeLight;
      case 'dark': return AppStrings.themeDark;
      default: return AppStrings.themeSystem;
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
            TextButton(onPressed: () => Navigator.pop(context), child: Text(AppStrings.cancel)),
            ElevatedButton(
              onPressed: () {
                onChanged(selectedValue);
                Navigator.pop(context);
              },
              child: Text(AppStrings.confirm),
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
            decoration: InputDecoration(labelText: AppStrings.numberPickerLabel),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(AppStrings.cancel)),
            ElevatedButton(
              onPressed: () {
                final value = int.tryParse(controller.text);
                if (value != null) {
                  onChanged(value);
                }
                Navigator.pop(context);
              },
              child: Text(AppStrings.confirm),
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
          title: Text(AppStrings.themeMode),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text(AppStrings.themeSystem),
                value: 'system',
                groupValue: settings.themeMode,
                onChanged: (value) {
                  settings.setThemeMode(value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: Text(AppStrings.themeLight),
                value: 'light',
                groupValue: settings.themeMode,
                onChanged: (value) {
                  settings.setThemeMode(value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: Text(AppStrings.themeDark),
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

  void _showLanguagePicker(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppStrings.language),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text(AppStrings.languageZh),
                subtitle: const Text('中文'),
                value: 'zh',
                groupValue: settings.languageCode,
                onChanged: (value) {
                  if (value == settings.languageCode) {
                    Navigator.pop(context);
                    return;
                  }
                  settings.setLanguageCode(value!);
                  Navigator.pop(context);
                  _showRestartDialog(context);
                },
              ),
              RadioListTile<String>(
                title: Text(AppStrings.languageEn),
                subtitle: const Text('English'),
                value: 'en',
                groupValue: settings.languageCode,
                onChanged: (value) {
                  if (value == settings.languageCode) {
                    Navigator.pop(context);
                    return;
                  }
                  settings.setLanguageCode(value!);
                  Navigator.pop(context);
                  _showRestartDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRestartDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(AppStrings.restartRequired),
          content: Text(AppStrings.restartDesc),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppStrings.restartLater),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                SystemNavigator.pop();
              },
              child: Text(AppStrings.restartNow),
            ),
          ],
        );
      },
    );
  }
}
