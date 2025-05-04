import 'dart:async';
import 'dart:convert';

import 'package:controll_me_daddy/components/game_button.dart';
import 'package:controll_me_daddy/components/pad.dart';
import 'package:controll_me_daddy/models/button_dto.dart';
import 'package:controll_me_daddy/models/joystick_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class ControllerScreen extends StatefulWidget {
  const ControllerScreen({super.key, required this.socketEndpoint});
  final String socketEndpoint;

  @override
  State<ControllerScreen> createState() => _ControllerScreenState();
}

class _ControllerScreenState extends State<ControllerScreen> {
  late WebSocketChannel _channel;
  bool accelerometerActivated = true;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  double _x = 0.0;
  double _y = 0.0;
  double _z = 0.0;

  @override
  void initState() {
    super.initState();
    _initAccelerometer();

    print("printing thing with the thing : ${widget.socketEndpoint}");
    try {
      _channel = IOWebSocketChannel.connect(widget.socketEndpoint);

      _channel.stream.listen(
        (message) {},
        onError: (error) {
          _showSnackbar("Connection error: ${error.toString()}", true);
        },
        onDone: () {
          _showSnackbar("Connection closed", true);
        },
      );
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSnackbar("Failed to connect: ${e.toString()}", true);
      });
    }
  }

  void _initAccelerometer() {
    if (accelerometerActivated) {
      _accelerometerSubscription = accelerometerEvents.listen(
        (AccelerometerEvent event) {
          if (!mounted) return;
          setState(() {
            _x = event.x;
            _y = event.y;
            _z = event.z;
          });
          // TODO: find a way to only make webhook calls when y is in specific ranges
          if (_y >= 0.5 && _y <= 1.5) {
            print("Printing 1");
          }
        },
        onError: (error) {
          print(error);
        },
        cancelOnError: true,
      );
    }
  }

  void _toggleAccelerometer(bool value) {
    setState(() {
      accelerometerActivated = value;
    });

    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;

    if (value) {
      _initAccelerometer();
    }
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _channel.sink.close();
    super.dispose();
  }

  void _showSnackbar(String message, bool isError) {
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
          duration: const Duration(seconds: 5),
          action:
              isError
                  ? SnackBarAction(
                    label: 'Retry',
                    textColor: Colors.white,
                    onPressed: () {
                      _reconnect();
                    },
                  )
                  : null,
        ),
      );
    });
  }

  void _reconnect() {
    try {
      _channel.sink.close();
      _channel = IOWebSocketChannel.connect(widget.socketEndpoint);
    } catch (e) {
      _showSnackbar("Reconnection failed: ${e.toString()}", true);
    }
  }

  void _sendKeyPress(ButtonDto value) {
    print(value);

    Map<String, dynamic> data = Map<String, dynamic>();
    data['key'] = value.key;
    data['value'] = value.value;
    final json = jsonEncode(data);
    _channel.sink.add(json);
  }

  void _sendJoystickMove(JoystickDto coords) {
    print(coords);

    Map<String, dynamic> data = Map<String, dynamic>();
    data['x'] =
        coords.x * -1; // Don't know why but x in server in negative here
    data['y'] = (coords.y);
    data['side'] = coords.side;
    print(coords.toString());
    final json = jsonEncode(data);
    _channel.sink.add(json);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(15, 15, 15, 0),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
                  return Container(
                    height: 200,
                    color: Colors.blue,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text('Accelerometer'),
                          Switch(
                            value: accelerometerActivated,
                            activeColor: Colors.red,
                            onChanged: (bool value) {
                              _toggleAccelerometer(value);
                              setModalState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        child: const Icon(Icons.menu, color: Colors.white, size: 25),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Joystick needs to be in row for some reason. Don't touch
            Row(
              children: [
                SizedBox(width: 200),
                Joystick(
                  stick: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue,
                    child: SizedBox.shrink(),
                  ),
                  base: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  listener: (details) {
                    print("Joystick 1: ${details.x}, ${details.y}");
                    JoystickDto joystickdto = JoystickDto(
                      x:
                          details
                              .y, // NOTE: I don't know why but y and x and messed up. /
                      y: details.x,
                      side: "right",
                    );
                    _sendJoystickMove(joystickdto);
                  },
                ),
              ],
            ),

            // end of joystick
            Pad(
              onPress: ((ButtonDto value) {
                _sendKeyPress(value);
              }),
              values: [308, 307, 305, 304],
            ),

            // Pause Button
            // const SizedBox(height: 20),
            SizedBox(
              height: 25,
              child: GameButton(
                onTapUp: (ButtonDto value) {
                  _sendKeyPress(value);
                },
                onTapDown: (ButtonDto value) {
                  _sendKeyPress(value);
                },
                btnKey: 315,
                arrIndex: 0,
              ),
            ),
            const SizedBox(height: 10),

            // Select Button
            SizedBox(
              height: 25,
              child: GameButton(
                onTapUp: (ButtonDto value) {
                  _sendKeyPress(value);
                },
                onTapDown: (ButtonDto value) {
                  _sendKeyPress(value);
                },
                btnKey: 314,
                arrIndex: 0,
              ),
            ),

            // const SizedBox(height: 20),
            Pad(
              onPress: ((value) {
                _sendKeyPress(value);
              }),
              values: [17, 16, 16, 17],
            ),
            Row(
              children: [
                SizedBox(width: 200),
                Joystick(
                  stick: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue,
                    child: SizedBox.shrink(),
                  ),
                  base: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  listener: (details) {
                    print("Joystick 1: ${details.x}, ${details.y}");
                    JoystickDto joystickdto = JoystickDto(
                      x:
                          details
                              .y, // NOTE: No idea why x and y are swapped here but don't touch this.
                      y: details.x,
                      side: "left",
                    );
                    _sendJoystickMove(joystickdto);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
