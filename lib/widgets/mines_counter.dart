import 'package:flutter/material.dart';

class MinesCounter extends StatelessWidget {
  const MinesCounter({
    required this.flaggedMinesCounter,
    required this.totalMinesCounter,
    super.key,
  });

  final ValueNotifier<int> flaggedMinesCounter;
  final ValueNotifier<int> totalMinesCounter;

  @override
  Widget build(final BuildContext context) => Row(
    children: <Widget>[
      const Text('Mines: '),
      ValueListenableBuilder<int>(
        valueListenable: flaggedMinesCounter,
        builder:
            (final BuildContext ctx, final int mines, final Widget? child) =>
                Text(mines.toString()),
      ),
      ValueListenableBuilder<int>(
        valueListenable: totalMinesCounter,
        builder:
            (
              final BuildContext context,
              final int value,
              final Widget? child,
            ) => Text('/$value'),
      ),
    ],
  );
}
