import 'package:flutter/material.dart';

class GameButton extends StatefulWidget {
  const GameButton({
    super.key,
    required this.onTapUp,
    required this.onTapDown,
    required this.value,
  });
  final ValueSetter<String> onTapDown;
  final ValueSetter<String> onTapUp;
  final String value;

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> {
  bool _isPressed = false; // Track the button's pressed state

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        widget.onTapDown(widget.value);
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: ((_) {
        widget.onTapUp(widget.value);

        setState(() {
          _isPressed = false;
        });
      }),
      child: Image(
        image: AssetImage(
          _isPressed
              ? 'assets/images/button-pressed.png'
              : 'assets/images/button.png',
        ),
      ),
    );
  }
}
