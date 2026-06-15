import 'package:flutter/material.dart';

/// 轻量级 i18n 方案：根据当前 locale 返回对应字符串
class AppStrings {
  static Locale _locale = const Locale('zh');

  static Locale get locale => _locale;

  static void setLocale(Locale locale) {
    _locale = locale;
  }

  static bool get isZh => _locale.languageCode == 'zh';

  // ==================== 通用 ====================
  static String get appName => isZh ? '番茄鸡' : 'Tomato Chicken';
  static String get cancel => isZh ? '取消' : 'Cancel';
  static String get save => isZh ? '保存' : 'Save';
  static String get delete => isZh ? '删除' : 'Delete';
  static String get edit => isZh ? '编辑' : 'Edit';
  static String get create => isZh ? '创建' : 'Create';
  static String get confirm => isZh ? '确定' : 'OK';
  static String get close => isZh ? '关闭' : 'Close';
  static String get noData => isZh ? '暂无数据' : 'No data';
  static String get loading => isZh ? '加载中...' : 'Loading...';
  static String get viewAll => isZh ? '查看全部' : 'View All';
  static String get target => isZh ? '目标' : 'Target';

  // ==================== 底部导航 ====================
  static String get navHome => isZh ? '首页' : 'Home';
  static String get navFocus => isZh ? '专注' : 'Focus';
  static String get navFitness => isZh ? '运动' : 'Fitness';
  static String get navStats => isZh ? '统计' : 'Stats';
  static String get navSettings => isZh ? '设置' : 'Settings';

  // ==================== 首页 Dashboard ====================
  static String get todoSection => isZh ? '待办事项' : 'To-Do';
  static String get todoEmpty => isZh ? '暂无待办，输入内容添加' : 'No to-dos yet, type to add';
  static String get todoAddHint => isZh ? '添加待办...' : 'Add to-do...';
  static String get todoEditTitle => isZh ? '编辑待办' : 'Edit To-Do';
  static String get todoContent => isZh ? '待办内容' : 'To-do content';

  static String get quickStartFocus => isZh ? '开始专注' : 'Start Focus';
  static String get quickStartWorkout => isZh ? '开始运动' : 'Start Workout';

  static String get focusPlanSection => isZh ? '专注计划' : 'Focus Plans';
  static String get focusPlanEmpty => isZh ? '暂无专注计划，点击 + 创建' : 'No focus plans, tap + to create';

  static String get workoutPlanSection => isZh ? '运动计划' : 'Workout Plans';
  static String get workoutPlanEmpty => isZh ? '暂无运动计划，点击 + 创建' : 'No workout plans, tap + to create';

  static String get todayTasks => isZh ? '今日任务' : 'Today\'s Tasks';

  static String get addFocusPlan => isZh ? '新建专注计划' : 'New Focus Plan';
  static String get addFocusPlanDesc => isZh ? '创建番茄钟专注计划' : 'Create a pomodoro focus plan';
  static String get addWorkoutPlan => isZh ? '新建运动计划' : 'New Workout Plan';
  static String get addWorkoutPlanDesc => isZh ? '创建运动锻炼计划' : 'Create a workout exercise plan';
  static String get editWorkoutPlan => isZh ? '编辑运动计划' : 'Edit Workout Plan';

  // ==================== 番茄钟 Timer ====================
  static String get todayPomodoros => isZh ? '今日番茄' : 'Today\'s Pomodoros';
  static String get currentState => isZh ? '当前状态' : 'Status';
  static String get selectFocusPlan => isZh ? '选择专注计划' : 'Select Focus Plan';
  static String get selectFocusPlanOptional => isZh ? '选择专注计划（可选）' : 'Select Focus Plan (optional)';
  static String get selectTaskOptional => isZh ? '选择任务（可选）' : 'Select Task (optional)';
  static String get selectTask => isZh ? '选择任务' : 'Select Task';
  static String get clearSelection => isZh ? '清除选择' : 'Clear';
  static String get noTodoTasks => isZh ? '暂无待办任务' : 'No pending tasks';
  static String planLoaded(String name) => isZh ? '已加载计划「$name」' : 'Plan "$name" loaded';
  static String planLoadedHint(String name) => isZh ? '已加载计划「$name」，点击开始按钮启动' : 'Plan "$name" loaded, tap start to begin';

