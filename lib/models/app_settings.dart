import 'package:isar/isar.dart';

/// Chạy lệnh CMD để tạo file này tự động.
/// Lệnh: dart run build_runner build
part 'app_settings.g.dart';

@Collection()
class AppSettings {
  // AppSettings ID
  Id id = Isar.autoIncrement;

  DateTime? firstLaunchDate;
}