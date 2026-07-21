import 'package:flutter/material.dart';
import 'package:minesweeper_game/data/difficulty.dart';
import 'package:minesweeper_game/data/functions.dart';
import 'package:minesweeper_game/data/game.dart';
import 'package:minesweeper_game/data/game_config.dart';

class BestTimesContent extends StatefulWidget {
  const BestTimesContent({super.key});

  @override
  _BestTimesContentState createState() => _BestTimesContentState();
}

class _BestTimesContentState extends State<BestTimesContent> {
  late Difficulty difficulty;

  @override
  void initState() {
    super.initState();
    difficulty = Game().config.difficulty;
  }

  @override
  Widget build(final BuildContext context) => Row(
    children: <Widget>[
      SizedBox(
        width: 50,
        child: ListView.builder(
          controller: ScrollController(),
          itemCount: Difficulty.values.length,
          itemBuilder: (final BuildContext context, final int index) =>
              RotatedBox(
                quarterTurns: 3,
                child: BestTimesTab(
                  onTap: () => setState(() {
                    difficulty = Difficulty.values[index];
                  }),
                  text: Difficulty.values[index].name,
                  selected: Difficulty.values[index] == difficulty,
                ),
              ),
        ),
      ),
      SizedBox(
        width: 250,
        child: ListView.builder(
          itemCount: Game().config.bestTimes[difficulty]!.length,
          itemBuilder: (context, index) {
            final BestTime bestTime =
                Game().config.bestTimes[difficulty]![index];
            return ListTile(
              title: Text(
                "#${index + 1} ${bestTime.name} - ${returnFormattedTimeString(bestTime.time)}",
              ),
            );
          },
          padding: EdgeInsets.zero,
        ),
      ),
    ],
  );
}

class BestTimesTab extends StatelessWidget {
  const BestTimesTab({
    required this.text,
    required this.onTap,
    this.selected = false,
    super.key,
  });

  final String text;

  final bool selected;

  final Function() onTap;

  @override
  Widget build(final BuildContext context) => Material(
    elevation: selected ? 8 : 0,
    color: selected ? Colors.amberAccent : null,
    shape: selected
        ? BoxBorder.fromLTRB(bottom: const BorderSide(width: 3))
        : null,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: SizedBox(
          width: 60,
          height: 10,
          child: Text(text, textAlign: TextAlign.center),
        ),
      ),
    ),
  );
}
