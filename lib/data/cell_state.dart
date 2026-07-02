import 'package:minesweeper_game/data/command.dart';
import 'package:minesweeper_game/data/game.dart';

abstract class CellState {
  const CellState(this.index);

  final int index;

  int get color;

  String get text;

  @override
  Type get runtimeType;

  @override
  bool operator ==(final Object other) => runtimeType == other.runtimeType;

  void click() {}

  void flag() {}

  @override
  int get hashCode => Object.hash(runtimeType, color, text);
}

class InitialCellState extends CellState {
  const InitialCellState(super.index);

  @override
  void click() => Game().executeCommand(ClickCellCommand(index));

  @override
  void flag() => Game().executeCommand(ToggleFlagCommand(index));

  @override
  int get color => 0xFFBDBDBD;

  @override
  Type get runtimeType => InitialCellState;

  @override
  String get text => '';
}

class ClickedCellState extends CellState {
  const ClickedCellState(super.index);

  @override
  int get color => Game().board.isMine(index) ? 0xFFE53935 : 0xFF76FF03;

  @override
  Type get runtimeType => ClickedCellState;

  int get neighborMines => Game().board.neighborMinesCount(index);

  @override
  String get text => Game().board.isMine(index)
      ? '💣'
      : neighborMines > 0 ? neighborMines.toString() : '';
}

class FlaggedCellState extends CellState {
  const FlaggedCellState(super.index);

  @override
  void flag() => Game().executeCommand(ToggleFlagCommand(index));

  @override
  int get color => 0xFFFFD54F;

  @override
  Type get runtimeType => FlaggedCellState;

  @override
  String get text => '🚩';
}
