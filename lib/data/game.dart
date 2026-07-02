import 'package:minesweeper_game/data/command.dart';
import 'package:minesweeper_game/data/game_board.dart';
import 'package:minesweeper_game/data/game_config.dart';
import 'package:minesweeper_game/data/game_state.dart';

class Game {
  factory Game() => _instance;
  Game._internal() {
    board = GameBoard(config.boardWidth, config.boardHeight);
  }
  static final Game _instance = Game._internal();

  late final GameBoard board;

  final GameConfig config = GameConfig();

  final Stopwatch stopwatch = Stopwatch();

  void Function(int)? onStartGame;
  void Function()? onPause;
  void Function()? onResume;
  void Function()? onNewGame;
  void Function()? onReset;
  void Function()? onGameOver;
  void Function()? onVictory;
  void Function(int)? onClickCell;
  void Function(int, bool)? onToggleFlag;

  GameState state = GameState.ready;

  void executeCommand(final Command command) {
    command.execute();
    return;
  }

  void gameOver() {
    if (isRunning || isReset) {
      stopwatch.stop();
      state = GameState.over;
      onGameOver?.call();
    }
  }

  void victory() {
    if (isRunning) {
      stopwatch.stop();
      board.mines
          .difference(board.flags)
          .forEach(
            (final int index) => executeCommand(ToggleFlagCommand(index)),
          );
      onVictory?.call();
    }
  }

  bool get isRunning => state == GameState.started;

  bool get isPaused => state == GameState.pause;

  bool get isReady => state == GameState.ready;

  bool get isReset => state == GameState.reset;

  bool get isOver => state == GameState.over;
}
