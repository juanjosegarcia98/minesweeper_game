import 'package:flutter/material.dart';
import 'package:minesweeper_game/data/functions.dart';

class StopwatchDisplay extends StatelessWidget {
  const StopwatchDisplay({required this.timeNotifier, super.key});

  final ValueNotifier<Duration> timeNotifier;

  @override
  Widget build(final BuildContext context) => ValueListenableBuilder<Duration>(
    valueListenable: timeNotifier,
    builder:
        (
          final BuildContext context,
          final Duration value,
          final Widget? child,
        ) => Text(returnFormattedTimeString(value)),
  );
}
