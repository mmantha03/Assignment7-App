import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sortstudy/data/study_task_data.dart';
import 'package:sortstudy/main.dart';
import 'package:sortstudy/models/study_task.dart';

void main() {
  test('sample task list has at least five items', () {
    expect(studyTasks.length, greaterThanOrEqualTo(5));
  });

  test('bucket labels describe the sort choices', () {
    expect(StudyBucket.confident.label, 'Confident');
    expect(StudyBucket.practice.label, 'Practice');
    expect(StudyBucket.later.label, 'Later');
  });

  testWidgets('app shows the first task and reset action', (tester) async {
    tester.view.physicalSize = const Size(430, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const SortStudyApp());
    await tester.pumpAndSettle();

    expect(find.text('SortStudy'), findsWidgets);
    expect(find.text('Flutter Layouts'), findsOneWidget);
    expect(find.text('Confident'), findsOneWidget);
    expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
  });
}
