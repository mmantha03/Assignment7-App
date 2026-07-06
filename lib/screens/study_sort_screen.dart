import 'package:flutter/material.dart';

import '../data/study_task_data.dart';
import '../models/study_task.dart';
import '../widgets/bucket_drop_zone.dart';
import '../widgets/progress_header.dart';
import '../widgets/study_task_card.dart';

class StudySortScreen extends StatefulWidget {
  const StudySortScreen({super.key});

  @override
  State<StudySortScreen> createState() => _StudySortScreenState();
}

class _StudySortScreenState extends State<StudySortScreen> {
  late List<StudyTask> remainingTasks;
  final Map<StudyBucket, List<StudyTask>> sortedTasks = {
    StudyBucket.confident: [],
    StudyBucket.practice: [],
    StudyBucket.later: [],
  };
  final List<_SortMove> moveHistory = [];

  String statusMessage = 'Drag a study item into a bucket.';

  @override
  void initState() {
    super.initState();
    remainingTasks = List.of(studyTasks);
  }

  StudyTask? get activeTask =>
      remainingTasks.isEmpty ? null : remainingTasks.first;

  int get sortedCount =>
      sortedTasks.values.fold(0, (total, items) => total + items.length);

  int get totalMinutes => sortedTasks.values
      .expand((items) => items)
      .fold(0, (total, task) => total + task.minutes);

  bool get isComplete => remainingTasks.isEmpty;

  void sortTask(StudyTask task, StudyBucket bucket) {
    if (!remainingTasks.any((item) => item.id == task.id)) {
      return;
    }

    setState(() {
      remainingTasks = remainingTasks
          .where((item) => item.id != task.id)
          .toList();
      sortedTasks[bucket] = [task, ...sortedTasks[bucket]!];
      moveHistory.add(_SortMove(task: task, bucket: bucket));
      statusMessage = '${task.title} moved to ${bucket.label}.';
    });
  }

  void undoLastMove() {
    if (moveHistory.isEmpty) {
      setState(() {
        statusMessage = 'Nothing to undo yet.';
      });
      return;
    }

    final lastMove = moveHistory.removeLast();

    setState(() {
      sortedTasks[lastMove.bucket] = sortedTasks[lastMove.bucket]!
          .where((task) => task.id != lastMove.task.id)
          .toList();
      remainingTasks = [lastMove.task, ...remainingTasks];
      statusMessage = '${lastMove.task.title} moved back.';
    });
  }

  void resetBoard() {
    setState(() {
      remainingTasks = List.of(studyTasks);
      for (final bucket in StudyBucket.values) {
        sortedTasks[bucket] = [];
      }
      moveHistory.clear();
      statusMessage = 'Board reset.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTask = activeTask;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SortStudy'),
        backgroundColor: const Color(0xfff4f0e8),
        actions: [
          IconButton(
            tooltip: 'Undo',
            onPressed: undoLastMove,
            icon: const Icon(Icons.undo_rounded),
          ),
          IconButton(
            tooltip: 'Reset',
            onPressed: resetBoard,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            ProgressHeader(
              sortedCount: sortedCount,
              totalCount: studyTasks.length,
              remainingCount: remainingTasks.length,
              minutes: totalMinutes,
            ),
            const SizedBox(height: 14),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutBack,
                  ),
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: currentTask == null
                  ? CompletionPanel(
                      key: const ValueKey('complete'),
                      confidentCount:
                          sortedTasks[StudyBucket.confident]!.length,
                      practiceCount: sortedTasks[StudyBucket.practice]!.length,
                      laterCount: sortedTasks[StudyBucket.later]!.length,
                      onReset: resetBoard,
                    )
                  : Draggable<StudyTask>(
                      key: ValueKey(currentTask.id),
                      data: currentTask,
                      feedback: Material(
                        color: Colors.transparent,
                        child: Transform.rotate(
                          angle: -0.07,
                          child: Transform.scale(
                            scale: 1.04,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 42,
                              child: StudyTaskCard(
                                task: currentTask,
                                isDragging: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.24,
                        child: StudyTaskCard(task: currentTask),
                      ),
                      child: StudyTaskCard(task: currentTask),
                    ),
            ),
            const SizedBox(height: 14),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    isComplete
                        ? Icons.check_circle_outline
                        : Icons.touch_app_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      statusMessage,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...StudyBucket.values.map(
              (bucket) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: BucketDropZone(
                  bucket: bucket,
                  tasks: sortedTasks[bucket]!,
                  onAccept: (task) => sortTask(task, bucket),
                ),
              ),
            ),
            const SizedBox(height: 4),
            OutlinedButton.icon(
              onPressed: resetBoard,
              icon: const Icon(Icons.restart_alt_rounded),
              label: const Text('Restart'),
            ),
          ],
        ),
      ),
    );
  }
}

class CompletionPanel extends StatelessWidget {
  const CompletionPanel({
    super.key,
    required this.confidentCount,
    required this.practiceCount,
    required this.laterCount,
    required this.onReset,
  });

  final int confidentCount;
  final int practiceCount;
  final int laterCount;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.celebration_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'Study Plan Complete',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Confident: $confidentCount  Practice: $practiceCount  Later: $laterCount',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Start Over'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortMove {
  const _SortMove({
    required this.task,
    required this.bucket,
  });

  final StudyTask task;
  final StudyBucket bucket;
}
