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

  String rankEmoji(int rank) => switch (rank) {
    1 => '🥇',
    2 => '🥈',
    3 => '🥉',
    _ => '🏅',
  };

  @override
  Widget build(final BuildContext context) {
    late final DateTime now;
    late final int rank;
    late final Difficulty difficulty;
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    late final TextEditingController nameController;

    final bool newRecord = Game().config.checkNewBestTime(gameElapsedTime);

    late final ValueNotifier<bool> saveNotifier;

    if (newRecord) {
      now = DateTime.now();
      difficulty = Game().config.difficulty;
      nameController = TextEditingController();
      saveNotifier = ValueNotifier(false);
      rank =
          Game().config.bestTimes[difficulty]!.lastIndexWhere(
            (final BestTime best) => best.time < gameElapsedTime,
          ) +
          1;
    }

    return AlertDialog(
      title: const Text('You have won!'),
      content: newRecord
          ? SizedBox(
              height: 178,
              child: Column(
                children: <Widget>[
                  const Text('You have made a new time record!'),
                  Text(
                    'Time elapsed: ${returnFormattedTimeString(gameElapsedTime)}',
                  ),
                  Text('Difficulty: ${difficulty.name}'),
                  Text('Rank: #${rank + 1} ${rankEmoji(rank)}'),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Row(
                          children: <Widget>[
                            const Text('Your name:'),
                            const SizedBox(width: 15),
                            SizedBox(
                              width: 100,
                              height: 50,
                              child: ValueListenableBuilder<bool>(
                                valueListenable: saveNotifier,
                                builder: (_, final bool value, _) => TextFormField(
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty || value.length < 3) {
                                      return 'Insert a name with at least 3 characters.';
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: nameController,
                                  readOnly: value,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        ValueListenableBuilder<bool>(
                          valueListenable: saveNotifier,
                          builder: (_, final bool value, _) =>
                              ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateColor.resolveWith(
                                    (_) => value
                                        ? Colors.lightGreenAccent
                                        : Colors.lightBlueAccent,
                                  ),
                                ),
                                onPressed: value
                                    ? null
                                    : () {
                                        if (formKey.currentState?.validate() ??
                                            true) {
                                          Game().config.saveNewRecord(
                                            nameController.value.text,
                                            gameElapsedTime,
                                            now,
                                          );
                                          saveNotifier.value = true;
                                        }
                                      },
                                icon: Icon(value ? Icons.check : Icons.save),
                                label: Text(value ? 'Saved!' : 'Save'),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Text('Time elapsed: ${returnFormattedTimeString(gameElapsedTime)}'),
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
