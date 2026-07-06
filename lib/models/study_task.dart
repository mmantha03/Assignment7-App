enum StudyBucket {
  confident,
  practice,
  later,
}

extension StudyBucketInfo on StudyBucket {
  String get label {
    switch (this) {
      case StudyBucket.confident:
        return 'Confident';
      case StudyBucket.practice:
        return 'Practice';
      case StudyBucket.later:
        return 'Later';
    }
  }

  String get message {
    switch (this) {
      case StudyBucket.confident:
        return 'Ready for a quick review.';
      case StudyBucket.practice:
        return 'Needs another pass.';
      case StudyBucket.later:
        return 'Save for the end.';
    }
  }
}

class StudyTask {
  final int id;
  final String title;
  final String topic;
  final String prompt;
  final int minutes;

  const StudyTask({
    required this.id,
    required this.title,
    required this.topic,
    required this.prompt,
    required this.minutes,
  });
}