  static String get timerIdle => isZh ? '空闲' : 'Idle';
  static String get timerRunning => isZh ? '专注中' : 'Focusing';
  static String get timerPaused => isZh ? '已暂停' : 'Paused';
  static String get timerBreak => isZh ? '休息中' : 'On Break';

  // ==================== 运动 Fitness ====================
  static String get manualRecord => isZh ? '手动记录' : 'Manual Record';
  static String get manualRecordTitle => isZh ? '手动记录运动数据' : 'Manual Workout Data';
  static String get manualRecordButton => isZh ? '手动记录运动' : 'Log Workout Manually';
  static String get manualRecordDesc => isZh ? '没有运动设备？手动输入步数、卡路里等数据' : 'No device? Enter steps, calories manually';
  static String get steps => isZh ? '步数' : 'Steps';
  static String get calories => isZh ? '卡路里' : 'Calories';
  static String get workoutDuration => isZh ? '运动时长' : 'Duration';
  static String get minutes => isZh ? '分钟' : 'min';
  static String get stepsHint => isZh ? '例如：8000' : 'e.g. 8000';
  static String get caloriesHint => isZh ? '例如：200' : 'e.g. 200';
  static String get durationHint => isZh ? '例如：30' : 'e.g. 30';
  static String get workoutDataSaved => isZh ? '运动数据已记录' : 'Workout data saved';
  static String get workoutCompleted => isZh ? '运动已完成！' : 'Workout completed!';
  static String get workoutPlanEmptyShort => isZh ? '暂无运动计划，点击右下角添加' : 'No workout plans, tap + to add';

  static String get healthData => isZh ? '今日健康数据' : 'Today\'s Health Data';
  static String get needAuth => isZh ? '需要授权读取健康数据' : 'Health data access authorization needed';
  static String get authorize => isZh ? '授权' : 'Authorize';
  static String get heartRate => isZh ? '心率' : 'Heart Rate';
  static String get resting => isZh ? '静息' : 'Resting';

  // ==================== 运动计划表单 ====================
  static String get planName => isZh ? '计划名称' : 'Plan Name';
  static String get planNameRequired => isZh ? '请输入计划名称' : 'Please enter plan name';
  static String get workoutType => isZh ? '运动类型' : 'Workout Type';
  static String get duration => isZh ? '时长（分钟）' : 'Duration (min)';
  static String get durationRequired => isZh ? '请输入时长' : 'Please enter duration';
  static String get validNumber => isZh ? '请输入有效数字' : 'Please enter a valid number';
  static String get frequency => isZh ? '频率' : 'Frequency';
  static String get enableReminder => isZh ? '开启提醒' : 'Enable Reminder';

  // ==================== 专注计划表单 ====================
  static String get workDuration => isZh ? '专注时长（分钟）' : 'Focus Duration (min)';
  static String get workDurationRequired => isZh ? '请输入时长' : 'Please enter duration';
  static String get shortBreak => isZh ? '短休息（分钟）' : 'Short Break (min)';
  static String get longBreak => isZh ? '长休息（分钟）' : 'Long Break (min)';
  static String get longBreakInterval => isZh ? '长休息间隔' : 'Long Break Interval';
  static String get targetPomodoros => isZh ? '目标番茄数（可选）' : 'Target Pomodoros (optional)';

  // ==================== 运动详情 ====================
  static String get detailWorkoutType => isZh ? '运动类型' : 'Workout Type';
  static String get detailDuration => isZh ? '时长' : 'Duration';
  static String get detailFrequency => isZh ? '频率' : 'Frequency';
  static String get detailTimeOfDay => isZh ? '时间段' : 'Time of Day';
  static String get detailNotes => isZh ? '备注' : 'Notes';

