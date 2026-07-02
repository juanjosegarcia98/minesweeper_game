import 'package:minesweeper_game/data/functions.dart';
import 'package:minesweeper_game/data/game.dart';

class GameBoard {
  GameBoard(this.width, this.height);

  int width;
  int height;
  Set<int> mines = <int>{};
  Set<int> flags = <int>{};
  Set<int> clicked = <int>{};
  int get flagsCount => flags.length;
  int get cellCount => width * height;

  void clearClickedAndFlags() {
    clicked = <int>{};
    flags = <int>{};
  }

  void setMines(final int count, final int firstClickIndex) {
    mines = randomInts(
      min: 0,
      max: (width * height) - 1,
      count: count,
      excludeNumbers: <int>{
        ...getNeighborCells(firstClickIndex),
        firstClickIndex,
      },
    );
  }

  void click(final int index, final void Function(int) onClick) {
    if (isClicked(index) || hasFlag(index)) {
      return;
    }

    if (isMine(index)) {
      clicked
        ..addAll(mines)
        ..forEach(onClick);
      Game().gameOver();
      return;
    }

    clicked.add(index);

    if (!hasNeighborMines(index)) {
      getNeighborCells(index).forEach((final int c) => click(c, onClick));
    }

    onClick(index);

    final int cells = width * height;
    final int clickedAndFlags = clicked.length + flags.length;
    final int remainingCells = cells - clickedAndFlags;
    final int minesMinusFlags = mines.length - flags.length;

    if (remainingCells == minesMinusFlags) {
      flags.addAll(mines.difference(flags));
      Game().victory();
      return;
    }
  }

  bool toggleFlag(final int index) {
    if (hasFlag(index)) {
      flags.remove(index);
      return false;
    } else {
      flags.add(index);
      return true;
    }
  }

  int r(final int i) => i ~/ width;
  int c(final int i) => i % width;

  Set<int> getNeighborCells(final int index) {
    final Set<int> neighborCells = <int>{};

    final List<int Function(int)> funcs = <int Function(int)>[
      (final int i) => r(i) == 0 || c(i) == 0 ? -1 : i - (width + 1),
      (final int i) => r(i) == 0 ? -1 : i - width,
      (final int i) => r(i) == 0 || c(i) == width - 1 ? -1 : i - (width - 1),
      (final int i) => c(i) == 0 ? -1 : i - 1,
      (final int i) => c(i) == width - 1 ? -1 : i + 1,
      (final int i) => r(i) == height - 1 || c(i) == 0 ? -1 : i + (width - 1),
      (final int i) => r(i) == height - 1 ? -1 : i + width,
      (final int i) =>
          r(i) == height - 1 || c(i) == width - 1 ? -1 : i + (width + 1),
    ];

    for (int Function(int) fun in funcs) {
      final int cellIndex = fun(index);
      if (cellIndex >= 0) {
        neighborCells.add(cellIndex);
      }
    }

    return neighborCells;
  }

  int neighborMinesCount(final int index) {
    int neighborMines = 0;

    for (int cell in getNeighborCells(index)) {
      if (isMine(cell)) {
        neighborMines += 1;
      }
    }

    return neighborMines;
  }

  bool hasNeighborMines(final int index) {
    for (int cell in getNeighborCells(index)) {
      if (isMine(cell)) {
        return true;
      }
    }

    return false;
  }

  bool isClicked(final int index) => clicked.contains(index);
  bool hasFlag(final int index) => flags.contains(index);
  bool isMine(final int index) => mines.contains(index);
}
