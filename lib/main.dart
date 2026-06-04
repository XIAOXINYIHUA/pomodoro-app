import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/timer_provider.dart';
import 'providers/task_provider.dart';
import 'providers/stat_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/health_provider.dart';
import 'providers/workout_plan_provider.dart';
import 'providers/workout_log_provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/focus_plan_provider.dart';

void main() async {
  // 捕获所有未处理的异常
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };

  WidgetsFlutterBinding.ensureInitialized();

  try {
    final settingsProvider = SettingsProvider();
    await settingsProvider.init();

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NavigationProvider()),
          ChangeNotifierProvider(create: (_) => TimerProvider()),
          ChangeNotifierProvider(create: (_) => TaskProvider()),
          ChangeNotifierProvider(create: (_) => StatProvider()),
          ChangeNotifierProvider.value(value: settingsProvider),
          ChangeNotifierProvider(create: (_) => HealthProvider()),
          ChangeNotifierProvider(create: (_) => WorkoutPlanProvider()),
          ChangeNotifierProvider(create: (_) => WorkoutLogProvider()),
          ChangeNotifierProvider(create: (_) => FocusPlanProvider()),
        ],
        child: const PomodoroApp(),
      ),
    );
  } catch (e, stackTrace) {
    debugPrint('Initialization Error: $e');
    debugPrint('Stack trace: $stackTrace');
    // 如果初始化失败，运行一个简单的错误页面
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('应用启动失败', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 8),
              Text('$e', style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    ));
  }
}
