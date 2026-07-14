import 'package:minesweeper_game/data/cell_state.dart';
import 'package:minesweeper_game/data/difficulty.dart';
import 'package:minesweeper_game/data/game.dart';
import 'package:minesweeper_game/data/game_state.dart';

abstract class Command {
  Game game = Game();

  void execute();
}

class StartGameCommand extends Command {
  StartGameCommand(this.firstClickIndex);

  final int firstClickIndex;

  @override
  void execute() {
    if (game.isReady) {
      game.board.setMines(game.config.mineCount, firstClickIndex);
    }
    game.board.click(
      firstClickIndex,
      (final int index) =>
          game.onChangeCellState?.call(ClickedCellState(index)),
    );
    if (game.isOver) {
      return;
    }
    game.stopwatch.start();
    game.state = GameState.started;
    game.onStartGame?.call(firstClickIndex);
    return;
  }
}

class NewGameCommand extends Command {
  @override
  void execute() {
    game.board.clearClickedAndFlags();
    game.stopwatch
      ..stop()
      ..reset();
    game.state = GameState.ready;
    game.onNewGame?.call();
    return;
  }
}

class PauseGameCommand extends Command {
  @override
  void execute() {
    if (game.isRunning) {
      game.stopwatch.stop();
      game.state = GameState.pause;
      game.onPause?.call();
      return;
    }
  }
}

class ResumeGameCommand extends Command {
  @override
  void execute() {
    if (game.isPaused) {
      game.stopwatch.start();
      game.state = GameState.started;
      game.onResume?.call();
      return;
    }
  }
}

class ResetGameCommand extends Command {
  @override
  void execute() {
    game.board.clearClickedAndFlags();
    game.stopwatch
      ..stop()
      ..reset();
    game.state = GameState.reset;
    game.onReset?.call();
    return;
  }
}

class ClickCellCommand extends Command {
  ClickCellCommand(this.index);

  final int index;

  @override
  void execute() {
    if (game.isReady || game.isReset) {
      game.executeCommand(StartGameCommand(index));
      return;
    }
    if (game.isRunning) {
      game.board.click(
        index,
        (final int index) =>
            game.onChangeCellState?.call(ClickedCellState(index)),
      );
      return;
    }
  }
}

class ToggleFlagCommand extends Command {
  ToggleFlagCommand(this.index);

  final int index;

  @override
  void execute() {
    final bool flag = game.board.toggleFlag(index);
    game.onChangeCellState?.call(
      flag ? FlaggedCellState(index) : InitialCellState(index),
    );
    return;
  }
}

class ChangeDifficultyCommand extends Command {
  ChangeDifficultyCommand(this.newDifficulty);
  final Difficulty newDifficulty;

  @override
  void execute() {
    game.config.difficulty = newDifficulty;
    game.board.width = game.config.boardWidth;
    game.board.height = game.config.boardHeight;
    game.executeCommand(NewGameCommand());
    return;
  }
}

class ChangeCustomGameSettings extends Command {
  ChangeCustomGameSettings({
    required this.width,
    required this.height,
    required this.mines,
  });

  final int width;
  final int height;
  final int mines;

  @override
  void execute() {
    game.config.customWidth = width;
    game.config.customHeight = height;
    game.config.customMineCount = mines;
    if (game.config.difficulty == Difficulty.custom) {
      game.executeCommand(ChangeDifficultyCommand(Difficulty.custom));
    }
    return;
  }
}
