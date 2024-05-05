import 'package:flutter/material.dart';
import 'package:minimal_habit_tracker/components/my_drawer.dart';
import 'package:minimal_habit_tracker/components/my_habit_title.dart';
import 'package:minimal_habit_tracker/components/my_heat_map.dart';
import 'package:minimal_habit_tracker/database/habit_database.dart';
import 'package:minimal_habit_tracker/models/habit.dart';
import 'package:minimal_habit_tracker/util/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /* --------------------------------- Biến -------------------------------- */

  final TextEditingController textController = TextEditingController();

  /* --------------------------------- Hàm --------------------------------- */

  @override
  void initState() {
    // Đọc và hiển thị những Habit có tồn tại khi App khởi động
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

  /// Xử lý tạo Habit mới
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Create a new Habit.',
          ),
        ),
        actions: [
          // SAVE BUTTON
          MaterialButton(
            onPressed: () {
              // Lấy tên Habit mới
              String newHabitName = textController.text;
              // Lưu vào Database
              context.read<HabitDatabase>().addHabit(newHabitName);
              // Quay lại màn hình chính
              Navigator.pop(context);
              // Xoá nội dung trong TextField
              textController.clear();
            },
            child: const Text('Save'),
          ),
          // CANCEL BUTTON
          MaterialButton(
            onPressed: () {
              // Quay lại màn hình chính
              Navigator.pop(context);
              // Xoá nội dung trong TextField
              textController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  /// Kiểm tra Habit đó ON hay OFF
  void checkHabitOnOff(bool? value, Habit habit) {
    // Update Habit completes status
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  /// Edit Habit Box
  void editHabitBox(Habit habit) {
    // Lấy tên hiện tại của Habit cho hiển thị trong TextField
    textController.text = habit.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          // SAVE BUTTON
          MaterialButton(
            onPressed: () {
              // Lấy tên Habit mới
              String newHabitName = textController.text;
              // Lưu vào Database
              context.read<HabitDatabase>().updateHabitName(habit.id, newHabitName);
              // Quay lại màn hình chính
              Navigator.pop(context);
              // Xoá nội dung trong TextField
              textController.clear();
            },
            child: const Text('Save'),
          ),
          // CANCEL BUTTON
          MaterialButton(
            onPressed: () {
              // Quay lại màn hình chính
              Navigator.pop(context);
              // Xoá nội dung trong TextField
              textController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  /// Delete Habit Box
  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure you want to delete?'),
        actions: [
          // DELETE BUTTON
          MaterialButton(
            onPressed: () {
              // Xoá khỏi Database
              context.read<HabitDatabase>().deleteHabit(habit.id);
              // Quay lại màn hình chính
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
          // CANCEL BUTTON
          MaterialButton(
            onPressed: () {
              // Quay lại màn hình chính
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  /* ----------------------------------------------------------------------- */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* ----------------------------- Top App ----------------------------- */
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      /* ----------------------------- Body App ---------------------------- */
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView(
        children: [
          // HEATMAP
          _buildHeatMap(),
          // HABIT LIST
          _buildHabitList(),
        ],
      ),
      /* ---------------------------- Bottom App --------------------------- */
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  /* -------------------------------- Widget ------------------------------- */

  Widget _buildHabitList() {
    // Habit Database
    final habitDatabase = context.watch<HabitDatabase>();

    // Danh sách các Habit hiện có
    List<Habit> currentHabits = habitDatabase.currentHabits;

    // Trả về danh sách các Habit trên UI
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      //
      itemCount: currentHabits.length,
      itemBuilder: (context, index) {
        // Truy cập đến từng Habit trong danh sách
        final habit = currentHabits[index];
        //! use from folder "util"
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);
        // Trả về nội dung UI của Habit
        return MyHabitTitle(
          isCompleted: isCompletedToday,
          text: habit.name,
          onChanged: (value) => checkHabitOnOff(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );
      },
    );
  }

  Widget _buildHeatMap() {
    // Habit Database
    final habitDatabase = context.watch<HabitDatabase>();

    // Current Habit
    List<Habit> currentHabits = habitDatabase.currentHabits;

    // Return HeatMap UI
    return FutureBuilder(
      future: habitDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        // Một khi có dữ liệu tồn tại -> tạo HeatMap
        if (snapshot.hasData) {
          return MyHeatMap(
            startDate: snapshot.data!,
            //! use from folder "util"
            datasets: prepareHeatMapDataset(currentHabits),
          );
        }
        // Xử lý trường hợp khi ko có dữ liệu nào trả về
        else {
          return Container();
        }
      },
    );
  }
}
