import 'dart:convert';
import 'dart:developer';

import 'package:minesweeper_game/data/difficulty.dart';
import 'package:minesweeper_game/data/functions.dart';

class GameConfig {
  factory GameConfig() => _instance;

  factory GameConfig.fromJson(final String json) {
    final Map map = jsonDecode(json);
    final Map<String, dynamic> bt = jsonDecode(map['bestTimes']);

    return GameConfig()
      ..difficulty = Difficulty.values[int.tryParse(map['difficulty']) ?? 0]
      ..customHeight = int.tryParse(map['customHeight']) ?? 9
      ..customWidth = int.tryParse(map['customWidth']) ?? 9
      ..customMineCount = int.tryParse(map['customMineCount']) ?? 10
      ..bestTimes = bt.map(
        (final String key, final value) => MapEntry(
          Difficulty.values[int.parse(key)],
          (value as List).map((final e) => BestTime.fromMap(e)).toList(),
        ),
      );
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
  Map<Difficulty, List<BestTime>> bestTimes = <Difficulty, List<BestTime>>{
    Difficulty.easy: <BestTime>[],
    Difficulty.medium: <BestTime>[],
    Difficulty.hard: <BestTime>[],
    Difficulty.custom: <BestTime>[],
  };

  bool checkNewBestTime(final Duration elapsedTime) =>
      bestTimes[difficulty]!.length < 10 ||
      (bestTimes[difficulty]!.lastIndexWhere(
            (final BestTime best) => best.time < elapsedTime,
          ) <
          9);

  void printBestTimes() {
    log('BEST TIMES:');
    for (final Difficulty difficulty in bestTimes.keys) {
      log('${difficulty.name}:');
      for (final BestTime time in bestTimes[difficulty]!) {
        log(time.toString());
      }
      log('---------');
    }
  }

  String toJson() => jsonEncode(<String, String>{
    'difficulty': difficulty.index.toString(),
    'customHeight': customHeight.toString(),
    'customWidth': customWidth.toString(),
    'customMineCount': customMineCount.toString(),
    'bestTimes': encodeBestTimes(),
  });

  String encodeBestTimes() {
    int idx = 0;
    final StringBuffer bestTimesSb = StringBuffer('{');
    bestTimes.forEach((final Difficulty key, final List<BestTime> value) {
      bestTimesSb
        ..write('"${key.index}"')
        ..write(':')
        ..write('[');
      for (final BestTime bestTime in value) {
        bestTimesSb.write(bestTime.toJson());
        if (value.indexOf(bestTime) != value.length - 1) {
          bestTimesSb.write(',');
        }
      }
      bestTimesSb.write(']');
      if (idx != bestTimes.length - 1) {
        bestTimesSb.write(',');
      }
      idx++;
    });
    bestTimesSb.write('}');
    return bestTimesSb.toString();
  }
}

class BestTime {
  const BestTime(this.name, this.time, this.timestamp);
  factory BestTime.fromJson(final String json) {
    final Map map = jsonDecode(json);
    return BestTime(
      map['name'] ?? 'NO_NAME',
      Duration(milliseconds: int.tryParse(map['time']) ?? 0),
      DateTime.fromMillisecondsSinceEpoch(int.tryParse(map['timestamp']) ?? 0),
    );
  }
  factory BestTime.fromMap(final Map map) => BestTime(
    map['name'] ?? 'NO_NAME',
    Duration(milliseconds: int.tryParse(map['time']) ?? 0),
    DateTime.fromMillisecondsSinceEpoch(int.tryParse(map['timestamp']) ?? 0),
  );

  final String name;
  final Duration time;
  final DateTime timestamp;

  String toJson() => jsonEncode(<String, String>{
    'name': name,
    'time': time.inMilliseconds.toString(),
    'timestamp': timestamp.millisecondsSinceEpoch.toString(),
  });

  @override
  String toString() => '$name - ${returnFormattedTimeString(time)}';
}
