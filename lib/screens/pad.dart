import 'package:controll_me_daddy/components/game_button.dart';
import 'package:controll_me_daddy/models/button_dto.dart';
import 'package:flutter/material.dart';

class Pad extends StatefulWidget {
  final List<int> values;
  final ValueSetter<ButtonDto> onPress;
  const Pad({super.key, required this.onPress, required this.values});

  @override
  State<Pad> createState() => _PadState();
}

class _PadState extends State<Pad> {
  @override
  void initState() {
    super.initState();
  }

  void onTapUp(ButtonDto value) {
    widget.onPress(value);
  }

  void onTapDown(ButtonDto value) {
    widget.onPress(value);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
        // this produces 2 rows.
        crossAxisCount: 7,
        // Generate 100 widgets that display their index in the list.
        children: [
          //
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          GameButton(
            onTapUp: (ButtonDto value) {
              onTapUp(value);
            },
            onTapDown: (ButtonDto value) {
              onTapDown(value);
            },
            btnKey: widget.values[2],
            arrIndex: 2,
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          //
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          GameButton(
            onTapUp: (ButtonDto value) {
              onTapUp(value);
            },
            onTapDown: (ButtonDto value) {
              onTapDown(value);
            },
            btnKey: widget.values[0],
            arrIndex: 0,
          ),
          const SizedBox(height: 20),
          GameButton(
            onTapUp: (ButtonDto value) {
              onTapUp(value);
            },
            onTapDown: (ButtonDto value) {
              onTapDown(value);
            },
            btnKey: widget.values[3],
            arrIndex: 3,
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          //
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          GameButton(
            onTapUp: (ButtonDto value) {
              onTapUp(value);
            },
            onTapDown: (ButtonDto value) {
              onTapDown(value);
            },
            btnKey: widget.values[1],
            arrIndex: 1,
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
