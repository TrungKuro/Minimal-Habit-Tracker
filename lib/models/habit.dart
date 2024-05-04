import 'package:isar/isar.dart';

/// Chạy lệnh CMD để tạo file này tự động.
/// Lệnh: dart run build_runner build
part 'habit.g.dart';

@Collection()
class Habit {
  // Habit ID
  Id id = Isar.autoIncrement;

  // Habit Name
  late String name;

  // Completed Days
  List<DateTime> completedDays = [];
}