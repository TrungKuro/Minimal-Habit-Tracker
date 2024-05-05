import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:minimal_habit_tracker/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class MyHabitTitle extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;

  const MyHabitTitle({
    super.key,
    required this.text,
    required this.isCompleted,
    required this.onChanged,
    required this.editHabit,
    required this.deleteHabit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 25,
      ),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            // EDIT OPTION
            SlidableAction(
              onPressed: editHabit,
              backgroundColor: Colors.green, //!
              icon: Icons.settings,
              borderRadius: BorderRadius.circular(8),
            ),
            // DELETE OPTION
            SlidableAction(
              onPressed: deleteHabit,
              backgroundColor: Colors.red, //!
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            if (onChanged != null) {
              // Toggle Completion Status
              onChanged!(!isCompleted);
            }
          },
          // HABIT TITLE
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isCompleted ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
            ),
            padding: const EdgeInsets.all(12),
            child: ListTile(
              title: Text(
                text,
                style: TextStyle(
                  color: isCompleted
                      ? (Provider.of<ThemeProvider>(context).isDarkMode ? Colors.black : Colors.white)
                      : Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              leading: Checkbox(
                activeColor: Theme.of(context).colorScheme.primary,
                checkColor: Provider.of<ThemeProvider>(context).isDarkMode ? Colors.black : Colors.white,
                value: isCompleted,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
