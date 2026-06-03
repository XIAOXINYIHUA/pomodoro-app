import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class TimerControls extends StatelessWidget {
  final TimerState state;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onReset;
  final VoidCallback onSkip;

  const TimerControls({
    super.key,
    required this.state,
    required this.onStart,
    required this.onPause,
    required this.onReset,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 重置按钮
        if (state != TimerState.idle)
          IconButton(
            onPressed: onReset,
            icon: const Icon(Icons.replay),
            iconSize: 32,
            tooltip: '重置',
          ),

        const SizedBox(width: 24),

        // 主按钮
        _buildMainButton(),

        const SizedBox(width: 24),

        // 跳过按钮
        if (state == TimerState.running || state == TimerState.breakTime)
          IconButton(
            onPressed: onSkip,
            icon: const Icon(Icons.skip_next),
            iconSize: 32,
            tooltip: '跳过',
          ),
      ],
    );
  }

  Widget _buildMainButton() {
    final color = state == TimerState.breakTime
        ? AppColors.fitnessGreen
        : AppColors.tomatoRed;

    IconData icon;
    VoidCallback onPressed;

    switch (state) {
      case TimerState.idle:
        icon = Icons.play_arrow;
        onPressed = onStart;
        break;
      case TimerState.running:
        icon = Icons.pause;
        onPressed = onPause;
        break;
      case TimerState.paused:
        icon = Icons.play_arrow;
        onPressed = onStart;
        break;
      case TimerState.breakTime:
        icon = Icons.pause;
        onPressed = onPause;
        break;
    }

    return GestureDetector(
      onLongPress: () {
        // 长按重置
        onReset();
      },
      child: FloatingActionButton.large(
        onPressed: onPressed,
        backgroundColor: color,
        child: Icon(icon, size: 48),
      ),
    );
  }
}