  // ==================== 统计 Stats ====================
  static String get focusTab => isZh ? '专注' : 'Focus';
  static String get workoutTab => isZh ? '运动' : 'Workout';
  static String get todayFocusOverview => isZh ? '今日专注概览' : 'Today\'s Focus Overview';
  static String get pomodoroCount => isZh ? '番茄数' : 'Pomodoros';
  static String get focusDuration => isZh ? '专注时长' : 'Focus Time';
  static String get completedTasks => isZh ? '完成任务' : 'Tasks Done';
  static String get weekFocusTrend => isZh ? '本周专注趋势（分钟）' : 'Weekly Focus Trend (min)';
  static String get todayWorkoutOverview => isZh ? '今日运动概览' : 'Today\'s Workout Overview';
  static String get weekWorkoutTrend => isZh ? '本周运动趋势' : 'Weekly Workout Trend';
  static String get workoutCompletionRate => isZh ? '运动完成率' : 'Workout Completion Rate';
  static String get planCompleted => isZh ? '计划完成' : 'Plans Done';
  static String get workoutMinutes => isZh ? '运动分钟' : 'Workout Min';
  static String get caloriesLabel => isZh ? '卡路里' : 'Calories';
  static String planCompletion(int completed, int total) =>
      isZh ? '$completed / $total 计划完成' : '$completed / $total plans done';

  // ==================== 任务 Tasks ====================
  static String get taskScreen => isZh ? '任务' : 'Tasks';
  static String get taskAll => isZh ? '全部' : 'All';
  static String get taskTodo => isZh ? '待做' : 'To Do';
  static String get taskInProgress => isZh ? '进行中' : 'In Progress';
  static String get taskDone => isZh ? '已完成' : 'Done';
  static String get noTasks => isZh ? '暂无任务' : 'No tasks';
  static String get newTask => isZh ? '新建任务' : 'New Task';
  static String get editTask => isZh ? '编辑任务' : 'Edit Task';
  static String get taskTitle => isZh ? '任务标题' : 'Task Title';
  static String get taskTitleRequired => isZh ? '请输入任务标题' : 'Please enter task title';
  static String get taskDescription => isZh ? '描述（可选）' : 'Description (optional)';
  static String get estimatedPomodoros => isZh ? '预估番茄数（可选）' : 'Est. Pomodoros (optional)';
  static String get confirmDelete => isZh ? '确认删除' : 'Confirm Delete';
  static String confirmDeleteTask(String title) => isZh ? '确定要删除任务"$title"吗？' : 'Delete task "$title"?';
  static String get pomodoroUnit => isZh ? '番茄' : 'pomodoros';

  // ==================== 专注计划 ====================
  static String get focusPlanScreen => isZh ? '专注计划' : 'Focus Plans';
  static String get focusPlanEmptyScreen => isZh ? '暂无专注计划' : 'No focus plans';
  static String get focusPlanEmptyHint => isZh ? '点击右下角按钮创建' : 'Tap the button below to create';
  static String get startFocus => isZh ? '开始专注' : 'Start Focus';
  static String get viewDetails => isZh ? '查看详情' : 'View Details';
  static String focusPlanSubtitle(int work, int break_) =>
      isZh ? '$work分钟专注 · $break_分钟休息' : '$work min focus · $break_ min break';
  static String get targetPomodoroLabel => isZh ? '目标番茄数' : 'Target Pomodoros';

  // ==================== 运动计划卡片 ====================
  static String get editPlan => isZh ? '编辑' : 'Edit';
  static String get deletePlan => isZh ? '删除' : 'Delete';
  static String workoutPlanSubtitle(int min, String freq) =>
      isZh ? '$min分钟 · $freq' : '$min min · $freq';

  // ==================== 频率 ====================
  static String get freqDaily => isZh ? '每天' : 'Daily';
  static String get freqWeekdays => isZh ? '工作日' : 'Weekdays';
  static String get freqWeekly => isZh ? '每周' : 'Weekly';
  static String get freqCustom => isZh ? '自定义' : 'Custom';

