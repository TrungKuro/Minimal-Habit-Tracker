import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:minimal_habit_tracker/models/app_settings.dart';
import 'package:minimal_habit_tracker/models/habit.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  /* ------------------------------ Biến tĩnh ------------------------------ */

  static late Isar isar;

  /* -------------------------------- SETUP -------------------------------- */

  /// Khởi tạo Database
  static Future<void> initialize() async {
    // Đường dẫn được ứng dụng tạo riêng cho dữ liệu người dùng tạo
    final dir = await getApplicationDocumentsDirectory();
    // Cung cấp các thông tin cho Isar Database
    isar = await Isar.open(
      // Thông tin các bộ sưu tập, gồm "Habit" và "AppSettings"
      [HabitSchema, AppSettingsSchema],
      // Đường dẫn lưu dữ liệu của người dùng
      directory: dir.path,
    );
  }

  /// Lưu ngày đầu tiên mà ứng dụng khởi động (cho HeatMap)
  Future<void> saveFirstLaunchDate() async {
    // Tìm đến bộ sưu tập "AppSettings" trong Database ...
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      // ... nếu chưa có thì lấy thông tin thời gian hiện tại ...
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      // ... và lưu mới vào Database
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  /// Lấy dữ liệu ngày đầu tiên mà ứng dụng khởi động (cho HeatMap)
  Future<DateTime?> getFirstLaunchDate() async {
    // Tìm đến bộ sưu tập "AppSettings" trong Database
    final settings = await isar.appSettings.where().findFirst();
    // Trả về thông tin thời gian lần chạy đầu tiên
    return settings?.firstLaunchDate;
  }

  /* --------------------------- CRUDX OPERATIONS -------------------------- */

  /// Danh sách các Habit
  List<Habit> currentHabits = [];

  ///! READ - đọc và lưu những Habit từ Database
  Future<void> readHabits() async {
    // Lấy tất cả danh sách Habit từ Database
    List<Habit> fetchHabits = await isar.habits.where().findAll();
    // Xoá danh sách cũ trên ứng dụng
    currentHabits.clear();
    // Nạp vào danh sách mới trên ứng dụng
    currentHabits.addAll(fetchHabits);
    // Cập nhập UI
    notifyListeners();
  }

  /* ----------------------------------------------------------------------- */

  /// CREATE - thêm 1 Habit
  Future<void> addHabit(String habitName) async {
    // Tạo 1 Habit mới, và lấy thông tin tên Habit
    final newHabit = Habit()..name = habitName;
    // Lưu mới vào Database
    await isar.writeTxn(() => isar.habits.put(newHabit));
    // Đọc lại tất cả từ Database
    readHabits();
  }

  /// UPDATE - kiểm tra Habit đó ON hay OFF
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    // Tìm Habit được chỉ định
    final habit = await isar.habits.get(id);
    if (habit != null) {
      // Nếu Habit đã hoàn thành -> thêm ngày hiện tại vào danh sách các ngày đã hoàn thành của Habit đó
      if (isCompleted) {
        // Chỉ thêm vào nếu dữ liệu thời gian ngày hôm nay chưa có
        if (!habit.completedDays.contains(DateTime.now())) {
          // Lấy thông tin ngày hôm nay
          final today = DateTime.now();
          // Thêm thông tin trên vào Habit này, chỉ lấy ngày/tháng/năm
          habit.completedDays.add(DateTime(
            today.year,
            today.month,
            today.day,
          ));
        }
      }
      // Ngược lại, Habit chưa hoàn thành -> loại bỏ ngày hiện tại khỏi danh sách các ngày đã hoàn thành của Habit đó
      else {
        habit.completedDays.removeWhere((date) =>
            date.year == DateTime.now().year && date.month == DateTime.now().month && date.day == DateTime.now().day);
      }
      // Lưu vào Database, với cập nhập mới
      await isar.writeTxn(() => isar.habits.put(habit));
    }
    // Đọc lại tất cả từ Database
    readHabits();
  }

  /// UPDATE - chỉnh sửa tên của Habit
  Future<void> updateHabitName(int id, String newName) async {
    // Tìm Habit được chỉ định
    final habit = await isar.habits.get(id);
    if (habit != null) {
      // Cập nhập tên mới cho Habit na2y
      habit.name = newName;
      // Lưu vào Database, với cập nhập mới
      await isar.writeTxn(() => isar.habits.put(habit));
    }
    // Đọc lại tất cả từ Database
    readHabits();
  }

  /// DELETE - xoá 1 Habit
  Future<void> deleteHabit(int id) async {
    // Tìm Habit được chỉ định và xoá nó
    await isar.writeTxn(() => isar.habits.delete(id));
    // Đọc lại tất cả từ Database
    readHabits();
  }
}
