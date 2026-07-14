import 'dart:io';

import 'package:flutter/material.dart';
import 'package:minesweeper_game/data/game.dart';
import 'package:minesweeper_game/data/game_config.dart';
import 'package:minesweeper_game/widgets/app.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  final Directory appDocumentsDirectory =
      await getApplicationDocumentsDirectory();
  final File configFile = File(
    '${appDocumentsDirectory.path}/minesweeperconfig.json',
  );
  if (configFile.existsSync()) {
    Game().config = GameConfig.fromJson(configFile.readAsStringSync());
    Game().board.width = Game().config.boardWidth;
    Game().board.height = Game().config.boardHeight;
  }

  runApp(const App());
}
