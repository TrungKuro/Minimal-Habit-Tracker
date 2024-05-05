// Given a Habit List of completion days is the Habit completed today
bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any(
    (date) => date.year == today.year && date.month == today.month && date.day == today.day,
  );
}
