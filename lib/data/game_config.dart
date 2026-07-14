import 'dart:convert';

import 'package:minesweeper_game/data/difficulty.dart';

class GameConfig {
  factory GameConfig() => _instance;

  factory GameConfig.fromJson(final String json) {
    final Map map = jsonDecode(json);
    return GameConfig()
      ..difficulty = Difficulty.values[int.tryParse(map['difficulty']) ?? 0]
      ..customHeight = int.tryParse(map['customHeight']) ?? 9
      ..customWidth = int.tryParse(map['customWidth']) ?? 9
      ..customMineCount = int.tryParse(map['customMineCount']) ?? 10;
  }
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

  String toJson() => jsonEncode(<String, String>{
    'difficulty': difficulty.index.toString(),
    'customHeight': customHeight.toString(),
    'customWidth': customWidth.toString(),
    'customMineCount': customMineCount.toString(),
  });
}
