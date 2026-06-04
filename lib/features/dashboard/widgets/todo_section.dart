import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/todo_item.dart';
import '../../../providers/todo_provider.dart';

class TodoSection extends StatefulWidget {
  const TodoSection({super.key});

  @override
  State<TodoSection> createState() => _TodoSectionState();
}

class _TodoSectionState extends State<TodoSection> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = '${AppDateUtils.getWeekdayName(now.weekday)} · ${now.month}月${now.day}日';

    return Consumer<TodoProvider>(
      builder: (context, todoProvider, _) {
        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 顶部：标题 + 日期
                Row(
                  children: [
                    const Icon(Icons.edit_note, color: AppColors.warmOrange, size: 24),
                    const SizedBox(width: 8),
                    Text('待办事项', style: Theme.of(context).textTheme.titleMedium),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.warmOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        dateStr,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.warmOrange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 待办列表
                if (todoProvider.todos.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Text(
                        '暂无待办，输入内容添加',
                        style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 13),
                      ),
                    ),
                  )
                else
                  ...todoProvider.todos.map((todo) => _buildTodoItem(context, todo, todoProvider)),

                const Divider(height: 24),

                // 底部输入框
                _buildInputField(context, todoProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTodoItem(BuildContext context, TodoItem todo, TodoProvider provider) {
    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => provider.deleteTodo(todo.id),
      child: InkWell(
        onLongPress: () => _showEditDeleteSheet(context, todo, provider),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              // 左侧序号指示
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: todo.isDone ? AppColors.success : AppColors.warmOrange,
                  shape: BoxShape.circle,
                ),
              ),
              // 待办文字
              Expanded(
                child: Text(
                  todo.title,
                  style: TextStyle(
                    fontSize: 15,
                    decoration: todo.isDone ? TextDecoration.lineThrough : null,
                    color: todo.isDone ? AppColors.textSecondaryLight : null,
                  ),
                ),
              ),
              // 右侧勾选框
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: todo.isDone,
                  onChanged: (_) => provider.toggleDone(todo.id),
                  activeColor: AppColors.success,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  side: BorderSide(color: AppColors.textSecondaryLight.withOpacity(0.5)),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(BuildContext context, TodoProvider provider) {
    return Row(
      children: [
        const Icon(Icons.add_circle_outline, color: AppColors.warmOrange, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: '添加待办...',
              hintStyle: TextStyle(fontSize: 14),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
            style: const TextStyle(fontSize: 14),
            textInputAction: TextInputAction.done,
            onSubmitted: (value) => _addTodo(provider),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send, size: 20),
          color: AppColors.warmOrange,
          onPressed: () => _addTodo(provider),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
      ],
    );
  }

  void _addTodo(TodoProvider provider) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    provider.addTodo(text);
    _controller.clear();
  }

  void _showEditDeleteSheet(BuildContext context, TodoItem todo, TodoProvider provider) {
    final editController = TextEditingController(text: todo.title);

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('编辑待办', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: editController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '待办内容',
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      provider.deleteTodo(todo.id);
                    },
                    icon: const Icon(Icons.delete_outline, color: AppColors.error),
                    label: const Text('删除', style: TextStyle(color: AppColors.error)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final newText = editController.text.trim();
                      if (newText.isNotEmpty && newText != todo.title) {
                        provider.updateTodo(todo.copyWith(title: newText));
                      }
                      Navigator.pop(ctx);
                    },
                    child: const Text('保存'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
