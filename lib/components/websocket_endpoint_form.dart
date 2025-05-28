import 'package:controll_me_daddy/screens/controller_screen.dart';
import 'package:controll_me_daddy/screens/qr_scanner_screen.dart';
import 'package:flutter/material.dart';

class WebsocketEndpointForm extends StatefulWidget {
  const WebsocketEndpointForm({super.key});

  @override
  WebsocketEndpointFormState createState() {
    return WebsocketEndpointFormState();
  }
}

class WebsocketEndpointFormState extends State<WebsocketEndpointForm> {
  final _formKey = GlobalKey<FormState>();
  final webSocketInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: webSocketInputController,
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => ControllerScreen(
                            socketEndpoint: webSocketInputController.text,
                          ),
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

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => QRScannerScreen()),
                );
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Connecting...')));
              },
              child: const Text('San QR Code'),
            ),
          ),
        ],
      ),
    );
  }
}
