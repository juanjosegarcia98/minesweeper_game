import 'package:flutter/material.dart';
import 'package:minesweeper_game/data/command.dart';
import 'package:minesweeper_game/data/difficulty.dart';
import 'package:minesweeper_game/data/game.dart';

class GameDifficultySelector extends StatelessWidget {
  const GameDifficultySelector({super.key});

  @override
  Widget build(final BuildContext context) => DropdownButton<Difficulty>(
    value: Game().config.difficulty,
    icon: const Icon(Icons.arrow_downward),
    onChanged: (final Difficulty? value) => Game().executeCommand(
      ChangeDifficultyCommand(value ?? Difficulty.easy),
    ),
    items: Difficulty.values
        .map<DropdownMenuItem<Difficulty>>(
          (final Difficulty value) => DropdownMenuItem<Difficulty>(
            value: value,
            child: Text(value.name),
          ),
        )
        .toList(),
  );
}
