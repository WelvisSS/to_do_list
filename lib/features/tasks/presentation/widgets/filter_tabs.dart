import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/task_bloc.dart';

class FilterTabs extends StatelessWidget {
  final TaskFilter currentFilter;

  const FilterTabs({super.key, required this.currentFilter});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _FilterButton(
              label: 'All',
              isSelected: currentFilter == TaskFilter.all,
              onTap: () {
                context.read<TaskBloc>().add(
                  const FilterTasksEvent(TaskFilter.all),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _FilterButton(
              label: 'pending',
              isSelected: currentFilter == TaskFilter.pending,
              onTap: () {
                context.read<TaskBloc>().add(
                  const FilterTasksEvent(TaskFilter.pending),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _FilterButton(
              label: 'done',
              isSelected: currentFilter == TaskFilter.done,
              onTap: () {
                context.read<TaskBloc>().add(
                  const FilterTasksEvent(TaskFilter.done),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1D6AAF) : const Color(0xFFD8E3E8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF0D3B64),
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
