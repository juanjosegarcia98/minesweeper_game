import 'dart:io';

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
            onLongPress: Platform.isAndroid
                ? () => notifier.value.flag()
                : null,
            onTap: () => notifier.value.click(),
            onSecondaryTap: () => notifier.value.flag(),
            child: Material(
              shape: Border.all(),
              color: Color(notifier.value.color),
              child: Center(
                child: LayoutBuilder(
                  builder: (_, final BoxConstraints constraints) => Text(
                    notifier.value.text,
                    style: TextStyle(fontSize: constraints.maxWidth / 1.6),
                  ),
                ),
              ),
            ),
          ),
        ),
  );
}
