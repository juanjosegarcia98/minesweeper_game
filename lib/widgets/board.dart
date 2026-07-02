import 'package:flutter/material.dart';
import 'package:minesweeper_game/data/cell_state.dart';
import 'package:minesweeper_game/data/game.dart';
import 'package:minesweeper_game/widgets/cell.dart';

class Board extends StatelessWidget {
  const Board({required this.cellStates, super.key});

  final ValueNotifier<List<ValueNotifier<CellState>>> cellStates;

  @override
  Widget build(final BuildContext context) =>
      ValueListenableBuilder<List<ValueNotifier<CellState>>>(
        valueListenable: cellStates,
        builder:
            (
              final BuildContext context,
              final List<ValueNotifier<CellState>> value,
              final Widget? child,
            ) => Center(
              child: Center(
                child: SizedBox(
                  width: 50 * Game().board.width.toDouble(),
                  height: 50 * Game().board.height.toDouble(),
                  child: GridView.count(
                    crossAxisCount: Game().board.width,
                    children: List<Cell>.generate(
                      Game().board.width * Game().board.height,
                      (final int index) => Cell(
                        notifier: cellStates.value[index],
                      ),
                    ),
                  ),
                ),
              ),
            ),
      );
}
