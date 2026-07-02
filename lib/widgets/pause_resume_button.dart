import 'package:flutter/material.dart';
import 'package:minesweeper_game/data/command.dart';
import 'package:minesweeper_game/data/game.dart';
import 'package:minesweeper_game/data/game_state.dart';

class PauseResumeButton extends StatelessWidget {
  const PauseResumeButton(this.notifier, {super.key});

  final ValueNotifier<GameState> notifier;

  @override
  Widget build(final BuildContext context) => ValueListenableBuilder<GameState>(
    valueListenable: notifier,
    builder:
        (
          final BuildContext context,
          final GameState value,
          final Widget? child,
        ) {
          IconData buildIcon() {
            if (value == GameState.started) {
              return Icons.pause;
            } else {
              return Icons.play_arrow;
            }
          }

          if (value == GameState.started || value == GameState.pause) {
            return Tooltip(
              message: value == GameState.started
                  ? 'Pause game'
                  : 'Resume game',
              child: IconButton(
                onPressed: () {
                  if (value == GameState.started) {
                    Game().executeCommand(PauseGameCommand());
                  } else {
                    Game().executeCommand(ResumeGameCommand());
                  }
                },
                icon: Icon(buildIcon()),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
  );
}
