import 'package:controll_me_daddy/screens/controller_screen.dart';
import 'package:controll_me_daddy/screens/wheel_screen.dart';
import 'package:flutter/material.dart';

class WebsocketEndpointForm extends StatefulWidget {
  const WebsocketEndpointForm({super.key});

  @override
  WebsocketEndpointFormState createState() {
    return WebsocketEndpointFormState();
  }
}

enum SingingCharacter { controller, steeringWheel }

class WebsocketEndpointFormState extends State<WebsocketEndpointForm> {
  SingingCharacter? _character = SingingCharacter.controller;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Websocket Endpoint',
              labelStyle: const TextStyle(color: Colors.white),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter websocket endpoint';
              }
              return null;
            },
          ),
          ListTile(
            title: const Text(
              'Controller',
              style: TextStyle(color: Colors.white), // White text
            ),
            leading: Radio<SingingCharacter>(
              value: SingingCharacter.controller,
              groupValue: _character,
              onChanged: (SingingCharacter? value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text(
              'Steering Wheel',
              style: TextStyle(color: Colors.white), // White text
            ),
            leading: Radio<SingingCharacter>(
              value: SingingCharacter.steeringWheel,
              groupValue: _character,
              onChanged: (SingingCharacter? value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              _character == SingingCharacter.steeringWheel
                                  ? WheelScreen(socketEndpoint: "sdfsdf")
                                  : ControllerScreen(socketEndpoint: "fsdfsdf"),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Connecting...')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
