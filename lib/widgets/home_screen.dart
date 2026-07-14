import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minesweeper_game/data/cell_state.dart';
import 'package:minesweeper_game/data/command.dart';
import 'package:minesweeper_game/data/functions.dart';
import 'package:minesweeper_game/data/game.dart';
import 'package:minesweeper_game/data/game_state.dart';
import 'package:minesweeper_game/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? stTimer;

  final ValueNotifier<Duration> _gameElapsedTime = ValueNotifier<Duration>(
    Duration.zero,
  );
  final ValueNotifier<GameState> _gameStateNotifier = ValueNotifier<GameState>(
    GameState.ready,
  );
  final ValueNotifier<int> _flaggedMinesCounter = ValueNotifier<int>(0);
  final ValueNotifier<int> _minesCounter = ValueNotifier<int>(
    Game().config.mineCount,
  );
  final ValueNotifier<List<ValueNotifier<CellState>>> _cellStates =
      ValueNotifier<List<ValueNotifier<CellState>>>(
        <ValueNotifier<CellState>>[],
      );

  void overrideCellStates() {
    _cellStates.value = List<ValueNotifier<CellState>>.generate(
      Game().board.width * Game().board.height,
      (final int index) => ValueNotifier<CellState>(InitialCellState(index)),
    );
  }

  void removeStopwatchTimer() {
    stTimer?.cancel();
    setState(() {
      stTimer = null;
    });
  }

  void resetCellStates() {
    for (final ValueNotifier<CellState> cellState in _cellStates.value) {
      if (cellState.value.runtimeType != InitialCellState) {
        cellState.value = InitialCellState(cellState.value.index);
      }
    }
  }

  void restartCounters() {
    _gameElapsedTime.value = Duration.zero;
    _flaggedMinesCounter.value = 0;
    _minesCounter.value = Game().config.mineCount;
  }

  void setStopwatchTimer() => stTimer = Timer.periodic(
    const Duration(seconds: 1),
    (_) => _gameElapsedTime.value = Game().stopwatch.elapsed,
  );

  @override
  void initState() {
    super.initState();
    overrideCellStates();

    Game().onChangeCellState = (final CellState newState) {
      if (newState.runtimeType == FlaggedCellState) {
        _flaggedMinesCounter.value++;
      }
      if (newState.runtimeType == InitialCellState) {
        _flaggedMinesCounter.value--;
      }
      _cellStates.value[newState.index].value = newState;
      return;
    };

    Game().onNewGame = () {
      removeStopwatchTimer();
      restartCounters();
      _gameStateNotifier.value = GameState.ready;
      overrideCellStates();
    };

    Game().onStartGame = (final int index) {
      setStopwatchTimer();
      _gameStateNotifier.value = GameState.started;
    };

    Game().onPause = () {
      removeStopwatchTimer();
      _gameStateNotifier.value = GameState.pause;
      unawaited(
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (final BuildContext ctx) => AlertDialog(
            title: const Text('Paused.'),
            content: ElevatedButton(
              onPressed: () {
                Game().executeCommand(ResumeGameCommand());
                Navigator.pop(context);
              },
              child: const Text('Resume'),
            ),
          ),
        ),
      );
    };
    Game().onResume = () {
      setStopwatchTimer();
      _gameStateNotifier.value = GameState.started;
    };
    Game().onGameOver = () {
      _gameStateNotifier.value = GameState.over;
      final Duration gameElapsedTime = Game().stopwatch.elapsed;
      removeStopwatchTimer();
      for (int index in Game().board.mines) {
        _cellStates.value[index].value == ClickedCellState(index);
      }
      unawaited(
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (final BuildContext ctx) => AlertDialog(
            title: const Text('Game Over.'),
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
          ),
        ),
      );
    };
    Game().onVictory = () {
      final Duration gameElapsedTime = Game().stopwatch.elapsed;
      removeStopwatchTimer();
      for (final int index in Game().board.flags) {
        _cellStates.value[index].value = FlaggedCellState(index);
      }
      _gameStateNotifier.value = GameState.over;
      unawaited(
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (final BuildContext ctx) => AlertDialog(
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
          ),
        ),
      );
    };
    Game().onReset = () {
      removeStopwatchTimer();
      restartCounters();
      _gameStateNotifier.value = GameState.reset;
      resetCellStates();
    };
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Center(child: Text('Minesweeper')),
      actions: <Widget>[
        PauseResumeButton(_gameStateNotifier),
        ValueListenableBuilder<GameState>(
          valueListenable: _gameStateNotifier,
          builder:
              (
                final BuildContext context,
                final GameState value,
                final Widget? child,
              ) {
                if (value == GameState.pause || value == GameState.started) {
                  return Tooltip(
                    message: 'Reset game',
                    child: IconButton(
                      onPressed: () =>
                          Game().executeCommand(ResetGameCommand()),
                      icon: const Icon(Icons.refresh),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
        ),
        ValueListenableBuilder<GameState>(
          valueListenable: _gameStateNotifier,
          builder:
              (
                final BuildContext context,
                final GameState value,
                final Widget? child,
              ) {
                if (value == GameState.started ||
                    value == GameState.pause ||
                    value == GameState.reset) {
                  return Tooltip(
                    message: 'New game',
                    child: IconButton(
                      onPressed: () => Game().executeCommand(NewGameCommand()),
                      icon: const Icon(Icons.add),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
        ),
      ],
    ),
    body: Board(cellStates: _cellStates),
    bottomNavigationBar: Material(
      color: Colors.amber,
      child: Row(
        children: <Widget>[
          MinesCounter(
            flaggedMinesCounter: _flaggedMinesCounter,
            totalMinesCounter: _minesCounter,
          ),
          const SizedBox(width: 20),
          StopwatchDisplay(timeNotifier: _gameElapsedTime),
          const Spacer(),
          GameDifficultySelector(),
          IconButton(
            onPressed: () => CustomGameSettingsDialog.show(context),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
    ),
  );
}
