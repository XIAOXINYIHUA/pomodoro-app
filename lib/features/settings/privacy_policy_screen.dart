import 'package:flutter/material.dart';
import '../../core/l10n/app_strings.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isZh = AppStrings.isZh;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.privacyPolicy),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isZh ? '隐私政策' : 'Privacy Policy',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isZh ? '最后更新：2025年1月' : 'Last updated: January 2025',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              isZh ? '1. 数据收集' : '1. Data Collection',
              isZh
                  ? '番茄鸡是一款完全离线的应用。所有数据（包括专注记录、运动计划、待办事项等）均存储在您的设备本地，不会上传到任何服务器。'
                  : 'Tomato Chicken is a fully offline app. All data (including focus records, workout plans, to-dos, etc.) is stored locally on your device and is not uploaded to any server.',
            ),
            _buildSection(
              context,
              isZh ? '2. 健康数据' : '2. Health Data',
              isZh
                  ? '如果您授权，本应用会读取系统健康应用（Apple Health / Google Health Connect / 华为运动健康）中的步数、卡路里、心率等数据，仅用于在应用内展示。这些数据不会被存储到应用的数据库中，也不会被传输给第三方。'
                  : 'If you authorize, this app reads steps, calories, heart rate and other data from the system health app (Apple Health / Google Health Connect / Huawei Health) for display purposes only. This data is not stored in the app\'s database and is not transmitted to any third party.',
            ),
            _buildSection(
              context,
              isZh ? '3. 权限使用' : '3. Permissions',
              isZh
                  ? '• 健康数据权限：用于读取步数、运动等健康数据\n• 通知权限：用于番茄钟完成提醒\n• 存储权限：用于数据导出功能\n\n所有权限均为可选，您可以随时在系统设置中关闭。'
                  : '• Health data permission: to read steps, exercise and other health data\n• Notification permission: for pomodoro completion reminders\n• Storage permission: for data export feature\n\nAll permissions are optional and can be disabled at any time in system settings.',
            ),
            _buildSection(
              context,
              isZh ? '4. 第三方服务' : '4. Third-party Services',
              isZh
                  ? '本应用不集成任何第三方分析、广告或数据收集服务。'
                  : 'This app does not integrate any third-party analytics, advertising, or data collection services.',
            ),
            _buildSection(
              context,
              isZh ? '5. 账户与登录' : '5. Account & Login',
              isZh
                  ? '本应用不需要注册账户或登录，所有功能均可直接使用。'
                  : 'This app does not require account registration or login. All features can be used directly.',
            ),
            _buildSection(
              context,
              isZh ? '6. 隐私政策网页' : '6. Privacy Policy Web',
              isZh
                  ? '完整隐私政策请访问：\nhttps://xiaoxinyihua.github.io/pomodoro-app/privacy-policy.html'
                  : 'Full privacy policy: \nhttps://xiaoxinyihua.github.io/pomodoro-app/privacy-policy.html',
            ),
            _buildSection(
              context,
              isZh ? '7. 联系我们' : '7. Contact Us',
              isZh
                  ? '如果您对本隐私政策有任何疑问，请通过以下方式联系我们：\n📧 2806016245@qq.com\n🐙 https://github.com/XIAOXINYIHUA/pomodoro-app/issues'
                  : 'If you have any questions about this privacy policy, please contact us:\n📧 2806016245@qq.com\n🐙 https://github.com/XIAOXINYIHUA/pomodoro-app/issues',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
