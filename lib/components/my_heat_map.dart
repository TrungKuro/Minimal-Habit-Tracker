import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {
  final DateTime startDate;
  final Map<DateTime, int> datasets;

  const MyHeatMap({
    super.key,
    required this.startDate,
    required this.datasets,
  });

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      startDate: startDate,
      endDate: DateTime.now(),
      datasets: datasets,
      colorMode: ColorMode.color,
      defaultColor: Theme.of(context).colorScheme.secondary,
      textColor: Theme.of(context).colorScheme.inversePrimary,
      showColorTip: false,
      showText: true,
      scrollable: true,
      size: 30,
      colorsets: {
        1: Colors.amber.shade100,
        2: Colors.amber.shade200,
        3: Colors.amber.shade300,
        4: Colors.amber.shade400,
        5: Colors.amber.shade500,
        6: Colors.amber.shade600,
        7: Colors.amber.shade700,
        8: Colors.amber.shade800,
        9: Colors.amber.shade900,
      },
    );
  }
}
