import 'package:minesweeper_game/data/difficulty.dart';

class GameConfig {
  factory GameConfig() => _instance;
  GameConfig._internal();
  static final GameConfig _instance = GameConfig._internal();

  int get boardWidth =>
      difficulty == Difficulty.custom ? customWidth : difficulty.width;
  int get boardHeight =>
      difficulty == Difficulty.custom ? customHeight : difficulty.height;
  int get mineCount =>
      difficulty == Difficulty.custom ? customMineCount : difficulty.mines;

  Difficulty difficulty = Difficulty.easy;
  int customWidth = 9;
  int customHeight = 9;
  int customMineCount = 10;
}
