import 'package:flutter/material.dart';
import 'package:minesweeper_game/data/difficulty.dart';
import 'package:minesweeper_game/data/game.dart';
import 'package:minesweeper_game/data/game_config.dart';
import 'package:minesweeper_game/widgets/best_times_content.dart';

class BestTimesDialog extends StatelessWidget {
  const BestTimesDialog({super.key});

  static void show(final BuildContext context) => showDialog(
    context: context,
    builder: (final BuildContext context) => const BestTimesDialog(),
  );

  @override
  Widget build(final BuildContext context) {
    final Map<Difficulty, List<BestTime>> bestTimes = Game().config.bestTimes;

    return AlertDialog(
      title: const Text('Best times'),
      content: SizedBox(height: 300,child: BestTimesContent()),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
