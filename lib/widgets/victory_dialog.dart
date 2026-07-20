import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minesweeper_game/data/command.dart';
import 'package:minesweeper_game/data/difficulty.dart';
import 'package:minesweeper_game/data/functions.dart';
import 'package:minesweeper_game/data/game.dart';
import 'package:minesweeper_game/data/game_config.dart';

class VictoryDialog extends StatelessWidget {
  const VictoryDialog({
    required this.gameElapsedTime,
    required this.context,
    super.key,
  });

  static void show(
    final BuildContext context,
    final Duration gameElapsedTime,
  ) => unawaited(
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (final BuildContext ctx) =>
          VictoryDialog(gameElapsedTime: gameElapsedTime, context: context),
    ),
  );

  final Duration gameElapsedTime;
  final BuildContext context;

  @override
  Widget build(final BuildContext context) {
    int rank;
    TextEditingController nameController;

    final bool newRecord = Game().config.checkNewBestTime(gameElapsedTime);

    if (newRecord) {
      rank =
          Game().config.bestTimes[Game().config.difficulty]!.lastIndexWhere(
            (best) => best.time < gameElapsedTime,
          ) +
          1;
    }

    return AlertDialog(
      title: const Text('You have won!'),
      content: Text(
        'Time elapsed: ${returnFormattedTimeString(gameElapsedTime)}',
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Game().executeCommand(NewGameCommand());
            Navigator.pop(context);
          },
          child: const Text('New Game'),
        ),
        ElevatedButton(
          onPressed: () {
            Game().executeCommand(ResetGameCommand());
            Navigator.pop(context);
          },
          child: const Text('Reset Game'),
        ),
      ],
    );
  }
}
