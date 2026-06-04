# 番茄运动 - 专注与运动管理 App

一款基于 Flutter 开发的番茄钟 + 运动计划管理应用，帮助用户高效管理专注时间和运动计划。

## 功能特性

### 🍅 番茄钟专注
- 环形倒计时器，支持专注 / 短休息 / 长休息自动切换
- 可自定义专注时长、休息时长、长休息间隔
- 支持创建多个专注计划，一键加载计划配置
- 关联任务，记录每个任务的番茄数
- 完成 / 跳过番茄自动记录

### 📋 待办事项
- 首页记事本风格待办列表
- 顶部显示当前星期和日期
- 每行右侧勾选框，点击切换完成状态
- 支持添加、编辑、删除、滑动删除
- 已完成项自动添加删除线

### 🏃 运动计划
- 创建运动计划（跑步、力量、瑜伽、骑行、游泳、散步等）
- 自定义运动时长、频率、时间段
- 一键完成运动打卡，记录运动日志
- 运动数据概览（步数、卡路里、运动时长、心率）

### 📊 统计分析
- 今日专注概览（番茄数、专注时长、完成任务数）
- 本周趋势折线图（fl_chart）
- 运动完成率统计
- 每日数据自动汇总

### ⚙️ 其他功能
- 深色 / 浅色 / 跟随系统主题切换
- 首页下拉刷新，跨天自动刷新数据
- 数据本地持久化（SQLite）
- 预留云同步字段（is_synced）

## 技术架构

```
lib/
├── main.dart                          # 应用入口
├── app.dart                           # MaterialApp + 底部导航
├── core/
│   ├── constants/app_constants.dart   # 枚举与默认常量
│   ├── theme/                         # 颜色、主题
│   └── utils/date_utils.dart          # 日期工具类
├── data/
│   ├── local/
│   │   ├── database.dart              # SQLite 数据库（v3）
│   │   └── dao/                       # 数据访问对象
│   └── models/                        # 数据模型
├── features/
│   ├── dashboard/                     # 首页（概览卡片、待办、计划列表）
│   ├── timer/                         # 番茄钟计时器
│   ├── fitness/                       # 运动计划与健康数据
│   ├── focus_plans/                   # 专注计划管理
│   ├── tasks/                         # 任务管理
│   ├── stats/                         # 统计图表
│   └── settings/                      # 设置页面
└── providers/                         # 状态管理（Provider）
```

### 技术栈

| 类别 | 技术 |
|------|------|
| 框架 | Flutter 3.x |
| 状态管理 | Provider |
| 本地数据库 | sqflite |
| 图表 | fl_chart |
| 健康数据 | health（Google Health Connect / Apple HealthKit） |
| UUID 生成 | uuid |
| 日期格式 | intl |

### 数据库表结构（v3）

| 表名 | 说明 |
|------|------|
| `pomodoro_sessions` | 番茄钟完成记录 |
| `tasks` | 任务列表 |
| `daily_stats` | 每日统计缓存 |
| `workout_plans` | 运动计划 |
| `workout_logs` | 运动完成日志 |
| `focus_plans` | 专注计划 |
| `todos` | 待办事项 |

## 快速开始

### 环境要求

- Flutter SDK >= 3.0
- Dart SDK >= 3.0
- Android Studio / VS Code

### 安装运行

```bash
# 克隆项目
git clone https://github.com/XIAOXINYIHUA/pomodoro-app.git
cd pomodoro-app

# 安装依赖
flutter pub get

# 运行调试
flutter run

# 构建 APK
flutter build apk --release
```

### 构建产物

Release APK 位于：
```
build/app/outputs/flutter-apk/app-release.apk
```

## 底部导航结构

| Tab | 页面 | 功能 |
|-----|------|------|
| 首页 | DashboardScreen | 概览卡片、待办事项、快捷操作、计划列表 |
| 专注 | TimerScreen | 番茄钟计时器、计划选择、任务选择 |
| 运动 | FitnessScreen | 健康数据、运动计划列表、运动打卡 |
| 统计 | StatsScreen | 专注/运动统计、本周趋势图表 |
| 设置 | SettingsScreen | 主题切换、个性化设置 |

## 后续规划

- [ ] 华为 Health Kit 接入（华为设备运动数据同步）
- [ ] 云端数据同步
- [ ] 专注计划详情页
- [ ] 运动计划编辑功能
- [ ] 数据导出（CSV / PDF）
- [ ] 桌面小组件（今日番茄、待办事项）
