import 'package:flutter/material.dart';

class StopwatchDisplay extends StatelessWidget {
  const StopwatchDisplay({required this.timeNotifier, super.key});

  final ValueNotifier<Duration> timeNotifier;

  String formattedTimeText(final Duration time) {
    final int milli = time.inMilliseconds;
    final String seconds = ((milli ~/ 1000) % 60).toString().padLeft(2, '0');
    final String minutes = ((milli ~/ 1000) ~/ 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(final BuildContext context) => ValueListenableBuilder<Duration>(
    valueListenable: timeNotifier,
    builder:
        (
          final BuildContext context,
          final Duration value,
          final Widget? child,
        ) => Text(formattedTimeText(value)),
  );
}
