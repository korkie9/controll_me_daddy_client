import 'package:controll_me_daddy/models/button_dto.dart';
import 'package:flutter/material.dart';

class TriggerButton extends StatefulWidget {
  const TriggerButton({
    super.key,
    required this.onTapUp,
    required this.onTapDown,
    required this.btnKey,
    required this.btnName,
    this.size,
  });
  final ValueSetter<ButtonDto> onTapDown;
  final ValueSetter<ButtonDto> onTapUp;
  final int btnKey;
  final String btnName;
  final double? size;

  @override
  State<TriggerButton> createState() => _TriggerButtonState();
}

class _TriggerButtonState extends State<TriggerButton> {
  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: GestureDetector(
        onTapDown: (_) {
          widget.onTapDown(ButtonDto(key: widget.btnKey, value: 1));
          setState(() {});
        },
        onTapUp: ((_) {
          widget.onTapUp(ButtonDto(key: widget.btnKey, value: 0));

          setState(() {});
        }),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            minimumSize: Size(140, 45),
          ),
          onPressed: () {},
          child: Text(widget.btnName),
        ),
      ),
    );
  }
}
