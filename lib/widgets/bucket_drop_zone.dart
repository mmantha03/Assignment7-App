import 'package:flutter/material.dart';

import '../models/study_task.dart';

class BucketDropZone extends StatelessWidget {
  const BucketDropZone({
    super.key,
    required this.bucket,
    required this.tasks,
    required this.onAccept,
  });

  final StudyBucket bucket;
  final List<StudyTask> tasks;
  final ValueChanged<StudyTask> onAccept;

  @override
  Widget build(BuildContext context) {
    return DragTarget<StudyTask>(
      onWillAcceptWithDetails: (_) => true,
      onAcceptWithDetails: (details) => onAccept(details.data),
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        return AnimatedScale(
          scale: isHovering ? 1.02 : 1,
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isHovering
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isHovering
                    ? Theme.of(context).colorScheme.primary
                    : Colors.black.withValues(alpha: 0.08),
                width: isHovering ? 3 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BucketIcon(bucket: bucket),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              bucket.label,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (child, animation) =>
                                ScaleTransition(
                              scale: animation,
                              child: child,
                            ),
                            child: Text(
                              '${tasks.length}',
                              key: ValueKey(tasks.length),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        bucket.message,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.black54,
                            ),
                      ),
                      if (tasks.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: tasks.take(3).map((task) {
                            return Chip(
                              label: Text(task.title),
                              visualDensity: VisualDensity.compact,
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BucketIcon extends StatelessWidget {
  const _BucketIcon({required this.bucket});

  final StudyBucket bucket;

  @override
  Widget build(BuildContext context) {
    final icon = switch (bucket) {
      StudyBucket.confident => Icons.check_circle_outline,
      StudyBucket.practice => Icons.edit_note_rounded,
      StudyBucket.later => Icons.schedule_rounded,
    };

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
