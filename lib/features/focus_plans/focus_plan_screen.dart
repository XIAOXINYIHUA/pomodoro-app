import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/focus_plan_provider.dart';
import 'focus_plan_card.dart';
import 'focus_plan_form_dialog.dart';

class FocusPlanScreen extends StatefulWidget {
  const FocusPlanScreen({super.key});

  @override
  State<FocusPlanScreen> createState() => _FocusPlanScreenState();
}

class _FocusPlanScreenState extends State<FocusPlanScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FocusPlanProvider>().loadPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('专注计划'),
      ),
      body: Consumer<FocusPlanProvider>(
        builder: (context, planProvider, _) {
          final plans = planProvider.plans;

          if (plans.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.timer_outlined, size: 64, color: AppColors.tomatoRed.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  const Text('暂无专注计划', style: TextStyle(fontSize: 18, color: AppColors.textSecondaryLight)),
                  const SizedBox(height: 8),
                  const Text('点击右下角按钮创建', style: TextStyle(color: AppColors.textSecondaryLight)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: plans.length,
            itemBuilder: (context, index) {
              return FocusPlanCard(plan: plans[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const FocusPlanFormDialog(),
          );
        },
        backgroundColor: AppColors.tomatoRed,
        child: const Icon(Icons.add),
      ),
    );
  }
}
