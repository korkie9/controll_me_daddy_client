class JoystickDto {
  final double x;
  final double y;
  final String side;

  JoystickDto({required this.x, required this.y, required this.side});

  @override
  String toString() => 'JoystickDto(x: $x, y: $y, side: $side)';
}