  // ==================== 运动类型 ====================
  static String get typeRunning => isZh ? '跑步' : 'Running';
  static String get typeStrength => isZh ? '力量训练' : 'Strength';
  static String get typeYoga => isZh ? '瑜伽' : 'Yoga';
  static String get typeCycling => isZh ? '骑行' : 'Cycling';
  static String get typeSwimming => isZh ? '游泳' : 'Swimming';
  static String get typeWalking => isZh ? '散步' : 'Walking';
  static String get typeCustom => isZh ? '自定义' : 'Custom';

  // ==================== 时间段 ====================
  static String get timeMorning => isZh ? '早上' : 'Morning';
  static String get timeLunch => isZh ? '中午' : 'Noon';
  static String get timeAfternoon => isZh ? '下午' : 'Afternoon';
  static String get timeEvening => isZh ? '晚上' : 'Evening';

  // ==================== 任务状态 ====================
  static String get statusTodo => isZh ? '待做' : 'To Do';
  static String get statusInProgress => isZh ? '进行中' : 'In Progress';
  static String get statusDone => isZh ? '已完成' : 'Done';

  // ==================== 番茄钟记录状态 ====================
  static String get pomodoroCompleted => isZh ? '已完成' : 'Completed';
  static String get pomodoroInterrupted => isZh ? '中断' : 'Interrupted';
  static String get pomodoroSkipped => isZh ? '跳过' : 'Skipped';

  // ==================== 设置 Settings ====================
  static String get settingsPomodoro => isZh ? '番茄钟设置' : 'Pomodoro Settings';
  static String get settingsWorkDuration => isZh ? '工作时长' : 'Work Duration';
  static String get settingsBreakDuration => isZh ? '休息时长' : 'Break Duration';
  static String get settingsLongBreakDuration => isZh ? '长休息时长' : 'Long Break Duration';
  static String get settingsLongBreakInterval => isZh ? '长休息间隔' : 'Long Break Interval';
  static String intervalSubtitle(int n) => isZh ? '每 $n 个番茄' : 'Every $n pomodoros';
  static String durationSubtitle(int n) => isZh ? '$n 分钟' : '$n min';

  static String get settingsWorkoutGoal => isZh ? '运动目标' : 'Workout Goals';
  static String get settingsStepGoal => isZh ? '每日步数目标' : 'Daily Step Goal';
  static String get settingsCalorieGoal => isZh ? '每日卡路里目标' : 'Daily Calorie Goal';
  static String get settingsWorkoutMinGoal => isZh ? '每日运动时长目标' : 'Daily Workout Duration Goal';
  static String get stepsUnit => isZh ? '步' : 'steps';

  static String get settingsNotification => isZh ? '通知设置' : 'Notifications';
  static String get enableNotifications => isZh ? '启用通知' : 'Enable Notifications';
  static String get notificationDesc => isZh ? '番茄结束、运动提醒等' : 'Pomodoro end, workout reminders, etc.';

  static String get settingsTheme => isZh ? '主题设置' : 'Theme';
  static String get themeMode => isZh ? '主题模式' : 'Theme Mode';
  static String get themeSystem => isZh ? '跟随系统' : 'System';
  static String get themeLight => isZh ? '浅色' : 'Light';
  static String get themeDark => isZh ? '深色' : 'Dark';

  static String get settingsLanguage => isZh ? '语言设置' : 'Language';
  static String get language => isZh ? '语言' : 'Language';
  static String get languageZh => isZh ? '中文' : 'Chinese';
  static String get languageEn => isZh ? '英文' : 'English';
  static String get restartRequired => isZh ? '需要重启' : 'Restart Required';
  static String get restartDesc => isZh ? '语言已切换，需要重启应用才能生效。是否立即重启？' : 'Language changed. The app needs to restart to apply. Restart now?';
  static String get restartNow => isZh ? '立即重启' : 'Restart Now';
  static String get restartLater => isZh ? '稍后重启' : 'Later';

