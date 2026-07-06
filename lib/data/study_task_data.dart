import '../models/study_task.dart';

const List<StudyTask> studyTasks = [
  StudyTask(
    id: 1,
    title: 'Flutter Layouts',
    topic: 'UI',
    prompt: 'Compare Row, Column, Stack, and ListView.',
    minutes: 12,
  ),
  StudyTask(
    id: 2,
    title: 'State Changes',
    topic: 'State',
    prompt: 'Explain how setState updates the screen.',
    minutes: 10,
  ),
  StudyTask(
    id: 3,
    title: 'GestureDetector',
    topic: 'Gestures',
    prompt: 'Name three gestures a widget can listen for.',
    minutes: 8,
  ),
  StudyTask(
    id: 4,
    title: 'Animations',
    topic: 'Motion',
    prompt: 'Describe when to use AnimatedContainer.',
    minutes: 9,
  ),
  StudyTask(
    id: 5,
    title: 'Navigation',
    topic: 'Screens',
    prompt: 'Review push, pop, and passing data.',
    minutes: 7,
  ),
  StudyTask(
    id: 6,
    title: 'Reusable Widgets',
    topic: 'Structure',
    prompt: 'Decide when a UI piece should become a widget.',
    minutes: 11,
  ),
];
