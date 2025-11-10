import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/task_bloc.dart';
import '../widgets/add_task_button.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/filter_tabs.dart';
import '../widgets/task_list.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF7F4),
      appBar: AppBar(
        title: const Text(
          'To do list',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF0D3B64),
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskInitial) {
            context.read<TaskBloc>().add(LoadTasksEvent());
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF0D3B64)),
            );
          } else if (state is TaskLoaded) {
            return Column(
              children: [
                FilterTabs(currentFilter: state.currentFilter),
                Expanded(child: TaskList(tasks: state.filteredTasks)),
              ],
            );
          } else if (state is TaskError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TaskBloc>().add(LoadTasksEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: AddTaskButton(
        onPressed: () => _showAddTaskDialog(context),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<TaskBloc>(),
        child: const AddTaskDialog(),
      ),
    );
  }
}
