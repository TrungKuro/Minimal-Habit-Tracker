import 'package:minimal_habit_tracker/models/habit.dart';

// Given a Habit List of completion days is the Habit completed today
bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any(
    (date) => date.year == today.year && date.month == today.month && date.day == today.day,
  );
}

// Prepare HeatMap Dataset
Map<DateTime, int> prepareHeatMapDataset(List<Habit> habits) {
  Map<DateTime, int> datasets = {};

  for (var habit in habits) {
    for (var date in habit.completedDays) {
      // Normalize day to avoid time mismatch
      final normalizedDate = DateTime(date.year, date.month, date.day);

      // If the day already exists in the dataset, increment its count
      if (datasets.containsKey(normalizedDate)) {
        datasets[normalizedDate] = datasets[normalizedDate]! + 1;
      }
      // Else initialize it with a count of 1
      else {
        datasets[normalizedDate] = 1;
      }
    }
  }

  return datasets;
}
