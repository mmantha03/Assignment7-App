import 'package:flutter/material.dart';

import '../models/study_task.dart';

class StudyTaskCard extends StatelessWidget {
  const StudyTaskCard({
    super.key,
    required this.task,
    this.isDragging = false,
  });

  final StudyTask task;
  final bool isDragging;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedScale(
      scale: isDragging ? 1.02 : 1,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      child: Card(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDragging
                  ? colorScheme.primary
                  : Colors.black.withValues(alpha: 0.06),
              width: isDragging ? 3 : 1,
            ),
            color: Colors.white,
            boxShadow: [
              if (isDragging)
                const BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 22,
                  offset: Offset(0, 12),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.school_outlined,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w900,
                                  ),
                        ),
                        Text(
                          '${task.topic} - ${task.minutes} min',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.black54,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.drag_indicator_rounded),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                task.prompt,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.3,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
