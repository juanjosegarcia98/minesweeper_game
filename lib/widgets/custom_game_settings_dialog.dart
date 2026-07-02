import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minesweeper_game/data/command.dart';
import 'package:minesweeper_game/data/game.dart';

class CustomGameSettingsDialog extends StatelessWidget {
  const CustomGameSettingsDialog({super.key});

  static void show(final BuildContext context_) => showDialog(
    context: context_,
    builder: (final BuildContext context) => const CustomGameSettingsDialog(),
  );

  @override
  Widget build(final BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController widthController = TextEditingController(
      text: Game().config.customWidth.toString(),
    );
    final TextEditingController heightController = TextEditingController(
      text: Game().config.customHeight.toString(),
    );
    final TextEditingController minesController = TextEditingController(
      text: Game().config.customMineCount.toString(),
    );

    return SimpleDialog(
      title: const Text('Custom game settings'),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: widthController,
                  validator: (final String? value) {
                    if (int.parse(widthController.text) < 5) {
                      return 'You have to set a minimum width of 5 cells.';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(label: Text('Width')),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                TextFormField(
                  controller: heightController,
                  validator: (final String? value) {
                    if (int.parse(heightController.text) < 5) {
                      return 'You have to set a minimum height of 5 cells.';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(label: Text('Height')),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                TextFormField(
                  controller: minesController,
                  validator: (final String? value) {
                    final int boardCells =
                        int.parse(heightController.text) *
                        int.parse(widthController.text);
                    if (boardCells - int.parse(minesController.text) < 10) {
                      return 'You have to set a maximum of'
                          ' ${boardCells - 10} mines';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(label: Text('Mines')),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                const SizedBox(height: 20),
                MaterialButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? true) {
                      Game().executeCommand(
                        ChangeCustomGameSettings(
                          width: int.parse(widthController.text),
                          height: int.parse(heightController.text),
                          mines: int.parse(minesController.text),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
