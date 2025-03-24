import 'package:controll_me_daddy/models/button_dto.dart';
import 'package:flutter/material.dart';

class GameButton extends StatefulWidget {
  const GameButton({
    super.key,
    required this.onTapUp,
    required this.onTapDown,
    required this.btnKey,
  });
  final ValueSetter<ButtonDto> onTapDown;
  final ValueSetter<ButtonDto> onTapUp;
  final int btnKey;

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> {
  bool _isPressed = false; // Track the button's pressed state

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        widget.onTapDown(
          ButtonDto(key: widget.btnKey, value: _isPressed ? 0 : 1),
        );
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: ((_) {
        widget.onTapUp(
          ButtonDto(key: widget.btnKey, value: _isPressed ? 1 : 0),
        );

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
