import 'package:flutter/material.dart';
import 'package:minesweeper_game/data/cell_state.dart';

class Cell extends StatelessWidget {
  const Cell({required this.notifier, super.key});

  final ValueNotifier<CellState> notifier;

  @override
  Widget build(final BuildContext context) => ValueListenableBuilder<CellState>(
    valueListenable: notifier,
    builder:
        (
          final BuildContext context,
          final CellState value,
          final Widget? child,
        ) => SizedBox.square(
          dimension: 30,
          child: GestureDetector(
            onTap: () => notifier.value.click(),
            onSecondaryTap: () => notifier.value.flag(),
            child: Material(
              shape: Border.all(),
              color: Color(notifier.value.color),
              child: Center(
                child: Text(
                  notifier.value.text,
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ),
          ),
        ),
  );
}