  static String get settingsAbout => isZh ? '关于' : 'About';
  static String get version => isZh ? '版本' : 'Version';
  static String get privacyPolicy => isZh ? '隐私政策' : 'Privacy Policy';
  static String get feedback => isZh ? '意见反馈' : 'Feedback';
  static String get feedbackCopied => isZh ? '邮箱地址已复制到剪贴板：2806016245@qq.com' : 'Email copied: 2806016245@qq.com';

  // ==================== 对话框 ====================
  static String get durationPickerTitle => isZh ? '时长' : 'Duration';
  static String get numberPickerLabel => isZh ? '数值' : 'Value';

  // ==================== 错误页面 ====================
  static String get appStartFailed => isZh ? '应用启动失败' : 'App launch failed';

  // ==================== 日期 ====================
  static String weekdayName(int weekday) {
    const zh = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    const en = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return isZh ? zh[weekday - 1] : en[weekday - 1];
  }

  static String weekdayShort(int weekday) {
    const zh = ['一', '二', '三', '四', '五', '六', '日'];
    const en = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return isZh ? zh[weekday - 1] : en[weekday - 1];
  }

  static String formatDate(int month, int day, int weekday) {
    final w = weekdayName(weekday);
    return isZh ? '$month月$day日 $w' : '$w, $month/$day';
  }

  static String formatDateShort(int month, int day) {
    return isZh ? '$month月$day日' : '$month/$day';
  }

  static String formatDurationHours(int seconds) {
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours;
    final mins = duration.inMinutes.remainder(60);
    if (isZh) {
      if (hours > 0) return '$hours小时$mins分钟';
      return '$mins分钟';
    } else {
      if (hours > 0) return '${hours}h ${mins}m';
      return '${mins}m';
    }
  }

  static String formatMinutesLabel(int minutes) {
    return isZh ? '$minutes 分钟' : '$minutes min';
  }

  // ==================== 健康数据 ====================
  static String get distance => isZh ? '距离' : 'Distance';
  static String get floors => isZh ? '楼层' : 'Floors';
  static String get sleep => isZh ? '睡眠' : 'Sleep';
  static String get bloodOxygen => isZh ? '血氧' : 'Blood Oxygen';
  static String get weight => isZh ? '体重' : 'Weight';
  static String get dataSource => isZh ? '数据来源' : 'Data Source';
  static String get dataSourceDesc => isZh ? '数据来自以下已连接的健康应用' : 'Data synced from connected health apps';
  static String get noHealthData => isZh ? '暂无健康数据' : 'No health data';
  static String get healthDataTip => isZh ? '请在系统健康应用中授权数据访问' : 'Please authorize data access in your system health app';
  static String get healthServiceUnavailable => isZh
      ? '健康数据自动读取不可用（您的设备可能不支持 Google Health Connect，华为设备后续将支持华为运动健康接入）。请使用下方「手动记录运动」功能。'
      : 'Automatic health data reading is unavailable (your device may not support Google Health Connect). Please use "Log Workout Manually" below.';
  static String get healthAuthDenied => isZh ? '健康数据授权被拒绝' : 'Health data authorization denied';
  static String get connectedApps => isZh ? '已连接应用' : 'Connected Apps';
  static String formatKm(double km) => isZh ? '${km.toStringAsFixed(1)} 公里' : '${km.toStringAsFixed(1)} km';
  static String formatFloors(int f) => isZh ? '$f 层' : '$f floors';
  static String formatSleepHours(double h) => isZh ? '${h.toStringAsFixed(1)} 小时' : '${h.toStringAsFixed(1)} hrs';
  static String formatBpOxygen(double v) => '${v.toStringAsFixed(0)}%';
  static String formatWeight(double kg) => isZh ? '${kg.toStringAsFixed(1)} kg' : '${kg.toStringAsFixed(1)} kg';
}
