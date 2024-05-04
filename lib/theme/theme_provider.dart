import 'package:flutter/material.dart';
import 'package:minimal_habit_tracker/theme/dart_mode.dart';
import 'package:minimal_habit_tracker/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  /* ---------------------------- Biến riêng tư ---------------------------- */

  // Light Mode là chế độ mặc định khi mới khởi động app
  ThemeData _themeData = lightMode;

  /* -------------------------------- Getter ------------------------------- */

  /// Cho biết chế độ chủ đề hiện tại
  ThemeData get themeData => _themeData;

  /// Cho biết có đang là Dark Mode hay ko?
  bool get isDarkMode => _themeData == darkMode;

  /* -------------------------------- Setter ------------------------------- */

  /// Cài đặt chủ đề hiển thị
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    // Cập nhập lại UI
    notifyListeners();
  }

  /* --------------------------------- Hàm --------------------------------- */

  /// Đảo chủ đề đang hiển thị
  void toggleTheme() {
    isDarkMode ? _themeData = lightMode : _themeData = darkMode;
    // Cập nhập lại UI
    notifyListeners();
  }
}
