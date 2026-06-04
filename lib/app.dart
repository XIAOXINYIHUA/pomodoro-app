import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/settings_provider.dart';
import 'providers/navigation_provider.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/timer/timer_screen.dart';
import 'features/fitness/fitness_screen.dart';
import 'features/stats/stats_screen.dart';
import 'features/settings/settings_screen.dart';

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return MaterialApp(
          title: '番茄运动',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.themeMode == 'dark'
              ? ThemeMode.dark
              : settings.themeMode == 'light'
                  ? ThemeMode.light
                  : ThemeMode.system,
          home: const MainScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static const List<Widget> _screens = [
    DashboardScreen(),
    TimerScreen(),
    FitnessScreen(),
    StatsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, nav, _) {
        return Scaffold(
          body: IndexedStack(
            index: nav.currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: nav.currentIndex,
            onTap: (index) => nav.changeTab(index),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
              BottomNavigationBarItem(icon: Icon(Icons.timer), label: '专注'),
              BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: '运动'),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '统计'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: '设置'),
            ],
          ),
        );
      },
    );
  }
}
