import 'package:flutter/material.dart';
import 'package:minesweeper_game/widgets/home_screen.dart';

/// Root app widget.
class App extends StatelessWidget {
  /// Constructor.
  const App({super.key});

  @override
  Widget build(final BuildContext context) => const MaterialApp(
    title: 'Minesweeper Game',
    home: HomeScreen(),
    debugShowCheckedModeBanner: false,
  );
}
