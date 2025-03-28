import 'dart:convert';

import 'package:controll_me_daddy/components/game_button.dart';
import 'package:controll_me_daddy/models/button_dto.dart';
import 'package:controll_me_daddy/models/joystick_dto.dart';
import 'package:controll_me_daddy/screens/pad.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const ControllMeDaddy());
}

class ControllMeDaddy extends StatelessWidget {
  const ControllMeDaddy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //title: 'WebSocket Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ControllMeDaddyState(),
    );
  }
}

class ControllMeDaddyState extends StatefulWidget {
  const ControllMeDaddyState({super.key});

  @override
  State<ControllMeDaddyState> createState() => _ControllMeDaddyState();
}

class _ControllMeDaddyState extends State<ControllMeDaddyState> {
  late WebSocketChannel _channel;
  double _x = 0.0;
  double _y = 0.0;
  double _z = 0.0;
  //String _message = '';
  //

  @override
  void initState() {
    super.initState();
    // Connect to the WebSocket server
    _channel = IOWebSocketChannel.connect(
      'ws://d7e3-102-217-76-205.ngrok-free.app/ws',
    );
    accelerometerEvents.listen(
      (AccelerometerEvent event) {
        //print(event);
        setState(() {
          _x = event.x;
          _y = event.y;
          _z = event.z;
        });
      },
      onError: (error) {
        // Logic to handle error
        // Needed for Android in case sensor is not available
      },
      cancelOnError: true,
    );
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                SizedBox(width: 200),
                Joystick(
                  stick: const CircleAvatar(
                    radius: 30,
                    backgroundColor:
                        Colors.blue, // You can change the color as needed
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
                    // Handle joystick movement
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

            const SizedBox(height: 50),
            Pad(
              onPress: ((ButtonDto value) {
                _sendKeyPress(value);
              }),
              values: [308, 307, 305, 304],
            ),

            // Pause Button
            const SizedBox(height: 50),
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

            const SizedBox(height: 50),
            Pad(
              onPress: ((value) {
                _sendKeyPress(value);
              }),
              values: [17, 16, 16, 17],
            ),
            const SizedBox(height: 50),
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
                              .y, // No idea why x and y are swapped here but don't touch this.
                      y: details.x,
                      side: "left",
                    );
                    _sendJoystickMove(joystickdto);
                  },
                ),
              ],
            ),
            //StreamBuilder(
            //  stream: _channel.stream,
            //  builder: (context, snapshot) {
            //    if (snapshot.hasData) {
            //      // Display messages received from the WebSocket server
            //      _message = snapshot.data.toString();
            //    } else if (snapshot.hasError) {
            //      _message = 'Error: ${snapshot.error}';
            //    } else {
            //      _message = 'No message received yet';
            //    }
            //    return Text(_message, style: const TextStyle(fontSize: 18));
            //  },
            //),
          ],
        ),
      ),
    );
  }
}
