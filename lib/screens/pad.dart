import 'package:controll_me_daddy/components/game_button.dart';
import 'package:flutter/material.dart';

class Pad extends StatefulWidget {
  final List<String> values;
  final ValueSetter<String> onPress;
  const Pad({super.key, required this.onPress, required this.values});

  @override
  State<Pad> createState() => _PadState();
}

class _PadState extends State<Pad> {
  @override
  void initState() {
    super.initState();
  }

  void onTapUp(String value) {
    print(value);
  }

  void onTapDown(String value) {
    print(value);
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
            onTapUp: (value) {
              onTapUp(value);
            },
            onTapDown: (value) {
              onTapDown(value);
            },
            value: widget.values[2],
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          //
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          GameButton(
            onTapUp: (value) {
              onTapUp(value);
            },
            onTapDown: (value) {
              onTapDown(value);
            },
            value: widget.values[0],
          ),
          const SizedBox(height: 20),
          GameButton(
            onTapUp: (value) {
              onTapUp(value);
            },
            onTapDown: (value) {
              onTapDown(value);
            },
            value: widget.values[3],
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          //
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          GameButton(
            onTapUp: (value) {
              onTapUp(value);
            },
            onTapDown: (value) {
              onTapDown(value);
            },
            value: widget.values[1],
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
